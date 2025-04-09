import { defineStore } from 'pinia';
import { ref } from 'vue';
import {
  getConversations,
  createConversation,
  inviteMembers,
  getConversationMembers,
  markConversationAsRead,
  deleteConversation, quitConversation,
  removeConversationMember,
  updateMemberRole
} from '@/api/conversation';
import {deleteGroup} from "@/api/group.js";

export const useConversationStore = defineStore('conversation', () => {
  const conversations = ref([]);
  const conversationMembers = ref([]);

  // 获取用户的会话列表
  const loadConversations = async () => {
    try {
      const response = await getConversations();
      conversations.value = response.data;
    } catch (error) {
      console.error('加载会话列表失败:', error);
      throw error;
    }
  };

  // 创建新会话
  const createNewConversation = async (type, memberIds) => {
    try {
      const response = await createConversation({memberIds, type});
      const newConversation = response.data;
      conversations.value.unshift(newConversation);
      return newConversation;
    } catch (error) {
      console.error('创建会话失败:', error);
      throw error;
    }
  };

  // 邀请成员加入会话
  const inviteNewMembers = async (conversationId, memberIds) => {
    try {
      await inviteMembers(conversationId, memberIds);
      // 更新会话列表
      await loadConversations();
    } catch (error) {
      console.error('邀请成员失败:', error);
      throw error;
    }
  };

  // 获取会话成员列表
  const fetchConversationMembers = async (conversationId) => {
    try {
      const response = await getConversationMembers(conversationId);
      if (response.code === 200) {
        conversationMembers.value = response.data || [];
      }
      return conversationMembers.value;
    } catch (error) {
      console.error('获取会话成员失败:', error);
      throw error;
    }
  };

  // 移除会话成员
  const removeMember = async (conversationId, memberId) => {
    try {
      const response = await removeConversationMember(conversationId, memberId);
      if (response.code === 200) {
        // 从本地列表中移除成员
        conversationMembers.value = conversationMembers.value.filter(member => member.userId != memberId);
        return true;
      }
      return false;
    } catch (error) {
      console.error('移除会话成员失败:', error);
      return false;
    }
  };

  // 更新成员角色
  const updateRole = async (conversationId, memberId, isAdmin) => {
    try {
      const response = await updateMemberRole(conversationId, memberId, isAdmin);
      if (response.code === 200) {
        // 更新本地成员角色
        const memberIndex = conversationMembers.value.findIndex(member => member.id === memberId);
        if (memberIndex !== -1) {
          conversationMembers.value[memberIndex].role = isAdmin ? 'ADMIN' : 'MEMBER';
        }
        return true;
      }
      return false;
    } catch (error) {
      console.error('更新成员角色失败:', error);
      return false;
    }
  };

  // 处理会话更新消息
  const handleConversationUpdate = async ({ content, conversationId }) => {
    switch (content.action) {
      case 'create':
        conversations.value.unshift(content.conversation)
        break;
      case 'update':
        // 更新会话信息
        const index = conversations.value.findIndex(c => c.id == conversationId);
        if (index !== -1) {
          conversations.value[index] = content.conversation;
        }
        break;
      case 'invite':
        // 重新加载会话列表
        await loadConversations();
        break;
      case 'delete':
        // 从列表中移除会话
        conversations.value = conversations.value.filter(c => c.id != conversationId);
        if (activeConversationId.value == conversationId) {
          activeConversationId.value = null;
        }
        break;
    }
  };

  // 标记会话为已读
  const markAsRead = async (conversationId) => {
    try {
      // 更新本地会话状态
      const index = conversations.value.findIndex(c => c.id == conversationId);
      if (index !== -1) {
        conversations.value[index].member.unreadCount = 0;
        await markConversationAsRead(conversationId);
      }
    } catch (error) {
      console.error('标记会话已读失败:', error);
      throw error;
    }
  };

  // 根据ID获取会话
  const getConversationById = (conversationId) => {
    if (!conversationId) return null;
    return conversations.value.find(c => c.id == conversationId) || null;
  };

  // 删除会话
  const deleteConversationById = async (conversationId) => {
    try {
      await deleteConversation(conversationId);
      // 从本地列表中移除会话
      conversations.value = conversations.value.filter(c => c.id != conversationId);
      // 如果删除的是当前活跃会话，重置活跃会话ID
      if (activeConversationId.value == conversationId) {
        activeConversationId.value = null;
      }
      return true;
    } catch (error) {
      console.error('删除会话失败:', error);
      return false;
    }

  };

  const quit = async (conversationId) => {
    const response = await quitConversation(conversationId);
    conversations.value = conversations.value.filter(c =>c.id != conversationId);
    return  response.code == 200;
  }

  const disbandGroup = async (conversationId) => {
    const conversation = getConversationById(conversationId)
    const response = await deleteGroup(conversation.group.id);

    conversations.value = conversations.value.filter(c =>c.id != conversationId);
    return  response.code == 200;
  }
  const updateConversationLastMessage = (conversationId,message) => {
    const index = conversations.value.findIndex(c => c.id == conversationId);
    if (index !== -1) {
      conversations.value[index].lastMessage = message;
    }
  }

  return {
    conversations,
    conversationMembers,
    loadConversations,
    createNewConversation,
    inviteNewMembers,
    fetchConversationMembers,
    removeMember,
    updateRole,
    handleConversationUpdate,
    quit,
    disbandGroup,
    markAsRead,
    getConversationById,
    deleteConversationById,
    updateConversationLastMessage
  };
});
