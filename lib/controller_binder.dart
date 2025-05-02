import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/login_controller.dart';
import 'package:task_manager_app/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_app/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_app/ui/controllers/forget_password_pin_verification_controller.dart';
import 'package:task_manager_app/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:task_manager_app/ui/controllers/new_task_controller.dart';
import 'package:task_manager_app/ui/controllers/register_controller.dart';
import 'package:task_manager_app/ui/controllers/reset_password_controller.dart';
import 'package:task_manager_app/ui/controllers/update_profile_controller.dart';

import 'ui/controllers/completed_task_controller.dart';
import 'ui/controllers/progress_task_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(CompletedTaskController());
    Get.put(CancelledTaskController());
    Get.put(ProgressTaskController());
    Get.put(AddNewTaskController());
    Get.put(ForgetPasswordVerifyEmailController());
    Get.put(ForgetPasswordPinVerificationController());
    Get.put(UpdateProfileController());
    Get.put(RegisterController());
    Get.put(ResetPasswordController());




  }

}