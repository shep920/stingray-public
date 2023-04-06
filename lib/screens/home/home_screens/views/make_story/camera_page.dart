import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hero/helpers/compress_to_shit.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  //void function that takes a file
  final void Function(File) onCameraSwitchPressed;

  const CameraScreen({super.key, required this.onCameraSwitchPressed});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
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
      _controller = CameraController(
          _cameras[_selectedCameraIndex], ResolutionPreset.max);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _controller.setFlashMode(FlashMode.off);
          //set the camera off of fisheye
          _controller.setZoomLevel(1);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onScaleEnd: (ScaleEndDetails details) {
                        setState(() {
                          //convert details to a double between 1 and 189

                          // _zoom += details.velocity.pixelsPerSecond.dx;
                          // _zoom += details.velocity.pixelsPerSecond.dy;
                          // //make zoom level go between 1 and 189
                          // _zoom = _zoom.clamp(1, 189);
                          // _controller.setZoomLevel(_zoom);
                        });
                      },
                      child: CameraPreview(_controller),
                    ),
                  ),
                ],
              ),
              if (loadingImage)
                Center(
                  child: CircularProgressIndicator(),
                ),
              Positioned(
                top: 70,
                right: 10,
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  padding: EdgeInsets.all(10),
                  //change the shape of the container to a circle

                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          (flashOff) ? Icons.flash_off : Icons.flash_on,
                          color: (flashOff) ? Colors.white : Colors.yellow,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.setZoomLevel(1);
                            flashOff = !flashOff;
                            (flashOff)
                                ? _controller.setFlashMode(FlashMode.off)
                                : _controller.setFlashMode(FlashMode.auto);
                          });
                        },
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
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              loadingImage = true;
                            });
                            // code to choose a picture from the gallery
                            PickFile.setImage(
                                    source: ImageSource.gallery,
                                    context: context)
                                .then((value) {
                              if (value != null) {
                                widget.onCameraSwitchPressed(value);
                              }
                            }).then((value) => setState(() {
                                      loadingImage = false;
                                    }));
                          },
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        //make an animated container that starts as a hollow circle and then fills up when the user taps it, then resets
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
                          child: InkWell(
                            onTap: () {
                              // code to take a picture
                              setState(() {
                                takingPhoto = true;
                                //wait 1 second, then reset the takingPhoto variable

                                setState(() {
                                  takingPhoto = false;
                                });
                                //take the picture
                                _controller.takePicture().then((file) async {
                                  //get the file from the xFile
                                  File _file = File(file.path);
                                  //compress the file

                                  widget.onCameraSwitchPressed(_file);
                                });
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // code to choose a picture from the gallery
                          },
                          child: Icon(
                            Icons.snowmobile,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          );
  }

  void _onCameraSwitchPressed() {
    if (_cameras.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      _controller = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.max,
      );
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          (flashOff)
              ? _controller.setFlashMode(FlashMode.off)
              : _controller.setFlashMode(FlashMode.auto);

          _controller.setZoomLevel(1);
        });
      });
    } else {
      print("Only one camera available");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
