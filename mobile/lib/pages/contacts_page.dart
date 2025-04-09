import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/models/contact_model.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/pages/friend_requests_page.dart';
import 'package:im_mobile/utils/toast_util.dart';
import '../providers/friendship_provider.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final pendingRequestsAsyncValue = ref.watch(pendingFriendRequestsProvider);
              return pendingRequestsAsyncValue.when(
                data: (requests) {
                  return Badge(
                    isLabelVisible: requests.isNotEmpty,
                    label: Text('${requests.length}'),
                    offset: const Offset(0, 5),
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FriendRequestsPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FriendRequestsPage(),
                      ),
                    );
                  },
                ),
                error: (_, __) => IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FriendRequestsPage(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showAddFriendDialog(context);
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
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.red),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child:  _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    final contacts = ref.watch(contactProvider);

    // 根据搜索过滤好友列表
    final filteredFriends = _searchQuery.isEmpty
        ? contacts
        : contacts.where((friend) =>
    friend.username.toLowerCase().contains(_searchQuery) ||
        (friend.nickname?.toLowerCase() ?? '').contains(_searchQuery))
        .toList();

    if (filteredFriends.isEmpty && _searchQuery.isNotEmpty) {
      return const Center(child: Text('No contacts found'));
    }

    // 创建包含群组入口和好友列表的组合列表
    return ListView.builder(
      itemCount: filteredFriends.length + 1, // +1 用于群组入口
      itemBuilder: (context, index) {
        if (index == 0) {
          // 群组入口
          return _buildGroupsEntry();
        } else {
          // 好友列表
          final friend = filteredFriends[index - 1];
          return _buildContactItem(
            context,
            friend.nickname??"",
            friend.email,
            friend.avatar, // 这里可以添加头像URL
            friend.status == UserStatus.online, // 这里可以根据实际情况显示在线状态
            initials: _getInitials(friend.nickname ?? friend.username),
            userId: friend.id,
          );
        }
      },
    );
  }

  // 构建群组入口项
  Widget _buildGroupsEntry() {
    return ListTile(
      onTap: () {
        context.push('/groups');
      },
      leading: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: const Center(
          child: Icon(
            Icons.group,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      title: const Text(
        '我的群聊',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: const Text('查看所有群聊'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }


  Widget _buildContactItem(BuildContext context, String name, String status,
      String? imagePath, bool isOnline,
      {String? initials, required int userId}) {
    return ListTile(
      onTap: () async{
        ConversationModel? conversationModel = await ref.read(conversationControllerProvider.notifier).createConversation([userId], "PRIVATE");
        if(conversationModel!=null && mounted){
          context.push('/chat/${conversationModel.id}');
        }
      },
      leading: Stack(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: imagePath == null ? Colors.blue : null,
            ),
            child: imagePath != null
                ? ClipOval(
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  )
                : Center(
                    child: Text(
                      initials ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _showDeleteFriendDialog(context, userId, name),
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return '';
  }

  void _showAddFriendDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Add Friend'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter user ID',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final int? userId = int.tryParse(controller.text);
                if (userId != null) {
                  _sendFriendRequest(userId);
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _sendFriendRequest(int userId) async {
    final notifier = ref.read(contactProvider.notifier);
    await notifier.sendFriendRequest(userId);
  }


  void _showDeleteFriendDialog(BuildContext context, int userId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除联系人'),
        content: Text('确定要删除联系人 $name 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFriend(userId);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteFriend(int friendId) {
    final notifier = ref.read(contactProvider.notifier);
    notifier.deleteFriendship(friendId).then((_) {
      ToastUtil.show("联系人已删除");
    }).catchError((error) {
      ToastUtil.show("删除失败");
    });
  }
}
