<template>
  <div class="h-full flex flex-col bg-white">
    <div class="p-4 border-b border-gray-200 flex items-center justify-between">
      <Button v-if="isMobile()" icon="pi pi-arrow-left" variant="text" rounded aria-label="Filter"
              severity="secondary" @click="goBack"/>
      <div v-else class="w-8"></div>
      <div class="flex items-center gap-2">
        <div>{{ conversation?.member.displayName }}</div>
      </div>
      <div class="flex items-center gap-3">
        <Button icon="pi pi-info-circle" variant="text" rounded aria-label="会话详情"
                severity="secondary" @click="showConversationDetails = true"/>
        <!-- <button class="p-2 text-gray-500 hover:bg-gray-100 rounded-full">
          <i class="pi pi-phone"></i>
        </button>
        <button class="p-2 text-gray-500 hover:bg-gray-100 rounded-full">
          <i class="pi pi-video"></i>
        </button> -->
      </div>
    </div>

    <div class="flex-1 overflow-y-auto overflow-x-hidden p-4 bg-gray-50" ref="messagesContainer"
         @scroll="handleScroll">
      <div v-if="loading" class="flex justify-center items-center py-4">
        <div
          class="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
      <template v-else>
        <!-- 加载更多指示器 -->
        <div v-if="isLoadingMore" class="flex justify-center items-center py-2">
          <div
            class="w-6 h-6 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
        <div v-if="messages.length === 0"
             class="flex justify-center items-center h-full text-gray-500">
          <p>没有消息记录</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="(message) in reversedMessages" :key="message.id" class="flex flex-col mb-4"
               :class="message.sender == currentUser ? 'items-end' : 'items-start'">
            <div class="flex w-full items-end gap-2"
                 :class="message.sender == currentUser ? 'flex-row-reverse' : ''">
              <div class="flex-shrink-0">
                <img :src="message.senderAvatar || '/src/assets/default-avatar.png'"
                     :alt="message.sender"
                     class="w-8 h-8 rounded-full object-cover"/>
              </div>
              <div class="max-w-[70%]">
                <!-- 普通文本消息 -->
                <div class="px-4 py-2 rounded-2xl whitespace-normal break-words"
                     :class="message.sender == currentUser ?
                     'bg-blue-500 text-white rounded-tr-none' :
                     'bg-white border border-gray-200 rounded-tl-none'">
                  {{ message.content.text }}
                </div>
              </div>
            </div>

            <div class="flex items-center mt-1"
                 :class="message.sender == currentUser ? 'flex-row-reverse' : ''">
              <span class="text-xs text-gray-500">{{ formatTime(message.timestamp) }}</span>
              <span v-if="message.sender == currentUser" class="text-xs text-gray-500">
                <i :class="['pi', message.read ? 'pi-check-circle' : 'pi-check']"></i>
                <span class="ml-1">{{ message.read ? '已读' : '已发送' }}</span>
              </span>
            </div>
          </div>
        </div>
      </template>
    </div>

    <div class="p-3 border-t border-gray-200 flex items-center gap-2 bg-white">
      <button class="p-2 text-gray-500 hover:bg-gray-100 rounded-full">
        <i class="pi pi-plus"></i>
      </button>
      <textarea v-model="newMessage" placeholder="输入消息..."
                class="flex-1 px-4 py-2 bg-gray-100 rounded-lg resize-none focus:outline-none focus:ring-2 focus:ring-blue-500 max-h-20"
                rows="1" @keydown.enter.prevent="sendMessage"></textarea>
      <button
        class="p-2 text-white bg-blue-500 hover:bg-blue-600 rounded-full disabled:opacity-50 disabled:cursor-not-allowed"
        :disabled="!newMessage.trim()" @click="sendMessage">
        <i class="pi pi-send"></i>
      </button>
    </div>

    <!-- 会话详情模态框 -->
    <Dialog
      v-model:visible="showConversationDetails"
      :modal="true"
      :closable="true"
      header="会话详情"
      class="w-4/5 md:w-3/4 lg:w-1/2"
      @show="onShowDetails"
    >
      <div v-if="loadingDetails" class="flex justify-center items-center py-4">
        <div
          class="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
      <div v-else class="flex flex-col gap-4">
        <!-- 会话基本信息 -->
        <div class="flex items-center gap-4 mb-4">
          <img
            :src="conversation?.avatar || '/src/assets/default-avatar.png'"
            alt="会话头像"
            class="w-20 h-20 rounded-full object-cover border-2 border-gray-200"
          />
          <div>
            <h3 class="text-xl font-bold">{{ conversation?.member.displayName }}</h3>
            <p v-if="conversation?.type === 'GROUP' && conversation.group" class="text-gray-500">
              {{ conversation.group.description || '暂无群组描述' }}
            </p>
            <p class="text-sm text-gray-500">
              {{ conversation?.type === 'GROUP' ? '群聊' : '单聊' }} ·
              {{ conversationStore.conversationMembers.length }} 位成员
            </p>
          </div>
        </div>

        <!-- 群聊设置 - 只在群聊中显示且当前用户是群主或管理员 -->
        <div v-if="conversation?.type === 'GROUP' && isAdminOrOwner"
             class="mb-4 border border-gray-200 rounded-lg p-4">
          <h4 class="font-bold mb-3">群聊设置</h4>
          <div class="flex flex-col gap-3">
            <div class="flex items-center justify-between">
              <span>加入审批</span>
              <ToggleSwitch v-model="conversation.requireApproval" @change="updateGroupSettings"/>
            </div>
            <div class="flex items-center justify-between">
              <span>仅管理员邀请</span>
              <ToggleSwitch v-model="conversation.onlyAdminCanInvite"
                            @change="updateGroupSettings"/>
            </div>
            <div class="flex items-center justify-between">
              <span>仅管理员发言</span>
              <ToggleSwitch v-model="conversation.onlyAdminCanSpeak" @change="updateGroupSettings"/>
            </div>
          </div>
        </div>

        <!-- 退出/解散群聊按钮 -->
        <div v-if="conversation?.type === 'GROUP'" class="mb-4">
          <Button
            v-if="isGroupOwner"
            icon="pi pi-trash"
            label="解散群聊"
            severity="danger"
            class="w-full"
            @click="confirmDisbandGroup"
          />
          <Button
            v-else
            icon="pi pi-sign-out"
            label="退出群聊"
            severity="secondary"
            class="w-full"
            @click="confirmQuitGroup"
          />
        </div>

        <!-- 成员列表 -->
        <div>
          <div class="flex justify-between items-center mb-2">
            <h4 class="font-bold">成员列表</h4>
            <div class="flex gap-2">
              <Button
                v-if="canInviteMembers"
                icon="pi pi-user-plus"
                size="small"
                severity="secondary"
                @click="showInviteMembersModal = true"
              />


              <OverlayBadge :value="pendingJoinRequestsCount" v-if="pendingJoinRequestsCount>0">
                <Button
                  v-if="isAdminOrOwner && conversation?.requireApproval"
                  icon="pi pi-users"
                  size="small"
                  severity="info"
                  @click="showJoinRequestsModal = true"
                  class="relative"
                >
                </Button>
              </OverlayBadge>
            </div>
          </div>
          <div class="border border-gray-200 rounded-lg p-2 max-h-[40vh] overflow-y-auto">
            <div v-if="conversationStore.conversationMembers.length > 0"
                 class="flex flex-col gap-2">
              <div
                v-for="member in conversationStore.conversationMembers"
                :key="member.id"
                class="flex items-center justify-between p-2 hover:bg-gray-50 rounded-lg"
              >
                <img
                  :src="member.avatar || '/src/assets/default-avatar.png'"
                  :alt="member.nickname || '未知用户'"
                  class="w-10 h-10 rounded-full mr-3"
                />
                <div class="flex-1">
                  <div class="font-medium">{{ member.nickname }}</div>
                  <div v-if="conversation?.type === 'GROUP'" class="text-xs text-gray-500">
                    {{ member.role }}
                  </div>
                </div>
                <div v-if="member.online" class="w-3 h-3 bg-green-500 rounded-full"></div>
                <!-- 设置管理员按钮 - 只在群聊中显示且当前用户是群主且目标是普通成员 -->
                <Button
                  v-if="conversation?.type === 'GROUP' && canSetAdmin(member)"
                  icon="pi pi-user-edit"
                  text
                  rounded
                  severity="info"
                  size="small"
                  aria-label="设置为管理员"
                  @click="confirmSetAdmin(member)"
                  class="mr-1"
                />
                <!-- 取消管理员按钮 - 只在群聊中显示且当前用户是群主且目标是管理员 -->
                <Button
                  v-if="conversation?.type === 'GROUP' && canDemoteAdmin(member)"
                  icon="pi pi-user-minus"
                  text
                  rounded
                  severity="warning"
                  size="small"
                  aria-label="取消管理员"
                  @click="confirmDemoteAdmin(member)"
                  class="mr-1"
                />
                <!-- 删除成员按钮 - 只在群聊中显示且满足权限条件 -->
                <Button
                  v-if="conversation?.type === 'GROUP' && canRemoveMember(member)"
                  icon="pi pi-trash"
                  text
                  rounded
                  severity="danger"
                  size="small"
                  aria-label="删除成员"
                  @click="confirmRemoveMember(member)"
                />
              </div>
            </div>
            <div v-else class="text-center py-4 text-gray-500">
              暂无成员信息
            </div>
          </div>
        </div>
      </div>
    </Dialog>

    <!-- 确认删除成员对话框 -->
    <ConfirmDialog>
      <template #message="{ message }">
        <div class="flex flex-column align-items-center p-4 gap-3">
          <i class="pi pi-exclamation-triangle text-6xl text-yellow-500"></i>
          <h3>{{ message.header }}</h3>
          <p>{{ message.message }}</p>
        </div>
      </template>
    </ConfirmDialog>

    <!-- 邀请成员模态框 -->
    <Dialog
      v-model:visible="showInviteMembersModal"
      :modal="true"
      :closable="true"
      header="邀请成员"
      class="w-4/5 md:w-3/4 lg:w-1/2"
      @show="onShowInviteModal"
    >
      <div v-if="loadingFriends" class="flex justify-center items-center py-4">
        <div
          class="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
      <div v-else class="flex flex-col gap-4">
        <!-- 搜索框 -->
        <div class="mb-2">
          <InputText
            v-model="searchFriendQuery"
            placeholder="搜索好友"
            class="w-full"
          />
        </div>

        <!-- 好友列表 -->
        <div class="border border-gray-200 rounded-lg p-2 max-h-[40vh] overflow-y-auto">
          <div v-if="filteredFriends.length > 0" class="flex flex-col gap-2">
            <div
              v-for="friend in filteredFriends"
              :key="friend.id"
              class="flex items-center p-2 hover:bg-gray-50 rounded-lg"
            >
              <Checkbox
                v-model="selectedFriends"
                :value="friend.id"
                :binary="false"
                class="mr-2"
              />
              <img
                :src="friend.avatar || '/src/assets/default-avatar.png'"
                :alt="friend.username"
                class="w-10 h-10 rounded-full mr-3"
              />
              <span>{{ friend.username }}</span>
            </div>
          </div>
          <div v-else class="text-center py-4 text-gray-500">
            {{ searchFriendQuery ? '没有找到匹配的好友' : '暂无好友' }}
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex justify-end gap-2">
          <Button
            label="取消"
            icon="pi pi-times"
            text
            @click="showInviteMembersModal = false"
          />
          <Button
            label="邀请"
            icon="pi pi-check"
            severity="success"
            :disabled="selectedFriends.length === 0"
            :loading="inviting"
            @click="inviteMembers"
          />
        </div>
      </template>
    </Dialog>

    <!-- 入群申请模态框 -->
    <JoinRequestsModal
      v-model:visible="showJoinRequestsModal"
      :conversation-id="props.conversationId"
      @requests-updated="updatePendingRequestsCount"
    />
  </div>
