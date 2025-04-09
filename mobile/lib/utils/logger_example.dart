import 'package:flutter/material.dart';
import 'logger.dart';

/// 日志组件使用示例
class LoggerExample extends StatefulWidget {
  const LoggerExample({super.key});

  @override
  State<LoggerExample> createState() => _LoggerExampleState();
}

class _LoggerExampleState extends State<LoggerExample> {
  String _logFilePath = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getLogFilePath();
    
    // 记录一些示例日志
    _writeExampleLogs();
  }

  // 获取日志文件路径
  Future<void> _getLogFilePath() async {
    setState(() {
      _isLoading = true;
    });
    
    final path = await Log.logFilePath;
    
    setState(() {
      _logFilePath = path ?? 'Unable to get log file path';
      _isLoading = false;
    });
  }

  // 写入示例日志
  Future<void> _writeExampleLogs() async {
    // 调试级别日志
    await Log.d('LoggerExample', 'This is a debug log message');
    
    // 信息级别日志
    await Log.i('LoggerExample', 'This is an info log message');
    
    // 警告级别日志
    await Log.w('LoggerExample', 'This is a warning log message');
    
    // 错误级别日志
    await Log.e('LoggerExample', 'This is an error log message', 
        Exception('This is a test exception'));
    
    // 致命错误日志
    try {
      throw Exception('This is a fatal error test');
    } catch (e, stackTrace) {
      await Log.f('LoggerExample', 'This is a fatal log message', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日志组件示例'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '日志组件功能演示',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('当前日志文件路径:'),
            const SizedBox(height: 8),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _logFilePath,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
            const SizedBox(height: 24),
            const Text('日志操作:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _writeExampleLogs,
                  child: const Text('写入示例日志'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Log.shareLogFile();
                  },
                  child: const Text('分享当前日志'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Log.shareAllLogFiles();
                  },
                  child: const Text('分享所有日志'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Log.clearLogs();
                  },
                  child: const Text('清除日志'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '使用说明:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. 日志组件提供了五个级别的日志记录: debug, info, warning, error, fatal\n'
              '2. 日志会自动保存到应用文档目录下的logs文件夹中\n'
              '3. 日志文件会按日期命名，并在超过5MB时自动轮转\n'
              '4. 可以随时分享日志文件用于调试',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}