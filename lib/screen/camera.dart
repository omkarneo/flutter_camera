// ignore_for_file: use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera/di/di.dart';
import 'package:flutter_camera/screen/preview.dart';
import 'package:flutter_camera/utils/file_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_camera_sound/native_camera_sound.dart';

class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  /// Default Constructor
  const CameraApp({super.key, required this.cameras});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  int cmaeraoption = 0;
  @override
  void initState() {
    super.initState();

    controller =
        CameraController(widget.cameras[cmaeraoption], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void cameraswitch(optioms) {
    controller =
        CameraController(widget.cameras[optioms], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cmaeraoption = optioms;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future takePicture(WidgetRef ref) async {
    if (!controller.value.isInitialized) {
      return null;
    }
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      final player = await AudioPlayer();
      await controller.setFlashMode(FlashMode.off);
      // await controller.setFlashMode()
      ref.read(CameraListProvider).shutterTaker();
      await player.play(AssetSource('sound/shutter.mp3'));

      XFile picture = await controller.takePicture();

      ref.read(CameraListProvider).takepicture(picture);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.flash_on))],
        // ),
        // appBar: AppBar(
        //   title: Text("Camera"),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           FileStorage().fetchImages();
        //         },
        //         icon: Icon(Icons.abc))
        //   ],
        // ),
        body: Stack(
      children: [
        SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: CameraPreview(
              controller,
            )),
        Consumer(builder: (context, ref, index) {
          var shutter = ref.watch(CameraListProvider).shutter;
          return shutter
              ? Container(
                  height: MediaQuery.sizeOf(context).height,
                  color: Colors.black.withOpacity(0.5),
                )
              : const SizedBox.shrink();
        }),
        SizedBox(
          height: 150,
          width: MediaQuery.sizeOf(context).width,
          child: Consumer(builder: (context, ref, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      if (ref.watch(CameraListProvider).focus) {
                        controller.setFocusMode(FocusMode.auto);
                      } else {
                        controller.setFocusMode(FocusMode.locked);
                      }
                      ref.read(CameraListProvider).focusSwitch();
                    },
                    icon: Icon(
                      ref.watch(CameraListProvider).focus
                          ? Icons.center_focus_strong_outlined
                          : Icons.center_focus_weak_outlined,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      if (ref.watch(CameraListProvider).flash) {
                        controller.setFlashMode(FlashMode.off);
                      } else {
                        controller.setFlashMode(FlashMode.torch);
                      }
                      ref.read(CameraListProvider).flashSwitch();
                    },
                    icon: Icon(
                      ref.watch(CameraListProvider).flash
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: Colors.white,
                    ))
              ],
            );
          }),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.75,
          bottom: 50,
          // left: MediaQuery.sizeOf(context).width / 2.5,
          // right: MediaQuery.sizeOf(context).width / 2.5,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                IconButton(
                    onPressed: () {
                      if (cmaeraoption == 1) {
                        cameraswitch(0);
                      } else {
                        cameraswitch(1);
                      }
                    },
                    icon: const Icon(
                      Icons.flip_camera_android_sharp,
                      size: 50,
                      color: Colors.white,
                    )),
                const Spacer(),
                Consumer(builder: (context, ref, child) {
                  return InkWell(
                    onTap: () async {
                      await takePicture(ref);

                      // controller.startVideoRecording();
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white, width: 10)),
                    ),
                  );
                }),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewPage(
                                  controller: controller,
                                  // picture: picture,
                                )),
                      ).then((value) {
                        controller.resumePreview();
                      });
                    },
                    icon: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    )),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
