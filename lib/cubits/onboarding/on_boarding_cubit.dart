import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';
import '../../repository/storage_repository.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  void onBoardingLoaded(User user) {
    emit(OnBoaringLoaded(user: user));
  }

  void initializeBoardingLoaded() {
    emit(OnBoardingInitial());
  }

  void updateOnBoardingUser(
      {String? bio,
      String? name,
      DateTime? birthDate,
      String? gender,
      String? firstUndergrad,
      String? secondUndergrad,
      String? thirdUndergrad,
      String? firstStudentOrganization,
      String? secondStudentOrganization,
      String? thirdStudentOrganization,
      String? firstStudentOrgPosition,
      String? secondStudentOrgPosition,
      String? thirdStudentOrgPosition,
      String? postGrad,
      String? fraternity,
      String? fratPosition,
      String? favoriteBar,
      String? favoriteSpot,
      String? associatedDorm,
      String? worstDorm,
      String? intramuralSport,
      String? instagramUrl,
      String? tiktokUrl,
      String? snapchatUrl,
      String? twitterUrl,
      String? tinderUrl,
      String? discordUrl,
      List<dynamic>? imageUrls}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;
      User _newUser = user.copyWith(
          bio: bio,
          name: name,
          birthDate: birthDate,
          gender: gender,
          imageUrls: imageUrls,
          firstUndergrad: firstUndergrad,
          secondUndergrad: secondUndergrad,
          thirdUndergrad: thirdUndergrad,
          firstStudentOrg: firstStudentOrganization,
          secondStudentOrg: secondStudentOrganization,
          thirdStudentOrg: thirdStudentOrganization,
          firstStudentOrgPosition: firstStudentOrgPosition,
          secondStudentOrgPosition: secondStudentOrgPosition,
          thirdStudentOrgPosition: thirdStudentOrgPosition,
          postGrad: postGrad,
          fraternity: fraternity,
          fratPosition: fratPosition,
          favoriteBar: favoriteBar,
          favoriteSpot: favoriteSpot,
          assosiatedDorm: associatedDorm,
          worstDorm: worstDorm,
          intramuralSport: intramuralSport,
          discordUrl: discordUrl,
          instagramUrl: instagramUrl,
          tiktokUrl: tiktokUrl,
          twitterUrl: twitterUrl,
          snapchatUrl: snapchatUrl,
          tinderUrl: tinderUrl)!;

      emit(OnBoardingInitial());
      emit(OnBoaringLoaded(user: _newUser));
    }
  }

  void deleteImageUrl(String imageUrl) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;
      emit(OnBoardingInitial());
      final imageUrls = user.imageUrls;

      imageUrls.remove(imageUrl);
      final _newUser = user.copyWith(imageUrls: imageUrls);

      emit(OnBoaringLoaded(user: _newUser!));
    }
  }

  Future<void> uploadImage(
      {required File compressedFile, required XFile xfile}) async {
    final user = (state as OnBoaringLoaded).user;
    await StorageRepository().uploadImage(user, xfile, compressedFile);
    String _imageUrl =
        await StorageRepository().getDownloadURL(user, xfile.name);
    final _newImageUrls = user.imageUrls;
    _newImageUrls.add(_imageUrl);
    final _newUser = user.copyWith(imageUrls: _newImageUrls);
    emit(OnBoardingInitial());
    emit(OnBoaringLoaded(user: _newUser!));
  }

  void validateTwitterUrl(
      {required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      final regex = RegExp(r'https://twitter.com/');

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(twitterUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid Twitter URL'),
          ),
        );
      }
    }
  }

  void validateTinderUrl({required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      //an example of a tinder url is https://tinder.com/@shep919 write a regex for this
      final regex = RegExp(r"https://tinder.com/@[a-zA-Z0-9_]+");

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(tinderUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid Tinder URL'),
          ),
        );
      }
    }
  }

  //validate instagram url
  void validateInstagramUrl(
      {required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      final regex = RegExp(r'https://www.instagram.com/');

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(instagramUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid Instagram URL'),
          ),
        );
      }
    }
  }

  //validate tiktok url
  void validateTiktokUrl({required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      final regex = RegExp(r'https://www.tiktok.com/');

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(tiktokUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid TikTok URL'),
          ),
        );
      }
    }
  }

  //validate snapchat url
  void validateSnapchatUrl(
      {required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      final regex = RegExp(r'https://www.snapchat.com/');

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(snapchatUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid Snapchat URL'),
          ),
        );
      }
    }
  }

  //validate discord url
  void validateDiscordUrl(
      {required String url, required BuildContext context}) {
    if (state is OnBoaringLoaded) {
      final user = (state as OnBoaringLoaded).user;

      final regex = RegExp(r"https://discord.gg/[a-zA-Z0-9]+");

      if (regex.hasMatch(url)) {
        emit(OnBoardingInitial());
        final _newUser = user.copyWith(discordUrl: url);
        emit(OnBoaringLoaded(user: _newUser!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid Discord URL'),
          ),
        );
      }
    }
  }
}
