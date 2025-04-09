import 'dart:async';
import 'dart:convert';
import 'package:im_mobile/models/user_model.dart';
import 'package:im_mobile/utils/shared_preferences_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/models/chat_message_model.dart';

class WebSocketService {
  // WebSocket连接
  WebSocketChannel? _channel;

  // 心跳定时器
  Timer? _heartbeatTimer;

  // 心跳超时定时器
  Timer? _heartbeatTimeoutTimer;

  // 重连定时器
  Timer? _reconnectTimer;

  // 是否已连接
  bool _isConnected = false;

  // 是否正在重连
  bool _isReconnecting = false;

  // 重连尝试次数
  int _reconnectAttempts = 0;

  // 最大重连尝试次数
  final int _maxReconnectAttempts = 5;

  // 重连延迟（毫秒）
  final int _reconnectDelay = 5000;

  // 心跳间隔（毫秒）
  final int _heartbeatInterval = 30000; // 30秒
  // 心跳超时（毫秒）
  final int _heartbeatTimeout = 5000; // 5秒
  // 服务器地址
  final String _serverUrl = 'ws://192.168.2.3:8080/ws';

  // 消息流控制器
  final _noticeController = StreamController<ChatMessageModel>.broadcast();
  final _chatMessageController = StreamController<ChatMessageModel>.broadcast();
  final _conversationChangeController =
      StreamController<ChatMessageModel>.broadcast();

  // 重连失败流控制器
  final _reconnectFailedController = StreamController<void>.broadcast();
  final _userStatusController = StreamController<ChatMessageModel>.broadcast();

  // 消息流
  Stream<ChatMessageModel> get noticeStream => _noticeController.stream;

  Stream<ChatMessageModel> get chatMessageStream =>
      _chatMessageController.stream;

  Stream<ChatMessageModel> get conversationChangeStream =>
      _conversationChangeController.stream;

  Stream<void> get reconnectFailedStream => _reconnectFailedController.stream;

  // 用户状态变更流控制器

// 用户状态变更流
  Stream<ChatMessageModel> get userStatusStream => _userStatusController.stream;

  // 消息监听器
  final List<Function(dynamic)> _messageListeners = [];

  // 连接状态监听器
  final List<Function(bool)> _connectionStatusListeners = [];

  // 重连失败监听器
  final List<Function()> _reconnectFailedListeners = [];

  // 单例模式
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  // 获取连接状态
  bool get isConnected => _isConnected;

  // 连接WebSocket
  Future<void> connect() async {
    // 获取存储的token
    final token = SharedPreferencesUtil.getToken();
    if (_isConnected || _isReconnecting || token == null) return;

    try {
      // 关闭现有连接
      await disconnect();

      // 创建新连接
      final uri = Uri.parse('$_serverUrl?token=$token');
      _channel = WebSocketChannel.connect(uri);

      // 监听连接状态
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        // onDone: _onDone,
      );

      _isConnected = true;
      _notifyConnectionStatusListeners(true);

      // 启动心跳
      _startHeartbeat();

      Log.i('WebSocketService', 'WebSocket连接成功');
    } catch (e, stackTrace) {
      Log.e('WebSocketService', 'WebSocket连接失败', e, stackTrace);
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  // 断开WebSocket连接
  Future<void> disconnect() async {
    _stopHeartbeat();
    _stopReconnect();

    if (_channel != null) {
      try {
        _channel!.sink.close(status.goingAway);
      } catch (e, stackTrace) {
        Log.e('WebSocketService', 'WebSocket关闭失败', e, stackTrace);
      } finally {
        _channel = null;
      }
    }

    _isConnected = false;
    _notifyConnectionStatusListeners(false);
    Log.i('WebSocketService', 'WebSocket连接已关闭');
  }

  // 发送消息
  void sendMessage(ChatMessageModel message) {
    if (!_isConnected || _channel == null) {
      Log.w('WebSocketService', 'WebSocket未连接，无法发送消息');
      return;
    }

    try {
      // 获取当前用户信息
      UserModel? user = SharedPreferencesUtil.getUserInfo();
      message = message.copyWith(
          sender: user?.id,
          senderAvatar: user?.avatar,
          senderNickname: user?.nickname);
      final jsonMessage = jsonEncode(message);
      Log.d('WebSocketService', '发送消息 $jsonMessage');

      _channel!.sink.add(jsonMessage);
    } catch (e, stackTrace) {
      Log.e('WebSocketService', '发送消息失败', e, stackTrace);
    }
  }

  // 发送心跳
  void _sendHeartbeat() {
    if (!_isConnected || _channel == null) return;

    try {
      sendMessage(ChatMessageModel.ping());

      // 设置心跳超时定时器
      _heartbeatTimeoutTimer?.cancel();
      _heartbeatTimeoutTimer =
          Timer(Duration(milliseconds: _heartbeatTimeout), () {
        Log.w('WebSocketService', '心跳超时，准备重连');
        _reconnect();
      });
    } catch (e, stackTrace) {
      Log.e('WebSocketService', '发送心跳失败', e, stackTrace);
    }
  }

  // 启动心跳
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(
      Duration(milliseconds: _heartbeatInterval),
      (_) => _sendHeartbeat(),
    );
  }

