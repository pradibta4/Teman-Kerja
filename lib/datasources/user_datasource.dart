import 'package:appwrite/appwrite.dart';
import 'package:coworkers/config/app_log.dart';
import 'package:coworkers/config/appwrite.dart';
import 'package:dartz/dartz.dart';

class UserDatasource {
  final Account _account = Appwrite.account;

  Future<void> logout() async {
    // hapus session di Appwrite
    await _account.deleteSession(sessionId: 'current');
  }

  static Future<Either<String, Map<String, dynamic>>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final resultAuth = await Appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      final response = await Appwrite.databases.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionUsers,
        documentId: resultAuth.$id,
        data: {'name': name, 'email': email},
      );

      final data = Map<String, dynamic>.from(response.data);
      AppLog.success(body: data.toString(), title: 'User - SignUp');

      return Right(data);
    } catch (e) {
      AppLog.error(body: e.toString(), title: 'User - SignUp');

      String defaultMessage = 'Terjadi suatu masalah';
      String message = defaultMessage;

      if (e is AppwriteException) {
        if (e.code == 409) {
          message = 'Email sudah terdaftar';
        } else {
          message = e.message ?? defaultMessage;
        }
      }

      return Left(message);
    }
  }

  static Future<Either<String, Map<String, dynamic>>> signIn(
    String email,
    String password,
  ) async {
    try {
      final userId = await _resolveUserId(email, password);
      final data = await _fetchUserData(userId);

      AppLog.success(body: data.toString(), title: 'User - SignIn');
      return Right(data);
    } catch (e) {
      AppLog.error(body: e.toString(), title: 'User - SignIn');

      String defaultMessage = 'Terjadi suatu masalah';
      String message = defaultMessage;

      if (e is AppwriteException) {
        if (e.code == 401 && e.type != 'user_session_already_exists') {
          message = 'Account tidak dikenali';
        } else if (e.message != null && e.message!.isNotEmpty) {
          message = e.message!;
        }
      }

      return Left(message);
    }
  }

  static Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    final response = await Appwrite.databases.getDocument(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.collectionUsers,
      documentId: userId,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<String> _resolveUserId(String email, String password) async {
    final existingUserId = await _getExistingSessionUserId();
    if (existingUserId != null) {
      // Session already active, no need to authenticate again.
      AppLog.netral(
        title: 'User - SignIn',
        body: 'Session aktif ditemukan, gunakan session saat ini',
      );
      return existingUserId;
    }

    return _createSessionUserId(email, password);
  }

  static Future<String?> _getExistingSessionUserId() async {
    try {
      // Quick health check: if Appwrite already has a session, reuse it instead of creating a new one.
      final session = await Appwrite.account.getSession(sessionId: 'current');
      return session.userId;
    } on AppwriteException catch (e) {
      if (e.code == 401 || e.code == 404) {
        return null;
      }
      rethrow;
    }
  }

  static Future<String> _createSessionUserId(
    String email,
    String password,
  ) async {
    try {
      // Normal sign-in path: create a fresh email/password session.
      final session = await Appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session.userId;
    } on AppwriteException catch (e) {
      if (e.type == 'user_session_already_exists') {
        // Appwrite throws this when a session already exists; just reuse it.
        final existing = await _getExistingSessionUserId();
        if (existing != null) {
          AppLog.netral(
            title: 'User - SignIn',
            body: 'Session sudah ada, melewati pembuatan baru',
          );
          return existing;
        }
      }
      rethrow;
    }
  }
}
