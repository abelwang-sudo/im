import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/chat_message_model.dart';
import 'package:im_mobile/pages/timeline_page.dart';
import 'package:im_mobile/providers/friendship_provider.dart';
import 'package:im_mobile/services/websocket_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'contacts_page.dart';
import 'profile_page.dart';
import 'conversation_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}


class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  final List<Widget> _pages = [
    const CachedPage(child: ConversationPage()),
    const CachedPage(child: ContactsPage()),
    const CachedPage(child: TimelinePage()),
    const CachedPage(child: ProfilePage()),
  ];

  late final WebSocketService _webSocketService;
  bool _isShowingReconnectDialog = false;
  late final StreamSubscription _reconnectFailedSubscription;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _webSocketService = WebSocketService();
    _webSocketService.connect();
    
    // 监听通知消息
    _webSocketService.noticeStream.listen((message) {
      if(message.content?.type == MessageContentType.contact){
        ref.read(contactProvider.notifier).handleContactUpdate(message);
      }
    });
    
    // 监听重连失败事件 - 使用Stream方式
    _reconnectFailedSubscription = _webSocketService.reconnectFailedStream.listen((_) => _onReconnectFailed());
  }
  
  @override
  void dispose() {
    _reconnectFailedSubscription.cancel();
    _webSocketService.disconnect();
    _pageController.dispose();
    super.dispose();
  }
  
  // 重连失败处理
  void _onReconnectFailed() {
    Log.d("_onReconnectFailed", "手动重连");
    // 避免重复显示对话框
    if (_isShowingReconnectDialog) return;
    
    setState(() {
      _isShowingReconnectDialog = true;
    });
    
    // 显示重连失败对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('连接失败'),
        content: const Text('无法连接到服务器，请检查网络连接后重试。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isShowingReconnectDialog = false;
              });
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isShowingReconnectDialog = false;
              });
              // 手动触发重连
              _webSocketService.manualReconnect();
            },
            child: const Text('重新连接'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 禁止滑动切换，只通过底部导航栏切换
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '聊天',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: '联系人',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

// 用于缓存页面状态的包装组件
class CachedPage extends StatefulWidget {
  final Widget child;
  
  const CachedPage({Key? key, required this.child}) : super(key: key);
  
  @override
  State<CachedPage> createState() => _CachedPageState();
}

class _CachedPageState extends State<CachedPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用
    return widget.child;
  }
  
  @override
  bool get wantKeepAlive => true; // 保持页面状态
}