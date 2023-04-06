import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/compress_to_shit.dart';
import '../../../models/models.dart';
import '../../../repository/storage_repository.dart';

class CustomImageContainer extends StatefulWidget {
  const CustomImageContainer({
    Key? key,
    this.imageUrl,
    this.deletable = true,
    this.uploadable = false,
    this.deleteImage,
    this.uploadImage,
  }) : super(key: key);

  final String? imageUrl;

  final bool? deletable;
  final bool uploadable;
  final void Function(String)? deleteImage;
  final void Function(String)? uploadImage;

  @override
  State<CustomImageContainer> createState() => _CustomImageContainerState();
}

class _CustomImageContainerState extends State<CustomImageContainer> {
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: (widget.imageUrl == null)
            ? (!uploading)
                ? (widget.uploadable)
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () async {
                            await uploadImage(context);
                          },
                        ),
                      )
                    : Container()
                : CircularProgressIndicator()
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                  (widget.deletable!)
                      ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Deleting...')));
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .deleteImageUrl(widget.imageUrl!);

                              setState(() {
                                uploading = false;
                              });
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Future<void> uploadImage(BuildContext context) async {
    ImagePicker _picker = ImagePicker();
    final XFile? _firstImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    final XFile _image = _firstImage!;
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image was selected.')));
    }

    if (_image != null) {
      setState(() {
        uploading = true;
      });

      CroppedFile? _croppedFile = await ImageCropper().cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(
          ratioX: 3,
          ratioY: 4,
        ),
        maxWidth: 1080,
        maxHeight: 1920,
      );

      if (_croppedFile == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No image was selected.')));
        setState(() {
          uploading = false;
        });
      }
      File? compressedFile =
          await CompressToShit.compressToShit(File(_croppedFile!.path));
      if (compressedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your image exceeded the 1mb limit.')));
        setState(() {
          uploading = false;
        });
      } else {
        await BlocProvider.of<OnBoardingCubit>(context)
            .uploadImage(xfile: _image, compressedFile: compressedFile);
        setState(() {
          uploading = false;
        });
      }
    }
  }
}