</template>

<script setup>
import {ref, computed, onActivated, onMounted, watch} from 'vue';
import {useUserStore} from '@/stores/user';
import {onBeforeRouteLeave, useRouter} from 'vue-router';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';
import Checkbox from 'primevue/checkbox';
import InputText from 'primevue/inputtext';
import OverlayBadge from 'primevue/overlaybadge';
import ConfirmDialog from 'primevue/confirmdialog';
import ToggleSwitch from 'primevue/toggleswitch';
import {useConfirm} from 'primevue/useconfirm';
import {
  getConversationMessages,
  inviteMembers as inviteConversationMembers,
  updateConversationInfo,
  getJoinRequests
} from '@/api/conversation';
import websocketService from '@/services/websocket.service';
import {useConversationStore} from "@/stores/conversation.js";
import {useContactsStore} from "@/stores/contacts.js";
import {toast} from '@/main.js';
import JoinRequestsModal from '@/components/common/JoinRequestsModal.vue';


const props = defineProps({
  conversationId: {
    type: [Number, String, null,],
    default: null
  }
});


const userStore = useUserStore();
const currentUser = computed(() => userStore.id);

const messages = ref([]);
const newMessage = ref('');
const loading = ref(false);
const messagesContainer = ref(null);
const router = useRouter();
const currentPage = ref(0);
const pageSize = ref(20);
const hasMoreMessages = ref(true);
const isLoadingMore = ref(false);
const scrollPosition = ref(0);
const showConversationDetails = ref(false);
// 会话成员现在从store中获取，不再使用本地ref变量
const loadingDetails = ref(false);
const showInviteMembersModal = ref(false);
const showJoinRequestsModal = ref(false);
const pendingJoinRequestsCount = ref(0);
const loadingFriends = ref(false);
const searchFriendQuery = ref('');
const selectedFriends = ref([]);
const inviting = ref(false);
const contactsStore = useContactsStore();
const confirm = useConfirm();
const removingMember = ref(false);
const updatingRole = ref(false);
const updatingSettings = ref(false);
const conversation = computed(() => {
  return conversationStore.getConversationById(props.conversationId)
});

