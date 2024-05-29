import 'package:flutter/foundation.dart';

class ParentControlModel extends ChangeNotifier {
  bool _isPasswordSet = false;
  bool get isPasswordSet => _isPasswordSet;

  void setPassword(String password) {
    // Save password securely using shared_preferences
    _isPasswordSet = true;
    notifyListeners();
  }

  bool authenticate(String enteredPassword) {
    // Validate the entered password with the saved password
    return true; // For simplicity, always return true here; replace with actual comparison
  }
}
