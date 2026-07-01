import '../models/settings_user.dart';
import '../services/settings_service.dart';

class SettingsRepository {
  final SettingsService service;

  SettingsRepository({required this.service});

  Stream<SettingsUser> watchUser() {
    return service.watchUserDocument().map(
      (snapshot) => SettingsUser.fromFirestore(snapshot),
    );
  }

  Future<SettingsUser> getUser() async {
    final snapshot = await service.getUserDocument();
    return SettingsUser.fromFirestore(snapshot);
  }

  Future<void> updateNotifications(bool enabled) =>
      service.updateNotifications(enabled);

  Future<void> updateUsername(String username) =>
      service.updateUsername(username);

  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) =>
      service.updateEmail(newEmail: newEmail, currentPassword: currentPassword);

  Future<void> updateProfileImageUrl(String imageUrl) =>
      service.updateProfileImageUrl(imageUrl);

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) => service.updatePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  Future<void> deleteUserDocument() => service.deleteUserDocument();

  Future<void> deleteAccount() => service.deleteAccount();
}