  // 停止心跳
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = null;
  }

  // 重连
  Future<void> _reconnect() async {
    Log.w('WebSocketService', '_reconnect');
    if (_isReconnecting) return;
    _isReconnecting = true;

    await disconnect();
    // 增加重连尝试次数
    _reconnectAttempts++;
    Log.i('WebSocketService',
        '重连尝试次数: $_reconnectAttempts/$_maxReconnectAttempts');

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    } else {
      Log.w('WebSocketService', '达到最大重连次数，停止重连');
      _isReconnecting = false;
      _reconnectAttempts = 0; // 重置计数器，以便下次可以重新尝试
      _notifyConnectionStatusListeners(false);
      _notifyReconnectFailedListeners(); // 通知重连失败
    }
  }

  // 安排重连
  void _scheduleReconnect() {
    _stopReconnect();
    _reconnectTimer = Timer(Duration(milliseconds: _reconnectDelay), () async {
      Log.i('WebSocketService',
          '执行重连 (尝试次数: $_reconnectAttempts/$_maxReconnectAttempts)');
      await connect();
    });
  }

  // 停止重连
  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
  }

  // 消息处理
  void _onMessage(dynamic message) {
    try {
      Log.d('WebSocketService', '收到消息$message');
      final data = jsonDecode(message);
      final chatMessage = ChatMessageModel.fromJson(data);

      // 处理心跳响应
      if (chatMessage.type == MessageType.pong) {
        _heartbeatTimeoutTimer?.cancel();
        return;
      }

      // 检查Stream控制器状态
      switch (chatMessage.type) {
        case MessageType.notice:
          if (!_noticeController.isClosed) {
            _noticeController.add(chatMessage);
          }
          // 检查是否是会话变更通知
          if (chatMessage.content?.type == MessageContentType.conversation &&
              !_conversationChangeController.isClosed) {
            _conversationChangeController.add(chatMessage);
          }
          break;
        case MessageType.chat:
          if (!_chatMessageController.isClosed) {
            _chatMessageController.add(chatMessage);
          }
          break;
        case MessageType.join:
          // 检查是否是用户状态变更通知
          if (!_userStatusController.isClosed) {
            _userStatusController.add(chatMessage);
          }
          break;
        case MessageType.leave:
        // 检查是否是用户状态变更通知
          if (!_userStatusController.isClosed) {
            _userStatusController.add(chatMessage);
          }
          break;
        default:
          break;
      }

      // 通知所有消息监听器
      for (var listener in _messageListeners) {
        listener(chatMessage);
      }
    } catch (e, stackTrace) {
      Log.e('WebSocketService', '处理消息失败', e, stackTrace);
    }
  }

  // 错误处理
  void _onError(error) {
    Log.e('WebSocketService', 'WebSocket错误', error);
    _reconnect();
  }

  // 连接关闭处理
  void _onDone() {
    Log.i('WebSocketService', 'WebSocket连接关闭');
    _isConnected = false;
    _notifyConnectionStatusListeners(false);
    _reconnect();
  }

  // 添加消息监听器
  void addMessageListener(Function(dynamic) listener) {
    _messageListeners.add(listener);
  }

  // 移除消息监听器
  void removeMessageListener(Function(dynamic) listener) {
    _messageListeners.remove(listener);
  }

  // 添加连接状态监听器
  void addConnectionStatusListener(Function(bool) listener) {
    _connectionStatusListeners.add(listener);
  }

  // 移除连接状态监听器
  void removeConnectionStatusListener(Function(bool) listener) {
    _connectionStatusListeners.remove(listener);
  }

  // 通知所有连接状态监听器
  void _notifyConnectionStatusListeners(bool status) {
    for (var listener in _connectionStatusListeners) {
      listener(status);
    }
  }

  // 通知所有重连失败监听器
  void _notifyReconnectFailedListeners() {
    if (!_reconnectFailedController.isClosed) {
      _reconnectFailedController.add(null);
    }

    for (var listener in _reconnectFailedListeners) {
      listener();
    }
  }

  // 添加重连失败监听器
  void addReconnectFailedListener(Function() listener) {
    _reconnectFailedListeners.add(listener);
  }

  // 移除重连失败监听器
  void removeReconnectFailedListener(Function() listener) {
    _reconnectFailedListeners.remove(listener);
  }

  // 手动重连
  Future<void> manualReconnect() async {
    // 重置重连尝试次数
    _reconnectAttempts = 0;
    _isReconnecting = false;

    // 尝试连接
    await connect();
  }
}
