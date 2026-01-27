import 'package:appwrite/models.dart';
import 'package:coworkers/controllers/user_controller.dart';
import 'package:coworkers/models/user_model.dart';
import 'package:d_session/d_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppSession {
  static Future<bool> setUser(Map<String, dynamic> user) async {
    final success = await DSession.setUser(user);

    if (success) {
      final userController = Get.put(UserController());
      userController.data = UserModel.fromJson(Map<String, dynamic>.from(user));
    }

    return success;
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final mapUser = await DSession.getUser();

    if (mapUser != null) {
      final userController = Get.put(UserController());
      userController.data = UserModel.fromJson(
        Map<String, dynamic>.from(mapUser),
      );
      return Map<String, dynamic>.from(mapUser);
    }

    return null;
  }

  static Future<bool> removeUser() async {
    final success = await DSession.removeUser();

    if (success) {
      final userController = Get.put(UserController());
      userController.data = const UserModel();
    }

    return success;
  }
}
