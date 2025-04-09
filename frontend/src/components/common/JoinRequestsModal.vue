<template>
  <Dialog
    v-model:visible="visible"
    :modal="true"
    :closable="true"
    header="入群申请"
    class="w-4/5 md:w-3/4 lg:w-1/2"
    @show="loadJoinRequests"
  >
    <div v-if="loading" class="flex justify-center items-center py-4">
      <div class="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
    </div>
    <div v-else class="flex flex-col gap-4">
      <div v-if="joinRequests.length === 0" class="text-center py-8 text-gray-500">
        暂无入群申请
      </div>
      <div v-else class="border border-gray-200 rounded-lg p-2 max-h-[50vh] overflow-y-auto">
        <div class="flex flex-col gap-2" v-if="joinRequests.length>0">
          <div
            v-for="request in joinRequests"
            :key="request.id"
            class="flex items-center justify-between p-3 hover:bg-gray-50 rounded-lg border border-gray-100"
          >
            <div class="flex items-center">
              <img
                :src="request.avatar || '/src/assets/default-avatar.png'"
                :alt="request.username || '未知用户'"
                class="w-10 h-10 rounded-full mr-3"
              />
              <div>
                <div class="font-medium">{{ request.applicant?.nickname }}</div>
                <div v-if="request.reason" class="text-sm text-gray-600 mt-1">
                  <span class="font-medium">申请理由:</span> {{ request.reason }}
                </div>
              </div>
            </div>
            <div class="flex gap-2">
              <Button
                icon="pi pi-check"
                severity="success"
                size="small"
                :loading="processingIds[request.id]"
                @click="handleRequest(request.id, true)"
                aria-label="同意"
              />
              <Button
                icon="pi pi-times"
                severity="danger"
                size="small"
                :loading="processingIds[request.id]"
                @click="handleRequest(request.id, false)"
                aria-label="拒绝"
              />
            </div>
          </div>
        </div>
        <div v-else>
          暂无请求
        </div>
      </div>
    </div>
  </Dialog>
</template>

<script setup>
import { ref, defineProps, defineEmits, watch } from 'vue';
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import { getJoinRequests, handleJoinRequest } from '@/api/conversation.js';
import { toast } from '@/main.js';
import {useConversationStore} from "@/stores/conversation.js";
const visible = defineModel('visible')

const props = defineProps({
  conversationId: {
    type: [Number,String, null],
    required: true
  }
});

const emit = defineEmits(['update:visible', 'requests-updated']);

const joinRequests = ref([]);
const loading = ref(false);
const processingIds = ref({});
const conversationStore =useConversationStore()


// 加载入群申请列表
const loadJoinRequests = async () => {
  if (!props.conversationId) return;

  loading.value = true;
  try {
    const response = await getJoinRequests(props.conversationId);
    if (response.code === 200) {
      joinRequests.value = response.data.filter(c => c.status == 'PENDING');

      // 通知父组件请求数量已更新
      emit('requests-updated', joinRequests.value.length);
    } else {
      toast.add({ severity: 'error', summary: '错误', detail: response.message || '获取入群申请失败', life: 3000 });
    }
  } catch (error) {
    console.error('获取入群申请失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '获取入群申请失败', life: 3000 });
  } finally {
    loading.value = false;
  }
};

// 处理入群申请
const handleRequest = async (applicationId, approved) => {
  if (!props.conversationId || !applicationId) return;

  // 设置处理中状态
  processingIds.value = { ...processingIds.value, [applicationId]: true };

  try {
    const response = await handleJoinRequest(props.conversationId, applicationId, approved);
    if(approved){
      conversationStore.fetchConversationMembers(props.conversationId);
    }
    if (response.code === 200) {
      // 从列表中移除已处理的申请
      joinRequests.value = joinRequests.value.filter(req => req.id !== applicationId);

      // 通知父组件请求数量已更新
      emit('requests-updated', joinRequests.value.length);

      // 显示成功提示
      toast.add({
        severity: 'success',
        summary: '成功',
        detail: approved ? '已同意入群申请' : '已拒绝入群申请',
        life: 3000
      });
    } else {
      toast.add({ severity: 'error', summary: '错误', detail: response.message || '处理入群申请失败', life: 3000 });
    }
  } catch (error) {
    console.error('处理入群申请失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '处理入群申请失败', life: 3000 });
  } finally {
    // 清除处理中状态
    const newProcessingIds = { ...processingIds.value };
    delete newProcessingIds[applicationId];
    processingIds.value = newProcessingIds;
  }
};
// 监听visible属性变化
watch(() => props.visible, (newValue) => {
  emit('update:visible', newValue);
  if (newValue) {
    loadJoinRequests();
  }
});
</script>
