import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/firebase_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/models/user_profile_model.dart';

class DbController2 extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<UserProfileModel> userProfileModel = <UserProfileModel>[].obs;

  Future<void> getMyInfo() async {
    userProfileModel.removeRange(0, userProfileModel.length);
    try {
      await _firestore
          .collection(FirebaseConst.users)
          .doc(_auth.currentUser?.uid)
          .get()
          .then((querySnapshot) async {
        userProfileModel.add(
          UserProfileModel(
            userId: querySnapshot.data()![FirebaseConst.userId],
            email: querySnapshot.data()![FirebaseConst.email],
            avatar: querySnapshot.data()![FirebaseConst.avatar],
            userName: querySnapshot.data()![FirebaseConst.userName],
            phoneNumber: querySnapshot.data()![FirebaseConst.phoneNumber],
            countryValue: querySnapshot.data()![FirebaseConst.countryValue],
            stateValue: querySnapshot.data()![FirebaseConst.stateValue],
            cityValue: querySnapshot.data()![FirebaseConst.cityValue],
            pinCode: querySnapshot.data()![FirebaseConst.pinCode],
            gender: querySnapshot.data()![FirebaseConst.gender],
            age: querySnapshot.data()![FirebaseConst.age],
            bloodGroup: querySnapshot.data()![FirebaseConst.bloodGroup],
            wantToDonate: querySnapshot.data()![FirebaseConst.wantToDonate],
          ),
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print('DbController2 getMyInfo Error = $e');
      }
    }
  }

  String avatarImageConst() {
    return ImageConst.avatarImageURL(userProfileModel[0].avatar);
  }
}
