import 'package:get/get.dart';
import 'package:task_manager_app/data/models/login_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controllers/auth_controller.dart';

class ForgetPasswordVerifyEmailController extends GetxController {
  bool _verifyEmailInProgress = false;
  bool get verifyEmailInProgress => _verifyEmailInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _email;
  String? get email => _email;



  Future<bool> verifyEmail(String email) async {
    bool isSuccess = false;
    _verifyEmailInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyEmailUrl(email),
    );

    if (response.isSuccess) {
      _email=email;
      isSuccess=true;
      _errorMessage=null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _verifyEmailInProgress = false;
    update();
    return isSuccess;
  }
}