const conversationStore = useConversationStore()

// 检测是否为移动端
const isMobile = () => {
  return window.innerWidth <= 768;
};

// 加载消息历史
const loadMessages = async () => {
  if (!props.conversationId) return;

  try {
    loading.value = true;
    currentPage.value = 0;
    hasMoreMessages.value = true;
    messages.value = [];

    const response = await getConversationMessages(props.conversationId, currentPage.value, pageSize.value);

    if (response.code === 200) {
      const messageData = response.data.content || [];
      messages.value = messageData;

      hasMoreMessages.value = !response.data.last;
    } else {
      console.error('加载消息失败:', response.message);
    }
  } catch (error) {
    console.error('加载消息失败:', error);
  } finally {
    loading.value = false;

    // 滚动到底部
    setTimeout(() => {
      if (messagesContainer.value) {
        messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
      }
    }, 100);
  }
};

// 加载更多消息
const loadMoreMessages = async () => {
  if (!props.conversationId || !hasMoreMessages.value || isLoadingMore.value) return;

  try {
    isLoadingMore.value = true;
    currentPage.value++;

    // 记录当前滚动位置和内容高度
    const scrollContainer = messagesContainer.value;
    const scrollHeight = scrollContainer.scrollHeight;

    const response = await getConversationMessages(props.conversationId, currentPage.value, pageSize.value);

    if (response.code === 200) {
      const messageData = response.data.content || [];

      // 将新消息添加到现有消息列表前面
      messages.value = [...messageData, ...messages.value];

      // 更新是否还有更多消息的标志
      hasMoreMessages.value = !response.data.last;

      // 等待DOM更新后维持滚动位置
      setTimeout(() => {
        if (scrollContainer) {
          // 计算新增内容的高度并调整滚动位置
          const newScrollHeight = scrollContainer.scrollHeight;
          const heightDifference = newScrollHeight - scrollHeight;
          scrollContainer.scrollTop = heightDifference;
        }
      }, 50);
    } else {
      console.error('加载更多消息失败:', response.message);
    }
  } catch (error) {
    console.error('加载更多消息失败:', error);
  } finally {
    isLoadingMore.value = false;
  }
};

