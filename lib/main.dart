import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/services/auth.dart';
import 'package:health_connect/views/pages/error_page.dart';
import 'package:health_connect/views/pages/home/home.dart';
import 'package:health_connect/views/pages/onboarding/introduction_page.dart';
import 'package:health_connect/views/pages/onboarding/create_profile_page_1.dart';
import 'package:health_connect/views/pages/waiting_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle()
      .copyWith(statusBarColor: ColorConst.whiteColor));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthController _controller = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConst.appTitle,
      navigatorKey: navigatorKey,
      theme: ThemeData.light().copyWith(
        primaryColor: ColorConst.primaryColor,
      ),
      home: FutureBuilder(
        future: _controller.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingPage();
          } else if (snapshot.hasError) {
            return const ErrorPage();
          } else if (!snapshot.hasData) {
            return const IntroductionPage();
          } else if (!_controller.userInfo) {
            return CreateProfilePage1();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
