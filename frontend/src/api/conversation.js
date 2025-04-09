import request from '@/utils/request';

// 获取用户的会话列表
export function getConversations() {
  return request({
    url: '/conversations',
    method: 'get'
  });
}

// 创建新会话
export function createConversation(data) {
  return request({
    url: '/conversations',
    method: 'post',
    data: data,
  });
}

// 邀请成员加入会话
export function inviteMembers(conversationId, memberIds) {
  return request({
    url: `/conversations/${conversationId}/members`,
    method: 'post',
    data: memberIds
  });
}

// 获取会话成员列表
export function getConversationMembers(conversationId) {
  return request({
    url: `/conversations/${conversationId}/members`,
    method: 'get'
  });
}

// 获取会话消息列表
export function getConversationMessages(conversationId, page = 0, size = 20) {
  return request({
    url: `/conversations/${conversationId}/messages`,
    method: 'get',
    params: { page, size }
  });
}

// 标记会话为已读
export function markConversationAsRead(conversationId) {
  return request({
    url: `/conversations/${conversationId}/read`,
    method: 'post'
  });
}

// 删除会话
export function deleteConversation(conversationId) {
  return request({
    url: `/conversations/${conversationId}`,
    method: 'delete'
  });
}

// 删除会话成员
export function removeConversationMember(conversationId, memberId) {
  return request({
    url: `/conversations/${conversationId}/members/${memberId}`,
    method: 'delete'
  });
}

// 退出群聊
export function quitConversation(conversationId) {
  return request({
    url: `/conversations/${conversationId}/quit`,
    method: 'post'
  });
}

// 更新群成员角色
export function updateMemberRole(conversationId, memberId, isAdmin) {
  return request({
    url: `/conversations/${conversationId}/members/${memberId}/role?isAdmin=${isAdmin}`,
    method: 'put',
  });
}

// 更新会话信息
export function updateConversationInfo(conversationId, data) {
  return request({
    url: `/conversations/${conversationId}`,
    method: 'put',
    data: data
  });
}

// 获取入群申请列表
export function getJoinRequests(conversationId) {
  return request({
    url: `/conversations/${conversationId}/join-requests`,
    method: 'get'
  });
}

// 处理入群申请
export function handleJoinRequest(conversationId, applicationId, approved) {
  return request({
    url: `/conversations/${conversationId}/join-requests/${applicationId}?approved=${approved}`,
    method: 'post'
  });
}
