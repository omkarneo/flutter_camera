import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/screen/camera.dart';
import 'package:flutter_camera/utils/sharedPref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPreference.init();
  cameras = await availableCameras();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CameraApp(
            cameras: cameras,
          )),
    );
  }
}
