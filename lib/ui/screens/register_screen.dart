import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/register_controller.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  final RegisterController _registerController = Get.find<RegisterController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  'Join with Us',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: 'Email'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _firstNameTEController,
                  decoration: InputDecoration(hintText: 'First Name'),
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _lastNameTEController,
                  decoration: InputDecoration(hintText: 'Last Name'),
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your last name';
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _mobileTEController,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (String? value) {
                    String phone = value?.trim() ?? '';
                    RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                    if (regExp.hasMatch(phone) == false) {
                      return 'Enter your valid phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                TextFormField(
                  obscureText: true,
                  controller: _passwordTEController,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                      return 'Enter your password more than 6 letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GetBuilder<RegisterController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.registrationInProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
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
                            TextSpan(text: "Have an Account?"),
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
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }
  Future<void> _registerUser() async {
    final bool isSuccess = await _registerController.registerUser(_emailTEController.text.trim(),_firstNameTEController.text.trim(),_lastNameTEController.text.trim(),_mobileTEController.text.trim(),_passwordTEController.text);

    if (isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'User registered successfully!');
    } else {
      showSnackBarMessage(context, _registerController.errorMessage!, true);
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

 @override
  void dispose() {
    // TODO: implement dispose
   _emailTEController.dispose();
   _firstNameTEController.dispose();
   _lastNameTEController.dispose();
   _mobileTEController.dispose();
   _passwordTEController.dispose();
    super.dispose();
  }
}
