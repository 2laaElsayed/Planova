import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planova_app/core/constants/app_colors.dart';

import '../models/statisticCardData.dart';
import '../widgets/statisticCard.dart';
import 'privacy_security_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsOn = true;
  bool _darkModeOn = false;

  final List<StatisticCardData> _statistics = const [
    StatisticCardData(
      title: 'Current Streak',
      value: '7 days',
      icon: Icons.local_fire_department,
      iconCircleColor: Color(0xFFFFE0B2),
      iconColor: Color(0xFFEF6C00),
    ),
    StatisticCardData(
      title: 'Longest Streak',
      value: '15 days',
      icon: Icons.emoji_events,
      iconCircleColor: Color(0xFFE1BEE7),
      iconColor: Color(0xFF6A1B9A),
    ),
    StatisticCardData(
      title: 'Completed',
      value: '124',
      icon: Icons.check_circle,
      iconCircleColor: Color(0xFFC8E6C9),
      iconColor: Color(0xFF2E7D32),
    ),
    StatisticCardData(
      title: 'Active Tasks',
      value: '12',
      icon: Icons.task_alt,
      iconCircleColor: Color(0xFFBBDEFB),
      iconColor: Color(0xFF1E88E5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.share_outlined, color: Color(0xFF1A1A2E)),
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
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE8EAF6),
                        child: Icon(
                          Icons.person,
                          size: 42,
                          color: Color(0xFF5C6BC0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mahmoud Ragab',
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Undergraduate Student',
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
                children: _statistics
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
                      activeColor: AppColors.primaryLightPurple,
                      value: _notificationsOn,
                      onChanged: (value) {
                        setState(() {
                          _notificationsOn = value;
                        });
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
                      activeColor: AppColors.primaryColor,
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
                            builder: (_) => const PrivacySecurityScreen(),
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
                  icon: const Icon(Icons.logout, color: AppColors.logoutRed),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      color: AppColors.logoutRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
