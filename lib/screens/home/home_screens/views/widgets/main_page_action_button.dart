import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/helpers/is_wave.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/make_story/new_story_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/compose_wave.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/compose_sea_real_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/compose_bubble_screen.dart';
import 'package:hero/widgets/action_button.dart';
import 'package:hero/widgets/expandable_fab.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MainPageActionButton extends StatelessWidget {
  const MainPageActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: ExpandableFab(
                  distance: 150,
                  children: [
                    if (user.isStingray)
                      ActionButton(
                        icon: const Icon(
                          //an icon that shows a pen
                          Icons.edit,

                          color: Colors.white,
                        ),
                        onPressed: () {
                          //push named route of bitch
                          Navigator.pushNamed(
                              context, ComposeWaveScreen.routeName,
                              arguments: Wave.default_type);
                        },
                      ),
                    if (user.isStingray)
                      ActionButton(
                        icon: const Icon(
                          //an icon that shows a pen
                          Icons.star,

                          color: Colors.white,
                        ),
                        onPressed: () {
                          //push named route of bitch
                          Navigator.pushNamed(
                              context, NewStoryScreen.routeName);
                        },
                      ),
                    if (user.isStingray)
                      ActionButton(
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          File? _image = await PickFile.setImage(
                              source: ImageSource.gallery, context: context);

                          CroppedFile? _croppedFile =
                              await ImageCropper().cropImage(
                            sourcePath: _image!.path,
                            aspectRatio: CropAspectRatio(
                              ratioX: 1,
                              ratioY: 1,
                            ),
                            maxWidth: 1080,
                            maxHeight: 1080,
                          );

                          Navigator.pushNamed(
                              context, ComposeBubbleScreen.routeName,
                              arguments: File(_croppedFile!.path));
                        },
                      ),
                    
                    if (user.finishedOnboarding)
                      ActionButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ComposeSeaRealScreen.routeName);
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
