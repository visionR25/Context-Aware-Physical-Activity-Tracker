import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:physical_tracking_app/pages/logIn/log_in.dart';
import 'package:physical_tracking_app/pages/navBar/nav_bar_screen.dart';
import 'package:physical_tracking_app/utils/global_functions.dart';

import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await assignUserData();
  runApp(const MyApp());
}

Rx<UserModel>? globalUserModel;

//assign data
assignUserData() async {
  UserModel? userModel = await getUserData();
  if (userModel != null) {
    globalUserModel = UserModel.copyModel(userModel).obs;
  }
}

///firebase auth
FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Physical Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: globalUserModel != null ? NavBarScreen() : LogIn(),
    );
  }
}