// 处理滚动事件
const handleScroll = () => {
  if (!messagesContainer.value) return;

  const {scrollTop} = messagesContainer.value;

  // 当滚动到顶部时加载更多消息
  if (scrollTop < 50 && hasMoreMessages.value && !isLoadingMore.value) {
    loadMoreMessages();
  }

  // 保存当前滚动位置
  scrollPosition.value = scrollTop;
};

// 发送消息
const sendMessage = async () => {
  if (!newMessage.value.trim()) return;

  // 获取WebSocket实例
  const wsInstance = websocketService.getInstance();
  if (!wsInstance || !wsInstance.isConnected) {
    console.error('WebSocket未连接，无法发送消息');
    return;
  }

  // 创建新消息对象
  const message = {
    text: newMessage.value,
    type: 'TEXT',
  };

  // 清空输入框
  newMessage.value = '';

  // 通过WebSocket发送消息
  const messageCreate = wsInstance.send('CHAT', message, props.conversationId);
  conversationStore.updateConversationLastMessage(props.conversationId, messageCreate)

  if (!messageCreate) {
    console.error('消息发送失败');
    // 可以在这里添加消息发送失败的处理逻辑
  }
  messages.value.unshift(messageCreate);
  // 滚动到底部
  setTimeout(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
    }
  }, 100);
};

