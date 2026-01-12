import 'package:coworkers/config/app_info.dart';
import 'package:coworkers/datasources/user_datasource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  void clear() {
    Get.delete<SignUpController>(force: true);
  }

  final edtName = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool n) => _loading.value = n;

  Future<void> execute(BuildContext context) async {
    // ------- VALIDASI INPUT -------
    if (edtName.text.isEmpty) {
      AppInfo.failed(context, 'Name wajib diisi');
      return;
    }

    if (edtEmail.text.isEmpty) {
      AppInfo.failed(context, 'Email wajib diisi');
      return;
    }

    if (!GetUtils.isEmail(edtEmail.text)) {
      AppInfo.failed(context, 'Email tidak valid');
      return;
    }

    if (edtPassword.text.isEmpty) {
      AppInfo.failed(context, 'Password wajib diisi');
      return;
    }

    if (edtPassword.text.length < 8) {
      AppInfo.failed(context, 'Password minimal 8 karakter');
      return;
    }

    // ------- CALL API -------
    loading = true;
    try {
      final result = await UserDatasource.signUp(
        edtName.text.trim(),
        edtEmail.text.trim(),
        edtPassword.text,
      );

      result.fold(
        (message) {
          AppInfo.failed(context, message);
        },
        (data) {
          AppInfo.toastSucces('Berhasil');
          // TODO: kalau mau langsung login / pindah page di sini
        },
      );
    } catch (e, st) {
      // kalau Future-nya error / throw
      // (misal AppwriteException belum di-handle di datasource)
      debugPrint('SignUp error: $e\n$st');
      AppInfo.failed(context, e.toString());
    } finally {
      // ini DIJAMIN kepanggil, mau sukses atau error
      loading = false;
    }
  }

  @override
  void onClose() {
    edtName.dispose();
    edtEmail.dispose();
    edtPassword.dispose();
    super.onClose();
  }
}
