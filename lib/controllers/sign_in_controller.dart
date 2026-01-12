import 'package:coworkers/config/app_info.dart';
import 'package:coworkers/config/app_log.dart';
import 'package:coworkers/config/enums.dart';
import 'package:coworkers/config/session.dart';
import 'package:coworkers/datasources/user_datasource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final _userDatasource = UserDatasource();

  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool value) => _loading.value = value;

  /// Clear both input fields but keep the controller instance alive.
  void clear() {
    edtEmail.clear();
    edtPassword.clear();
  }

  @override
  void onClose() {
    edtEmail.dispose();
    edtPassword.dispose();
    super.onClose();
  }

  Future<void> logout() async {
    try {
      await _userDatasource.logout();
      await AppSession.removeUser();
      AppLog.success(title: 'User - Logout', body: 'Berhasil logout');
    } catch (e) {
      AppLog.error(title: 'User - Logout', body: e.toString());
    }
  }

  Future<void> execute(BuildContext context) async {
    final email = edtEmail.text.trim();
    final password = edtPassword.text;

    if (email.isEmpty) {
      AppInfo.failed(context, 'Email wajib diisi');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppInfo.failed(context, 'Email tidak valid');
      return;
    }

    if (password.isEmpty) {
      AppInfo.failed(context, 'Password wajib diisi');
      return;
    }

    if (password.length < 8) {
      AppInfo.failed(context, 'Password minimal 8 karakter');
      return;
    }

    loading = true;
    try {
      final result = await UserDatasource.signIn(email, password);

      await result.fold<Future<void>>(
        (message) async {
          // Data source already handles session reuse; errors here mean invalid credentials or server issues.
          AppLog.error(title: 'User - SignIn', body: message);
          if (!context.mounted) return;
          AppInfo.failed(context, message);
        },
        (data) async {
          // Persist the authenticated user locally so GetX controllers can react.
          await AppSession.setUser(data);
          AppLog.success(title: 'User - SignIn', body: 'Berhasil login');
          AppInfo.toastSucces('Berhasil');
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(
            context,
            AppRoute.dashboard.name,
          );
        },
      );
    } catch (e) {
      AppLog.error(title: 'User - SignIn', body: e.toString());
      if (context.mounted) {
        AppInfo.failed(context, 'Gagal masuk, coba beberapa saat lagi');
      }
    } finally {
      loading = false;
    }
  }
}
