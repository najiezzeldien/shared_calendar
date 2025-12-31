import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_calendar/features/auth/domain/entities/app_user.dart';
import 'package:shared_calendar/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return AppUser(id: user.uid, email: user.email!, name: user.displayName);
    });
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return AppUser(id: user.uid, email: user.email!, name: user.displayName);
    }
    return null;
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Sync user to Firestore (in case they signed up before we added this logic)
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'name': user.displayName,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error syncing user to Firestore: $e');
      }

      return Right(
        AppUser(id: user.uid, email: user.email!, name: user.displayName),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Sign in failed'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Sync user to Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'name': user.displayName,
        }, SetOptions(merge: true));
      } catch (e) {
        // Continue even if sync fails, though it's not ideal
        debugPrint('Error syncing user to Firestore: $e');
      }

      if (name != null) {
        await user.updateDisplayName(name);
      }

      return Right(AppUser(id: user.uid, email: user.email!, name: name));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'internal-error' ||
          e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
        return Left(
          AuthFailure(
            'Sign up failed. Try disabling "Email Enumeration Protection" in Firebase Console -> Authentication -> Settings.',
          ),
        );
      }
      return Left(AuthFailure(e.message ?? 'Sign up failed'));
    } catch (e) {
      if (e.toString().contains('CONFIGURATION_NOT_FOUND')) {
        return Left(
          AuthFailure(
            'Sign up failed. Try disabling "Email Enumeration Protection" in Firebase Console -> Authentication -> Settings.',
          ),
        );
      }
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign in on Android (not usually on Web/iOS)
          // We can handle this if we want auto-sign in
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Verification Failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;

      // Sync to Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'phoneNumber': user.phoneNumber,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error syncing user to Firestore: $e');
      }

      return Right(
        AppUser(id: user.uid, email: user.email ?? '', name: user.displayName),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Sign in failed'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserOnboardingData({
    required String uid,
    required String accountType,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'accountType': accountType,
        'onboardingCompleted': true,
      }, SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
