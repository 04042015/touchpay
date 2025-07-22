import '../models/user.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  // Login
  static Future<User> login(String username, String password) async {
    try {
      final response = await ApiService.post('auth/login', {
        'username': username,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      final token = response['token'];

      // Save token and user data locally
      await LocalStorageService.setString(_tokenKey, token);
      await LocalStorageService.setString(_userKey, user.toJson().toString());

      return user;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await ApiService.post('auth/logout', {});
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await LocalStorageService.remove(_tokenKey);
      await LocalStorageService.remove(_userKey);
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await LocalStorageService.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final userJson = await LocalStorageService.getString(_userKey);
    if (userJson != null) {
      try {
        return User.fromJson(userJson as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Get auth token
  static Future<String?> getToken() async {
    return await LocalStorageService.getString(_tokenKey);
  }

  // Refresh token
  static Future<String> refreshToken() async {
    try {
      final response = await ApiService.post('auth/refresh', {});
      final newToken = response['token'];
      await LocalStorageService.setString(_tokenKey, newToken);
      return newToken;
    } catch (e) {
      throw AuthException('Token refresh failed: $e');
    }
  }

  // Change password
  static Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await ApiService.post('auth/change-password', {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw AuthException('Password change failed: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
