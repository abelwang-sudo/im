import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import router from '@/router';
import { login as apiLogin, register as apiRegister, updateUserProfile } from '@/api/user';
import storage from '@/utils/storage';
import { useContactsStore } from './contacts';
import { useConversationStore } from './conversation';

export const useUserStore = defineStore('user', () => {
  const token = ref(storage.get('token'));
  const id = ref(storage.get('id'));
  const username = ref(storage.get('username'));
  const nickname = ref(storage.get('nickname'));
  const email = ref(storage.get('email'));
  const avatar = ref(storage.get('avatar'));

  const isAuthenticated = computed(() => !!token.value);

  async function login(credentials) {
    try {
      const response = await apiLogin(credentials);

      if (response.code === 200) {
        const userData = response.data;

        token.value = userData.token;
        id.value = userData.id;
        username.value = userData.username;
        nickname.value = userData.nickname || userData.username;
        email.value = userData.email;
        avatar.value = userData.avatar;

        // 保存到本地存储
        storage.set('token', token.value);
        storage.set('id', id.value);
        storage.set('username', username.value);
        storage.set('nickname', nickname.value);
        storage.set('email', email.value);
        storage.set('avatar', avatar.value,null);

        // 登录成功后加载联系人和会话数据
        const contactsStore = useContactsStore();
        const conversationStore = useConversationStore();
        await Promise.all([
          contactsStore.fetchContacts(),
          contactsStore.fetchPendingRequests(),
          conversationStore.loadConversations()
        ]);

        return true;
      }
      return false;
    } catch (error) {
      console.error('登录失败:', error);
      return false;
    }
  }

  function logout() {
    token.value = '';
    id.value = '';
    username.value = '';
    nickname.value = '';
    email.value = '';
    avatar.value = '';

    // 清除本地存储
    storage.removeMultiple(['token', 'id', 'username', 'nickname', 'email', 'avatar']);

    // 清除联系人和会话数据
    const contactsStore = useContactsStore();
    const conversationStore = useConversationStore();

    // 重置联系人数据
    contactsStore.contacts = [];
    contactsStore.pendingRequests = [];

    // 重置会话数据
    conversationStore.conversations = [];
    // 不再需要清除axios默认头部，因为使用了统一请求组件

    // 重定向到登录页
    router.push('/login');
  }

  async function register(userData) {
    try {
      const response = await apiRegister(userData);
      return response.code === 200;
    } catch (error) {
      console.error('注册失败:', error);
      return false;
    }
  }

  // 添加更新用户信息的方法
  async function updateUserInfo(userInfo) {
    try {
      const response = await updateUserProfile(userInfo);

      if (response.code === 200) {
        const userData = response.data;

        // 更新 store 中的状态
        if (userData.nickname) {
          nickname.value = userData.nickname;
          storage.set('nickname', nickname.value);
        }

        if (userData.avatar) {
          avatar.value = userData.avatar;
          storage.set('avatar', avatar.value);
        }

        return true;
      }
      return false;
    } catch (error) {
      console.error('更新用户信息失败:', error);
      return false;
    }
  }

  return {
    token,
    id,
    username,
    nickname,
    avatar,
    email,
    isAuthenticated,
    login,
    logout,
    register,
    updateUserInfo  // 导出新方法
  };
});
