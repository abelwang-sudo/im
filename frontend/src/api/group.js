import request from '@/utils/request';

// 创建新群组
export function createGroup(data) {
  return request({
    url: '/groups',
    method: 'post',
    data
  });
}

// 获取群组详情
export function getGroupDetail(groupId) {
  return request({
    url: `/groups/${groupId}`,
    method: 'get'
  });
}

// 更新群组信息
export function updateGroup(groupId, data) {
  return request({
    url: `/groups/${groupId}`,
    method: 'put',
    data
  });
}

// 获取群组成员列表
export function getGroupMembers(groupId) {
  return request({
    url: `/groups/${groupId}/members`,
    method: 'get'
  });
}

// 解散群聊
export function deleteGroup(groupId) {
  return request({
    url: `/groups/${groupId}`,
    method: 'delete'
  });
}
