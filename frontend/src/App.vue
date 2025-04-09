<script setup>
import Toast from 'primevue/toast';
import { RouterView } from 'vue-router';
import { onUnmounted } from 'vue';
import websocketService from '@/services/websocket.service';


onUnmounted(() => {
  // 清理消息监听器
  if (websocketService.getInstance()) {
    websocketService.getInstance().logOut()
  }
});
</script>

<template>
  <div>
    <Toast position="top-right" />
    <router-view v-slot="{ Component }">
      <keep-alive>
        <component :is="Component" />
      </keep-alive>
    </router-view>
  </div>
</template>

<style scoped>

</style>
