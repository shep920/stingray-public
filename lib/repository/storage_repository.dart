import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:hero/helpers/compress_to_shit.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:image_picker/image_picker.dart';

import '/models/models.dart';

class StorageRepository {
  //make a constructor for StorageRepository that takes a boolean testing that is false by default
  StorageRepository({this.testing = false});

  final bool testing;
  late FirebaseStorage storage =
      (testing) ? MockFirebaseStorage() : FirebaseStorage.instance;

  Future<void> uploadImage(User user, XFile image, File compressedFile) async {
    try {
      await storage.ref('${user.id}/${image.name}').putFile(
            compressedFile,
          );
    } catch (err) {
      print(err);
    }
  }

  Future<void> uploadDiscoveryMessageImage(
      {required File compressedFile, required String chatId}) async {
    String ref =
        'discoveryMessages/$chatId/${compressedFile.path.split('/').last}';
    await storage.ref(ref).putFile(
          compressedFile,
        );
  }

  Future<void> deleteImage(User user, String imageUrl) async {
    FirestoreRepository().deleterUserImagurl(user, imageUrl);
    await storage.refFromURL(imageUrl).delete();
  }

  Future<void> deleteUser(User user) async {
    final storageRef = FirebaseStorage.instance.ref().child("${user.id}");
    final listResult = await storageRef.listAll();

    for (var item in listResult.items) {
      await item.delete();
      // The items under storageRef.
    }
  }

  //write a method uploadWaveImage that takes a file and waveId and uploads it to the waveId folder
  Future<void> uploadWaveImage(File image, String waveId) async {
    try {
      await storage
          .ref('waves/$waveId/${image.path.split('/').last}')
          .putFile(image);
    } catch (err) {
      print(err);
    }
  }

  Future<void> uploadPrizeImage({required File image,required String prizeId}) async {
    try {
      await storage
          .ref('waves/$prizeId/${image.path.split('/').last}')
          .putFile(image);
    } catch (err) {
      print(err);
    }
  }

  Future<void> uploadUserVerificationImage(File image, String userId) async {
    try {
      await storage
          .ref('userVerification/$userId/${image.path.split('/').last}')
          .putFile(image);
    } catch (err) {
      print(err);
    }
  }

  Future<void> uploadStory(File image, String stingrayId) async {
    try {
      await storage
          .ref('stories/$stingrayId/${image.path.split('/').last}')
          .putFile(image);
    } catch (err) {
      print(err);
    }
  }

  //write a method getWaveImageUrl that takes a waveId and imageName and returns the download url
  Future<String> getWaveImageUrl(File image, String waveId) async {
    String downloadURL = await storage
        .ref('waves/$waveId/${image.path.split('/').last}')
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> getPrizeImageUrl(File image, String prizeId) async {
    String downloadURL = await storage
        .ref('waves/$prizeId/${image.path.split('/').last}')
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> getUserVerificationImageUrl(File image, String userId) async {
    String downloadURL = await storage
        .ref('userVerification/$userId/${image.path.split('/').last}')
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> getStoryImageUrl(File image, String stingrayId) async {
    String downloadURL = await storage
        .ref('stories/$stingrayId/${image.path.split('/').last}')
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> getDiscoveryMessageImageUrl(
      {required File compressedFile, required String chatId}) async {
    String ref =
        'discoveryMessages/$chatId/${compressedFile.path.split('/').last}';
    String downloadURL = await storage.ref(ref).getDownloadURL();
    return downloadURL;
  }

  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL =
        await storage.ref('${user.id}/$imageName').getDownloadURL();
    return downloadURL;
  }
}
