<template>
  <Dialog
    :visible="visible"
    :modal="true"
    :closable="true"
    :header="currentStep === 1 ? '选择群成员' : '配置群信息'"
    class="w-4/5 md:w-3/4 lg:w-1/2 "
    @hide="closeModal"
  >

    <template #closebutton>
      <Button
        icon="pi pi-times"
        class="p-button-rounded p-button-text p-button-sm"
        @click="closeModal"
      />
    </template>
    <div class="flex flex-col gap-4 h-full">
      <!-- 步骤指示器 -->
      <div class="flex items-center justify-center mb-4">
        <div class="flex items-center">
          <div class="w-8 h-8 rounded-full bg-blue-500 text-white flex items-center justify-center font-bold">1</div>
          <div class="h-1 w-16 bg-gray-300" :class="{ 'bg-blue-500': currentStep > 1 }"></div>
          <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold"
               :class="currentStep > 1 ? 'bg-blue-500 text-white' : 'bg-gray-300 text-gray-600'">2</div>
        </div>
      </div>

      <!-- 步骤1: 选择群成员 -->
      <div v-if="currentStep === 1">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">选择群成员</label>
          <!-- 搜索框移到滚动区域外部 -->
          <div class="mb-2">
            <InputText
              v-model="searchQuery"
              placeholder="搜索好友"
              class="w-full"
            />
          </div>
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
              {{ searchQuery ? '没有找到匹配的好友' : '暂无好友' }}
            </div>
          </div>
          <small v-if="submitted && selectedFriends.length === 0" class="p-error">请至少选择一个群成员</small>
        </div>
      </div>

      <!-- 步骤2: 配置群信息 -->
      <div v-else>
        <div class="flex items-center gap-4">
          <!-- 群头像上传 -->
          <div class="relative">
            <img
              :src="groupAvatar || '/src/assets/default-avatar.png'"
              alt="群头像"
              class="w-20 h-20 rounded-full object-cover border-2 border-gray-200"
            />
            <Button
              icon="pi pi-camera"
              class="absolute bottom-0 right-0 w-8 h-8 p-0"
              rounded
              severity="secondary"
              @click="triggerFileInput"
            />
            <input
              type="file"
              ref="fileInput"
              accept="image/*"
              class="hidden"
              @change="handleFileChange"
            />
          </div>

          <!-- 群名称和简介 -->
          <div class="flex-1">
            <div class="mb-2">
              <label for="groupName" class="block text-sm font-medium text-gray-700 mb-1">群名称</label>
              <InputText
                id="groupName"
                v-model="groupName"
                placeholder="请输入群名称"
                class="w-full"
                :class="{ 'p-invalid': submitted && !groupName }"
              />
              <small v-if="submitted && !groupName" class="p-error">群名称不能为空</small>
            </div>

            <div>
              <label for="groupDescription" class="block text-sm font-medium text-gray-700 mb-1">群简介</label>
              <Textarea
                id="groupDescription"
                v-model="groupDescription"
                placeholder="请输入群简介"
                rows="2"
                class="w-full"
              />
            </div>
          </div>
        </div>

        <!-- 已选成员展示 -->
        <div class="mt-4">
          <label class="block text-sm font-medium text-gray-700 mb-2">已选择的成员 ({{ selectedFriends.length }})</label>
          <div class="flex flex-wrap gap-2 max-h-32 overflow-y-auto p-1">
            <div
              v-for="friendId in selectedFriends"
              :key="friendId"
              class="flex items-center bg-gray-100 rounded-full px-3 py-1 mb-1"
            >
              <span class="text-sm">{{ getFriendName(friendId) }}</span>
              <Button
                icon="pi pi-times"
                class="p-button-rounded p-button-text p-button-sm ml-1 p-0 w-4 h-4"
                @click="removeFriend(friendId)"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex justify-between gap-2">
        <Button
          v-if="currentStep > 1"
          label="上一步"
          icon="pi pi-arrow-left"
          text
          @click="prevStep"
        />
        <div v-else></div>
        <div class="flex gap-2">
          <Button
            label="取消"
            icon="pi pi-times"
            text
            @click="closeModal"
          />
          <Button
            v-if="currentStep === 1"
            label="下一步"
            icon="pi pi-arrow-right"
            severity="info"
            @click="nextStep"
          />
          <Button
            v-else
            label="创建"
            icon="pi pi-check"
            severity="success"
            @click="handleCreateGroup"
            :loading="loading"
          />
        </div>
      </div>
    </template>
  </Dialog>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useContactsStore } from '@/stores/contacts';
import { getUploadUrl, uploadFileWithPresignedUrl } from '@/api/user';
import { createGroup } from '@/api/group';
import { toast } from '@/main.js';

