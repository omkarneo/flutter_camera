import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/utils/file_storage.dart';

class ImageListModel extends ChangeNotifier {
  List data = [];
  bool shutter = false;
  bool flash = false;
  bool focus = false;

  // void loadOlddatya

  void getImage() async {
    data = await FileStorage().fetchImages();

    notifyListeners();
  }

  void flashSwitch() {
    if (flash) {
      flash = false;
    } else {
      flash = true;
    }
    notifyListeners();
  }

  void focusSwitch() {
    if (focus) {
      focus = false;
    } else {
      focus = true;
    }
    notifyListeners();
  }

  void shutterTaker() {
    shutter = true;
    notifyListeners();
  }

  void takepicture(XFile file) async {
    shutter = false;
    // });
    var fileData = await file.readAsBytes();
    String fileName = "${generateRandomString(5)}.jpg";
    FileStorage.writeCounter(fileData, fileName);
    notifyListeners();
    // await Future.delayed(Duration(milliseconds: 500), () {
    // data.add(file);
  }

  String generateRandomString(int length) {
    final random = Random();
    const availableChars = 'abcdefghijklmnopqrstuvwxyz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }
}
