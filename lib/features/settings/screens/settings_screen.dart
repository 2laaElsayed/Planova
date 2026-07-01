import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/settings_user.dart';
import '../models/statisticCardData.dart';
import '../providers/settings_provider.dart';
import '../repository/settings_repository.dart';
import '../services/settings_service.dart';
import '../widgets/statisticCard.dart';
import 'privacy_security_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeOn = false;

  Future<void> _handleLogout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final goRouter = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppColors.textGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.logoutRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed != true) return;

    try {
      await auth.logout();
      settingsProvider.clear();
      if (!mounted) return;
      goRouter.go('/signIn');
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString(), style: GoogleFonts.poppins())),
      );
    }
  }

  List<StatisticCardData> _buildStatisticCards(SettingsUser? user) {
    final currentStreak = user?.currentStreak ?? 0;
    final longestStreak = user?.longestStreak ?? 0;
    final completedTasks = user?.completedTasks ?? 0;
    final activeTasks = user?.activeTasks ?? 0;

    return [
      StatisticCardData(
        title: 'Current Streak',
        value: '$currentStreak days',
        icon: Icons.local_fire_department,
        iconCircleColor: const Color(0xFFFFE0B2),
        iconColor: const Color(0xFFEF6C00),
      ),
      StatisticCardData(
        title: 'Longest Streak',
        value: '$longestStreak days',
        icon: Icons.emoji_events,
        iconCircleColor: const Color(0xFFE1BEE7),
        iconColor: const Color(0xFF6A1B9A),
      ),
      StatisticCardData(
        title: 'Completed',
        value: '$completedTasks',
        icon: Icons.check_circle,
        iconCircleColor: const Color(0xFFC8E6C9),
        iconColor: const Color(0xFF2E7D32),
      ),
      StatisticCardData(
        title: 'Active Tasks',
        value: '$activeTasks',
        icon: Icons.task_alt,
        iconCircleColor: const Color(0xFFBBDEFB),
        iconColor: const Color(0xFF1E88E5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) {
        final provider = SettingsProvider(
          repository: SettingsRepository(service: SettingsService()),
        );
        provider.loadUser();
        return provider;
      },
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final user = settings.user;
          final statistics = _buildStatisticCards(user);
          final notificationsOn = user?.notificationsEnabled ?? true;

          return Scaffold(
            backgroundColor: AppColors.cardColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Setting',
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Color(0xFF1A1A2E),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF5C6BC0),
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFE8EAF6),
                              backgroundImage:
                                  user != null && user.profilePicUrl.isNotEmpty
                                  ? NetworkImage(user.profilePicUrl)
                                        as ImageProvider
                                  : null,
                              child: user == null || user.profilePicUrl.isEmpty
                                  ? Text(
                                      user?.initials ?? 'U',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user?.fullName ?? 'Loading...',
                            style: GoogleFonts.poppins(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.role ?? 'Loading...',
                            style: GoogleFonts.poppins(
                              color: AppColors.textGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Statistics',
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      children: statistics
                          .map((data) => buildStatisticCard(data))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Preferences',
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      margin: EdgeInsets.zero,
                      color: AppColors.cardColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            title: Text(
                              'Notifications',
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Study reminders & alerts',
                              style: GoogleFonts.poppins(
                                color: AppColors.textGrey,
                                fontSize: 12,
                              ),
                            ),
                            secondary: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE7F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Color(0xFF5E35B1),
                                size: 20,
                              ),
                            ),
                            activeThumbColor: AppColors.primaryLightPurple,
                            value: notificationsOn,
                            onChanged: settings.isSaving
                                ? null
                                : (value) async {
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    try {
                                      await settings.setNotificationsEnabled(
                                        value,
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString(),
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            title: Text(
                              'Dark Mode',
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Reduce eye strain at night',
                              style: GoogleFonts.poppins(
                                color: AppColors.textGrey,
                                fontSize: 12,
                              ),
                            ),
                            secondary: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EAF6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.nights_stay,
                                color: Color(0xFF3949AB),
                                size: 20,
                              ),
                            ),
                            activeThumbColor: AppColors.primaryColor,
                            value: _darkModeOn,
                            onChanged: (value) {
                              setState(() {
                                _darkModeOn = value;
                              });
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE7F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Color(0xFF5E35B1),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'Privacy & Security',
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Manage account & data',
                              style: GoogleFonts.poppins(
                                color: AppColors.textGrey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF9E9E9E),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (routeContext) =>
                                      ChangeNotifierProvider<
                                        SettingsProvider
                                      >.value(
                                        value: settings,
                                        child: const PrivacySecurityScreen(),
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: AppColors.logoutRed),
                          foregroundColor: AppColors.logoutRed,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(
                          Icons.logout,
                          color: AppColors.logoutRed,
                        ),
                        label: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            color: AppColors.logoutRed,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: settings.isSaving
                            ? null
                            : () => _handleLogout(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
