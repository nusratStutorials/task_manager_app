import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/models/user_model.dart';

class AuthController{
  static String? token;
  static UserModel? userModel;
  static const String _tokenkey = 'token';
  static const _userDataKey = 'user-data';
  static Future<void> saveUserInformation(String accessToken, UserModel user) async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenkey, accessToken);
    sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));
    token=accessToken;
    userModel=user;
  }

  static Future<void> getUserInformation() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken=sharedPreferences.getString(_tokenkey);
    String? savedUserModelString=sharedPreferences.getString(_userDataKey);
    if(savedUserModelString!=null){
      UserModel savedUserModel = UserModel.fromJson(jsonDecode(savedUserModelString));
      userModel=savedUserModel;
    }
    token=accessToken;
  }

  static Future<bool> checkIfUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_tokenkey);
    if(userAccessToken!=null){
      await getUserInformation();
      return true;
    }
    else{
      return false;
    }

  }

  static Future<void> clearUserData() async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token=null;
    userModel=null;
  }
}