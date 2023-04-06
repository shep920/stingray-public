// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hero/cubits/signupNew/cubit/signup_cubit.dart';
// import 'package:hero/models/user_model.dart' as myUser;
// import 'package:hero/repository/firestore_repository.dart';
// import 'package:provider/src/provider.dart';

// import '../../../cubits/signIn/cubit/signin_cubit.dart';

// class CustomOnboardingButton extends StatelessWidget {
//   final TabController tabController;
//   final String text;
//   final Function(String)? onChanged;
//   final void Function(myUser.User)? setUserData;

//   final String? id;
//   final String? bio;
//   final int? age;
//   final String? gender;
//   final int? imageCount;
//   final String? name;
//   final String? handle;
//   final bool? isValid;
//   final DateTime? birthDate;
//   final List<dynamic>? goals;
//   final myUser.User? user;
//   final List<String>? stingrayIds;
//   final bool? wantsToTalk;

//   const CustomOnboardingButton({
//     Key? key,
//     required this.tabController,
//     this.text = 'START',
//     this.onChanged,
//     this.imageCount,
//     this.name,
//     this.handle,
//     required this.id,
//     this.bio,
//     this.isValid,
//     this.birthDate,
//     this.age,
//     this.goals,
//     this.user,
//     this.gender,
//     this.stingrayIds,
//     this.wantsToTalk,
//     this.setUserData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5.0),
//         gradient: LinearGradient(colors: [
//           Theme.of(context).colorScheme.primary,
//           Theme.of(context).backgroundColor,
//         ]),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           primary: Colors.transparent,
//         ),
//         onPressed: () async {
//           try {
//             submit(context);
//           } catch (e) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(e.toString())));
//           }
//         },
//         child: Container(
//           width: double.infinity,
//           child: Center(
//             child: Text(
//               text,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline4!
//                   .copyWith(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void submit(BuildContext context) {
//     if (tabController.index == 0) {
//       handleErrors();
//       FirestoreRepository()
//                                   .updateHandle(id, handle!);
//     }
//     if (tabController.index == 1) {
//       birthdateErrors();
//       FirestoreRepository(id: id).updatebirthDate(id, birthDate!);
//     }
//     if (tabController.index == 2) {
//       FirestoreRepository(id: id).updateName(id, name!);
//       FirestoreRepository(id: id).updateBio(user, bio!);
//     }
//     if (tabController.index == 3) {
//       if (gender == null) {
//         throw ('Please select a gender');
//       }
//       FirestoreRepository(id: id).updateGender(id, gender!);
//     }
//     if (tabController.index == 4) {
//       print('bruh');
//       if (imageCount! < 2) {
//         throw (Exception('You need to have at least two images'));
//       }
//     }
//     if (tabController.index == 5) {
//       FirestoreRepository(id: id).updateGoals(user, goals!);
//       FirestoreRepository().updateOnboarding(id, stingrayIds!);

//       print('moment');
//       Navigator.popAndPushNamed(context, '/wrapper/');
//     }
//     if (tabController.index != 6) {
//       tabController.animateTo(tabController.index + 1);
//     }
//   }

//   void birthdateErrors() {
//     if (birthDate == null) {
//       throw ('Please select your birthDate');
//     }
//     if (age! < 18) {
//       throw ('You must be 18 or older to use this app');
//     }
//   }

//   void handleErrors() {
//     if (handle![0] != '@') {
//       throw ('Your handle needs to start with @');
//     }
//     if (handle == '@') {
//       throw ('Your handle needs to be more than the @');
//     }
//     if (handle!.substring(0, handle!.length) == '') {
//       throw (Exception('Your Handle cannot be empty'));
//     }
//     if (handle!.length > 30) {
//       throw (Exception('Your Handle cannot be more than 30 characters'));
//     }
//     if (isValid == false) {
//       throw ('Your Handle is already in use.');
//     }
//   }
// }
