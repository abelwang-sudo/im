import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/post_model.dart';
import 'package:im_mobile/services/post_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/providers/post_provider.g.dart';

// 好友动态列表状态提供者
@Riverpod(keepAlive: true)
class TimelinePosts extends _$TimelinePosts {
  @override
  Future<List<PostModel>> build() async {
    return _fetchTimelinePosts();
  }

  Future<List<PostModel>> _fetchTimelinePosts() async {
    try {
      final posts = await PostService.getTimelinePosts();
      return posts?.content??[];
    } catch (e) {
      Log.e("TimelinePosts", "获取动态列表失败: $e");
      return [];
    }
  }

  // 刷新动态列表
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchTimelinePosts);
  }

  // 点赞/取消点赞动态
  Future<void> toggleLike(int postId) async {
    // 获取当前状态
    final currentPosts = state.value ?? [];
    final postIndex = currentPosts.indexWhere((post) => post.id == postId);
    
    if (postIndex == -1) return;
    
    final post = currentPosts[postIndex];
    final isCurrentlyLiked = post.liked ?? false;
    
    // 乐观更新UI
    final updatedPost = post.copyWith(
        liked: !isCurrentlyLiked,
      likeCount: isCurrentlyLiked ? post.likeCount - 1 : post.likeCount + 1
    );
    
    final updatedPosts = List<PostModel>.from(currentPosts);
    updatedPosts[postIndex] = updatedPost;
    
    state = AsyncValue.data(updatedPosts);
    
    try {
      // 调用API
      bool success;
      if (isCurrentlyLiked) {
        success = await PostService.unlikePost(postId);
      } else {
        success = await PostService.likePost(postId);
      }
      
      if (!success) {
        // 如果API调用失败，回滚UI更新
        final revertedPosts = List<PostModel>.from(state.value ?? []);
        revertedPosts[postIndex] = post;
        state = AsyncValue.data(revertedPosts);
        ToastUtil.showError("操作失败，请重试");
      }
    } catch (e) {
      // 发生异常，回滚UI更新
      final revertedPosts = List<PostModel>.from(state.value ?? []);
      revertedPosts[postIndex] = post;
      state = AsyncValue.data(revertedPosts);
      Log.e("TimelinePosts", "点赞操作失败: $e");
      ToastUtil.showError("操作失败，请重试");
    }
  }

  // 添加新动态到列表
  void addPost(PostModel newPost) {
    final currentPosts = state.value ?? [];
    state = AsyncValue.data([newPost, ...currentPosts]);
  }
}

// 我的动态列表状态提供者
@riverpod
Future<List<PostModel>> myPosts(MyPostsRef ref) async {
  try {
    return await PostService.getMyPosts();
  } catch (e) {
    Log.e("MyPosts", "获取我的动态列表失败: $e");
    return [];
  }
}

// 用户动态列表状态提供者
@riverpod
Future<List<PostModel>> userPosts(UserPostsRef ref, int userId) async {
  try {
    return await PostService.getUserPosts(userId);
  } catch (e) {
    Log.e("UserPosts", "获取用户动态列表失败: $e");
    return [];
  }
}