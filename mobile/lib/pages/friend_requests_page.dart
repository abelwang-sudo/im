import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/friendship_model.dart';
import 'package:im_mobile/providers/friendship_provider.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';

class FriendRequestsPage extends ConsumerWidget {
  const FriendRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('好友请求'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildFriendRequestsList(ref),
    );
  }

  Widget _buildFriendRequestsList(WidgetRef ref) {
    final pendingRequestsAsyncValue = ref.watch(pendingFriendRequestsProvider);
    
    return pendingRequestsAsyncValue.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无好友请求', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final requester = request.requester;
            if (requester == null) return const SizedBox.shrink();
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(_getInitials(requester.nickname ?? requester.username)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requester.nickname ?? requester.username,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '请求添加您为好友',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _rejectFriendRequest(context, ref, request.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('拒绝'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _acceptFriendRequest(context, ref, request.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('接受'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        Log.e("friendsProvider", error.toString(), error, stack);
        return Center(child: Text('加载失败: $error'));
      },
    );
  }

  void _acceptFriendRequest(BuildContext context, WidgetRef ref, int friendshipId) {
    final notifier = ref.read(contactProvider.notifier);
    notifier.acceptFriendRequest(friendshipId).then((_) {
      ToastUtil.show("已接受好友请求");
    }).catchError((error) {
      ToastUtil.show("操作失败");
    });
  }

  void _rejectFriendRequest(BuildContext context, WidgetRef ref, int friendshipId) {
    final notifier = ref.read(contactProvider.notifier);
    notifier.rejectFriendRequest(friendshipId).then((_) {
      ToastUtil.show("已拒绝好友请求");
    }).catchError((error) {
      ToastUtil.show("操作失败");
    });
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
}