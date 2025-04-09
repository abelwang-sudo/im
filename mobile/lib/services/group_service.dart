import 'dart:convert';
import 'package:im_mobile/models/conversation_model.dart';

import '../models/base_response.dart';
import '../models/group_model.dart';
import '../utils/http_client.dart';

class GroupService {
  static final HttpClient _httpClient = HttpClient();

  // 创建新群组
  static Future<ConversationModel?> createGroup({
    required String name,
    required String description,
    required List<int> memberIds,
    String? avatar,
  }) async {
    BaseResponse<ConversationModel?> response = await _httpClient.post<ConversationModel>(
      '/groups',
      data: {
        'name': name,
        'description': description,
        'memberIds': memberIds,
        'avatar': avatar,
      },
      fromJsonT: (dynamic json) => ConversationModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // 获取群组详情
  static Future<GroupModel> getGroupDetails(int groupId) async {
    BaseResponse<GroupModel> response = await _httpClient.get<GroupModel>(
      '/groups/$groupId',
      fromJsonT: (json) {
        if (json is Map<String, dynamic> && json['extraSettings'] is String) {
          try {
            final settingsStr = json['extraSettings'] as String;
            json['extraSettings'] = jsonDecode(settingsStr);
          } catch (e) {
            // 如果解析失败，使用默认值
            json['extraSettings'] = {
              'requireApproval': false,
              'onlyAdminCanSpeak': false,
              'onlyAdminCanInvite': false
            };
          }
        }
        return GroupModel.fromJson(json as Map<String, dynamic>);
      },
    );
    return response.data!;
  }

  // 更新群组信息
  static Future<dynamic> updateGroup(
    int groupId, {
    String? name,
    String? description,
    String? avatar,
    Map<String, dynamic>? extraSettings,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (avatar != null) data['avatar'] = avatar;
    if (extraSettings != null) data['extraSettings'] = jsonEncode(extraSettings);

    BaseResponse<dynamic> response = await _httpClient.put<dynamic>(
      '/groups/$groupId',
      data: data,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  // 添加群成员
  static Future<dynamic> addGroupMembers(int groupId, List<int> memberIds) async {
    BaseResponse<dynamic> response = await _httpClient.post<dynamic>(
      '/groups/$groupId/members',
      data: memberIds,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  // 移除群成员
  static Future<void> removeGroupMember(int groupId, int memberId) async {
    await _httpClient.delete<void>(
      '/groups/$groupId/members/$memberId',
      fromJsonT: (_) {},
    );
  }

  // 退出群组
  static Future<void> leaveGroup(int groupId) async {
    await _httpClient.post<void>(
      '/groups/$groupId/leave',
      fromJsonT: (_) {},
    );
  }

  // 解散群组
  static Future<void> dissolveGroup(int groupId) async {
    await _httpClient.delete<void>(
      '/groups/$groupId',
      fromJsonT: (_) {},
    );
  }

  // 获取用户加入的群组列表
  static Future<List<GroupModel>> getUserGroups() async {
    BaseResponse<List<GroupModel>> response = await _httpClient.get<List<GroupModel>>(
      '/groups',
      fromJsonT: (json) {
        if (json == null) return [];
        return (json as List).map((item) {
          // 处理 extraSettings 字段
          if (item is Map<String, dynamic> && item['extraSettings'] is String) {
            try {
              final settingsStr = item['extraSettings'] as String;
              item['extraSettings'] = jsonDecode(settingsStr);
            } catch (e) {
              // 如果解析失败，使用默认值
              item['extraSettings'] = {
                'requireApproval': false,
                'onlyAdminCanSpeak': false,
                'onlyAdminCanInvite': false
              };
            }
          }
          return GroupModel.fromJson(item as Map<String, dynamic>);
        }).toList();
      },
    );
    return response.data ?? [];
  }
}
