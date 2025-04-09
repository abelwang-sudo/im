import request from '@/utils/request';

// 发送好友请求
export function sendFriendRequest(addresseeId) {
  return request({
    url: `/friendships/request/${addresseeId}`,
    method: 'post'
  });
}

// 接受好友请求
export function acceptFriendRequest(friendshipId) {
  return request({
    url: `/friendships/accept/${friendshipId}`,
    method: 'put'
  });
}

// 拒绝好友请求
export function rejectFriendRequest(friendshipId) {
  return request({
    url: `/friendships/reject/${friendshipId}`,
    method: 'put'
  });
}

// 获取用户的所有好友
export function getUserFriends() {
  return request({
    url: '/friendships/friends',
    method: 'get'
  });
}

// 获取用户收到的所有待处理好友请求
export function getPendingFriendRequests() {
  return request({
    url: '/friendships/pending',
    method: 'get'
  });
}

// 检查与指定用户是否是好友
export function checkFriendship(userId) {
  return request({
    url: `/friendships/check/${userId}`,
    method: 'get'
  });
}

// 删除好友关系
export function deleteFriendship(friendId) {
  return request({
    url: `/friendships/${friendId}`,
    method: 'delete'
  });
}