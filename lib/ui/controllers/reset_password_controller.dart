import 'package:get/get.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _resetPasswordInProgress = false;
  bool get resetPasswordInProgress => _resetPasswordInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword(String email, String password, String otp) async {
    bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess=true;
      _errorMessage=null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _resetPasswordInProgress = false;
    update();
    return isSuccess;
  }
}

