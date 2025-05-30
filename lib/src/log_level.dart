part of 'logger.dart';

const String _ansiReset = "\u001b[0m";
const String _ansiGreen = "\u001b[32m";
const String _ansiYellow = "\u001b[33m";
const String _ansiRed = "\u001b[31m";
const String _ansiCyan = "\u001b[36m";
const String _ansiWhite = "\u001b[37m";
const String _ansiMagenta = "\u001b[35m";

/// Enum representing different log levels for logging purposes.
enum LogLevel {
  /// Verbose log level, used for detailed debugging information.
  verbose,

  /// Debug log level, used for general debugging information.
  debug,

  /// Info log level, used for informational messages.
  info,

  /// Warning log level, used for non-critical issues or warnings.
  warning,

  /// Error log level, used for critical errors or exceptions.
  error,

  /// Fatal log level, used for severe errors that may cause application failure.
  fatal,

  /// WTF log level, used for unexpected or critical issues.
  wtf,
}

/// Extension on the `LogLevel` enum to provide additional functionality.
extension LogLevelExtension on LogLevel {
  /// Returns a display-friendly name for each log level.
  ///
  /// This is useful for formatting log messages with human-readable log levels.
  String get displayName {
    switch (this) {
      case LogLevel.verbose:
        return "VERBOSE";
      case LogLevel.debug:
        return "DEBUG";
      case LogLevel.info:
        return "INFO";
      case LogLevel.warning:
        return "WARNING";
      case LogLevel.error:
        return "ERROR";
      case LogLevel.fatal:
        return "FATAL";
      case LogLevel.wtf:
        return "WTF";
    }
  }

  /// Returns a color code for the log level.

  String get color {
    switch (this) {
      case LogLevel.verbose:
        return _ansiCyan;
      case LogLevel.debug:
        return _ansiGreen;
      case LogLevel.info:
        return _ansiWhite;
      case LogLevel.warning:
        return _ansiYellow;
      case LogLevel.error:
        return _ansiRed;
      case LogLevel.fatal:
        return _ansiMagenta;
      case LogLevel.wtf:
        return _ansiRed;
    }
  }

  int get levelIndex {
    switch (this) {
      case LogLevel.verbose:
        return 0;
      case LogLevel.debug:
        return 1000;
      case LogLevel.info:
        return 2000;
      case LogLevel.warning:
        return 3000;
      case LogLevel.error:
        return 4000;
      case LogLevel.fatal:
        return 5000;
      case LogLevel.wtf:
        return 6000;
    }
  }
}
