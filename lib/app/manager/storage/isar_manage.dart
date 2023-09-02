// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:picswap/domain/model/coin_model.dart';

// final isarFutureProvider = FutureProvider<Isar>((ref) async {
//   final dir = await getApplicationDocumentsDirectory();
//   final isar = await Isar.open(
//     [CoinModelSchema],
//     directory: dir.path,
//   );

//   return isar;
// });
