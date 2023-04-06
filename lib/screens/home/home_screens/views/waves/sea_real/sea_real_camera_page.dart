import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hero/helpers/compress_to_shit.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/sea_real_countdown.dart';
import 'package:image_picker/image_picker.dart';

class SeaRealCameraScreen extends StatefulWidget {
  //void function that takes a file
  final void Function(File) takeFirstImage;
  final void Function(File) getSecondImage;
  final void Function(bool) setLoadingFront;
  final void Function(bool) setLoadingBack;

  const SeaRealCameraScreen(
      {super.key,
      required this.takeFirstImage,
      required this.getSecondImage,
      required this.setLoadingFront,
      required this.setLoadingBack});
  @override
  _SeaRealCameraScreenState createState() => _SeaRealCameraScreenState();
}

class _SeaRealCameraScreenState extends State<SeaRealCameraScreen> {
  CameraController? _frontController;
  // late CameraController _backController;

  int _selectedCameraIndex = 0;
  late List<CameraDescription> _cameras;
  bool takingPhoto = false;
  bool flashOff = true;
  double _zoom = 0;
  bool loadingImage = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _cameras = cameras;
      _frontController = CameraController(_cameras[0], ResolutionPreset.max);
      _frontController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _frontController!.setFlashMode(FlashMode.off);
          //set the camera off of fisheye
          _frontController!.setZoomLevel(1);
        });
      });

      // _backController = CameraController(_cameras[1], ResolutionPreset.max);
      // _backController.initialize().then((_) {
      //   if (!mounted) {
      //     return;
      //   }
      //   setState(() {
      //     _backController.setFlashMode(FlashMode.off);
      //     //set the camera off of fisheye
      //     _backController.setZoomLevel(1);
      //   });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _frontController == null
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SeaRealCountDown(),
                    GestureDetector(
                      onScaleEnd: (ScaleEndDetails details) {
                        setState(() {});
                      },
                      child: //if
                          Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black),
                              child: AspectRatio(
                                // aspectRatio: _frontController!.value.aspectRatio but inverted
                                aspectRatio:
                                    1 / _frontController!.value.aspectRatio,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CameraPreview(_frontController!)),
                              )),
                    ),
                  ],
                ),
              ),
              if (loadingImage)
                Center(
                  child: CircularProgressIndicator(),
                ),
              Positioned(
                  bottom: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            (flashOff) ? Icons.flash_off : Icons.flash_on,
                            color: (flashOff) ? Colors.white : Colors.yellow,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              _frontController!.setZoomLevel(1);
                              flashOff = !flashOff;
                              (flashOff)
                                  ? _frontController!
                                      .setFlashMode(FlashMode.off)
                                  : _frontController!
                                      .setFlashMode(FlashMode.auto);
                            });
                          },
                        ),
                        AnimatedContainer(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          duration: Duration(milliseconds: 200),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                takingPhoto ? Colors.white : Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // code to take a picture
                              setState(() {
                                takingPhoto = true;

                                // setState(() {
                                //   takingPhoto = false;
                                // });

                                // widget.setLoadingFront(true);

                                // _frontController!
                                //     .takePicture()
                                //     .then((file) async {
                                //   File _file = File(file.path);
                                //   widget.takeFirstImage(_file);
                                // });
                              });

                              //wait 1 second then set taking photo to false
                              Future.delayed(Duration(milliseconds: 1000),
                                  () async {
                                setState(() {
                                  takingPhoto = false;
                                });

                                widget.setLoadingFront(true);

                                _frontController!
                                    .takePicture()
                                    .then((file) async {
                                  //flip the xfile

                                  File _file = File(file.path);
                                  //flip the image

                                  widget.takeFirstImage(_file);
                                });
                              });

                              //async 2 seconds then set loading to false
                              Future.delayed(Duration(milliseconds: 2000),
                                  () async {
                                widget.setLoadingBack(true);
                                CameraController _frontController =
                                    CameraController(
                                        _cameras[(_selectedCameraIndex == 0)
                                            ? 1
                                            : 0],
                                        ResolutionPreset.max);

                                _frontController.initialize().then((_) {
                                  if (!mounted) {
                                    return;
                                  }
                                  setState(() {
                                    (flashOff)
                                        ? _frontController
                                            .setFlashMode(FlashMode.off)
                                        : _frontController
                                            .setFlashMode(FlashMode.auto);
                                    //set the camera off of fisheye
                                    _frontController.setZoomLevel(1);
                                  });
                                }).then((value) {
                                  //wait 1 second then take the picture
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () async {
                                    //turn flash off
                                    _frontController
                                        .setFlashMode(FlashMode.off);

                                    _frontController
                                        .takePicture()
                                        .then((file) async {
                                      File _file = File(file.path);
                                      widget.getSecondImage(_file);
                                    }).then((value) {
                                      widget.setLoadingBack(false);
                                    });
                                  });
                                });

                                //wait a second then take the picture
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.switch_camera,
                              color: Colors.white, size: 40),
                          onPressed: () {
                            _onCameraSwitchPressed();
                          },
                        ),
                      ],
                    ),
                  ))
            ],
          );
  }

  void _onCameraSwitchPressed() {
    if (_cameras.length > 1) {
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
      int _newBackIndex = _selectedCameraIndex == 0 ? 1 : 0;

      _frontController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.max,
      );
      _frontController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          (flashOff)
              ? _frontController!.setFlashMode(FlashMode.off)
              : _frontController!.setFlashMode(FlashMode.auto);

          _frontController!.setZoomLevel(1);
        });
      });

      // _backController = CameraController(
      //   _cameras[_newBackIndex],
      //   ResolutionPreset.max,
      // );
      // _backController.initialize().then((_) {
      //   if (!mounted) {
      //     return;
      //   }
      //   setState(() {
      //     _backController.setFlashMode(FlashMode.off);

      //     _backController.setZoomLevel(1);
      //   });
      // });
    } else {
      print("Only one camera available");
    }
  }

  @override
  void dispose() {
    _frontController?.dispose();
    super.dispose();
  }
}
