abstract interface class IForgotPasswordDataSource {
  Future<String> sendOtp(String email);
  Future<String> verifyOtp(String otp, String tempToken);
  Future<void> resetPassword(String newPassword, String resetToken);
}