// 格式化时间
const formatTime = (timestamp) => {
  if (!timestamp) return '';

  const date = new Date(timestamp);
  return date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
};

// 格式化日期
// 注意: 这个函数保留供将来使用
/* eslint-disable-next-line no-unused-vars */
const formatDate = (timestamp) => {
  if (!timestamp) return '';

  const date = new Date(timestamp);
  return date.toLocaleDateString([], {year: 'numeric', month: '2-digit', day: '2-digit'});
};

// 添加WebSocket消息监听的函数
const setupWebSocketListener = () => {
  const wsInstance = websocketService.getInstance();

  if (wsInstance && wsInstance.isConnected) {
    // 监听聊天消息
    if (!wsInstance.messageListeners['CHAT']) {
      wsInstance.messageListeners['CHAT'] = [];
    }
    wsInstance.messageListeners['CHAT'].push((message) => {
      // 只处理当前会话的消息
      if (message.conversationId && message.conversationId == props.conversationId) {
        // 基于conversationId匹配的消息
        handleNewMessage(message);
      }
    });
    return true;
  }
  return false;
};

const addListener = () => {
  // 尝试添加WebSocket消息监听
  let retryCount = 0;
  const maxRetries = 10;
  const retryInterval = 500; // 500毫秒

  const trySetupListener = () => {
    if (setupWebSocketListener()) {
      return;
    }

    if (retryCount < maxRetries) {
      retryCount++;
      setTimeout(trySetupListener, retryInterval);
    } else {
      console.error('WebSocket连接超时，无法添加消息监听器');
    }
  };

  trySetupListener();
}

onMounted(() => {
  console.log('onMounted')
  addListener();
  if (!isMobile()) {
    watch(() => props.conversationId, () => {
      loadMessages();
      if (conversation.value && conversation.value.type === 'GROUP' && conversation.value.requireApproval) {
        fetchPendingRequestsCount();
      }
    }, {immediate: true});
  }
})



onActivated(() => {
  console.log('onActivated')
  // 加载消息
  loadMessages();
  // 如果是群聊且需要审批，获取待处理的入群申请数量
  if (conversation.value && conversation.value.type === 'GROUP' && conversation.value.requireApproval) {
    fetchPendingRequestsCount();
  }
  addListener();
})

onBeforeRouteLeave(async () => {
  // 清理WebSocket消息监听
  const wsInstance = websocketService.getInstance();
  if (wsInstance && wsInstance.messageListeners['CHAT']) {
    wsInstance.messageListeners['CHAT'] = wsInstance.messageListeners['CHAT'].filter(
      callback => callback.toString().indexOf('handleNewMessage') === -1
    );
  }
  await conversationStore.markAsRead(props.conversationId)
});

// 处理新消息
const handleNewMessage = (message) => {
  // 检查是否是自己发送的消息，如果是则跳过（因为在sendMessage方法中已经添加过了）
  if (message.sender === Number(userStore.id)) {
    return;
  }

  // 添加到消息列表
  messages.value.unshift(message);

  // 滚动到底部
  setTimeout(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
    }
  }, 100);
};


