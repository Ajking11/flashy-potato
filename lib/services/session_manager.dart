// Simple in-memory session manager
class SessionManager {
  static bool _isLoggedIn = false;
  
  // Clear the session
  static void clearSession() {
    _isLoggedIn = false;
  }
  
  // Set logged in status
  static void setLoggedIn() {
    _isLoggedIn = true;
  }
  
  // Check if logged in
  static bool isLoggedIn() {
    return _isLoggedIn;
  }
}