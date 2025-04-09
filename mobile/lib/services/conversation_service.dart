import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/models/page_model.dart';
import 'package:im_mobile/models/conversation_member_model.dart';
import 'package:im_mobile/models/join_request_model.dart';

import '../models/base_response.dart';
import '../models/chat_message_model.dart';
import '../utils/http_client.dart';

class ConversationService {
  static final HttpClient _httpClient = HttpClient();

  // 获取用户的会话列表
  static Future<List<ConversationModel>> getConversations() async {
    BaseResponse<List<ConversationModel>> response = await _httpClient.get<List<ConversationModel>>(
      '/conversations',
      fromJsonT: (json) => json == null
        ? []
        : (json as List).map((item) => ConversationModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 创建新会话
  static Future<dynamic> createConversation(List<int> memberIds, String type,{String? avatar,String? name}) async {
    BaseResponse<dynamic> response = await _httpClient.post<dynamic>(
      '/conversations',
      data: {'type': type,'memberIds':memberIds,'avatar':avatar,'name':name},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  // 邀请成员加入会话
  static Future<dynamic> inviteMembers(int conversationId, List<int> memberIds) async {
    BaseResponse<dynamic> response = await _httpClient.post<dynamic>(
      '/conversations/$conversationId/members',
      data: memberIds,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  // 获取会话成员列表
  static Future<List<ConversationMemberModel>> getConversationMembers(int conversationId) async {
    BaseResponse<List<ConversationMemberModel>> response = await _httpClient.get<List<ConversationMemberModel>>(
      '/conversations/$conversationId/members',
      fromJsonT: (json) => json == null
        ? []
        : (json as List).map((item) => ConversationMemberModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 获取会话消息列表
  static Future<Page<ChatMessageModel>> getConversationMessages(
    int conversationId,
    {int page = 0, int size = 20}
  ) async {
    BaseResponse<Page<ChatMessageModel>> response = await _httpClient.get<Page<ChatMessageModel>>(
      '/conversations/$conversationId/messages',
      queryParameters: {'page': page, 'size': size},
      fromJsonT:(json) => Page.fromJson(json, (dynamic data) => ChatMessageModel.fromJson(data as Map<String, dynamic>)),
    );
    return response.data!;
  }

  // 标记会话为已读
  static Future<void> markAsRead(int conversationId) async {
    await _httpClient.post<void>(
      '/conversations/$conversationId/read',
      fromJsonT: (_) {},
    );
  }

  // 删除会话
  static Future<void> deleteConversation(int conversationId) async {
    await _httpClient.delete<void>(
      '/conversations/$conversationId',
      fromJsonT: (_) {},
    );
  }

  // 退出会话
  static Future<void> quitConversation(int conversationId) async {
    await _httpClient.post<void>(
      '/conversations/$conversationId/quit',
      fromJsonT: (_) {},
    );
  }

  // 删除会话成员
  static Future<void> removeMember(int conversationId, int memberId) async {
    await _httpClient.delete<void>(
      '/conversations/$conversationId/members/$memberId',
      fromJsonT: (_) {},
    );
  }

  // 设置成员角色
  static Future<void> setMemberRole(int conversationId, int memberId, String role) async {
    await _httpClient.put<void>(
      '/conversations/$conversationId/members/$memberId/role?isAdmin=${role=="ADMIN"}' ,
      fromJsonT: (_) {},
    );
  }

  static update(int id, {bool? requireApproval, bool? onlyAdminCanSpeak, bool? onlyAdminCanInvite})async {
     await _httpClient.put<void>(
      '/conversations/$id',
      data: {
        'requireApproval': requireApproval,
        'onlyAdminCanSpeak': onlyAdminCanSpeak,
        'onlyAdminCanInvite': onlyAdminCanInvite
        },
      fromJsonT: (_) {},
    );
  }

  // 获取入群申请列表
  static Future<List<JoinRequestModel>> getJoinRequests(int conversationId) async {
    BaseResponse<List<JoinRequestModel>> response = await _httpClient.get<List<JoinRequestModel>>(
      '/conversations/$conversationId/join-requests',
      fromJsonT: (json) => json == null
        ? []
        : (json as List).map((item) => JoinRequestModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 处理入群申请
  static Future<void> handleJoinRequest(int conversationId, int applicationId, bool approved) async {
    await _httpClient.post<void>(
      '/conversations/$conversationId/join-requests/$applicationId?approved=$approved',
      fromJsonT: (_) {},
    );
  }
}