// 返回上一页
const goBack = () => {
  router.back();
};

// 在 script setup 中添加计算属性
const reversedMessages = computed(() => {
  return [...messages.value].reverse();
});

// 加载会话详情
const loadConversationDetails = async () => {
  if (!props.conversationId) return;
  try {
    loadingDetails.value = true;
    // 获取会话成员，现在使用store方法
    await conversationStore.fetchConversationMembers(props.conversationId);
  } catch (error) {
    console.error('加载会话详情失败:', error);
  } finally {
    loadingDetails.value = false;
  }
};

// 监听会话详情模态框的显示
const onShowDetails = async () => {
  await loadConversationDetails();
  await fetchPendingRequestsCount();
};

// 获取待处理的入群申请数量
const fetchPendingRequestsCount = async () => {
  if (!props.conversationId || !isAdminOrOwner.value) return;
  try {
    const response = await getJoinRequests(props.conversationId);
    if (response.code === 200) {
      pendingJoinRequestsCount.value = response.data.filter(c => c.status == 'PENDING').length;
    }
  } catch (error) {
    console.error('获取入群申请数量失败:', error);
  }
};

// 更新待处理的入群申请数量
const updatePendingRequestsCount = (count) => {
  pendingJoinRequestsCount.value = count;
};

// 判断当前用户是否可以邀请成员
const canInviteMembers = computed(() => {
  if (!conversation.value || !conversationStore.conversationMembers.length) return false;

  // 如果是单聊，不能邀请成员
  if (conversation.value.type !== 'GROUP') return false;

  // 如果群组设置了只有管理员可以邀请
  if (conversation.value?.onlyAdminCanInvite) {
    // 查找当前用户在群组中的角色
    const currentMember = conversationStore.conversationMembers.find(member => member.userId == currentUser.value);
    return currentMember && ['OWNER', 'ADMIN'].includes(currentMember.role);
  }

  // 默认所有成员都可以邀请
  return true;
});

// 判断当前用户是否为群主或管理员
const isAdminOrOwner = computed(() => {

  if (!conversation.value || !conversationStore.conversationMembers.length || conversation.value.type !== 'GROUP') return false;
  // 查找当前用户在群组中的角色
  const currentMember = conversationStore.conversationMembers.find(member => member.userId == currentUser.value);

  return currentMember && ['OWNER', 'ADMIN'].includes(currentMember.role);
});

// 判断当前用户是否为群主
const isGroupOwner = computed(() => {
  if (!conversation.value || !conversationStore.conversationMembers.length || conversation.value.type !== 'GROUP') return false;

  // 查找当前用户在群组中的角色
  const currentMember = conversationStore.conversationMembers.find(member => member.userId == currentUser.value);
  return currentMember && currentMember.role === 'OWNER';
});

// 确认退出群聊
const confirmQuitGroup = () => {
  confirm.require({
    header: '确认退出群聊',
    message: '您确定要退出该群聊吗？退出后需要重新被邀请才能加入。',
    icon: 'pi pi-exclamation-triangle',
    acceptLabel: '确认退出',
    rejectLabel: '取消',
    accept: quitGroup,
    reject: () => {
    }
  });
};

// 确认解散群聊
const confirmDisbandGroup = () => {
  confirm.require({
    header: '确认解散群聊',
    message: '您确定要解散该群聊吗？此操作将删除所有群聊记录且无法恢复。',
    icon: 'pi pi-exclamation-triangle',
    acceptLabel: '确认解散',
    rejectLabel: '取消',
    accept: disbandGroup,
    reject: () => {
    }
  });
};

// 退出群聊
const quitGroup = async () => {
  const success = await conversationStore.quit(props.conversationId)
  if (success) {
    toast.add({severity: 'success', summary: '成功', detail: '已退出群聊', life: 3000});
    showConversationDetails.value = false;
    router.push('/home');
  } else {
    toast.add({severity: 'error', summary: '错误', detail: '退出群聊失败', life: 3000});
  }
};

