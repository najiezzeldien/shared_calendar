import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_providers.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state is null (idle)
    return null;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signInWithEmail(email: email, password: password);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) => state = const AsyncData(null),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signUpWithEmail(email: email, password: password, name: name);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) => state = const AsyncData(null),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signOut();
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) => state = const AsyncData(null),
    );
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          onCodeSent: (verificationId, resendToken) {
            state = const AsyncData(null);
            onCodeSent(verificationId);
          },
          onVerificationFailed: (message) {
            state = AsyncError(message, StackTrace.current);
            onVerificationFailed(message);
          },
        );

    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) {}, // Initiated successfully
    );
  }

  Future<void> signInWithPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signInWithPhoneNumber(
          verificationId: verificationId,
          smsCode: smsCode,
        );
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) => state = const AsyncData(null),
    );
  }

  Future<void> saveOnboardingData({required String accountType}) async {
    state = const AsyncLoading();
    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    if (user != null) {
      final result = await ref
          .read(authRepositoryProvider)
          .updateUserOnboardingData(uid: user.id, accountType: accountType);
      result.fold(
        (failure) => state = AsyncError(failure.message, StackTrace.current),
        (_) => state = const AsyncData(null),
      );
    } else {
      state = AsyncError("User not logged in", StackTrace.current);
    }
  }
}
