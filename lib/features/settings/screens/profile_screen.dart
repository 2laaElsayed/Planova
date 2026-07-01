import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import '../providers/settings_provider.dart';
import '../models/settings_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _currentUserId;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _syncControllers(SettingsUser? user) {
    if (user == null) return;
    if (_currentUserId != user.uid) {
      _currentUserId = user.uid;
      _usernameController.text = user.fullName;
      _emailController.text = user.email;
    }
  }

  Future<String?> _promptForPassword() async {
    final passwordController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Password', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your current password to update your email.',
                style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.kPrimary),
              onPressed: () => Navigator.of(context).pop(passwordController.text.trim()),
              child: Text('Confirm', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
    passwordController.dispose();
    return result;
  }

  Future<void> _onChangePhotoTapped(SettingsProvider settings) async {
    final imageUrlController = TextEditingController();
    final newImageUrl = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Profile Photo', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          content: TextField(
            controller: imageUrlController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Paste image URL',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.kPrimary),
              onPressed: () => Navigator.of(context).pop(imageUrlController.text.trim()),
              child: Text('Save', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );

    imageUrlController.dispose();
    if (newImageUrl == null || newImageUrl.isEmpty) return;

    try {
      await settings.updateProfileImageUrl(newImageUrl);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile photo updated', style: GoogleFonts.poppins())),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString(), style: GoogleFonts.poppins())),
      );
    }
  }

  Future<void> _saveChanges(SettingsProvider settings, SettingsUser user) async {
    if (_formKey.currentState?.validate() != true) return;

    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();
    final emailChanged = newEmail != user.email;
    final nameChanged = newUsername != user.fullName;

    if (!emailChanged && !nameChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nothing to save', style: GoogleFonts.poppins())),
      );
      return;
    }

    try {
      if (nameChanged) {
        await settings.updateUsername(newUsername);
      }
      if (emailChanged) {
        final password = await _promptForPassword();
        if (password == null || password.isEmpty) return;
        await settings.updateEmail(newEmail, password);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully', style: GoogleFonts.poppins())),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString(), style: GoogleFonts.poppins())),
      );
    }
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: AppColors.textGrey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final user = settings.user;
    _syncControllers(user);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFFE8EAF6),
                          backgroundImage: user.profilePicUrl.isNotEmpty
                              ? NetworkImage(user.profilePicUrl) as ImageProvider
                              : null,
                          child: user.profilePicUrl.isEmpty
                              ? Text(
                                  user.initials,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () => _onChangePhotoTapped(settings),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName,
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.role,
                      style: GoogleFonts.poppins(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildFormField(
                            label: 'Username',
                            icon: Icons.person_outline,
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            label: 'Email Address',
                            icon: Icons.mail_outline,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: settings.isSaving
                                  ? null
                                  : () => _saveChanges(settings, user),
                              child: Text(
                                settings.isSaving ? 'Saving...' : 'Save Changes',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
