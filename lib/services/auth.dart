import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/main.dart';
import 'package:health_connect/services/db/db_2.dart';
import 'package:health_connect/views/dialogs/dialogs.dart';
import 'package:health_connect/views/pages/home/home.dart';
import 'package:health_connect/views/pages/onboarding/introduction_page.dart';
import 'package:health_connect/views/pages/onboarding/create_profile_page_1.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();

  bool isSignedIn = false;
  String userId = 'userId';
  String email = "email";

  doThis() async {
    isSignedIn = true;
    userId = _auth.currentUser!.uid;
    email = _auth.currentUser!.email.toString();
  }

  bool userInfo = false;

  getUserInfo() async {
    final dbController2 = Get.put(DbController2(), permanent: true);
    await dbController2.getMyInfo();
    if (dbController2.userProfileModel.isNotEmpty) {
      userInfo = true;
    }
  }

  currentUser() async {
    return _asyncMemoizer.runOnce(() async {
      if (_auth.currentUser?.uid == null) {
        isSignedIn = false;
      } else {
        doThis();
        await getUserInfo();
      }
      return _auth.currentUser;
    });
  }

  createUser(
      {String? email, String? password, required BuildContext context}) async {
    Dialogs.circularProgressIndicatorDialog(context);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.toString(),
        password: password.toString(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await doThis();
        Get.offAll(() => CreateProfilePage1());
      }
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(e.message.toString());
    } catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(StringConst.anUnexpectedError);
    }
  }

  signInWithEmail(
      {String? email, String? password, required BuildContext context}) async {
    Dialogs.circularProgressIndicatorDialog(context);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      User? user = userCredential.user;
      if (user != null) {
        doThis();
        await getUserInfo();
        if (!userInfo) {
          Get.to(() => CreateProfilePage1());
        } else {
          Get.offAll(() => const HomePage());
        }
      }
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(e.message.toString());
    } catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(StringConst.anUnexpectedError);
    }
  }

  signOut() async {
    await _auth.signOut();
    isSignedIn = false;
    userId = 'userId';
    email = "email";
    userInfo = false;
    Get.offAll(() => const IntroductionPage());
  }

  forgotPassword(String email, BuildContext context) async {
    Dialogs.circularProgressIndicatorDialog(context);
    try {
      await _auth.sendPasswordResetEmail(email: email).then(
        (value) {
          navigatorKey.currentState!.pop();
          Dialogs.defaultDialog2(
              StringConst.resetPassword, StringConst.passwordResetEmail);
        },
      ).catchError(
        (e) {
          navigatorKey.currentState!.pop();
          Dialogs.defaultDialog1(e.message.toString());
        },
      );
    } catch (e) {
      navigatorKey.currentState!.pop();
      Dialogs.defaultDialog1(StringConst.anUnexpectedError);
    }
  }
}
