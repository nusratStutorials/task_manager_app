import 'package:get/get.dart';
import 'package:task_manager_app/data/models/login_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controllers/auth_controller.dart';

class ForgetPasswordPinVerificationController extends GetxController {
  bool _pinVerificationInProgress = false;
  bool get pinVerificationInProgress => _pinVerificationInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _email;
  String? get email => _email;
  String? _otp;
  String? get otp => _otp;


  Future<bool> verifyPin(String email,String otp) async {
    bool isSuccess = false;
    _pinVerificationInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyOtpUrl(email,otp),
    );

    if (response.isSuccess) {
      _email=email;
      _otp=otp;
      isSuccess=true;
      _errorMessage=null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _pinVerificationInProgress = false;
    update();
    return isSuccess;
  }
}
