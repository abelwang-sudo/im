import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// 日志级别枚举
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal
}

/// 日志管理器
class Logger {
  // 单例实例
  static final Logger _instance = Logger._internal();

  // 工厂构造函数
  factory Logger() => _instance;

  // 内部构造函数
  Logger._internal() {
    _initialize();
  }

  // 日志文件
  File? _logFile;

  // 日志文件最大大小（5MB）
  static const int _maxLogSize = 5 * 1024 * 1024;

  // 日志文件路径
  String? _logFilePath;

  // 日期格式化器
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  // 日志级别对应的颜色和前缀
  final Map<LogLevel, Map<String, dynamic>> _logLevelConfig = {
    LogLevel.debug: {'prefix': 'DEBUG', 'color': Colors.blue},
    LogLevel.info: {'prefix': 'INFO', 'color': Colors.green},
    LogLevel.warning: {'prefix': 'WARN', 'color': Colors.orange},
    LogLevel.error: {'prefix': 'ERROR', 'color': Colors.red},
    LogLevel.fatal: {'prefix': 'FATAL', 'color': Colors.purple},
  };

  // 当前日志级别（默认为debug，记录所有日志）
  LogLevel _currentLogLevel = LogLevel.debug;

  /// 设置日志级别
  set logLevel(LogLevel level) {
    _currentLogLevel = level;
  }

  /// 获取日志文件路径
  Future<String?> get logFilePath async {
    if (_logFilePath == null) {
      await _initialize();
    }
    return _logFilePath;
  }

  /// 初始化日志系统
  Future<void> _initialize() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String logDirPath = '${appDocDir.path}/logs';

      // 确保日志目录存在
      final Directory logDir = Directory(logDirPath);
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      // 创建日志文件名（使用当前日期）
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFilePath = '$logDirPath/app_log_$today.log';

