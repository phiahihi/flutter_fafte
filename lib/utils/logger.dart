import 'package:logger/logger.dart';
import 'package:fafte/env/env.dart';

Level loggerLevel = dev ? Level.debug : Level.nothing;

class Log {
  static final Log _instance = Log._();
  Log._() {
    Logger.level = loggerLevel;

    _logger = Logger(printer: PrettyPrinter());
  }
  static Log get ins => _instance;

  static late Logger _logger;

  void i(dynamic message) {
    _logger.i(message);
  }

  void d(dynamic message) {
    _logger.d(message);
  }

  void v(dynamic message) {
    _logger.v(message);
  }

  void w(dynamic message) {
    _logger.w(message);
  }

  void e(dynamic message) {
    _logger.e(message);
  }

  void wtf(dynamic message) {
    _logger.wtf(message);
  }
}
