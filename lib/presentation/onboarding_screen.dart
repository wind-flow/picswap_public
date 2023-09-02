// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:picswap/presentation/main_screen.dart';

// class OnBoardingScreen extends ConsumerWidget {
//   const OnBoardingScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//             title: 'We are worker',
//             body: 'We are developer',
//             image: Image.asset('image/work1.jpg'),
//             decoration: getPageDecoration()),
//         PageViewModel(
//             title: 'We are worker',
//             body: 'We make code',
//             image: Image.asset('image/work2.jpg'),
//             decoration: getPageDecoration()),
//         PageViewModel(
//             title: 'We are worker',
//             body: 'We hustle and hustle',
//             image: Image.asset('image/work3.jpg'),
//             decoration: getPageDecoration())
//       ],
//       done: const Text('done'),
//       onDone: () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const MainScreen()),
//         );
//       },
//       showBackButton: true,
//       showDoneButton: true,
//       showNextButton: true,
//       // showSkipButton: true,
//       next: const Icon(Icons.arrow_forward),
//       back: const Icon(Icons.arrow_back),
//       dotsDecorator: DotsDecorator(
//           color: Colors.cyan,
//           size: const Size(15, 15),
//           activeSize: const Size(27, 15),
//           activeShape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
//       curve: Curves.bounceOut,
//     );
//   }

//   PageDecoration getPageDecoration() {
//     return const PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
//       bodyTextStyle: TextStyle(
//         fontSize: 34,
//         color: Colors.blue,
//       ),
//       imagePadding: EdgeInsets.only(top: 40),
//       pageColor: Colors.orange,
//     );
//   }
// }
