// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:picswap/domain/provider/user_item_provider.dart';
// import 'package:picswap/domain/provider/user_provider.dart';

// import '../app/layout/default_layout.dart';
// import '../app/manager/colors_manager.dart';
// import '../app/manager/values_manager.dart';

// class MyProfileScreen extends ConsumerStatefulWidget {
//   const MyProfileScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _MyProfileScreenState();
// }

// class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(userProvider);
//     final userItem = ref.watch(userItemProvider);

//     return DefaultLayout(
//         appBar: AppBar(
//             title: const Text('My Proile'),
//             centerTitle: true,
//             backgroundColor: AppColor.primaryColor,
//             leading: IconButton(
//                 onPressed: () => context.pop(), icon: const Icon(Icons.close))),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
//           child: Column(
//             children: [
//               const SizedBox(height: AppPadding.p24),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(AppSize.s36),
//                     color: AppColor.primaryColor),
//                 child: Row(
//                   children: [
//                     Text(
//                       user.nickname,
//                       style: const TextStyle(fontSize: AppSize.s24),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }

//   Widget informCard({required String coin}) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Text('Coin : $coin'),
//           ],
//         ),
//       ],
//     );
//   }
// }
