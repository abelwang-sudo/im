import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/conversation_member_model.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/models/join_request_model.dart';
import 'package:im_mobile/providers/conversation_member_provider.dart';
import 'package:im_mobile/services/conversation_service.dart';
import 'package:im_mobile/services/group_service.dart';
import 'package:im_mobile/services/websocket_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part '../generated/providers/conversation_provider.g.dart';
/// 会话列表状态提供者
@Riverpod(keepAlive: true)
class ConversationController extends _$ConversationController {
  @override
  List<ConversationModel> build() {
    // 初始化WebSocket监听
    final webSocketService = WebSocketService();
    webSocketService.conversationChangeStream.listen((message) {
      Log.i("conversationChangeStream", "listen");
      if(message.content?.action == "create"){
        final newConversation = message.content!.conversation!;
        // 如果是新会话，添加到列表中
        if (!state.any((conversation) => conversation.id == newConversation.id)) {
          state = [...state, newConversation] ;
        }
      }
      if(message.content?.action == "update"){
        final updatedConversation = message.content!.conversation!;
        // 查找并更新现有会话，如果不存在则添加新会话
        state = state.map((conversation) {
          if (conversation.id == updatedConversation.id) {
            return updatedConversation;
          }
          return conversation;
        }).toList();
      }

      if(message.content?.action == "delete"){
        final deletedConversationId = message.conversationId;
        // 从状态中移除被删除的会话
        state = state.where((conversation) => conversation.id != deletedConversationId).toList();
      }

    });
    return [];
  }
  /// 加载会话列表
  Future<void> loadConversations() async {
    try {
      Log.i('ConversationController', '加载会话列表');
      final conversationsData = await ConversationService.getConversations();


      state = conversationsData;
      Log.i('ConversationController', '加载会话列表成功: ${conversationsData.length}个会话');
    } catch (e, stackTrace) {
      Log.e('ConversationController', '加载会话列表失败', e, stackTrace);
      // 加载失败时保持当前状态
    }
  }

  /// 将会话标记为已读
  Future<void> markAsRead(int conversationId) async {
    try {
      state = state.map((conversation) {
        if (conversation.id == conversationId) {
          return conversation.copyWith(member: conversation.member?.copyWith(unreadCount: 0));
        }
        return conversation;
      }).toList();
      await ConversationService.markAsRead(conversationId);
    } catch (e, stackTrace) {
      Log.e('ConversationController', '标记会话已读失败', e, stackTrace);
    }
  }

  /// 创建新会话
  Future<ConversationModel?> createConversation(List<int> memberIds, String type, {String? name, String? avatar}) async {
    try {
      final response = await ConversationService.createConversation(memberIds, type, name: name, avatar: avatar);
      final newConversation = ConversationModel.fromJson(response as Map<String, dynamic>);

      // 添加到会话列表
      state = [...state, newConversation];

      return newConversation;
    } catch (e, stackTrace) {
      Log.e('ConversationController', '创建会话失败', e, stackTrace);
      return null;
    }
  }

  addConversation(ConversationModel conversation){
      state = [conversation,...state];
  }

  /// 根据ID获取会话
  ConversationModel? getConversationById(int conversationId) {
    try {
      return state.firstWhere(
        (conversation) => conversation.id == conversationId,
        orElse: () => throw Exception('会话不存在'),
      );
    } catch (e, stackTrace) {
      Log.e('ConversationController', '获取会话失败: $conversationId', e, stackTrace);
      return null;
    }
  }

  /// 删除会话
  Future<bool> deleteConversation(int conversationId) async {
    try {
      // 先从本地状态中移除会话
      state = state.where((conversation) => conversation.id != conversationId).toList();
      // 调用API删除会话
      await ConversationService.deleteConversation(conversationId);
      Log.i('ConversationController', '删除会话成功: $conversationId');
      return true;
    } catch (e, stackTrace) {
      Log.e('ConversationController', '删除会话失败: $conversationId', e, stackTrace);
      // 删除失败时，重新加载会话列表恢复状态
      loadConversations();
      return false;
    }
  }

  update(ConversationModel newConversation){
    state = state.map((conversation) {
      if (conversation.id == newConversation.id) {
        return newConversation;
      }
      return conversation;
    }).toList();
  }

  Future<void> updateGroupSetting(ConversationModel conversation,String settingName,bool value) async {
    // 根据设置名称更新相应的设置
    if (settingName == 'requireApproval') {
      await ConversationService.update(
        conversation.id,
        requireApproval: value,
      );
      update(conversation.copyWith(requireApproval: value));
    } else if (settingName == 'onlyAdminCanSpeak') {
      await ConversationService.update(
        conversation.id,
        onlyAdminCanSpeak: value,
      );
      update(conversation.copyWith(onlyAdminCanSpeak: value));
    } else if (settingName == 'onlyAdminCanInvite') {
      await ConversationService.update(
        conversation.id,
        onlyAdminCanInvite: value,
      );
      update(conversation.copyWith(onlyAdminCanInvite: value));
    }
  }



  Future<void> inviteMembers(int conversationId,List<int>? ids) async {
    if (ids!=null && ids.isNotEmpty) {
      await ConversationService.inviteMembers(conversationId, ids);
      ref.read(conversationMembersProvider(conversationId).notifier).load();
      ToastUtil.show('邀请成功');
    }
  }

  Future<void> quitGroup(int conversationId) async {
    await ConversationService.quitConversation(conversationId);
    state = state.where((conversation) => conversation.id != conversationId).toList();
    ToastUtil.show('已退出群聊');
  }

  Future<void> dissolveGroup(int groupId) async {
    await GroupService.dissolveGroup(groupId);
    state = state.where((conversation) => conversation.group?.id != groupId).toList();
    ToastUtil.show('群聊已解散');
  }

  Future<void> removeMember(int conversationId,ConversationMemberModel member) async {
    await ConversationService.removeMember(conversationId, member.userId);
    ref.read(conversationMembersProvider(conversationId).notifier).load();
    ToastUtil.show('成员已移除');
  }

  Future<void> setMemberRole(
      int conversationId,ConversationMemberModel member, String role) async {
    await ConversationService.setMemberRole(conversationId, member.userId, role);
    ref.read(conversationMembersProvider(conversationId).notifier).load();
    ToastUtil.show('设置成功');
  }

  // /// 获取未处理的入群申请数量
  // Future<int> getPendingJoinRequestsCount(int conversationId) async {
  //   try {
  //     final requests = await ConversationService.getJoinRequests(conversationId);
  //     // 过滤出状态为PENDING的申请并返回数量
  //     return requests.where((request) => request.status == 'PENDING').length;
  //   } catch (e, stackTrace) {
  //     Log.e('ConversationController', '获取未处理申请数量失败', e, stackTrace);
  //     return 0;
  //   }
  // }
}

// 待处理好友请求状态提供者
@riverpod
Future<List<JoinRequestModel>> joinRequests(Ref ref,int conversationId) async {
  return await ConversationService.getJoinRequests(conversationId);
}