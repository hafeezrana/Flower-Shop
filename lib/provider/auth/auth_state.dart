import 'package:flowershop/model/userdata.dart';

class UserAuthState {
  final UserData? user;
  final bool isLoading;
  final String? error;
  final String? otpCode;

  UserAuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.otpCode,
  });

  UserAuthState copyWith({
    UserData? user,
    bool? isLoading,
    String? error,
    String? otpCode,
  }) {
    return UserAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
