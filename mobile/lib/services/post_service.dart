
import 'dart:io';
import 'package:im_mobile/models/signature_model.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import 'package:im_mobile/models/page_model.dart';

import '../models/base_response.dart';
import '../models/post_model.dart';
import '../utils/http_client.dart';

class PostService {
  static final HttpClient _httpClient = HttpClient();

  // 创建新动态
  static Future<PostModel?> createPost(String content, List<MediaModel> images) async {
    final data = {
      'content': content,
      if (images.isNotEmpty) 'medias': images,
    };
    
    BaseResponse<PostModel?> response = await _httpClient.post<PostModel?>(
      '/posts',
      data: data,
      fromJsonT: (json) => json == null ? null : PostModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // 获取动态详情
  static Future<PostModel?> getPostDetail(int postId) async {
    BaseResponse<PostModel?> response = await _httpClient.get<PostModel?>(
      '/posts/$postId',
      fromJsonT: (json) => json == null ? null : PostModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // 获取指定用户的动态列表
  static Future<List<PostModel>> getUserPosts(int userId) async {
    BaseResponse<List<PostModel>> response = await _httpClient.get<List<PostModel>>(
      '/posts/user/$userId',
      fromJsonT: (json) => json == null 
        ? [] 
        : (json as List).map((item) => PostModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 获取当前用户的动态列表
  static Future<List<PostModel>> getMyPosts() async {
    BaseResponse<List<PostModel>> response = await _httpClient.get<List<PostModel>>(
      '/posts/my',
      fromJsonT: (json) => json == null 
        ? [] 
        : (json as List).map((item) => PostModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
    return response.data ?? [];
  }

  // 获取好友动态列表（包括自己的动态）
  static Future<Page<PostModel>?> getTimelinePosts() async {
    BaseResponse<Page<PostModel>> response = await _httpClient.get<Page<PostModel>>(
      '/posts/timeline',
      fromJsonT: (json) => Page.fromJson(json, (dynamic data) => PostModel.fromJson(data as Map<String, dynamic>)),
    );
    return response.data;
  }

  // 点赞动态
  static Future<bool> likePost(int postId) async {
    BaseResponse<bool> response = await _httpClient.post<bool>(
      '/posts/$postId/like',
      fromJsonT: (json) => json == null ? false : json as bool,
    );
    return response.data ?? false;
  }

  // 取消点赞
  static Future<bool> unlikePost(int postId) async {
    BaseResponse<bool> response = await _httpClient.delete<bool>(
      '/posts/$postId/like',
      fromJsonT: (json) => json == null ? false : json as bool,
    );
    return response.data ?? false;
  }

  // 上传头像
  static Future<List<MediaModel>> upload(List<File> imageFile) async {
    // 获取预签名URL
    List<MediaModel> s = [];
    await Future.wait(imageFile.map((value) async {
      try {
        BaseResponse<SignatureModel> urlResponse = await _httpClient.sign(value);
        
        if (urlResponse.data == null) {
          return;
        }
        
        // 上传文件
        SignatureModel uploadSuccess = await _httpClient.upload(
          urlResponse.data!,
          value
        );
        
        String? type = lookupMimeType(value.path);
        s.add(MediaModel(
          mediaUrl: uploadSuccess.fileUrl,  
          mediaType: type?.split("/")[0] ?? "unknown"
        ));
      } catch (e) {
        Log.e("PostService.upload", "上传文件失败", e);
      }
    }));
    
    return s;
  }

}