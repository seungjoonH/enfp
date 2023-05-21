import 'package:camera/camera.dart';
import 'package:enfp/firebase_options.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/presenter/global.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/camera.dart';
import 'package:enfp/route.dart';
import 'package:enfp/view/page/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraP.descriptions = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ENFPApp());
}

class ENFPApp extends StatelessWidget {
  const ENFPApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalP.initControllers();

    return GetBuilder<UserP>(
      builder: (userP) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          themeMode: userP.loggedUser?.themeMode ?? ThemeMode.system,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ETheme.lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ETheme.darkColorScheme,
          ),
          home: const LoginPage(),
          getPages: ERoute.getPages,
        );
      },
    );
  }
}