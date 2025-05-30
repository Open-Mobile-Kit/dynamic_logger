import 'package:dynamic_logger/dynamic_logger.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLogSink extends LogSink {
  MockLogSink(super.name);

  final List<String> loggedMessages = [];

  @override
  Future<void> log(LogLevel level, String message,
      {dynamic error, StackTrace stackTrace = StackTrace.empty}) async {
    final now = DateTime.now().toLocal().toString();
    final formattedMessage = """
[$now] [$level] [$name]
$message
""";
    loggedMessages.add(formattedMessage);

    if (error != null) {
      loggedMessages.add("Error: $error");
    }
    if (stackTrace != StackTrace.empty) {
      loggedMessages.add("StackTrace: $stackTrace");
    }
  }
}

void main() {
  group('Logger', () {
    late MockLogSink mockLogSink;
    late Logger logger;

    setUp(() {
      mockLogSink = MockLogSink('TestLogger');
      logger = Logger('TestLogger', [mockLogSink]);
    });

    test('info logs a message with INFO level', () async {
      logger.info('This is an info message');

      expect(mockLogSink.loggedMessages.length, 1);
      expect(mockLogSink.loggedMessages.first.contains('[INFO]'), isTrue);
      expect(
          mockLogSink.loggedMessages.first.contains('This is an info message'),
          isTrue);
    });

    test('error logs a message with ERROR level and includes error details',
            () async {
          final error = Exception('Test exception');
          final stackTrace = StackTrace.fromString('Stack trace string');

          logger.error('This is an error message', error, stackTrace);

          expect(mockLogSink.loggedMessages.length, greaterThanOrEqualTo(3));

          // General log message
          expect(mockLogSink.loggedMessages[0].contains('[ERROR]'), isTrue);
          expect(mockLogSink.loggedMessages[0].contains('This is an error message'),
              isTrue);

          // Error details
          expect(mockLogSink.loggedMessages[1].contains('Test exception'), isTrue);

          // Stack trace
          expect(
              mockLogSink.loggedMessages[2].contains('Stack trace string'), isTrue);
        });

    test('fatal logs a message with FATAL level and includes error details',
            () async {
          final error = Exception('Fatal exception');
          final stackTrace = StackTrace.fromString('Stack trace string');

          logger.fatal('This is a fatal message', error, stackTrace);

          expect(mockLogSink.loggedMessages.length, greaterThanOrEqualTo(3));

          // General log message
          expect(mockLogSink.loggedMessages[0].contains('[FATAL]'), isTrue);
          expect(mockLogSink.loggedMessages[0].contains('This is a fatal message'),
              isTrue);

          // Error details
          expect(mockLogSink.loggedMessages[1].contains('Fatal exception'), isTrue);

          // Stack trace
          expect(
              mockLogSink.loggedMessages[2].contains('Stack trace string'), isTrue);
        });

    test('wtf logs a message with WTF level and includes error details',
            () async {
          final error = Exception('WTF exception');
          final stackTrace = StackTrace.fromString('Stack trace string');

          logger.wtf('This is a WTF message', error, stackTrace);

          expect(mockLogSink.loggedMessages.length, greaterThanOrEqualTo(3));

          // General log message
          expect(mockLogSink.loggedMessages[0].contains('[WTF]'), isTrue);
          expect(mockLogSink.loggedMessages[0].contains('This is a WTF message'),
              isTrue);

          // Error details
          expect(mockLogSink.loggedMessages[1].contains('WTF exception'), isTrue);

          // Stack trace
          expect(
              mockLogSink.loggedMessages[2].contains('Stack trace string'), isTrue);
        });

    test('warning logs a message with WARNING level', () async {
      logger.warning('This is a warning message');

      expect(mockLogSink.loggedMessages.length, 1);
      expect(mockLogSink.loggedMessages.first.contains('[WARNING]'), isTrue);
      expect(
          mockLogSink.loggedMessages.first
              .contains('This is a warning message'),
          isTrue);
    });

    test('debug logs a message with DEBUG level', () async {
      logger.debug('This is a debug message');

      expect(mockLogSink.loggedMessages.length, 1);
      expect(mockLogSink.loggedMessages.first.contains('[DEBUG]'), isTrue);
      expect(
          mockLogSink.loggedMessages.first.contains('This is a debug message'),
          isTrue);
    });
  });
}
