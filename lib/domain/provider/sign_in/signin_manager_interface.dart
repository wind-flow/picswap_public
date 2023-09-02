abstract class LoginManagerInterface {
  Future<String?> login();
  Future<void> logout();
}
