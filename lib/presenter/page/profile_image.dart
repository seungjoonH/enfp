import 'dart:io';

import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageP extends GetxController {
  final s = FirebaseStorage.instance;

  static void toProfileImage(EUser user) {
    Get.toNamed('/profileImage', arguments: user);
    final profileImageP = Get.find<ProfileImageP>();
    profileImageP.user = user;
    profileImageP.init();
  }

  void init() {
    _editMode = false; update();
  }

  late EUser user;
  late File _image;

  bool _editMode = false;
  bool _loading = false;

  bool get editMode => _editMode;
  bool get loading => _loading;

  void pickImage() async {
    _editMode = true; update();

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    _loading = true; update();
    _image = File(pickedFile.path);

    UploadTask uploadTask = s.ref().child('profile/${user.uid}.png').putFile(_image);

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state != TaskState.success) return;

    user.imageUrl = await snapshot.ref.getDownloadURL();
    _loading = false; update();
  }

  void submit() {
    final userP = Get.find<UserP>();
    userP.loggedUser = user;
    userP.save();
    _editMode = false;
    update();
  }
}