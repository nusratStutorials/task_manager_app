import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/models/login_model.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/service/network_client.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(String email,String firstName,String lastName,String mobile, String? password,XFile? photo) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if (password != null) {
      requestBody['password'] = password;
    }
    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      String encodedImage= base64Encode(imageBytes);
      requestBody['photo']=encodedImage;
    }

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    if (response.isSuccess) {
      if (photo == null) {
        requestBody['photo']=AuthController.userModel?.photo;
      }
      final updatedUser = UserModel.fromJson(requestBody);
      AuthController.saveUserInformation(AuthController.token!,updatedUser);
      isSuccess=true;
      _errorMessage=null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }
}
