import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';
import '../providers/auth_provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      try {
        final currentContext = context;

        await currentContext.read<AuthProvider>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!currentContext.mounted) return;

        currentContext.go(
          '/verifyCode',
          extra: {
            'fullName': _nameController.text.trim(),
            'email': _emailController.text.trim(),
          },
        );
      } catch (e) {
        if (!context.mounted) return;

        final errorMessage = context.read<AuthProvider>().getErrorMessage(e);
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: errorMessage),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D264F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Create new account to get Started",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  CustomAuthField(
                    controller: _nameController,
                    hint: "Full Name",
                    icon: Icons.person_outline,
                    validator: (val) => val!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 20),

                  CustomAuthField(
                    controller: _emailController,
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                    validator: (val) {
                      if (val == null || !val.contains('@')) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomAuthField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    suffixIcon: Icons.visibility_off_outlined,
                    validator: (val) =>
                        val!.length < 6 ? "Min 6 characters" : null,
                  ),
                  const SizedBox(height: 20),

                  CustomAuthField(
                    controller: _confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    suffixIcon: Icons.visibility_off_outlined,
                  ),

                  const SizedBox(height: 40),

                  authProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF9BA4FF),
                        )
                      : AuthButton(text: "Sign Up", onPressed: _handleSignUp),

                  const SizedBox(height: 25),
                  _buildOrDivider(),
                  const SizedBox(height: 25),
                  _buildSignInRow(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade200)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("or", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade200)),
      ],
    );
  }

  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already Have an Account ? ",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            context.go('/signIn');
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Color(0xFF9BA4FF),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF9BA4FF),
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
