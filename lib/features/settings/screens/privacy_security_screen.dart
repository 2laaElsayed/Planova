import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:planova_app/features/auth/providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'profile_screen.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _isDeleting = false;

  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final auth = context.read<AuthProvider>();
    final goRouter = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete your account and all related data?',
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
                'Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await provider.deleteAccount();
      await auth.logout();
      if (!mounted) return;
      goRouter.go('/signIn');
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString(), style: GoogleFonts.poppins())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Widget _buildTrailingIcon(Color color) {
    return Icon(Icons.chevron_right, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SettingsProvider>().user;
    final String userName = user?.fullName ?? 'Loading...';
    final DateTime? lastChanged = user?.passwordChangedAt;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Privacy & Security',
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.backgroundColor,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF5C6BC0)),
                    ),
                    title: Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      userName,
                      style: GoogleFonts.poppins(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    trailing: _buildTrailingIcon(const Color(0xFF9E9E9E)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (routeContext) =>
                              ChangeNotifierProvider<SettingsProvider>.value(
                                value: context.read<SettingsProvider>(),
                                child: const ProfileScreen(),
                              ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lock, color: Color(0xFF5C6BC0)),
                    ),
                    title: Text(
                      'Change Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      lastChanged != null
                          ? 'Last changed ${timeago.format(lastChanged)}'
                          : 'Never changed',
                      style: GoogleFonts.poppins(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    trailing: _buildTrailingIcon(const Color(0xFF9E9E9E)),
                    onTap: () => context.push('/changePassword'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    title: Text(
                      'Delete Account',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE53935),
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently remove your data',
                      style: GoogleFonts.poppins(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    trailing: _buildTrailingIcon(const Color(0xFFE53935)),
                    onTap: _isDeleting
                        ? null
                        : () => _showDeleteConfirmDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
