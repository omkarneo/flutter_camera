// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/di/di.dart';
import 'dart:io';

import 'package:flutter_camera/screen/camera.dart';
import 'package:flutter_camera/utils/sharedPref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class PreviewPage extends ConsumerStatefulWidget {
  final CameraController controller;
  const PreviewPage({Key? key, required this.controller}) : super(key: key);

  @override
  ConsumerState<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends ConsumerState<PreviewPage> {
  @override
  void initState() {
    widget.controller.pausePreview();
    ref.read(CameraListProvider).getImage();
    super.initState();

    // widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Page'),

        // leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () async {
        //       widget.controller.resumePreview();
        //       Navigator.pop(context);

        //       // List<CameraDescription> cameras = await availableCameras();
        //       // Navigator.pushAndRemoveUntil(
        //       //     context,
        //       //     MaterialPageRoute(
        //       //       builder: (context) => CameraApp(cameras: cameras),
        //       //     ),
        //       //     (route) => false);
        //     }),
      ),
      body: Consumer(builder: (context, ref, child) {
        var listdata = ref.watch(CameraListProvider).data.reversed.toList();
        print(listdata);
        return Center(
          child: GridView.builder(
              // reverse: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: listdata.length,
              itemBuilder: (context, index) {
                var data = listdata[index];
                return InkWell(
                  onTap: () {
                    var path = File(data.path).path.toString();
                    var pathList = path.split("/");

                    showAdaptiveDialog(
                      useSafeArea: false,
                      context: context,
                      builder: (context) {
                        return Stack(
                          // fit: StackFit.expand,
                          children: [
                            PhotoView(
                                imageProvider: FileImage(
                              data,
                            )),
                            SizedBox(
                              height: 80,
                              width: MediaQuery.sizeOf(context).width,
                              child: AppBar(
                                backgroundColor: Colors.black.withOpacity(0.8),
                                iconTheme:
                                    const IconThemeData(color: Colors.white),
                                title: Text(
                                  pathList[pathList.length - 1],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return PhotoView(
                    //         imageProvider: FileImage(
                    //       data,
                    //     ));
                    //   },
                    // );
                  },
                  child: Card(
                    child: Image.file(File(data.path),
                        fit: BoxFit.cover, width: 100),
                  ),
                );
              }),
        );
      }),
    );
  }
}
