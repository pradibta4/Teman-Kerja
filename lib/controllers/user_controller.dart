import 'package:coworkers/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _data = const UserModel().obs;
  UserModel get data => _data.value;
  set data(UserModel n) => _data.value = n;
}
