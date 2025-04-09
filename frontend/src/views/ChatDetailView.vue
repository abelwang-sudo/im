<template>
  <div class="h-screen">
    <ChatWindow :conversationId="conversationId"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useConversationStore } from '@/stores/conversation';
import ChatWindow from '@/components/layout/ChatWindow.vue';
const route = useRoute();

// 从路由参数获取会话ID
const conversationId = computed(() => route.params.id);

</script>

<style scoped>
</style>
