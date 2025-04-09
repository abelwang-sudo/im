import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/chat_message_model.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/pages/conversation_detail_page.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/services/conversation_service.dart';
import 'package:im_mobile/services/websocket_service.dart';
import 'package:im_mobile/providers/user_provider.dart';
import 'package:im_mobile/utils/logger.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int conversationId;

  const ChatPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  late final WebSocketService _webSocketService;
  bool _isLoading = false;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMoreMessages = true;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  // 添加StreamSubscription变量来管理WebSocket消息监听
  late final StreamSubscription<ChatMessageModel> _chatMessageSubscription;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();

    // 监听WebSocket消息并保存订阅对象
    _chatMessageSubscription = _webSocketService.chatMessageStream.listen(_handleNewMessage);

    // 加载历史消息
    _loadMessages();

    // 添加滚动监听器，用于加载更多消息
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // 取消WebSocket消息监听，避免组件销毁后仍接收消息
    _chatMessageSubscription.cancel();
    super.dispose();
  }

  // 滚动监听器，用于加载更多消息
  void _scrollListener() {
    if (_scrollController.position.pixels == 0 && !_isLoading && _hasMoreMessages) {
      _loadMoreMessages();
    }
  }

  // 加载历史消息
  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _hasMoreMessages = true;
      _messages.clear();
    });

    try {
      final page = await ConversationService.getConversationMessages(
        widget.conversationId,
        page: _currentPage,
        size: _pageSize
      );
      List<ChatMessageModel>  messages = page.content;
      _messages.addAll(messages);
      _hasMoreMessages = messages.length >= _pageSize;
      _isLoading = false;
      setState(() {});
    } catch (e, stackTrace) {
      Log.e('ChatPage', '加载消息失败', e, stackTrace);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 加载更多历史消息
  Future<void> _loadMoreMessages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 增加页码以获取更早的消息
      _currentPage++;

      final page = await ConversationService.getConversationMessages(
        widget.conversationId,
        page: _currentPage,
        size: _pageSize
      );

      List<ChatMessageModel> messages = page.content;

      // 判断是否还有更多消息
      _hasMoreMessages = messages.length >= _pageSize;

      // 将新消息添加到列表末尾
      if (messages.isNotEmpty) {
        setState(() {
          _messages.addAll(messages);
        });
      }
    } catch (e, stackTrace) {
      Log.e('ChatPage', '加载更多消息失败', e, stackTrace);
      // 加载失败时恢复页码
      _currentPage--;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 处理新消息
  void _handleNewMessage(ChatMessageModel message) {
    if (message.type != MessageType.chat || message.conversationId != widget.conversationId) return;
    final currentUser = ref.read(userProvider);
    final isMe = message.sender == currentUser?.id;
    // 因为在_sendMessage方法中已经添加过了
    if (isMe) return;
    setState(() {
      _messages.insert(0, message);
    });
  }

  // 格式化时间戳
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    ConversationModel conversationModel = ref.watch(conversationControllerProvider.select((e) => e.firstWhere((c) => c.id == widget.conversationId)));
    return PopScope(
      onPopInvokedWithResult: (bool didPop, result){
        ref.read(conversationControllerProvider.notifier).markAsRead(widget.conversationId);
      },
      child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          conversationModel.member?.displayName??"",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ConversationDetailPage(
                    id: conversationModel.id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadMoreMessages,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                reverse: true,  // 不反转列表，保持正常顺序
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    ), );
  }

  Widget _buildMessageItem(ChatMessageModel message) {
    final currentUser = ref.read(userProvider);

    bool isMe =  currentUser?.id == message.sender;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[_buildOtherAvatar(message.senderAvatar), const SizedBox(width: 8)],
          Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(message.content?.text??""),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildOtherAvatar(avatar) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatar == null ? Colors.blue : null,
      ),
      child:  avatar != null
          ? ClipOval(
              child: Image.network(
                avatar!,
                fit: BoxFit.cover,
              ),
            )
          : const Center(),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }


// 发送消息
  void _sendMessage(String text) {
    if (!_webSocketService.isConnected) {
      Log.w('ChatPage', 'WebSocket未连接，无法发送消息');
      return;
    }

    final currentUser = ref.read(userProvider);
    if (currentUser == null) return;

    // 创建消息内容
    final content = MessageContent(MessageContentType.text, text);

    // 创建聊天消息
    final message = ChatMessageModel.chat(
      content: content,
      conversationId: widget.conversationId,
    );

    ConversationModel conversationModel = ref.read(conversationControllerProvider.select((e) => e.firstWhere((c) => c.id == widget.conversationId)));

    ref.read(conversationControllerProvider.notifier).update(conversationModel.copyWith(
      lastMessage: message
    ));
    // 发送消息
    _webSocketService.sendMessage(message);
    // 添加到本地消息列表
    setState(() {
      _messages.insert(0, message);
    });
  }
}