      _logFile = File(_logFilePath!);
      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }

      // 检查日志文件大小，如果超过最大大小则进行轮转
      await _checkLogFileSize();

      // 记录应用启动日志
      await log(LogLevel.info, 'Logger', 'Logger initialized successfully');
    } catch (e) {
      debugPrint('Logger initialization failed: $e');
    }
  }

  /// 检查日志文件大小并在必要时进行轮转
  Future<void> _checkLogFileSize() async {
    if (_logFile == null) return;

    try {
      final int fileSize = await _logFile!.length();

      if (fileSize > _maxLogSize) {
        // 创建备份文件名
        final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final String backupPath = '${_logFilePath!.substring(0, _logFilePath!.lastIndexOf('.'))}_$timestamp.log';

        // 重命名当前日志文件为备份文件
        await _logFile!.rename(backupPath);

        // 创建新的日志文件
        _logFile = File(_logFilePath!);
        await _logFile!.create();

        await log(LogLevel.info, 'Logger', 'Log file rotated. Previous log saved to: $backupPath');
      }
    } catch (e) {
      debugPrint('Error checking log file size: $e');
    }
  }

  /// 记录日志
  Future<void> log(LogLevel level, String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    // 检查是否应该记录此级别的日志
    if (level.index < _currentLogLevel.index) return;

    try {
      // 确保日志文件已初始化
      if (_logFile == null) {
        await _initialize();
      }

      // 检查日志文件大小
      await _checkLogFileSize();

      // 格式化日志消息
      final String timestamp = _dateFormatter.format(DateTime.now());
      final String levelPrefix = _logLevelConfig[level]?['prefix'] ?? 'UNKNOWN';

      String logMessage = '[$timestamp] [$levelPrefix] [$tag] $message';

      // 添加错误信息和堆栈跟踪（如果有）
      if (error != null) {
        logMessage += '\nError: $error';
      }

      if (stackTrace != null) {
        logMessage += '\nStackTrace: $stackTrace';
      }

      // 写入日志文件
      await _logFile!.writeAsString('$logMessage\n', mode: FileMode.append);

      // 在控制台打印日志（带颜色）
      final Color color = _logLevelConfig[level]?['color'] ?? Colors.grey;
      debugPrint('\x1B[${_colorToAnsi(color)}m$logMessage\x1B[0m');
    } catch (e) {
      debugPrint('Failed to write log: $e');
    }
  }

  /// 将Flutter颜色转换为ANSI颜色代码（用于控制台输出）
  int _colorToAnsi(Color color) {
    if (color == Colors.black) return 30;
    if (color == Colors.red) return 31;
    if (color == Colors.green) return 32;
    if (color == Colors.yellow || color == Colors.orange) return 33;
    if (color == Colors.blue) return 34;
    if (color == Colors.purple || color == Colors.pink) return 35;
    if (color == Colors.cyan) return 36;
    if (color == Colors.white) return 37;
    return 37; // 默认为白色
  }

  /// 调试日志
  Future<void> d(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await log(LogLevel.debug, tag, message, error, stackTrace);
  }

  /// 信息日志
  Future<void> i(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await log(LogLevel.info, tag, message, error, stackTrace);
  }

  /// 警告日志
  Future<void> w(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await log(LogLevel.warning, tag, message, error, stackTrace);
  }

  /// 错误日志
  Future<void> e(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await log(LogLevel.error, tag, message, error, stackTrace);
  }

  /// 致命错误日志
  Future<void> f(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await log(LogLevel.fatal, tag, message, error, stackTrace);
  }

  /// 清除日志文件
  Future<void> clearLogs() async {
    try {
      if (_logFile != null && await _logFile!.exists()) {
        await _logFile!.writeAsString('');
        await log(LogLevel.info, 'Logger', 'Log file cleared');
      }
    } catch (e) {
      debugPrint('Failed to clear logs: $e');
    }
  }

  /// 获取所有日志文件
  Future<List<File>> getAllLogFiles() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String logDirPath = '${appDocDir.path}/logs';

      final Directory logDir = Directory(logDirPath);
      if (!await logDir.exists()) {
        return [];
      }

      final List<FileSystemEntity> entities = await logDir.list().toList();
      return entities
          .whereType<File>()
          .where((file) => file.path.endsWith('.log'))
          .toList();
    } catch (e) {
      debugPrint('Failed to get log files: $e');
      return [];
    }
  }

  /// 分享日志文件
  Future<void> shareLogFile() async {
    try {
      if (_logFilePath == null) return;

      final File file = File(_logFilePath!);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(_logFilePath!)],
          subject: 'Application Logs',
          text: 'Here are the application logs for debugging',
        );
      } else {
        debugPrint('Log file does not exist');
      }
    } catch (e) {
      debugPrint('Failed to share log file: $e');
    }
  }

  /// 分享所有日志文件
  Future<void> shareAllLogFiles() async {
    try {
      final List<File> logFiles = await getAllLogFiles();

      if (logFiles.isEmpty) {
        debugPrint('No log files to share');
        return;
      }

      final List<XFile> xFiles = logFiles.map((file) => XFile(file.path)).toList();

      await Share.shareXFiles(
        xFiles,
        subject: 'Application Logs',
        text: 'Here are all the application logs for debugging',
      );
    } catch (e) {
      debugPrint('Failed to share all log files: $e');
    }
  }
}

/// 日志工具类（便于直接使用）
class Log {
  static final Logger _logger = Logger();

  /// 设置日志级别
  static set logLevel(LogLevel level) {
    _logger.logLevel = level;
  }
  
  /// 调试日志
  static Future<void> d(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await _logger.d(tag, message, error, stackTrace);
  }
  
  /// 信息日志
  static Future<void> i(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await _logger.i(tag, message, error, stackTrace);
  }
  
  /// 警告日志
  static Future<void> w(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await _logger.w(tag, message, error, stackTrace);
  }
  
  /// 错误日志
  static Future<void> e(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await _logger.e(tag, message, error, stackTrace);
  }
  
  /// 致命错误日志
  static Future<void> f(String tag, String message, [dynamic error, StackTrace? stackTrace]) async {
    await _logger.f(tag, message, error, stackTrace);
  }
  
  /// 分享当前日志文件
  static Future<void> shareLogFile() async {
    await _logger.shareLogFile();
  }
  
  /// 分享所有日志文件
  static Future<void> shareAllLogFiles() async {
    await _logger.shareAllLogFiles();
  }
  
  /// 清除日志
  static Future<void> clearLogs() async {
    await _logger.clearLogs();
  }
  
  /// 获取日志文件路径
  static Future<String?> get logFilePath async {
    return await _logger.logFilePath;
  }
}