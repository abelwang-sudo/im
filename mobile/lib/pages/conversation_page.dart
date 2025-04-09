
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/utils/toast_util.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // 加载会话列表
    ref.read(conversationControllerProvider.notifier).loadConversations();

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('会话'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              // 跳转到选择联系人页面创建群聊
              context.push('/select-contacts');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: _buildConversationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList() {
    final conversations = ref.watch(conversationControllerProvider);

    // 根据搜索过滤会话列表
    final filteredConversations = _searchQuery.isEmpty
        ? conversations
        : conversations.where((conversation) {
            // 单聊场景，根据联系人信息过滤
            if (conversation.type == 'SINGLE') {
              return conversation.member?.displayName?.toLowerCase().contains(_searchQuery) ?? false;
            }
            // 群聊场景，根据群名称过滤
            else if (conversation.type == 'GROUP' && conversation.name != null) {
              return conversation.name!.toLowerCase().contains(_searchQuery);
            }
            return false;
          }).toList();

    if (filteredConversations.isEmpty) {
      return const Center(child: Text('暂无会话'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        // 刷新会话列表
        await ref.read(conversationControllerProvider.notifier).loadConversations();
      },
      child: ListView.builder(
        itemCount: filteredConversations.length,
        itemBuilder: (context, index) {
          final conversation = filteredConversations[index];
          return _buildConversationItem(conversation);
        },
      ),
    );
  }

  Widget _buildConversationItem(ConversationModel conversation) {
    final formattedTime = conversation.lastMessage?.timestamp != null
        ? _formatTimestamp(conversation.lastMessage!.timestamp)
        : '';

    return Dismissible(
      key: Key('conversation-${conversation.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // 显示确认对话框
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('确认删除'),
              content: const Text('确定要删除这个会话吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('删除'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        // 调用删除会话的方法
        final success = await ref.read(conversationControllerProvider.notifier).deleteConversation(conversation.id);
        if (!success) {
          // 如果删除失败，显示提示
          if (!mounted) return;
          ToastUtil.show("删除会话失败");
        }
      },
      child: ListTile(
        onTap: () {
          context.push("/chat/${conversation.id}");

        },
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: conversation.avatar != null ? NetworkImage(conversation.avatar!) : null,
              child: conversation.avatar == null ? Text(
                _getInitials(conversation.name??""),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ) : null,
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.member?.displayName ?? conversation.name??"",
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: conversation.lastMessage != null
            ? Text(
                "${conversation.lastMessage?.content?.text}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 5),
            if (conversation.member?.unreadCount != null && conversation.member!.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${conversation.member!.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 获取姓名首字母
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    return name.substring(0, 1).toUpperCase();
  }

  // 格式化时间戳
  String _formatTimestamp(int timestamp) {
    final now = DateTime.now();
    final messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(messageTime);

    if (difference.inDays > 0) {
      return '${messageTime.month}/${messageTime.day}';
    } else if (difference.inHours > 0) {
      return '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}