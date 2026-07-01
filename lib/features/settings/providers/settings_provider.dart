import 'dart:async';
import 'package:flutter/material.dart';
import '../models/settings_user.dart';
import '../repository/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repository;
  StreamSubscription<SettingsUser>? _subscription;

  SettingsUser? _user;
  SettingsUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  SettingsProvider({required this.repository});

  void loadUser() {
    _subscription?.cancel();
    _subscription = repository.watchUser().listen(
      (user) {
        _user = user;
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  Future<void> refreshUser() async {
    try {
      _setLoading(true);
      _user = await repository.getUser();
    } catch (_) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _setSaving(true);
    try {
      await repository.updateNotifications(enabled);
      _user = _user?.copyWith(notificationsEnabled: enabled);
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> updateUsername(String username) async {
    _setSaving(true);
    try {
      await repository.updateUsername(username);
      _user = _user?.copyWith(fullName: username);
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> updateEmail(String newEmail, String currentPassword) async {
    _setSaving(true);
    try {
      await repository.updateEmail(newEmail: newEmail, currentPassword: currentPassword);
      _user = _user?.copyWith(email: newEmail);
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> updateProfileImageUrl(String imageUrl) async {
    _setSaving(true);
    try {
      await repository.updateProfileImageUrl(imageUrl);
      _user = _user?.copyWith(profilePicUrl: imageUrl);
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    _setSaving(true);
    try {
      await repository.updatePassword(currentPassword: currentPassword, newPassword: newPassword);
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> deleteAccount() async {
    _setSaving(true);
    try {
      await repository.deleteAccount();
      _user = null;
    } catch (_) {
      rethrow;
    } finally {
      _setSaving(false);
    }
  }

  void clear() {
    _subscription?.cancel();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
