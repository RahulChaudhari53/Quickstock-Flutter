class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // Emulator server
  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://192.168.1.70:5050";

  static const String baseUrl = "$serverAddress/api/users/";

  // Auth
  static const String login = "login";
  static const String register = "signup";
  static const String sendOtp = "forgotPassword";
  static const String verifyOtp = "verify-otp";
  static const String resetPassword = "resetPassword";
}
