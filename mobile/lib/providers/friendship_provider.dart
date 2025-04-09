import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/chat_message_model.dart';
import 'package:im_mobile/models/contact_model.dart';
import 'package:im_mobile/services/websocket_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:im_mobile/providers/user_provider.dart';
import '../models/base_response.dart';
import '../models/friendship_model.dart';
import '../services/friendship_service.dart';

part '../generated/providers/friendship_provider.g.dart';

// 待处理好友请求状态提供者
@riverpod
Future<List<FriendshipModel>> pendingFriendRequests(Ref ref) async {
  final userState = ref.watch(userProvider);
  if (userState == null) {
    return [];
  }
  return await FriendshipService.getPendingFriendRequests();
}

// 好友请求操作状态提供者
@Riverpod(keepAlive: true)
class Contact extends _$Contact {
  final webSocketService = WebSocketService();

  @override
  List<ContactModel> build() {
    final userState = ref.watch(userProvider);
    if (userState == null) {
      throw Exception('用户未登录');
    }
    // 初始化WebSocket监听
    webSocketService.userStatusStream.listen((message) {
      Log.d("userStatusStream", message.content?.status.toString()??"");
      state = state.map((contact) {
        if (contact.id == message.sender) {
          return contact.copyWith(status: message.content!.status!);
        }
        return contact;
      }).toList();
    });

    FriendshipService.getUserFriends().then((v){
      state = v;
    });
    return [];
  }

  // 发送好友请求
  Future<void> sendFriendRequest(int addresseeId) async {
    BaseResponse<FriendshipModel?> response =  await FriendshipService.sendFriendRequest(addresseeId);
    if(response.success){
      ToastUtil.show("操作成功");
    }
  }

  // 接受好友请求
  Future<void> acceptFriendRequest(int friendshipId) async {
    await FriendshipService.acceptFriendRequest(friendshipId);
    List<FriendshipModel>? requests = ref.read(pendingFriendRequestsProvider).value;
    FriendshipModel? request =  requests?.firstWhere((e) => e.id == friendshipId);
    if(request!=null && request.requester != null){
      state = [...state ,request.requester!];
    }
    ref.refresh(pendingFriendRequestsProvider);
  }

  // 拒绝好友请求
  Future<void> rejectFriendRequest(int friendshipId) async {
    await FriendshipService.rejectFriendRequest(friendshipId);
    ref.refresh(pendingFriendRequestsProvider);
  }

  // 删除好友
  Future<void> deleteFriendship(int userId) async {
    await FriendshipService.deleteFriendship(userId);
    state = state.where((contact) => contact.id !=  userId).toList();
  }

  // 处理联系人更新消息
  void handleContactUpdate(ChatMessageModel  message) {
    switch (message.content?.action) {
      case 'request':
        ref.refresh(pendingFriendRequestsProvider);
        break;
      case 'accept':
        // 好友请求被接受
        if(message.content?.friendship?.addressee!=null){
          state = [...state,message.content!.friendship!.addressee!];
        }
        ref.refresh(pendingFriendRequestsProvider);
        break;
      case 'reject':
        // 好友请求被拒绝
        ref.refresh(pendingFriendRequestsProvider);
        break;
      case 'delete':
        // 好友关系被删除
        state = state.where((contact) => contact.id !=  message.sender).toList();
        break;
    }
  }
}
