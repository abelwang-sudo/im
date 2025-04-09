<template>
  <div class="h-full">
    <!-- 移动端视图 -->
    <div class="md:hidden h-full">
      <!-- 联系人列表 (当未选择联系人时显示) -->
      <div v-if="!selectedContact" class="h-full flex flex-col">
        <div class="flex justify-between items-center p-4 bg-white border-b border-gray-200">
          <h1 class="text-2xl font-semibold text-gray-900">Chat</h1>
          <button class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 hover:bg-gray-200">
            <i class="fas fa-plus"></i>
          </button>
        </div>
        <ConversationList
          :items="conversationStore.conversations"
          @select-item="handleSelectContact"
          @create-item="handleCrate"
          class="flex-1 overflow-hidden"
        />
      </div>
    </div>

    <!-- 桌面端视图 -->
    <div class="hidden md:flex h-full">
      <div class="w-80 h-full overflow-hidden border-r border-gray-200">
        <ConversationList
          :items="conversationStore.conversations"
          @create-item="handleCrate"
          @select-item="handleSelectContact"
        />
      </div>
      <div class="flex-1 h-full overflow-hidden">
        <ChatWindow v-if="selectedContact" :conversation-id="selectedContact.id"
        />
        <div v-else class="h-full flex items-center justify-center bg-gray-50">
          <p class="text-lg text-gray-500">选择一个联系人开始聊天</p>
        </div>
      </div>
    </div>
      <!-- 创建群聊模态框 -->
  <CreateGroupStepModal
    :visible="showCreateGroupModal"
    @update:visible="showCreateGroupModal = $event"
    @group-created="handleGroupCreated"
  />
  </div>

</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useConversationStore } from '@/stores/conversation';
import ConversationList from '@/components/layout/ConversationList.vue';
import ChatWindow from '@/components/layout/ChatWindow.vue';
import CreateGroupStepModal from '@/components/common/CreateGroupStepModal.vue';
import {isMobile} from "@/utils/helpers.js";

const conversationStore = useConversationStore();
const router = useRouter();

const selectedContact = ref(null);


// 选择会话
const handleSelectContact = (conversation) => {
  // 在移动端环境下，跳转到聊天详情页面
  if (isMobile()) {
    router.push(`/chat/${conversation.id}`);
  } else {
    if(selectedContact.value!=null){
      conversationStore.markAsRead(selectedContact.value.id)
    }
    conversationStore.markAsRead(conversation.id)

    // 桌面端保持原有逻辑，在当前页面切换组件
    selectedContact.value = conversation;
  }
};

const showCreateGroupModal = ref(false);

const handleCrate = () => {
  showCreateGroupModal.value = true;
};

// 处理群聊创建成功
const handleGroupCreated = async (group) => {
  // 刷新会话列表
  await conversationStore.loadConversations();

  // 找到新创建的群聊会话
  const newGroupConversation = conversationStore.conversations.find(
    conv => conv.type === 'group' && conv.id === group.id
  );

  // 如果找到了，选中该会话
  if (newGroupConversation) {
    handleSelectContact(newGroupConversation);
  }
};

onMounted(async () => {
  // 加载会话列表
  await conversationStore.loadConversations();

});

</script>

<style scoped>
</style>
