import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

part 'log_level.dart';

part 'log_sink.dart';

part 'logger_mixin.dart';

/// Manages loggers and global log sinks for the application.
class LogManager {
  static const String defaultLoggerName = "DEFAULT";

  // Singleton instance of LogManager
  static final LogManager _instance = LogManager._internal();

  /// Factory constructor to return the singleton instance.
  factory LogManager() => _instance;

  /// Private constructor for singleton pattern.
  LogManager._internal();

  // Map to store loggers by their names.
  final Map<String, Logger> _loggers = {};

  // List of global log sinks shared across all loggers.
  final List<LogSink> _globalLogSinks = [];

  /// Adds multiple log sinks to the global list.
  void addLogSinks(List<LogSink> targets) {
    _globalLogSinks.addAll(targets);
  }

  /// Removes a specific log sink from the global list.
  void removeLogSink(LogSink target) {
    _globalLogSinks.remove(target);
  }

  /// Retrieves a logger by name or creates a new one if it doesn't exist.
  Logger getLogger([String name = defaultLoggerName, List<LogSink>? sinks]) {
    return _loggers.putIfAbsent(
      name,
      () => Logger(name, sinks ?? _globalLogSinks),
    );
  }
}

/// Handles logging messages with different log levels.
class Logger {
  final String name;
  final List<LogSink> _logSinks;

  /// Creates a logger with a specific name and associated log sinks.
  Logger(this.name, this._logSinks);

  /// Logs a message with the INFO level.
  void info(String message) {
    _writeLog(LogLevel.info, message);
  }

  /// Logs a message with the ERROR level, including optional error and stack trace.
  void error(
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    _writeLog(LogLevel.error, message, error, stackTrace);
  }

  /// Logs a message with the WARNING level.
  void warning(
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    _writeLog(LogLevel.warning, message);
  }

  /// Logs a message with the DEBUG level.
  void debug(
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    _writeLog(LogLevel.debug, message);
  }

  /// Logs a message with the VERBOSE level.
  void verbose(String message) {
    _writeLog(LogLevel.verbose, message);
  }

  /// Logs a message with the FATAL level, including optional error and stack trace.
  void fatal(
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    _writeLog(LogLevel.fatal, message, error, stackTrace);
  }

  /// Logs a message with the WTF level, including optional error and stack trace.
  void wtf(
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    _writeLog(LogLevel.wtf, message, error, stackTrace);
  }

  /// Writes a log message to all associated log sinks.
  ///
  /// [level] - The log level of the message.
  /// [message] - The log message.
  /// [error] - Optional error details.
  /// [stackTrace] - Optional stack trace details.
  void _writeLog(
    LogLevel level,
    String message, [
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  ]) {
    for (var sink in _logSinks) {
      sink.log(level, message, error: error, stackTrace: stackTrace);
    }
  }
}
