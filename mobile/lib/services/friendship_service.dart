import 'package:im_mobile/models/contact_model.dart';

import '../models/base_response.dart';
import '../models/friendship_model.dart';
import '../utils/http_client.dart';

class FriendshipService {
  static final HttpClient _httpClient = HttpClient();

  // 获取用户的所有好友
  static Future<List<ContactModel>> getUserFriends() async {
    BaseResponse<List<ContactModel>> response = await _httpClient.get<List<ContactModel>>(
        '/friendships/friends',
        fromJsonT: (json) => json == null 
          ? [] 
          : (json as List).map((item) => ContactModel.fromJson(item as Map<String, dynamic>)).toList(),
      );
      return response.data ?? [];
  }

  // 获取用户收到的所有待处理好友请求
 static Future<List<FriendshipModel>> getPendingFriendRequests() async {
    BaseResponse<List<FriendshipModel>> response = await _httpClient.get<List<FriendshipModel>>(
      '/friendships/pending',
      fromJsonT: (json) => json == null 
        ? [] 
        : (json as List).map((item) => FriendshipModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 发送好友请求
 static Future<BaseResponse<FriendshipModel?>> sendFriendRequest(int addresseeId) async {
    BaseResponse<FriendshipModel?> response = await _httpClient.post<FriendshipModel?>(
      '/friendships/request/$addresseeId',
      fromJsonT: (json) => json == null ? null : FriendshipModel.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  // 接受好友请求
 static Future<FriendshipModel?> acceptFriendRequest(int friendshipId) async {
    BaseResponse<FriendshipModel> response = await _httpClient.put<FriendshipModel>(
      '/friendships/accept/$friendshipId',
      fromJsonT: (json) => FriendshipModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // 拒绝好友请求
static  Future<FriendshipModel?> rejectFriendRequest(int friendshipId) async {
    BaseResponse<FriendshipModel?> response = await _httpClient.put<FriendshipModel?>(
      '/friendships/reject/$friendshipId',
      fromJsonT: (json) => json == null ? null : FriendshipModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // 检查与指定用户是否是好友
 static Future<bool> checkFriendship(int userId) async {
    BaseResponse<bool> response = await _httpClient.get<bool>(
      '/friendships/check/$userId',
      fromJsonT: (json) => json == null ? false : json as bool,
    );
    return response.data ?? false;
  }

  // 删除好友关系
 static Future<bool> deleteFriendship(int friendId) async {
    BaseResponse<bool> response = await _httpClient.delete<bool>(
      '/friendships/$friendId',
      fromJsonT: (json) => json == null ? false : json as bool,
    );
    return response.data ?? false;
  }
}