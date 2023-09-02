import 'dart:convert';

import 'package:dio/dio.dart';

import '../manager/constants.dart';

class Failure extends DioError {
  final int code;
  @override
  final String message;
  Failure({
    required this.code,
    required this.message,
  }) : super(requestOptions: RequestOptions(path: AppConstants.baseUrl));

  // factory Failure.fromJson(Map<String, dynamic> json,
  //         RequestOptions Function(Object? json) fromJsonT) =>
  //     _$FailureFromJson(json, fromJosnT);

  // factory CursorPagination.fromJson(
  //         Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
  //     _$CursorPaginationFromJson(json, fromJsonT);

  // Map<String, dynamic> toJson() => _$FailureToJson(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
    };
  }

  factory Failure.fromMap(Map<String, dynamic> map) {
    return Failure(
      code: map['code'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}

// enum DataSource {
//   SUCCESS,
//   NO_CONTENT,
//   BAD_REQUEST,
//   FORBIDDEN,
//   UNAUTHORISED,
//   NOT_FOUND,
//   INTERNAL_SERVER_ERROR,
//   CONNECT_TIMEOUT,
//   CANCEL,
//   RECEIVE_TIMEOUT,
//   SEND_TIMEOUT,

//   NOT_FOUND_RESOURCE_ERROR,
//   INVALID_REQUEST_ERROR,
//   INTERNAL_ERROR,
//   EXTERNAL_ERROR,

//   AUTH_ERROR,
//   INVALID_OAUTH2_TOKEN,
//   INVALID_TOKEN,
//   EXPIRED_TOKEN,

//   PHONE_AUTH_EXCEED_MAXIMUM_COUNT,
//   PHONE_AUTH_TIMEOUT,

//   UNKNOWN_COMPANY,
//   ALREADY_EXISTS_EMAIL,
//   EMAIL_AUTH_EXCEED_MAXIMUM_COUNT,
//   EMAIL_AUTH_TIMEOUT,
//   ALREADY_EXISTS_NICKNAME,

//   NOT_CERTIFIED_USER,
//   NOT_ACTIVE_USER,

//   FINISHED_MEETING,
//   EXCEED_PARTICIPANTS,
//   ALREADY_PARTICIPANTS,
// }

// class ErrorHandler implements Exception {
//   late Failure failure;

//   ErrorHandler.handle(dynamic error) {
//     if (error is DioError) {
//       // dio error so its error from response of the API
//       failure = _handleError(error);
//     } else {
//       // default error
//       failure = DataSource.INTERNAL_ERROR.getFailure();
//     }
//   }

//   Failure _handleError(DioError error) {
//     switch (error.type) {
//       case DioErrorType.connectTimeout:
//         return DataSource.CONNECT_TIMEOUT.getFailure();
//       case DioErrorType.sendTimeout:
//         return DataSource.SEND_TIMEOUT.getFailure();
//       case DioErrorType.receiveTimeout:
//         return DataSource.RECEIVE_TIMEOUT.getFailure();
//       case DioErrorType.response:
//         switch (error.response?.statusCode) {
//           case ResponseCode.BAD_REQUEST:
//             return DataSource.BAD_REQUEST.getFailure();
//           case ResponseCode.FORBIDDEN:
//             return DataSource.FORBIDDEN.getFailure();
//           case ResponseCode.UNAUTHORISED:
//             return DataSource.UNAUTHORISED.getFailure();
//           case ResponseCode.NOT_FOUND:
//             return DataSource.NOT_FOUND.getFailure();
//           case ResponseCode.INTERNAL_SERVER_ERROR:
//             return DataSource.INTERNAL_SERVER_ERROR.getFailure();
//           default:
//             return DataSource.INTERNAL_ERROR.getFailure();
//         }
//       case DioErrorType.cancel:
//         return DataSource.CANCEL.getFailure();
//       case DioErrorType.other:
//         return DataSource.INTERNAL_ERROR.getFailure();
//     }
//   }
// }

// extension DataSourceExtension on DataSource {
//   Failure getFailure() {
//     switch (this) {
//       case DataSource.NOT_FOUND_RESOURCE_ERROR:
//         return Failure(
//             code: ResponseCode.NOT_FOUND_RESOURCE_ERROR,
//             message: ResponseMessage.NOT_FOUND_RESOURCE_ERROR);
//       case DataSource.INVALID_REQUEST_ERROR:
//         return Failure(
//             code: ResponseCode.INVALID_REQUEST_ERROR,
//             message: ResponseMessage.INVALID_REQUEST_ERROR);
//       case DataSource.INTERNAL_ERROR:
//         return Failure(
//             code: ResponseCode.INTERNAL_ERROR,
//             message: ResponseMessage.INTERNAL_ERROR);
//       case DataSource.EXTERNAL_ERROR:
//         return Failure(
//             code: ResponseCode.EXTERNAL_ERROR,
//             message: ResponseMessage.EXTERNAL_ERROR);
//       case DataSource.AUTH_ERROR:
//         return Failure(
//             code: ResponseCode.AUTH_ERROR, message: ResponseMessage.AUTH_ERROR);
//       case DataSource.INVALID_OAUTH2_TOKEN:
//         return Failure(
//             code: ResponseCode.INVALID_OAUTH2_TOKEN,
//             message: ResponseMessage.INVALID_OAUTH2_TOKEN);
//       case DataSource.INVALID_TOKEN:
//         return Failure(
//             code: ResponseCode.INVALID_TOKEN,
//             message: ResponseMessage.INVALID_TOKEN);
//       case DataSource.EXPIRED_TOKEN:
//         return Failure(
//             code: ResponseCode.EXPIRED_TOKEN,
//             message: ResponseMessage.EXPIRED_TOKEN);
//       case DataSource.PHONE_AUTH_EXCEED_MAXIMUM_COUNT:
//         return Failure(
//             code: ResponseCode.PHONE_AUTH_EXCEED_MAXIMUM_COUNT,
//             message: ResponseMessage.PHONE_AUTH_EXCEED_MAXIMUM_COUNT);
//       case DataSource.PHONE_AUTH_TIMEOUT:
//         return Failure(
//             code: ResponseCode.PHONE_AUTH_TIMEOUT,
//             message: ResponseMessage.PHONE_AUTH_TIMEOUT);
//       case DataSource.UNKNOWN_COMPANY:
//         return Failure(
//             code: ResponseCode.UNKNOWN_COMPANY,
//             message: ResponseMessage.UNKNOWN_COMPANY);
//       case DataSource.ALREADY_EXISTS_EMAIL:
//         return Failure(
//             code: ResponseCode.ALREADY_EXISTS_EMAIL,
//             message: ResponseMessage.ALREADY_EXISTS_EMAIL);
//       case DataSource.EMAIL_AUTH_EXCEED_MAXIMUM_COUNT:
//         return Failure(
//             code: ResponseCode.EMAIL_AUTH_EXCEED_MAXIMUM_COUNT,
//             message: ResponseMessage.EMAIL_AUTH_EXCEED_MAXIMUM_COUNT);
//       case DataSource.EMAIL_AUTH_TIMEOUT:
//         return Failure(
//             code: ResponseCode.EMAIL_AUTH_TIMEOUT,
//             message: ResponseMessage.EMAIL_AUTH_TIMEOUT);
//       case DataSource.ALREADY_EXISTS_NICKNAME:
//         return Failure(
//             code: ResponseCode.ALREADY_EXISTS_NICKNAME,
//             message: ResponseMessage.ALREADY_EXISTS_NICKNAME);
//       case DataSource.NOT_CERTIFIED_USER:
//         return Failure(
//             code: ResponseCode.NOT_CERTIFIED_USER,
//             message: ResponseMessage.NOT_CERTIFIED_USER);
//       case DataSource.NOT_ACTIVE_USER:
//         return Failure(
//             code: ResponseCode.NOT_ACTIVE_USER,
//             message: ResponseMessage.NOT_ACTIVE_USER);
//       case DataSource.FINISHED_MEETING:
//         return Failure(
//             code: ResponseCode.FINISHED_MEETING,
//             message: ResponseMessage.FINISHED_MEETING);
//       case DataSource.EXCEED_PARTICIPANTS:
//         return Failure(
//             code: ResponseCode.EXCEED_PARTICIPANTS,
//             message: ResponseMessage.EXCEED_PARTICIPANTS);
//       case DataSource.ALREADY_PARTICIPANTS:
//         return Failure(
//             code: ResponseCode.ALREADY_PARTICIPANTS,
//             message: ResponseMessage.ALREADY_PARTICIPANTS);
//       case DataSource.SUCCESS:
//         return Failure(
//             code: ResponseCode.SUCCESS, message: ResponseMessage.SUCCESS);
//       case DataSource.NO_CONTENT:
//         return Failure(
//             code: ResponseCode.NO_CONTENT, message: ResponseMessage.NO_CONTENT);
//       case DataSource.BAD_REQUEST:
//         return Failure(
//             code: ResponseCode.BAD_REQUEST,
//             message: ResponseMessage.BAD_REQUEST);
//       case DataSource.FORBIDDEN:
//         return Failure(
//             code: ResponseCode.FORBIDDEN, message: ResponseMessage.FORBIDDEN);
//       case DataSource.UNAUTHORISED:
//         return Failure(
//             code: ResponseCode.UNAUTHORISED,
//             message: ResponseMessage.UNAUTHORISED);
//       case DataSource.NOT_FOUND:
//         return Failure(
//             code: ResponseCode.NOT_FOUND, message: ResponseMessage.NOT_FOUND);
//       case DataSource.INTERNAL_SERVER_ERROR:
//         return Failure(
//             code: ResponseCode.INTERNAL_SERVER_ERROR,
//             message: ResponseMessage.INTERNAL_SERVER_ERROR);
//       case DataSource.CONNECT_TIMEOUT:
//         return Failure(
//             code: ResponseCode.CONNECT_TIMEOUT,
//             message: ResponseMessage.CONNECT_TIMEOUT);
//       case DataSource.CANCEL:
//         return Failure(
//             code: ResponseCode.CANCEL, message: ResponseMessage.CANCEL);
//       case DataSource.RECEIVE_TIMEOUT:
//         return Failure(
//             code: ResponseCode.RECEIVE_TIMEOUT,
//             message: ResponseMessage.RECEIVE_TIMEOUT);
//       case DataSource.SEND_TIMEOUT:
//         return Failure(
//             code: ResponseCode.SEND_TIMEOUT,
//             message: ResponseMessage.SEND_TIMEOUT);
//     }
//   }
// }

// class ResponseCode {
//   // API status codes
//   static const int SUCCESS = 200; // success with data
//   static const int NO_CONTENT = 201; // success with no content
//   static const int BAD_REQUEST = 400; // failure, api rejected the request
//   static const int FORBIDDEN = 403; // failure, api rejected the request
//   static const int UNAUTHORISED = 401; // failure user is not authorised
//   static const int NOT_FOUND =
//       404; // failure, api url is not correct and not found
//   static const int INTERNAL_SERVER_ERROR =
//       500; // failure, crash happened in server side

//   static const int CONNECT_TIMEOUT = -2;
//   static const int CANCEL = -3;
//   static const int RECEIVE_TIMEOUT = -4;
//   static const int SEND_TIMEOUT = -5;

//   static const int NOT_FOUND_RESOURCE_ERROR = -4001;
//   static const int INVALID_REQUEST_ERROR = -4002;
//   static const int INTERNAL_ERROR = -5000;
//   static const int EXTERNAL_ERROR = -6000;

//   static const int AUTH_ERROR = -4100;
//   static const int INVALID_OAUTH2_TOKEN = -4101;
//   static const int INVALID_TOKEN = -4102;
//   static const int EXPIRED_TOKEN = -4103;

//   static const int PHONE_AUTH_EXCEED_MAXIMUM_COUNT = -4201;
//   static const int PHONE_AUTH_TIMEOUT = -4202;

//   static const int UNKNOWN_COMPANY = -4301;
//   static const int ALREADY_EXISTS_EMAIL = -4302;
//   static const int EMAIL_AUTH_EXCEED_MAXIMUM_COUNT = -4303;
//   static const int EMAIL_AUTH_TIMEOUT = -4304;
//   static const int ALREADY_EXISTS_NICKNAME = -4305;

//   static const int NOT_CERTIFIED_USER = -4501;
//   static const int NOT_ACTIVE_USER = -4502;

//   static const int FINISHED_MEETING = -4601;
//   static const int EXCEED_PARTICIPANTS = -4602;
//   static const int ALREADY_PARTICIPANTS = -4603;
// }

// class ResponseMessage {
//   // API status codes
//   // API response codes
//   static const String SUCCESS = AppString.success; // success with data
//   static const String NO_CONTENT =
//       AppString.noContent; // success with no content
//   static const String BAD_REQUEST =
//       AppString.badRequestError; // failure, api rejected our request
//   static const String FORBIDDEN =
//       AppString.forbiddenError; // failure,  api rejected our request
//   static const String UNAUTHORISED =
//       AppString.unauthorizedError; // failure, user is not authorised
//   static const String NOT_FOUND = AppString
//       .notFoundError; // failure, API url is not correct and not found in api side.
//   static const String INTERNAL_SERVER_ERROR =
//       AppString.internalServerError; // failure, a crash happened in API side.
//   static const String CANCEL =
//       AppString.defaultError; // API request was cancelled

//   static const String RECEIVE_TIMEOUT =
//       AppString.timeoutError; //  issue in connectivity
//   static const String SEND_TIMEOUT =
//       AppString.timeoutError; //  issue in connectivity
//   static const String CONNECT_TIMEOUT =
//       AppString.timeoutError; // issue in connectivity

//   static const String NOT_FOUND_RESOURCE_ERROR = "not found resource";
//   static const String INVALID_REQUEST_ERROR = "invalid request";
//   static const String INTERNAL_ERROR = "unknown error";
//   static const String EXTERNAL_ERROR = "external error";

//   static const String AUTH_ERROR = "failed authentication error";
//   static const String INVALID_OAUTH2_TOKEN = "invalid oauth2 token";
//   static const String INVALID_TOKEN = "invalid token";
//   static const String EXPIRED_TOKEN = "expired token";

//   static const String PHONE_AUTH_EXCEED_MAXIMUM_COUNT =
//       "Mobile phone authentication count exceeded";
//   static const String PHONE_AUTH_TIMEOUT = "phone auth timeout";

//   static const String UNKNOWN_COMPANY = "unknown company";
//   static const String ALREADY_EXISTS_EMAIL = "already exists email";
//   static const String EMAIL_AUTH_EXCEED_MAXIMUM_COUNT =
//       "email authentication count exceeded";
//   static const String EMAIL_AUTH_TIMEOUT = "email auth timeout";
//   static const String ALREADY_EXISTS_NICKNAME = "already exists nickname";

//   static const String NOT_CERTIFIED_USER = "인증된 유저가 아닙니다.";
//   static const String NOT_ACTIVE_USER = "활성화된 유저가 아닙니다.";

//   static const String FINISHED_MEETING = "종료된 미팅";
//   static const String EXCEED_PARTICIPANTS = "참여인원 초과";
//   static const String ALREADY_PARTICIPANTS = "이미 참여된 미팅";
// }
