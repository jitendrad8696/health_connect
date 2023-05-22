import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/firebase_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/controllers/create_profile_controller.dart';
import 'package:health_connect/main.dart';
import 'package:health_connect/views/dialogs/dialogs.dart';

class DbController1 extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CreateProfileController _createProfileController = Get.find();

  Future<void> saveUserInfo(BuildContext context) async {
    Dialogs.circularProgressIndicatorDialog(context);
    try {
      User? user = _auth.currentUser;
      return _firestore.collection(FirebaseConst.users).doc(user!.uid).set(
        {
          FirebaseConst.userId: user.uid,
          FirebaseConst.email: user.email,
          FirebaseConst.avatar: _createProfileController.avatar(),
          FirebaseConst.userName: _createProfileController.userName(),
          FirebaseConst.phoneNumber: _createProfileController.userPhoneNumber(),
          FirebaseConst.countryValue: _createProfileController.countryValue(),
          FirebaseConst.stateValue: _createProfileController.stateValue(),
          FirebaseConst.cityValue: _createProfileController.cityValue(),
          FirebaseConst.pinCode: _createProfileController.pinCode(),
          FirebaseConst.gender: _createProfileController.gender(),
          FirebaseConst.age: _createProfileController.age(),
          FirebaseConst.bloodGroup: _createProfileController.bloodGroup(),
          FirebaseConst.wantToDonate: _createProfileController.wantToDonate(),
        },
      );
    } catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(StringConst.anUnexpectedError);
      if (kDebugMode) {
        print('DbController1 saveUserInfo Error = $e');
      }
    }
  }
}
