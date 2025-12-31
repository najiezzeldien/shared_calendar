import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  });

  Future<Either<Failure, AppUser>> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  Future<Either<Failure, void>> updateUserOnboardingData({
    required String uid,
    required String accountType,
  });

  Future<AppUser?> getCurrentUser();
}
