import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  Future fetchImages() async {
    var imageData = [];
    final String directory = await getExternalDocumentPath();
    Directory(directory).create(recursive: true).then((value) {
      var listdata = value.listSync();
      for (var element in listdata) {
        imageData.add(element);
        // print(element.path);
      }
    });
    return imageData;
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/Download/fortest");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    if (await directory.exists()) {
      print("Saved Path: $exPath");
      await Directory(exPath).create(recursive: true);
      return exPath;
    } else {
      await directory.create();
      print("Saved Path: $exPath");
      await Directory(exPath).create(recursive: true);
      return exPath;
    }
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(Uint8List bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');

    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}
