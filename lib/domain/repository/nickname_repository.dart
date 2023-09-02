import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picswap/domain/model/nickname_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../app/dio/dio.dart';
import '../../app/manager/constants.dart';

part 'nickname_repository.g.dart';

final nicknameRepository = Provider<NicknameRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return NicknameRepository(dio);
});

@RestApi(baseUrl: AppConstants.nicknameUrl)
abstract class NicknameRepository {
  factory NicknameRepository(Dio dio) = _NicknameRepository;
  // format=json&count=1
  @GET('/?format=json&count=1')
  Future<NicknameModel> getNickname();
}
