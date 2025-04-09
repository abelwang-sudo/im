<template>
  <div class="flex flex-col h-screen">
    <!-- 主内容区域 -->
    <div class="flex-1 overflow-y-auto">
      <component :is="currentComponent" />
    </div>
    <!-- 底部导航栏 -->
    <div class="bottom-tab-bar bg-white border-t border-gray-200 flex justify-around items-center py-2">
      <div v-for="tab in tabs" :key="tab.name" @click="activeTab = tab.name"
        class="tab-item flex flex-col items-center py-1 px-3 cursor-pointer relative"
        :class="{ 'text-blue-500': activeTab === tab.name, 'text-gray-500': activeTab !== tab.name }">
        <div class="tab-icon mb-1" v-html="tab.icon"></div>
        <span class="tab-label text-xs">{{ tab.label }}</span>
        <span  class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full px-1.5 py-0.5 min-w-[18px] text-center"  v-if='tab.badge >0' >
          {{ tab.badge }}
        </span>
      </div>

    </div>
    <!-- WebSocket重连对话框 -->
    <Dialog :visible="showReconnectDialog" header="连接断开" :closable="false" :modal="true">
      <div class="p-4">
        <p class="mb-4">与服务器的连接已断开，多次重连尝试失败。</p>
        <div class="flex justify-center">
          <Button label="重新连接" @click="reconnectWebSocket" class="p-button-primary" />
        </div>
      </div>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { useContactsStore } from '@/stores/contacts';
import { useUserStore } from '@/stores/user';
import ContactsView from '@/views/ContactsView.vue';
import ProfileView from '@/views/ProfileView.vue';
import { useRouter } from 'vue-router';
import ConversationView from "@/views/ConversationView.vue";
import websocketService from "@/services/websocket.service.js";
import Dialog from "primevue/dialog";
import Button from "primevue/button";
import {useConversationStore} from "@/stores/conversation.js";
const router = useRouter();
const activeTab = ref('chat');
const contactsStore = useContactsStore();
const conversationStore = useConversationStore();
const userStore = useUserStore();
// 重连对话框状态
const showReconnectDialog = ref(false);

// 初始化函数
const initializeApp = async () => {
  // 初始化好友请求
  await contactsStore.fetchPendingRequests();
  await contactsStore.fetchContacts();

  // 初始化WebSocket服务并设置用户相关的监听器
  websocketService.initializeForUser(
    'ws://localhost:8080/ws',
    { contactsStore, conversationStore },
    () => { showReconnectDialog.value = true }
  );
};

// 监听用户认证状态
watch(() => userStore.isAuthenticated, (newValue) => {
  console.log('isAuthenticated changed:', newValue);
  if (!newValue) {
    router.push('/login');
    showReconnectDialog.value = false;
  } else {
    initializeApp();
  }
}, { immediate: true, deep: true });


// 定义标签页
// 使用计算属性来动态获取badge值
const contactsBadge = computed(() => contactsStore.pendingRequests.length);

const tabs = [
  {
    name: 'chat',
    label: '聊天',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" /></svg>'
  },
  {
    name: 'contacts',
    label: '联系人',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" /></svg>',
    get badge() { return contactsBadge.value; }
  },
  {
    name: 'discover',
    label: '发现',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" /></svg>'
  },
  {
    name: 'profile',
    label: '我的',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>'
  }
];

// 根据当前激活的标签返回对应的组件
const currentComponent = computed(() => {
  switch (activeTab.value) {
    case 'contacts':
      return ContactsView;
    case 'chat':
      return ConversationView;
    case 'discover':
      // 暂时使用占位组件
      return {
        template: '<div class="p-4"><h1 class="text-2xl font-bold">发现</h1><p class="mt-4 text-gray-600">发现功能正在开发中...</p></div>'
      };
    case 'profile':
      return ProfileView;
    default:
      return ContactsView;
  }
});


// 手动重连WebSocket
const reconnectWebSocket = () => {
  const wsInstance = websocketService.getInstance();
  if (wsInstance) {
    wsInstance.manualReconnect();
    showReconnectDialog.value = false;
  }
};

</script>

<style scoped>
.bottom-tab-bar {
  height: 60px;
}

.tab-item {
  transition: all 0.2s ease;
}

.tab-item:active {
  transform: scale(0.95);
}
</style>
