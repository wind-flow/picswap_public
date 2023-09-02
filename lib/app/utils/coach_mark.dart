// import 'package:flutter/material.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// void showTutorial(BuildContext context, List<TargetFocus> targets) {
//   TutorialCoachMark tutorial = TutorialCoachMark(
//       targets: targets, // List<TargetFocus>
//       colorShadow: Colors.red, // DEFAULT Colors.black
//       // alignSkip: Alignment.bottomRight,
//       // textSkip: "SKIP",
//       // paddingFocus: 10,
//       // focusAnimationDuration: Duration(milliseconds: 500),
//       // unFocusAnimationDuration: Duration(milliseconds: 500),
//       // pulseAnimationDuration: Duration(milliseconds: 500),
//       // pulseVariation: Tween(begin: 1.0, end: 0.99),
//       // showSkipInLastTarget: true,
//       // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//       onFinish: () {
//         print("finish");
//       },
//       onClickTargetWithTapPosition: (target, tapDetails) {
//         print("target: $target");
//         print(
//             "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
//       },
//       onClickTarget: (target) {
//         print(target);
//       },
//       onSkip: () {
//         print("skip");
//       })
//     ..show(context: context);

//   // tutorial.skip();
//   // tutorial.finish();
//   // tutorial.next(); // call next target programmatically
//   // tutorial.previous(); // call previous target programmatically
// }
