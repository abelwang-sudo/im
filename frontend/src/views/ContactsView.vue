<template>
  <div class="contacts-container p-4">
    <div class="header flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">Contacts</h1>
      <div class="flex space-x-2">
        <button @click="showRequestsModal = true"
          class="friend-requests-btn bg-green-500 text-white p-2 rounded-md flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path
              d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
          </svg>
          <span v-if="contactsStore.pendingRequests?.length > 0"
            class="ml-1 bg-red-500 text-white text-xs rounded-full px-1.5 py-0.5">
            {{ contactsStore.pendingRequests.length }}
          </span>
        </button>
        <button @click="showAddContactModal = true" class="add-contact-btn bg-blue-500 text-white p-2 rounded-md">
          <span class="text-2xl">+</span>
        </button>
      </div>
    </div>

    <div class="search-container mb-4 relative">
      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <span class="text-gray-400">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd"
              d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
              clip-rule="evenodd" />
          </svg>
        </span>
      </div>
      <input type="text" v-model="searchQuery" placeholder="Search"
        class="w-full pl-10 pr-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
    </div>

    <div class="contacts-list">
      <!-- 群聊入口 -->
      <div class="contact-item flex items-center p-3 border-b border-gray-100 hover:bg-gray-50 cursor-pointer"
        @click="showGroupsModal = true">
        <div class="avatar-container relative mr-3">
          <div class="w-12 h-12 rounded-full bg-purple-500 flex items-center justify-center text-white">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
              <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v1h8v-1zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-1a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v1h-3zM4.75 12.094A5.973 5.973 0 004 15v1H1v-1a3 3 0 013.75-2.906z" />
            </svg>
          </div>
        </div>
        <div class="contact-info flex-1">
          <h3 class="font-medium">我的群聊</h3>
          <p class="text-sm text-gray-500">
            查看所有加入的群组
          </p>
        </div>
        <div class="text-gray-400">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
        </div>
      </div>

      <!-- 联系人列表 -->
      <div v-for="contact in filteredContacts" :key="contact.id"
        class="contact-item flex items-center p-3 border-b border-gray-100 hover:bg-gray-50 cursor-pointer"
        @click="selectContact(contact)">
        <div class="avatar-container relative mr-3">
          <img :src="contact.avatar || '/src/assets/default-avatar.png'" :alt="contact.username"
            class="w-12 h-12 rounded-full object-cover">
          <span v-if="contact.online"
            class="status-indicator bg-green-500 absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-white"></span>
        </div>
        <div class="contact-info flex-1">
          <h3 class="font-medium">{{ contact.username }}</h3>
          <p class="text-sm text-gray-500">
            {{ contact.status??"OFFLINE" }}
          </p>
        </div>
        <button @click.stop="confirmDeleteContact(contact)" class="text-gray-500 hover:text-red-500 p-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd"
              d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z"
              clip-rule="evenodd" />
          </svg>
        </button>
      </div>

      <div v-if="contactsStore.contacts.length === 0" class="text-center py-8 text-gray-500">
        No contacts found
      </div>
    </div>

    <!-- Add Contact Modal -->
    <div v-if="showAddContactModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-xl font-bold mb-4">Add New Contact</h2>
        <div class="mb-4">
          <label class="block text-gray-700 mb-2">Username or ID</label>
          <input v-model="newContactId" type="text"
            class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Enter username or ID">
        </div>
        <div class="flex justify-end space-x-2">
          <button @click="showAddContactModal = false" class="px-4 py-2 border rounded-md hover:bg-gray-100">
            Cancel
          </button>
          <button @click="sendFriendRequest" class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600"
            :disabled="!newContactId || isLoading">
            {{ isLoading ? 'Sending...' : 'Send Request' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Friend Requests Modal -->
    <div v-if="showRequestsModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold">Friend Requests</h2>
          <button @click="showRequestsModal = false" class="text-gray-500 hover:text-gray-700">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div v-if=" (!contactsStore.pendingRequests || contactsStore.pendingRequests.length === 0)"
          class="text-center py-4 text-gray-500">
          No pending friend requests
        </div>

        <div v-else class="max-h-96 overflow-y-auto">
          <div v-for="request in contactsStore.pendingRequests" :key="request.id" class="p-3 border-b last:border-b-0">
            <div class="flex items-center mb-2">
              <img :src="request.requester.avatar || '/src/assets/default-avatar.png'" :alt="request.requester.username"
                class="w-10 h-10 rounded-full mr-3 object-cover">
              <div>
                <p class="font-medium">{{ request.requester.username }}</p>
                <p class="text-xs text-gray-500">Sent {{ formatDate(request.createdAt) }}</p>
              </div>
            </div>
            <div class="flex space-x-2 justify-end">
              <button @click="rejectRequest(request.id)" class="px-3 py-1 border rounded-md hover:bg-gray-100 text-sm">
                Reject
              </button>
              <button @click="acceptRequest(request.id)"
                class="px-3 py-1 bg-blue-500 text-white rounded-md hover:bg-blue-600 text-sm">
                Accept
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Contact Confirmation Modal -->
    <div v-if="showDeleteConfirmModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-xl font-bold mb-4">删除联系人</h2>
        <p class="mb-4">确定要删除联系人 <span class="font-medium">{{ contactToDelete?.username }}</span> 吗？此操作不可撤销。</p>
        <div class="flex justify-end space-x-2">
          <button @click="showDeleteConfirmModal = false" class="px-4 py-2 border rounded-md hover:bg-gray-100">
            取消
          </button>
          <button @click="deleteContact" class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600"
            :disabled="isDeleting">
            {{ isDeleting ? '删除中...' : '删除' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 群聊列表模态框 -->
    <Dialog v-model:visible="showGroupsModal" header="我的群聊" :style="{ width: '450px' }" :modal="true">
      <div v-if="groupConversations.length === 0" class="text-center py-4 text-gray-500">
        您还没有加入任何群聊
      </div>

      <div v-else class="max-h-96 overflow-y-auto">
        <div v-for="group in groupConversations" :key="group.id"
          class="p-3 border-b last:border-b-0 hover:bg-gray-50 cursor-pointer"
          @click="selectGroup(group)">
          <div class="flex items-center">
            <div class="w-10 h-10 rounded-full bg-purple-500 flex items-center justify-center text-white mr-3">
              <span v-if="group.name" class="text-lg font-bold">{{ group.name.charAt(0) }}</span>
              <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v1h8v-1zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-1a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v1h-3zM4.75 12.094A5.973 5.973 0 004 15v1H1v-1a3 3 0 013.75-2.906z" />
              </svg>
            </div>
            <div>
              <p class="font-medium">{{ group.name || '群聊' + group.id }}</p>
<!--              <p class="text-xs text-gray-500">{{ group.member?.count || 0 }} 位成员</p>-->
            </div>
          </div>
        </div>
      </div>
    </Dialog>
  </div>


</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useContactsStore } from '@/stores/contacts';
import { useToast } from 'primevue/usetoast';

const router = useRouter();
const contactsStore = useContactsStore();
const searchQuery = ref('');
const showAddContactModal = ref(false);
const showRequestsModal = ref(false);
const showDeleteConfirmModal = ref(false);
const contactToDelete = ref(null);
const newContactId = ref('');
const isLoading = ref(false);
const isDeleting = ref(false);
const toast = useToast();
// 使用store中的联系人列表
import { computed } from 'vue';
import {useConversationStore} from "@/stores/conversation.js";
const filteredContacts = computed(() => contactsStore.filteredContacts(searchQuery.value));

// 格式化最后在线时间
const formatLastSeen = (timestamp) => {
  if (!timestamp) return 'a long time ago';

  const date = new Date(timestamp);
  const now = new Date();
  const diffInHours = Math.floor((now - date) / (1000 * 60 * 60));

  if (diffInHours < 1) {
    return 'just now';
  } else if (diffInHours < 24) {
    return `${diffInHours} ${diffInHours === 1 ? 'hour' : 'hours'} ago`;
  } else {
    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays < 7) {
      return `${diffInDays} ${diffInDays === 1 ? 'day' : 'days'} ago`;
    } else {
      return date.toLocaleDateString();
    }
  }
};

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString();
};

const conversationStore = useConversationStore()
// 群聊相关状态和函数
const showGroupsModal = ref(false);
const groupConversations = computed(() => {
  return conversationStore.conversations.filter(conv => conv.type === 'GROUP');
});

// 选择群聊，跳转到聊天页面
const selectGroup = (group) => {
  showGroupsModal.value = false;
  router.push({ path: '/chat/' + group.id });
};

// 选择联系人，创建单聊会话并跳转到聊天页面
const selectContact = async (contact) => {
  // 创建单聊会话
  const conversation = await conversationStore.createNewConversation('PRIVATE', [contact.id]);
  // 跳转到聊天页面
  router.push({path: '/chat/'+conversation.id});
};

// 发送好友请求
const sendFriendRequest = async () => {
  if (!newContactId.value) return;
  isLoading.value = true;
  const success = await contactsStore.sendRequest(newContactId.value);
  if (success) {
    showAddContactModal.value = false;
    newContactId.value = '';
    toast.add({ severity: 'success', summary: '成功', detail: '好友请求已发送', life: 3000 });
  }
  isLoading.value = false;
};

// 接受好友请求
const acceptRequest = async (requestId) => {
  const success = await contactsStore.acceptRequest(requestId);
  if (!success) {
    toast.add({ severity: 'error', summary: '错误', detail: '接受好友请求失败', life: 3000 });
  }
};

// 拒绝好友请求
const rejectRequest = async (requestId) => {
  const success = await contactsStore.rejectRequest(requestId);
  if (!success) {
    toast.add({ severity: 'error', summary: '错误', detail: '拒绝好友请求失败', life: 3000 });
  }
};



// 确认删除联系人
const confirmDeleteContact = (contact) => {
  contactToDelete.value = contact;
  showDeleteConfirmModal.value = true;
};

// 删除联系人
const deleteContact = async () => {
  if (!contactToDelete.value) return;

  try {
    isDeleting.value = true;
    const success = await contactsStore.deleteContact(contactToDelete.value.id);
    if (success) {
      showDeleteConfirmModal.value = false;
      contactToDelete.value = null;
    } else {
      toast.add({ severity: 'error', summary: '错误', detail: '删除联系人失败', life: 3000 });
    }
  } finally {
    isDeleting.value = false;
  }
};

// 在组件挂载时加载会话列表
onMounted(async () => {
  try {
    await conversationStore.loadConversations();
  } catch (error) {
    toast.add({ severity: 'error', summary: '错误', detail: '加载会话列表失败', life: 3000 });
  }
});

</script>

<style scoped>
</style>
