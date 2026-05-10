import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_button.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key, this.userData});
  final Map<String, String>? userData;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.mark_email_unread_outlined,
              size: 80,
              color: Color(0xFF9BA4FF),
            ),
            const SizedBox(height: 30),
            const Text(
              "Verify Your Email",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D264F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "We've sent a verification link to your email. Please click the link to activate your account.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Text(
              "Check your inbox",
              style: TextStyle(
                color: const Color(0xFF9BA4FF),
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            authProvider.isLoading
                ? const CircularProgressIndicator(color: Color(0xFF9BA4FF))
                : AuthButton(
                    text: "I've Verified My Email",
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();

                      await auth.checkEmailVerified();

                      if (!context.mounted) return;

                      if (auth.isEmailVerified) {
                        try {
                          await auth.saveUserDataToFirestore(
                            fullName: userData?['fullName'] ?? "New User",
                            email: userData?['email'] ?? "",
                          );

                          if (context.mounted) {
                            context.go('/');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error saving data: $e")),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Email not verified yet. Please check your inbox.",
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the link? ",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                GestureDetector(
                  onTap: () async {
                    await context.read<AuthProvider>().sendVerificationEmail();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification link resent!"),
                      ),
                    );
                  },
                  child: const Text(
                    "Resend Link",
                    style: TextStyle(
                      color: Color(0xFF9BA4FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF9BA4FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
