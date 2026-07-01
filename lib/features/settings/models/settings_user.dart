import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsUser {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final String profilePicUrl;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final int currentStreak;
  final int longestStreak;
  final int completedTasks;
  final int activeTasks;
  final DateTime? passwordChangedAt;

  const SettingsUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profilePicUrl,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.currentStreak,
    required this.longestStreak,
    required this.completedTasks,
    required this.activeTasks,
    this.passwordChangedAt,
  });

  factory SettingsUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    final preferences = (data['preferences'] as Map<String, dynamic>?) ?? {};
    final statistics = (data['statistics'] as Map<String, dynamic>?) ?? {};

    final role =
        (data['bio_title'] as String?) ?? (data['role'] as String?) ?? 'Member';

    DateTime? changedAt;
    final passwordChangedAt = data['passwordChangedAt'];
    if (passwordChangedAt is Timestamp) {
      changedAt = passwordChangedAt.toDate();
    } else if (passwordChangedAt is DateTime) {
      changedAt = passwordChangedAt;
    }

    final fullNameFromSnake = (data['full_name'] as String?)?.trim();
    final fullNameFromCamel = (data['fullName'] as String?)?.trim();
    final username = (data['username'] as String?)?.trim();
    final usernameAlt = (data['user_name'] as String?)?.trim();
    final email = (data['email'] as String?)?.trim();
    final resolvedFullName = fullNameFromSnake?.isNotEmpty == true
        ? fullNameFromSnake!
        : fullNameFromCamel?.isNotEmpty == true
        ? fullNameFromCamel!
        : null;
    final resolvedUsername = username?.isNotEmpty == true
        ? username!
        : usernameAlt?.isNotEmpty == true
        ? usernameAlt!
        : null;
    return SettingsUser(
      uid: data['uid'] as String? ?? snapshot.id,
      fullName:
          resolvedFullName ??
          resolvedUsername ??
          (email?.isNotEmpty == true ? email! : 'New User'),
      email: email ?? '',
      role: role,
      profilePicUrl: (data['profile_pic_url'] as String?) ?? '',
      notificationsEnabled:
          (preferences['notifications_enabled'] as bool?) ?? true,
      darkModeEnabled: (preferences['dark_mode_enabled'] as bool?) ?? false,
      currentStreak: (statistics['current_streak'] as int?) ?? 0,
      longestStreak: (statistics['longest_streak'] as int?) ?? 0,
      completedTasks: (statistics['completed_tasks_count'] as int?) ?? 0,
      activeTasks: (statistics['active_tasks_count'] as int?) ?? 0,
      passwordChangedAt: changedAt,
    );
  }

  SettingsUser copyWith({
    String? fullName,
    String? email,
    String? role,
    String? profilePicUrl,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    int? currentStreak,
    int? longestStreak,
    int? completedTasks,
    int? activeTasks,
    DateTime? passwordChangedAt,
  }) {
    return SettingsUser(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedTasks: completedTasks ?? this.completedTasks,
      activeTasks: activeTasks ?? this.activeTasks,
      passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
    );
  }

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : 'U';
  }
}
