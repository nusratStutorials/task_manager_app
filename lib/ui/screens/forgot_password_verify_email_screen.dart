import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:task_manager_app/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';

import '../widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  final ForgetPasswordVerifyEmailController _forgetPasswordVerifyEmailController = Get.find<ForgetPasswordVerifyEmailController>();
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
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4,),
                Text('A 6 digit verification pin will be sent to your email.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey
                ),),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: 'Email'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                GetBuilder<ForgetPasswordVerifyEmailController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.verifyEmailInProgress==false,
                      replacement: CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapSignInButton() {
    Navigator.pop(context);
  }
  void _onTapSubmitButton() {
    _verifyEmail();
  }

 Future<void> _verifyEmail() async {
    final bool isSuccess = await _forgetPasswordVerifyEmailController.verifyEmail(
      _emailTEController.text.trim()
    );

    if (isSuccess) {
      Get.to(
            () => ForgotPasswordPinVerificationScreen(email: _emailTEController.text.trim(),),
      );
    } else {
      showSnackBarMessage(
        context,
        _forgetPasswordVerifyEmailController.errorMessage!,
        true,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTEController.dispose();
    super.dispose();
  }
}
