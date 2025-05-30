# Dynamic Logger

A flexible, extensible, and customizable logging solution for Flutter applications that provides multiple logging targets, log levels, and formatting options.

## Features

- **Multiple Log Levels**: Support for verbose, debug, info, warning, error, fatal, and wtf levels
- **Multiple Output Destinations**: Log to console, file, remote server, or create custom log sinks
- **Color-Coded Console Output**: Enhanced readability with color-coded log messages
- **Structured Logging**: Consistent log format with timestamp, level, source, and message
- **Flexible Integration**: Use directly or with convenient LoggerMixin
- **Singleton Management**: Centralized logger management with LogManager
- **Customizable Output**: Create custom log sinks for specialized logging needs

## Installation

Add `dynamic_logger` to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_logger:
    git:
      url: ssh://git@github.com:Open-Mobile-Kit/dynamic_logger.git
      ref: main
```

Then run:

```
flutter pub get
```

## Basic Usage

### Simple Logging

```dart
import 'package:dynamic_logger/dynamic_logger.dart';

void main() {
  // Get the default logger
  final logger = LogManager().getLogger();
  
  // Log messages with different levels
  logger.info("Application started");
  logger.debug("Debug information");
  logger.warning("Warning message");
  logger.error("Error occurred", Exception("Something went wrong"));
}
```

### Using LoggerMixin

```dart
import 'package:dynamic_logger/dynamic_logger.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with LoggerMixin {
  @override
  void initState() {
    super.initState();
    
    // Logger name is automatically set to the class name
    logger.info("Widget initialized");
  }
  
  void _handleButtonPress() {
    try {
      // Some operation
      logger.debug("Button pressed");
    } catch (e, stackTrace) {
      logger.error("Failed to handle button press", e, stackTrace);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Advanced Usage

### Custom Log Sinks

```dart
import 'package:dynamic_logger/dynamic_logger.dart';

void main() {
  // Setup multiple log sinks
  final logManager = LogManager();
  logManager.addLogSinks([
    ConsoleLogSink("AppLogs"),
    FileLogSink("app_logs"),
    ServerLogSink("https://logs.example.com/api/logs", "RemoteLogs"),
  ]);
  
  // Get a logger that will output to all configured sinks
  final logger = logManager.getLogger("MyLogger");
  
  // Log message will go to console, file and remote server
  logger.info("This is logged everywhere");
}
```

### Creating a Custom Log Sink

```dart
import 'package:dynamic_logger/dynamic_logger.dart';

class AnalyticsLogSink extends LogSink {
  final AnalyticsService _analytics;
  
  AnalyticsLogSink(this._analytics) : super("Analytics");
  
  @override
  Future<void> log(
    LogLevel level,
    String message, {
    dynamic error,
    StackTrace stackTrace = StackTrace.empty,
  }) async {
    // Only send errors and warnings to analytics
    if (level == LogLevel.error || level == LogLevel.warning) {
      await _analytics.trackEvent(
        name: "app_log",
        properties: {
          "level": level.displayName,
          "message": message,
          "error": error?.toString() ?? "",
        },
      );
    }
  }
}

// Usage
final analyticsService = AnalyticsService();
LogManager().addLogSinks([AnalyticsLogSink(analyticsService)]);
```

### Logger with Specific Sinks

```dart
import 'package:dynamic_logger/dynamic_logger.dart';

class UserService with LoggerMixin {
  Future<void> login(String username, String password) async {
    try {
      // Create a specialized logger for sensitive operations
      final secureLogger = loggerWithOutput(
        "SecureOperations",
        sinks: [
          // Only log to console in debug builds
          if (kDebugMode) ConsoleLogSink("SecureOps"),
          // Always log to secure server
          ServerLogSink("https://secure-logs.example.com", "SecureLogs"),
        ],
      );
      
      secureLogger.info("Login attempt for user: $username");
      
      // Login logic here
      
      secureLogger.info("Login successful for user: $username");
    } catch (e, stackTrace) {
      logger.error("Login failed", e, stackTrace);
    }
  }
}
```

## API Reference

### Log Levels

- `verbose`: Detailed debugging information
- `debug`: General debugging information
- `info`: Informational messages
- `warning`: Non-critical issues or warnings
- `error`: Critical errors or exceptions
- `fatal`: Severe errors that may cause application failure
- `wtf`: Unexpected or critical issues ("What a Terrible Failure")

### Log Sinks

- `ConsoleLogSink`: Outputs logs to the console with color-coding
- `FileLogSink`: Writes logs to a file in the application documents directory
- `ServerLogSink`: Sends logs to a remote server via HTTP POST requests

### Core Classes

- `LogManager`: Singleton for managing loggers and global log sinks
- `Logger`: Core logging functionality with methods for each log level
- `LoggerMixin`: Convenient mixin for adding logging to classes

## License

This project is licensed under the MIT License - see the LICENSE file for details.