import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  //This function used to upload image on firebase storage
  Future<String?> uploadImage(path) async {

    // Creating the name
    String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    // adding the metadata
    SettableMetadata metadata =
    SettableMetadata(
        cacheControl: "public,max-age=300",
        contentType: "image/jpeg",
    );
    //Set up references to upload images
    Reference referenceImageToUpload = FirebaseStorage.instance.ref().child('images').child(uniqueFileName);
    referenceImageToUpload.updateMetadata(metadata);
    try {
      await referenceImageToUpload.putFile(File(path),metadata);
      String imageUrl = await referenceImageToUpload.getDownloadURL();
     return imageUrl;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
