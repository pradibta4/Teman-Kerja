import 'package:appwrite/appwrite.dart';

class Appwrite {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '68d0e3070016eab43741';

  static const databaseId = '690db42a002e922bbbf6';
  static const collectionUsers = 'users';
  static const collectionWorkers = 'workers';
  static const collectionBookings = 'booking';
  static const bucketWorkers = '690ea1e200038380f1c7';

  static Client client = Client();
  static late Account account;
  static late Databases databases;

  static void init() {
    client.setEndpoint(endpoint).setProject(projectId);

    account = Account(client);
    databases = Databases(client);
  }

  static String imageURL(String fileId) {
    return '$endpoint/storage/buckets/$bucketWorkers/files/$fileId/view?project=$projectId';
  }
}