// 组件属性
const props = defineProps({
  visible: {
    type: Boolean,
    required: true
  }
});

// 组件事件
const emit = defineEmits(['update:visible', 'group-created']);

// 状态变量
const contactsStore = useContactsStore();
const currentStep = ref(1); // 当前步骤：1-选择成员，2-配置群信息
const groupName = ref('');
const groupDescription = ref('');
const groupAvatar = ref('');
const searchQuery = ref('');
const selectedFriends = ref([]);
const fileInput = ref(null);
const submitted = ref(false);
const loading = ref(false);
const avatarFile = ref(null);

// 过滤好友列表
const filteredFriends = computed(() => {
  if (!searchQuery.value) {
    return contactsStore.contacts;
  }
  const query = searchQuery.value.toLowerCase();
  return contactsStore.contacts.filter(friend =>
    friend.username.toLowerCase().includes(query)
  );
});

// 获取好友名称
const getFriendName = (friendId) => {
  const friend = contactsStore.contacts.find(f => f.id === friendId);
  return friend ? friend.username : '未知用户';
};

// 步骤控制
const nextStep = () => {
  submitted.value = true;

  // 验证第一步
  if (currentStep.value === 1) {
    if (selectedFriends.value.length === 0) {
      return;
    }
    currentStep.value = 2;
    submitted.value = false;
  }
};

const prevStep = () => {
  currentStep.value = 1;
  submitted.value = false;
};

// 移除已选成员
const removeFriend = (friendId) => {
  selectedFriends.value = selectedFriends.value.filter(id => id !== friendId);
};

// 触发文件选择
const triggerFileInput = () => {
  fileInput.value.click();
};

// 处理文件选择
const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (!file) return;

  // 检查文件类型
  if (!file.type.startsWith('image/')) {
    toast.add({ severity: 'error', summary: '错误', detail: '请选择图片文件', life: 3000 });
    return;
  }

  // 检查文件大小 (限制为2MB)
  if (file.size > 2 * 1024 * 1024) {
    toast.add({ severity: 'error', summary: '错误', detail: '图片大小不能超过2MB', life: 3000 });
    return;
  }

  // 预览图片
  const reader = new FileReader();
  reader.onload = (e) => {
    groupAvatar.value = e.target.result;
  };
  reader.readAsDataURL(file);

  // 保存文件引用
  avatarFile.value = file;
};

// 上传头像
const uploadAvatar = async () => {
  if (!avatarFile.value) return null;

  try {
    // 获取文件类型和扩展名
    const fileType = avatarFile.value.type;
    const fileExt = fileType.split('/')[1] || 'png';
    const fileName = `group_${Date.now()}.${fileExt}`;

    // 获取预签名URL
    const uploadUrlRes = await getUploadUrl(fileName, fileType);
    if (uploadUrlRes.code !== 200) {
      throw new Error(uploadUrlRes.message || '获取上传URL失败');
    }

    // 上传文件
    const uploadRes = await uploadFileWithPresignedUrl(avatarFile.value, uploadUrlRes.data.uploadUrl);
    return uploadUrlRes.data.fileUrl;
  } catch (error) {
    console.error('上传头像失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '上传头像失败', life: 3000 });
    return null;
  }
};

// 创建群聊
const handleCreateGroup = async () => {
  submitted.value = true;

  // 表单验证
  if (!groupName.value) {
    return;
  }

  loading.value = true;

  try {
    // 上传头像（如果有）
    let avatarUrl = null;
    if (avatarFile.value) {
      avatarUrl = await uploadAvatar();
    }

    // 创建群聊数据
    const groupData = {
      name: groupName.value,
      description: groupDescription.value,
      avatar: avatarUrl,
      memberIds: selectedFriends.value
    };

    // 发送创建群聊请求
    const result = await createGroup(groupData);

    if (result.code === 200) {
      toast.add({ severity: 'success', summary: '成功', detail: '群聊创建成功', life: 3000 });
      emit('group-created', result.data);
      closeModal();
    } else {
      throw new Error(result.message || '创建群聊失败');
    }
  } catch (error) {
    console.error('创建群聊失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: error.message || '创建群聊失败', life: 3000 });
  } finally {
    loading.value = false;
  }
};

// 关闭模态框
const closeModal = () => {
  // 重置表单
  currentStep.value = 1;
  groupName.value = '';
  groupDescription.value = '';
  groupAvatar.value = '';
  searchQuery.value = '';
  selectedFriends.value = [];
  avatarFile.value = null;
  submitted.value = false;

  // 关闭模态框
  emit('update:visible', false);
};

// 加载好友列表
onMounted(async () => {
  if (contactsStore.contacts.length === 0) {
    await contactsStore.fetchContacts();
  }
});
</script>
