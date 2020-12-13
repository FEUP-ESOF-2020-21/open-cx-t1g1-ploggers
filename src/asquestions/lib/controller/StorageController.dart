import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  final storage = FirebaseStorage.instance;

  Future<String> getImgURL(String path) async {
    return await storage.ref(path).getDownloadURL();
  }

  Future<String> uploadFile(File image, String filename) async {
    TaskSnapshot task = await storage.ref().child(filename).putFile(image);

    return task.ref.getDownloadURL();
  }
}
