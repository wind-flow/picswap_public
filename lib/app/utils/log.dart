import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:picswap/app/utils/file_utils.dart';

class Log {
  Log._();

  factory Log() {
    return instance;
  }

  static const String tagSuffix = 'picswap] ';
  static final Log instance = Log._();
  static final Logger logger = Logger();
  static final DateFormat dateFormat = DateFormat('yy/MM/dd - HH:mm:ss');

  static void v(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    // logger.v(
    //     '$tagSuffix====================================================================');
    logger.v('$tagSuffix$message', error, stackTrace);
    await _recordLog(message, error, stackTrace);
  }

  static void d(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    logger.d(
        '$tagSuffix====================================================================');
    logger.d('$tagSuffix$message', error, stackTrace);
    await _recordLog(message, error, stackTrace);
  }

  static void i(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    logger.i(
        '$tagSuffix====================================================================');
    logger.i('$tagSuffix$message', error, stackTrace);
    await _recordLog(message, error, stackTrace);
  }

  static void w(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    logger.w(
        '$tagSuffix====================================================================');
    logger.w('$tagSuffix$message', error, stackTrace);
    await _recordLog(message, error, stackTrace);
  }

  static void e(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    logger.e(
        '$tagSuffix====================================================================');
    logger.e('$tagSuffix$message', error, stackTrace);
    await _recordLog(message, error, stackTrace);
  }

  static Future<void> _recordLog(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    await FileUtils.writeToLogFile('log.txt',
        '\n------------ ${dateFormat.format(DateTime.now())} ------------\n');
    await FileUtils.writeToLogFile('log.txt', '$message');
    // FirebaseCrashlyticsManager.record(message.toString());
  }
}

class LoggerProvider extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    print('provider : $provider');
    print('prviousValue : $previousValue => nextValue : $newValue');
  }

  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    // TODO: implement didAddProvider
    super.didAddProvider(provider, value, container);

    print('provider : $provider');
    print('value : $value');
  }
}
