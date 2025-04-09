import {defineStore} from 'pinia';
import {ref, computed} from 'vue';
import {
  getUserFriends,
  getPendingFriendRequests,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  deleteFriendship
} from '@/api/friendship';

export const useContactsStore = defineStore('contacts', () => {
  const contacts = ref([]);
  const pendingRequests = ref([]);

  // 过滤联系人列表
  const filteredContacts = computed(() => {
    return (query) => {
      if (!query) return contacts.value;
      const searchQuery = query.toLowerCase();
      return contacts.value.filter(contact =>
        contact.username.toLowerCase().includes(searchQuery)
      );
    };
  });

  // 获取联系人列表
  async function fetchContacts() {
    try {
      const response = await getUserFriends();
      contacts.value = response.data || [];
    } catch (error) {
      console.error('获取联系人列表失败:', error);
    }
  }

  // 获取待处理的好友请求
  async function fetchPendingRequests() {
    try {
      const response = await getPendingFriendRequests();
      pendingRequests.value = response.data || [];
    } catch (error) {
      console.error('获取待处理好友请求失败:', error);
    }
  }

  // 发送好友请求
  async function sendRequest(userId) {
    try {
      const res = await sendFriendRequest(userId);
      return res.code === 200;
    } catch (error) {
      console.error('发送好友请求失败:', error);
      return false;
    }
  }

  // 接受好友请求
  async function acceptRequest(requestId) {
    try {
      await acceptFriendRequest(requestId);
      await Promise.all([fetchContacts(), fetchPendingRequests()]);
      return true;
    } catch (error) {
      console.error('接受好友请求失败:', error);
      return false;
    }
  }

  // 拒绝好友请求
  async function rejectRequest(requestId) {
    try {
      await rejectFriendRequest(requestId);
      await fetchPendingRequests();
      return true;
    } catch (error) {
      console.error('拒绝好友请求失败:', error);
      return false;
    }
  }

  // 删除联系人
  async function deleteContact(contactId) {
    try {
      await deleteFriendship(contactId);
      contacts.value = contacts.value.filter(c => c.id !== contactId);
      return true;
    } catch (error) {
      console.error('删除联系人失败:', error);
      return false;
    }
  }

  // 处理联系人更新消息
  function handleContactUpdate({action}) {
    switch (action) {
      case 'request':
        // 新的好友请求
        fetchPendingRequests();
        break;
      case 'accept':
        // 好友请求被接受
        fetchContacts();
        fetchPendingRequests();
        break;
      case 'reject':
        // 好友请求被拒绝
        fetchPendingRequests();
        break;
      case 'delete':
        // 好友关系被删除
        fetchContacts();
        break;
    }
  }

  /**
   * 处理用户状态变更
   * @param {object} message - 包含 userId 和 status 的消息
   */
  function handleUserStatusUpdate(message) {
    const {sender, content} = message;
    const contact = this.contacts.find(c => c.id == sender);
    if (contact) {
      contact.status = content.status;
      // 触发UI更新
      this.contacts = [...this.contacts];
    }
  }

  return {
    contacts,
    pendingRequests,
    filteredContacts,
    fetchContacts,
    fetchPendingRequests,
    sendRequest,
    acceptRequest,
    rejectRequest,
    deleteContact,
    handleContactUpdate,
    handleUserStatusUpdate
  };
});
