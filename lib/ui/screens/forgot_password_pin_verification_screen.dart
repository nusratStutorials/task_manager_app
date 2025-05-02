import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';
import 'package:task_manager_app/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';


class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordPinVerificationScreen({super.key, required this.email});

  @override
  State<ForgotPasswordPinVerificationScreen> createState() => _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pinCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
   bool _pinVerificationInProgress = false;

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
                  'Pin Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4,),
                Text('A 6 digit verification pin has been sent to your email.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey
                ),),
                const SizedBox(height: 24),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _pinCodeTEController,
                  appContext: context,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmitButton,
                  child: Text('Verify'),
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (pre)=>false);
  }

  void _onTapSubmitButton() {
    _verifyPin(widget.email,_pinCodeTEController.text, context);
  }

  Future<void> _verifyPin(String email,String otp,BuildContext context) async {
    _pinVerificationInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyOtpUrl(email,otp),
    );
    _pinVerificationInProgress = false;
    if (response.isSuccess) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen(email: widget.email,otp: otp,)));


    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _pinCodeTEController.dispose();
    super.dispose();
  }
}
