import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';

import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _conformNewPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ResetPasswordController _resetPasswordController = Get.find<ResetPasswordController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Set a new password minimum length of 6 letters.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  obscureText: true,
                  controller: _newPasswordTEController,
                  decoration: InputDecoration(hintText: 'New Password'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  controller: _conformNewPasswordTEController,
                  decoration: InputDecoration(hintText: 'Confirm New Password'),
                ),
                const SizedBox(height: 16),
                GetBuilder<ResetPasswordController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.resetPasswordInProgress == false,
                      replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Text('Confirm'),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: "Have Account?"),
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      _onTapSignInButton();
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    _resetPassword();
  }
  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (pre) => false,
    );
  }
  Future<void> _resetPassword() async {
    final bool isSuccess =  await _resetPasswordController.resetPassword(
      widget.email,_newPasswordTEController.text,widget.otp
    );
    if (_newPasswordTEController.text != _conformNewPasswordTEController.text) {
      showSnackBarMessage(context, 'Passwords do not match', true);
      return;
    }

    if (isSuccess) {
      showSnackBarMessage(context, 'Password reset successfully!');
      await Future.delayed(Duration(seconds: 2));
      if(mounted){
        Get.offAll(() => const LoginScreen());
      }

    } else {
      showSnackBarMessage(context, _resetPasswordController.errorMessage!, true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _newPasswordTEController.dispose();
    _conformNewPasswordTEController.dispose();
    super.dispose();
  }
}
