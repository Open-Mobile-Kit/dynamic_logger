part of 'logger.dart';

mixin LoggerMixin {
  /// A logger instance for the default logger.
  Logger get defaultLogger {
    return LogManager().getLogger(LogManager.defaultLoggerName, [
      ConsoleLogSink(LogManager.defaultLoggerName),
    ]);
  }

  /// A logger instance for the class that uses this mixin.
  Logger get logger {
    return LogManager().getLogger(source, [ConsoleLogSink(source)]);
  }

  /// A logger instance for the class that uses this mixin with a custom name.
  ///
  Logger loggerWithOutput(String name, {List<LogSink>? sinks}) {
    return LogManager().getLogger(name, sinks);
  }

  /// Gets the current source of the logger.
  String get source {
    return runtimeType.toString();
  }
}
