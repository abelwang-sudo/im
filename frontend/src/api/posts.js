import request from '@/utils/request';

// 创建新动态
export function createPost(data) {
  return request({
    url: '/posts',
    method: 'post',
    data
  });
}

// 获取动态详情
export function getPostDetail(postId) {
  return request({
    url: `/posts/${postId}`,
    method: 'get'
  });
}

// 获取指定用户的动态列表
export function getUserPosts(userId) {
  return request({
    url: `/posts/user/${userId}`,
    method: 'get'
  });
}

// 获取当前用户的动态列表
export function getMyPosts() {
  return request({
    url: '/posts/my',
    method: 'get'
  });
}

// 获取好友动态列表（包括自己的动态）
export function getTimelinePosts() {
  return request({
    url: '/posts/timeline',
    method: 'get'
  });
}

// 点赞动态
export function likePost(postId) {
  return request({
    url: `/posts/${postId}/like`,
    method: 'post'
  });
}

// 取消点赞
export function unlikePost(postId) {
  return request({
    url: `/posts/${postId}/like`,
    method: 'delete'
  });
}

// 检查用户是否已点赞动态
export function checkLikeStatus(postId) {
  return request({
    url: `/posts/${postId}/like/status`,
    method: 'get'
  });
}
