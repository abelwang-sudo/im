<template>
  <div class="h-full flex flex-col bg-white overflow-hidden">
    <div class="p-4 border-b border-gray-200 flex items-center gap-2">
      <input
        type="text"
        :placeholder="searchPlaceholder"
        class="flex-1 px-4 py-2 bg-gray-100 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
      <Button
        @click="$emit('create-item')"
        icon="pi pi-plus"
        rounded
        text
        severity="info"
        aria-label="创建新会话"
      />
    </div>
    <div class="flex-1 overflow-y-auto overflow-x-hidden ">
      <div
        v-for="item in items"
        :key="item.id"
        class="relative border-b border-gray-100 overflow-hidden "
      >
        <!-- 滑动容器 -->
        <div
          class="swipe-container"
          :class="[selectItem?.id === item.id ? 'bg-gray-100' : 'bg-white']"
          :style="{ transform: `translateX(${item.id === activeItemId ? swipeOffset : 0}px)` }"
          @touchstart.passive="handleTouchStart($event, item)"
          @touchmove.passive="handleTouchMove($event)"
          @touchend="handleTouchEnd()"
          @mousedown="handleMouseDown($event, item)"
          @mousemove="handleMouseMove($event)"
          @mouseup="handleMouseUp()"
          @mouseleave="handleMouseUp()"
        >
          <!-- 会话内容 -->
          <div
            class="flex items-center p-4 hover:bg-gray-50 min-w-0 relative cursor-pointer w-full "
            @click="handleItemClick(item)"
          >
            <div class="mr-4 w-12 h-12">
              <img
                :src="item.avatar || '/src/assets/default-avatar.png'"
                :alt="item.name"
                class="w-12 h-12 rounded-full object-cover"
              />
              <div
                v-if="type === 'contact' && item.type === 'user'"
                :class="['absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-white', item.online ? 'bg-green-500' : 'bg-gray-400']"
              ></div>
            </div>
            <div class="flex-1">
              <div class="flex justify-between items-center mb-1">
                <div class="flex-1 items-center gap-2">
                  <h3 class="font-semibold text-gray-900">{{ item.member.displayName }}</h3>
                </div>
                <span class="text-xs text-gray-500">{{ formatTime(item.lastMessage?.timestamp) }}</span>
              </div>
              <div class="flex justify-between items-center min-w-0">
                <p class="text-sm text-gray-500 truncate flex-1 mr-2 min-w-0 line-clamp-2">
                  {{ item.lastMessage?.content?.text || item.lastMessage?.content || '' }}
                </p>
                <div
                  v-if="item.member?.unreadCount > 0 && (selectItem?.id !== item.id || isMobile())"
                  class="bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center flex-shrink-0"
                >
                  {{ item.member.unreadCount }}
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- 删除按钮区域 -->
        <div
          class="delete-action absolute top-0 right-0 bottom-0 flex items-center justify-center bg-red-500 text-white"
          :style="{ width: deleteButtonWidth + 'px' }"
          @click="confirmDeleteConversation(item)"
        >
          <i class="pi pi-trash mr-1"></i>
          <span>删除</span>
        </div>
      </div>
    </div>

    <!-- 删除确认对话框 -->
    <Dialog :visible="showDeleteDialog" header="确认删除" :style="{ width: '350px' }" :modal="true">
      <div class="confirmation-content">
        <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem" />
        <span>确定要删除此会话吗？此操作不可撤销。</span>
      </div>
      <template #footer>
        <Button label="取消" icon="pi pi-times" text @click="showDeleteDialog = false" />
        <Button label="删除" icon="pi pi-check" severity="danger" @click="deleteConversation" />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { defineProps, defineEmits, ref } from 'vue';

import { useConversationStore } from '@/stores/conversation';
import {isMobile} from "@/utils/helpers.js";

const emit = defineEmits(['select-item','create-item']);
const conversationStore = useConversationStore();
const selectItem = ref(null)

// 滑动相关状态
const activeItemId = ref(null);
const swipeOffset = ref(0);
const startX = ref(0);
const currentX = ref(0);
const deleteButtonWidth = ref(80); // 删除按钮宽度
const swipeThreshold = ref(40); // 滑动阈值，超过这个值会显示删除按钮
const isSwipping = ref(false); // 是否正在滑动的标志

