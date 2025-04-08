import 'package:flutter/material.dart';
import '../models/User.dart';

class UserProvider extends ChangeNotifier {
  Utilisateur? _currentUser;
  
  Utilisateur? get currentUser => _currentUser;
  
  void setCurrentUser(Utilisateur? user) {
    _currentUser = user;
    notifyListeners();
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
  
  bool get isLoggedIn => _currentUser != null;
}