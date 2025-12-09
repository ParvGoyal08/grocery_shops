import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/sample_data.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];

  AuthProvider() {
    _initializeUsers();
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isShopOwner => _currentUser?.isShopOwner ?? false;
  bool get isCustomer => _currentUser?.isCustomer ?? false;

  void _initializeUsers() {
    _users.addAll(SampleData.getUsers());
  }

  List<User> get allUsers => List.unmodifiable(_users);

  bool login(String username, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.username.toLowerCase() == username.toLowerCase() && u.password == password,
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUserLocation(double latitude, double longitude) {
    if (_currentUser != null) {
      _currentUser!.latitude = latitude;
      _currentUser!.longitude = longitude;
      notifyListeners();
    }
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}
