<template>
  <div class="profile-container p-4">
    <div class="bg-white rounded-lg shadow-md p-6 mb-4">
      <!-- 用户基本信息卡片 -->
      <div class="flex items-center mb-6">
        <div class="relative">
          <img
            :src="userStore.avatar || '/src/assets/default-avatar.png'"
            alt="用户头像"
            class="w-20 h-20 rounded-full object-cover border-2 border-gray-200"
          />
          <button
            @click="handleAvatarUpload"
            class="absolute bottom-0 right-0 bg-blue-500 text-white rounded-full p-1 shadow-md"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
            </svg>
          </button>
          <input
            type="file"
            ref="fileInput"
            accept="image/*"
            class="hidden"
            @change="onFileSelected"
          />
        </div>
        <div class="ml-4 flex-1">
          <h2 class="text-xl font-bold text-gray-800">{{ userStore.nickname || userStore.username }}</h2>
          <p class="text-gray-500">{{ userStore.email }}</p>
        </div>
        <button
          @click="isEditing = true"
          class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 transition-colors"
        >
          编辑资料
        </button>
      </div>

      <!-- 用户详细信息列表 -->
      <div class="space-y-4" v-if="!isEditing && !isChangingPassword">
        <div class="flex justify-between items-center py-2 border-b border-gray-100">
          <span class="text-gray-600">用户名</span>
          <span class="text-gray-800">{{ userStore.username }}</span>
        </div>
        <div class="flex justify-between items-center py-2 border-b border-gray-100">
          <span class="text-gray-600">昵称</span>
          <span class="text-gray-800">{{ userStore.nickname }}</span>
        </div>
        <div class="flex justify-between items-center py-2 border-b border-gray-100">
          <span class="text-gray-600">邮箱</span>
          <span class="text-gray-800">{{ userStore.email }}</span>
        </div>

        <!-- 添加修改密码按钮 -->
        <div class="flex justify-end mt-4 space-x-3">
          <button
            @click="isChangingPassword = true"
            class="px-4 py-2 bg-green-500 text-white rounded-md hover:bg-green-600 transition-colors"
          >
            修改密码
          </button>

          <!-- 添加退出登录按钮 -->
          <button
            @click="handleLogout"
            class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 transition-colors"
          >
            退出登录
          </button>
        </div>
      </div>

      <!-- 编辑表单 -->
      <form v-if="isEditing" @submit.prevent="handleSubmit" class="space-y-4">
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">昵称</label>
          <input
            v-model="editForm.nickname"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
        <div class="flex justify-end space-x-3">
          <button
            type="button"
            @click="cancelEdit"
            class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors"
          >
            取消
          </button>
          <button
            type="submit"
            class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors"
            :disabled="loading"
          >
            {{ loading ? '保存中...' : '保存' }}
          </button>
        </div>
      </form>

      <!-- 修改密码表单 -->
      <form v-if="isChangingPassword" @submit.prevent="handlePasswordChange" class="space-y-4">
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">当前密码</label>
          <input
            v-model="passwordForm.oldPassword"
            type="password"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="请输入当前密码"
          />
        </div>
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">新密码</label>
          <input
            v-model="passwordForm.newPassword"
            type="password"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="请输入新密码"
          />
        </div>
        <div class="space-y-2">
          <label class="block text-sm font-medium text-gray-700">确认新密码</label>
          <input
            v-model="passwordForm.confirmPassword"
            type="password"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="请再次输入新密码"
          />
        </div>
        <div class="flex justify-end space-x-3">
          <button
            type="button"
            @click="cancelPasswordChange"
            class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors"
          >
            取消
          </button>
          <button
            type="submit"
            class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors"
            :disabled="loading"
          >
            {{ loading ? '提交中...' : '提交' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useUserStore } from '@/stores/user';
import { uploadAvatar, changePassword } from '@/api/user';
import { useToast } from 'primevue/usetoast';
import websocketService from "@/services/websocket.service.js";

const toast = useToast();
const userStore = useUserStore();
const fileInput = ref(null);
const loading = ref(false);

// 状态控制
const isEditing = ref(false);
const isChangingPassword = ref(false);

const editForm = reactive({
  nickname: userStore.nickname
});

// 密码表单
const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

// 处理头像上传
const handleAvatarUpload = () => {
  fileInput.value.click();
};

// 文件选择后的处理
const onFileSelected = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  try {
    loading.value = true;

    // 上传头像到MinIO
    const response = await uploadAvatar(file);

    if (response.code === 200) {
      const avatarUrl = response.data.url;

      const success = await userStore.updateUserInfo({ avatar: avatarUrl });
      if(success){
        // 强制更新头像显示
        userStore.$patch({ avatar: avatarUrl });
        toast.add({ severity: 'success', summary: '成功', detail: '头像更新成功', life: 3000 });
      }
    }
  } catch (error) {
    console.error('头像上传失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '头像上传失败', life: 3000 });
  } finally {
    loading.value = false;
    // 重置文件输入框
    event.target.value = '';
  }
};

// 提交表单
const handleSubmit = async () => {
  try {
    loading.value = true;
    const success = await userStore.updateUserInfo({ nickname: editForm.nickname });

    if (success) {
      toast.add({ severity: 'success', summary: '成功', detail: '个人资料更新成功', life: 3000 });
      isEditing.value = false;
    }
  } catch (error) {
    console.error('更新个人资料失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '更新个人资料失败', life: 3000 });
  } finally {
    loading.value = false;
  }
};

// 取消编辑
const cancelEdit = () => {
  editForm.nickname = userStore.nickname;
  isEditing.value = false;
};

// 处理密码修改
const handlePasswordChange = async () => {
  // 验证新密码
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    toast.add({ severity: 'error', summary: '错误', detail: '两次输入的新密码不一致', life: 3000 });
    return;
  }

  if (passwordForm.newPassword.length < 6) {
    toast.add({ severity: 'error', summary: '错误', detail: '新密码长度不能少于6个字符', life: 3000 });
    return;
  }

  try {
    loading.value = true;

    const response = await changePassword({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    });

    if (response.code === 200) {
      toast.add({ severity: 'success', summary: '成功', detail: '密码修改成功', life: 3000 });
      isChangingPassword.value = false;
      // 清空表单
      passwordForm.oldPassword = '';
      passwordForm.newPassword = '';
      passwordForm.confirmPassword = '';
    } else {
      toast.add({ severity: 'error', summary: '错误', detail: response.message || '密码修改失败', life: 3000 });
    }
  } catch (error) {
    console.error('密码修改失败:', error);
    toast.add({ severity: 'error', summary: '错误', detail: '密码修改失败', life: 3000 });
  } finally {
    loading.value = false;
  }
};

// 取消密码修改
const cancelPasswordChange = () => {
  passwordForm.oldPassword = '';
  passwordForm.newPassword = '';
  passwordForm.confirmPassword = '';
  isChangingPassword.value = false;
};

// 处理退出登录
const handleLogout = () => {
  // 显示确认对话框
  if (confirm('确定要退出登录吗？')) {
    userStore.logout();
    websocketService.getInstance().logOut()
    toast.add({ severity: 'info', summary: '提示', detail: '您已成功退出登录', life: 3000 });
  }
};

// 组件挂载时初始化表单数据
onMounted(() => {
  // 只需要初始化编辑表单
  editForm.nickname = userStore.nickname;
});
</script>
