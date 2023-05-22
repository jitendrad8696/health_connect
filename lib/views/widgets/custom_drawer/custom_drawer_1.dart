import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/firebase_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/services/auth.dart';
import 'package:health_connect/services/db/db_2.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/views/pages/home/home.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Drawer1 extends StatefulWidget {
  const Drawer1({Key? key}) : super(key: key);

  @override
  State<Drawer1> createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  final DbController2 _dbController2 = Get.find();

  final AuthController _authController = Get.find();

  File? imageFile;

  void cropimage(XFile? file) async {
    try {
      CroppedFile? cropfile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        compressQuality: 20,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (cropfile != null) {
        setState(() {
          imageFile = File(cropfile.path);
        });
        if (context.mounted) {
          Navigator.pop(context);
        }
        setdata();
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
    } catch (e) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error", e.toString());
    }
  }

  void selectimage(ImageSource source) async {
    UiHelper.showLoadingDialog(context, "Loading");
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        if (context.mounted) {
          Navigator.pop(context);
          UiHelper.showAlertDialog(
              context, "Upload Health Docs !!", "please select the image");
        }
        return;
      }
      cropimage(pickedFile);
    } catch (e) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error!", e.toString());
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Health Docs"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectimage(ImageSource.gallery);
                },
                title: const Text("Select From Gallary"),
                leading: const Icon(Icons.photo_album_outlined),
              ),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectimage(ImageSource.camera);
                  },
                  title: const Text("Select From Camera"),
                  leading: const Icon(Icons.camera_alt_outlined))
            ]),
          );
        });
  }

  void setdata() async {
    try {
      UiHelper.showLoadingDialog(context, "Uploading ");
      DateTime now = DateTime.now();
      String filename = now.toString();
      UploadTask uploadtask = FirebaseStorage.instance
          .ref()
          .child('${FirebaseConst.images}/$filename')
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadtask;
      String imageurl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection(FirebaseConst.images).add({
        FirebaseConst.userId: _authController.userId,
        FirebaseConst.imageUrl: imageurl,
        'TS': DateTime.now(),
      }).then((value) {
        Navigator.pop(context);
        UiHelper.showAlertDialog(
            context, "Image Uploaded", "Your Image Uploaded Successfully");
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConst.whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(ImageConst.bg),
              ),
            ),
            accountName: Text(
              _dbController2.userProfileModel[0].userName,
              style: const TextStyle(
                color: ColorConst.whiteColor,
              ),
            ),
            accountEmail: Text(
              _dbController2.userProfileModel[0].email,
              style: const TextStyle(
                color: ColorConst.whiteColor,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: AppSizes.height10 * 10,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    _dbController2.avatarImageConst(),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text(StringConst.home),
              onTap: () {
                if (Get.currentRoute == '/' ||
                    Get.currentRoute == '/HomePage') {
                  Get.back();
                }
              }),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Get.back();
              Get.to(ProfilePage(
                name: _dbController2.userProfileModel[0].userName,
                pic: _dbController2.avatarImageConst(),
                email: _dbController2.userProfileModel[0].email,
                phone: _dbController2.userProfileModel[0].phoneNumber,
                bloodGroup: _dbController2.userProfileModel[0].bloodGroup,
                age: _dbController2.userProfileModel[0].age,
                uid: _dbController2.userProfileModel[0].userId,
                cityName: _dbController2.userProfileModel[0].cityValue,
                stateName: _dbController2.userProfileModel[0].stateValue,
                gender: _dbController2.userProfileModel[0].gender,
              ));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text("Upload Docs"),
            onTap: () async {
              showPhotoOption();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.image_search_outlined),
            title: const Text("See Docs"),
            onTap: () {
              Get.back();
              Get.to(() => const ShowImages());
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.find_in_page_outlined),
            title: const Text("Find Donors"),
            onTap: () {
              Get.back();
              Get.to(() => const FindDonors());
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("Chats"),
            onTap: () {
              Get.back();
              Get.to(() => ChatRoom());
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(StringConst.logout),
            onTap: () async {
              await _authController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