defineProps({
  items: {
    type: Array,
    required: true
  },
  type: {
    type: String,
    default: 'conversation',
    validator: (value) => ['conversation', 'contact'].includes(value)
  },
  searchPlaceholder: {
    type: String,
    default: '搜索会话'
  }
});

// 删除会话相关状态
const showDeleteDialog = ref(false);
const conversationToDelete = ref(null);

const handleItemClick = (item) => {
  // 如果正在滑动，则不触发点击事件
  if (!isSwipping.value) {
    selectItem.value = item;
    emit('select-item', item);
  }
};

const confirmDeleteConversation = (item) => {
  conversationToDelete.value = item;
  showDeleteDialog.value = true;
};

const deleteConversation = async () => {
  try {
    if (conversationToDelete.value) {
      conversationStore.deleteConversationById(conversationToDelete.value.id);
    }
    showDeleteDialog.value = false;
  } catch (error) {
    console.error('删除会话失败:', error);
  }
};

const formatTime = (date) => {
  if (!date) return '';
  const now = new Date();
  const messageDate = new Date(date);
  const diff = now - messageDate;

  // 小于1分钟
  if (diff < 60000) {
    return '刚刚';
  }
  // 小于1小时
  if (diff < 3600000) {
    return `${Math.floor(diff / 60000)}分钟前`;
  }
  // 小于24小时
  if (diff < 86400000) {
    return `${Math.floor(diff / 3600000)}小时前`;
  }
  // 大于24小时
  return messageDate.toLocaleDateString();
};

// 触摸事件处理
const handleTouchStart = (event, item) => {
  startX.value = event.touches[0].clientX;
  activeItemId.value = item.id;
};

const handleTouchMove = (event) => {
  if (!activeItemId.value) return;

  currentX.value = event.touches[0].clientX;
  const diff = currentX.value - startX.value;

  // 如果滑动距离超过一定阈值，标记为正在滑动
  if (Math.abs(diff) > 5) {
    isSwipping.value = true;
  }

  // 只允许向左滑动
  if (diff < 0) {
    // 限制最大滑动距离为删除按钮宽度
    swipeOffset.value = Math.max(diff, -deleteButtonWidth.value);
  } else {
    swipeOffset.value = 0;
  }
};

const handleTouchEnd = () => {
  if (!activeItemId.value) return;

  // 如果滑动距离超过阈值，则完全展开删除按钮
  if (Math.abs(swipeOffset.value) > swipeThreshold.value) {
    swipeOffset.value = -deleteButtonWidth.value;
  } else {
    // 否则回到初始位置
    swipeOffset.value = 0;
  }

  // 如果回到初始位置，清除激活状态
  if (swipeOffset.value === 0) {
    activeItemId.value = null;
  }

  // 使用setTimeout延迟重置滑动标志，以防止误触发点击事件
  setTimeout(() => {
    isSwipping.value = false;
  }, 100);
};

// 鼠标事件处理（桌面端支持）
const handleMouseDown = (event, item) => {
  startX.value = event.clientX;
  activeItemId.value = item.id;
};

const handleMouseMove = (event) => {
  if (!activeItemId.value) return;

  currentX.value = event.clientX;
  const diff = currentX.value - startX.value;

  // 如果滑动距离超过一定阈值，标记为正在滑动
  if (Math.abs(diff) > 5) {
    isSwipping.value = true;
  }

  // 只允许向左滑动
  if (diff < 0) {
    // 限制最大滑动距离为删除按钮宽度
    swipeOffset.value = Math.max(diff, -deleteButtonWidth.value);
  } else {
    swipeOffset.value = 0;
  }
};

const handleMouseUp = () => {
  if (!activeItemId.value) return;

  // 如果滑动距离超过阈值，则完全展开删除按钮
  if (Math.abs(swipeOffset.value) > swipeThreshold.value) {
    swipeOffset.value = -deleteButtonWidth.value;
  } else {
    // 否则回到初始位置
    swipeOffset.value = 0;
  }

  // 如果回到初始位置，清除激活状态
  if (swipeOffset.value === 0) {
    activeItemId.value = null;
  }

  // 使用setTimeout延迟重置滑动标志，以防止误触发点击事件
  setTimeout(() => {
    isSwipping.value = false;
  }, 100);
};
</script>

<style scoped>
.swipe-container {
  width: 100%;
  display: flex;
  transition: transform 0.3s ease;
  position: relative;
  z-index: 1;
}

.delete-action {
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 500;
  z-index: 0;
}
</style>