// 解散群聊
const disbandGroup = async () => {
  try {
    if (!conversation.value || !conversation.value.group || !conversation.value.group.id) {
      toast.add({severity: 'error', summary: '错误', detail: '群组信息不完整', life: 3000});
      return;
    }

    const success = await conversationStore.disbandGroup(props.conversationId)

    if (success) {
      toast.add({severity: 'success', summary: '成功', detail: '群聊已解散', life: 3000});
      showConversationDetails.value = false;
      router.push('/home');
    } else {
      toast.add({severity: 'error', summary: '错误', detail: '解散群聊失败', life: 3000});
    }
  } catch (error) {
    console.error('解散群聊失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '解散群聊失败', life: 3000});
  }
};

// 过滤好友列表，排除已经在会话中的成员
const filteredFriends = computed(() => {
  // 获取已在会话中的成员ID
  const memberIds = conversationStore.conversationMembers.map(member => member.userId);
  // 过滤出未在会话中的好友
  let availableFriends = contactsStore.contacts.filter(friend => !memberIds.includes(friend.id));

  // 如果有搜索关键词，进一步过滤
  if (searchFriendQuery.value) {
    const query = searchFriendQuery.value.toLowerCase();
    availableFriends = availableFriends.filter(friend =>
      friend.username.toLowerCase().includes(query)
    );
  }

  return availableFriends;
});

// 显示邀请成员模态框
const onShowInviteModal = async () => {
  loadingFriends.value = true;
  selectedFriends.value = [];
  searchFriendQuery.value = '';

  try {
    // 确保联系人列表已加载
    if (contactsStore.contacts.length === 0) {
      await contactsStore.fetchContacts();
    }
  } catch (error) {
    console.error('加载联系人失败:', error);
  } finally {
    loadingFriends.value = false;
  }
};

// 邀请成员
const inviteMembers = async () => {
  if (selectedFriends.value.length === 0) return;

  inviting.value = true;

  try {
    await inviteConversationMembers(props.conversationId, selectedFriends.value);

    // 关闭模态框
    showInviteMembersModal.value = false;

    // 重新加载会话成员
    await loadConversationDetails();

    // 显示成功提示
    toast.add({severity: 'success', summary: '成功', detail: '成员邀请成功', life: 3000});
  } catch (error) {
    console.error('邀请成员失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '邀请成员失败', life: 3000});
  } finally {
    inviting.value = false;
    selectedFriends.value = [];
  }
};

// 判断当前用户是否可以设置指定成员为管理员
const canSetAdmin = (member) => {
  if (!conversation.value || conversation.value.type !== 'GROUP') return false;

  // 获取当前用户在群组中的角色
  const currentMember = conversationStore.conversationMembers.find(m => m.userId == currentUser.value);
  if (!currentMember) return false;

  // 只有群主可以设置管理员
  if (currentMember.role !== 'OWNER') return false;

  // 不能对自己操作
  if (member.userId === currentMember.userId) return false;

  // 只能将普通成员设置为管理员
  return member.role === 'MEMBER';
};

// 判断当前用户是否可以删除指定成员
const canRemoveMember = (member) => {
  if (!conversation.value || conversation.value.type !== 'GROUP') return false;

  // 获取当前用户在群组中的角色
  const currentMember = conversationStore.conversationMembers.find(m => m.userId == currentUser.value);
  if (!currentMember) return false;

  // 群主不能被删除
  if (member.role === 'OWNER') return false;

  // 群主可以删除任何人
  if (currentMember.role === 'OWNER') return member.userId !== currentMember.userId;

  // 管理员只能被群主删除
  if (member.role === 'ADMIN') return false;

  // 管理员可以删除普通成员
  if (currentMember.role === 'ADMIN') return member.role === 'MEMBER';

  // 普通成员不能删除任何人
  return false;
};

// 确认设置管理员
const confirmSetAdmin = (member) => {
  confirm.require({
    header: '设置管理员',
    message: `确定要将 ${member.nickname} 设置为管理员吗？`,
    icon: 'pi pi-user-edit',
    acceptLabel: '确定',
    rejectLabel: '取消',
    accept: () => setMemberAsAdmin(member),
    reject: () => {
    }
  });
};

// 确认删除成员
const confirmRemoveMember = (member) => {
  confirm.require({
    header: '确认删除成员',
    message: `确定要将 ${member.nickname} 移出群聊吗？`,
    icon: 'pi pi-exclamation-triangle',
    acceptLabel: '确定',
    rejectLabel: '取消',
    accept: () => removeMember(member),
    reject: () => {
    }
  });
};

// 删除成员
const removeMember = async (member) => {
  if (!conversation.value || !props.conversationId) return;

  removingMember.value = true;

  try {
    const success = await conversationStore.removeMember(props.conversationId, member.userId);

    if (success) {
      // 显示成功提示
      toast.add({severity: 'success', summary: '成功', detail: '成员已移出群聊', life: 3000});
    } else {
      toast.add({severity: 'error', summary: '错误', detail: '移出成员失败', life: 3000});
    }
  } catch (error) {
    console.error('移出成员失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '移出成员失败', life: 3000});
  } finally {
    removingMember.value = false;
  }
};

// 设置成员为管理员
const setMemberAsAdmin = async (member) => {
  if (!conversation.value || !props.conversationId) return;

  updatingRole.value = true;

  try {
    const success = await conversationStore.updateRole(props.conversationId, member.userId, true);

    if (success) {
      // 显示成功提示
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: `已将 ${member.nickname} 设置为管理员`,
        life: 3000
      });
    } else {
      toast.add({severity: 'error', summary: '错误', detail: '设置管理员失败', life: 3000});
    }
  } catch (error) {
    console.error('设置管理员失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '设置管理员失败', life: 3000});
  } finally {
    updatingRole.value = false;
  }
};
// 判断当前用户是否可以取消指定成员的管理员身份
const canDemoteAdmin = (member) => {
  if (!conversation.value || conversation.value.type !== 'GROUP') return false;

  // 获取当前用户在群组中的角色
  const currentMember = conversationStore.conversationMembers.find(m => m.userId == currentUser.value);
  if (!currentMember) return false;

  // 只有群主可以取消管理员
  if (currentMember.role !== 'OWNER') return false;

  // 不能对自己操作
  if (member.userId === currentMember.userId) return false;

  // 只能将管理员降级为普通成员
  return member.role === 'ADMIN';
};

// 确认取消管理员
const confirmDemoteAdmin = (member) => {
  confirm.require({
    header: '取消管理员',
    message: `确定要取消 ${member.nickname} 的管理员身份吗？`,
    icon: 'pi pi-user-minus',
    acceptLabel: '确定',
    rejectLabel: '取消',
    accept: () => demoteAdmin(member),
    reject: () => {
    }
  });
};

// 更新群聊设置
const updateGroupSettings = async () => {
  if (!conversation.value || !props.conversationId || !isAdminOrOwner.value) return;

  updatingSettings.value = true;

  try {
    const response = await updateConversationInfo(props.conversationId, {
      requireApproval: conversation.value.requireApproval,
      onlyAdminCanInvite: conversation.value.onlyAdminCanInvite,
      onlyAdminCanSpeak: conversation.value.onlyAdminCanSpeak
    });

    if (response.code === 200) {
      toast.add({severity: 'success', summary: '成功', detail: '群聊设置已更新', life: 3000});
    } else {
      toast.add({
        severity: 'error',
        summary: '错误',
        detail: response.message || '更新群聊设置失败',
        life: 3000
      });
    }
  } catch (error) {
    console.error('更新群聊设置失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '更新群聊设置失败', life: 3000});
  } finally {
    updatingSettings.value = false;
  }
};

// 取消成员的管理员身份
const demoteAdmin = async (member) => {
  if (!conversation.value || !props.conversationId) return;

  updatingRole.value = true;

  try {
    const success = await conversationStore.updateRole(props.conversationId, member.userId, false);

    if (success) {
      // 显示成功提示
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: `已取消 ${member.nickname} 的管理员身份`,
        life: 3000
      });
    } else {
      toast.add({severity: 'error', summary: '错误', detail: '取消管理员失败', life: 3000});
    }
  } catch (error) {
    console.error('取消管理员失败:', error);
    toast.add({severity: 'error', summary: '错误', detail: '取消管理员失败', life: 3000});
  } finally {
    updatingRole.value = false;
  }
};
</script>
