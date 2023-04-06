// import 'package:flutter/material.dart';
// import 'package:hero/screens/onboarding/widgets/custom_onbaording_buttons.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';

// import 'package:hero/screens/onboarding/widgets/widgets.dart';

// import '../../../models/models.dart';

// class Biography extends StatefulWidget {
//   final TabController tabController;
//   final User user;

//   const Biography({
//     Key? key,
//     required this.tabController,
//     required this.user,
//   }) : super(key: key);

//   @override
//   State<Biography> createState() => _BiographyState();
// }

// class _BiographyState extends State<Biography> {
//   String bio = '';
//   @override
//   Widget build(BuildContext context) {
//     final controller = TextEditingController();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextHeader(
//                   tabController: widget.tabController,
//                   text: 'Describe Yourself'),
//               CustomTextField(
//                 hint: 'Enter your bio',
//                 onChanged: (val) => setState(() => bio = val),
//               ),
//               SizedBox(height: 100),
//               CustomTextHeader(
//                   tabController: widget.tabController,
//                   text: 'What do you like?'),
//               Row(
//                 children: [
//                   CustomTextContainer(text: 'bruh'),
//                   CustomTextContainer(text: 'Worm Odyssey'),
//                   CustomTextContainer(text: 'gay stuff'),
//                   CustomTextContainer(text: 'IDK'),
//                 ],
//               ),
//               Row(
//                 children: [
//                   CustomTextContainer(text: 'squid game'),
//                   CustomTextContainer(text: '4chan.org'),
//                   CustomTextContainer(text: 'Madden 2042'),
//                 ],
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               StepProgressIndicator(
//                 totalSteps: 3,
//                 currentStep: 3,
//                 selectedColor: Theme.of(context).colorScheme.primary,
//                 unselectedColor: Theme.of(context).scaffoldBackgroundColor,
//               ),
//               SizedBox(height: 10),
//               CustomOnboardingButton(
//                 tabController: widget.tabController,
//                 text: 'NEXT STEP',
//                 bio: bio,
//                 id: widget.user.id,
//                 gender: '',
//                 age: 0,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
