<template>
  <div class="discover-container p-4">
    <div class="header flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">好友动态</h1>
      <button @click="showCreatePostModal = true" class="create-post-btn bg-blue-500 text-white p-2 rounded-md flex items-center">
        <span class="text-xl mr-1">+</span> 发布动态
      </button>
    </div>

    <!-- 加载状态 -->
    <div v-if="postsStore.isLoading" class="flex justify-center items-center py-8">
      <div class="spinner"></div>
    </div>

    <!-- 错误提示 -->
    <div v-else-if="postsStore.error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
      {{ postsStore.error }}
    </div>

    <!-- 空状态 -->
    <div v-else-if="postsStore.timelinePosts.length === 0" class="text-center py-8 text-gray-500">
      <div class="mb-4">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mx-auto text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z" />
        </svg>
      </div>
      <p class="text-lg">暂无动态</p>
      <p class="mt-2">点击右上角按钮发布你的第一条动态吧！</p>
    </div>

    <!-- 动态列表 -->
    <div v-else class="posts-list space-y-4">
      <div v-for="post in postsStore.timelinePosts" :key="post.id" class="post-card bg-white rounded-lg shadow p-4">
        <div class="post-header flex items-center mb-3">
          <img :src="post.userAvatar || '/src/assets/default-avatar.png'" alt="用户头像" class="w-10 h-10 rounded-full mr-3">
          <div>
            <div class="font-semibold">{{ post.username }}</div>
            <div class="text-xs text-gray-500">{{ formatDate(post.createdAt) }}</div>
          </div>
        </div>
        <div class="post-content mb-3">
          <p class="text-gray-800">{{ post.content }}</p>
          <div v-if="post.medias && post.medias.length > 0" class="mt-2 grid grid-cols-2 gap-2">
            <div v-for="(media, index) in post.medias" :key="index">
              <img v-if="media.mediaType === 'image'" :src="media.mediaUrl" alt="动态图片" class="w-full rounded-lg object-cover" style="max-height: 200px">
              <video v-else-if="media.mediaType === 'video'" :src="media.mediaUrl" class="w-full rounded-lg" style="max-height: 200px" controls></video>
            </div>
          </div>
        </div>
        <div class="post-actions flex justify-end items-center text-gray-500">
          <button @click="toggleLike(post)" class="flex items-center" :class="{'text-red-500': post.liked}">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" :fill="post.liked ? 'currentColor' : 'none'" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
            </svg>
            <span>{{ post.likeCount || 0 }}</span>
          </button>
        </div>
      </div>
    </div>

    <!-- 发布动态对话框 -->
    <Dialog v-model:visible="showCreatePostModal" header="发布动态" :style="{width: '90%', maxWidth: '500px'}">
      <div class="p-4">
        <div class="mb-4">
          <label for="postContent" class="block text-sm font-medium text-gray-700 mb-2">内容</label>
          <textarea
            id="postContent"
            v-model="newPost.content"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
            placeholder="分享你的想法..."
          ></textarea>
        </div>
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 mb-2">媒体文件</label>
          <div v-if="newPost.imagePreviews.length > 0" class="mb-2 grid grid-cols-2 gap-2">
            <div v-for="(preview, index) in newPost.imagePreviews" :key="index" class="relative">
              <img v-if="preview.type === 'image'" :src="preview.url" alt="预览图片" class="w-full h-32 object-cover rounded-md">
              <video v-else :src="preview.url" class="w-full h-32 object-cover rounded-md" controls></video>
              <button @click="removeImage(index)" class="absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center">
                ×
              </button>
            </div>
          </div>
          <div>
            <label for="postImage" class="cursor-pointer inline-block px-4 py-2 border border-gray-300 rounded-md text-sm text-gray-700 hover:bg-gray-50">
              <span>选择媒体文件</span>
              <input
                type="file"
                id="postImage"
                accept="image/*,video/*"
                class="hidden"
                @change="handleImageUpload"
                multiple
              >
            </label>
          </div>
        </div>
      </div>
      <template #footer>
        <div class="flex justify-end space-x-2">
          <Button label="取消" @click="showCreatePostModal = false" class="p-button-text" />
          <Button label="发布" @click="publishPost" :loading="publishing" :disabled="!newPost.content.trim()" class="p-button-primary" />
        </div>
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { usePostsStore } from '@/stores/posts';
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import { uploadFileWithPresignedUrl } from '@/api/user';

const postsStore = usePostsStore();

// 状态变量
const showCreatePostModal = ref(false);
const publishing = ref(false);
const newPost = ref({
  content: '',
  images: [],
  imagePreviews: []
});

// 初始化加载动态列表
onMounted(async () => {
  await postsStore.fetchTimelinePosts();
});

// 处理图片上传
const handleImageUpload = (event) => {
  const files = event.target.files;
  if (files && files.length > 0) {
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      newPost.value.images.push(file);
      newPost.value.imagePreviews.push({
        url: URL.createObjectURL(file),
        type: file.type.startsWith('image/') ? 'image' : 'video'
      });
    }
  }
};

// 移除已选择的图片
const removeImage = (index) => {
  newPost.value.images.splice(index, 1);
  newPost.value.imagePreviews.splice(index, 1);
};

// 发布动态
const publishPost = async () => {
  if (!newPost.value.content.trim()) return;

  publishing.value = true;
  try {
    let mediaFiles = [];

    // 如果有媒体文件，先上传
    if (newPost.value.images.length > 0) {
      for (let i = 0; i < newPost.value.images.length; i++) {
        const file = newPost.value.images[i];
        const result = await uploadFileWithPresignedUrl(file);
        if (result.code === 200) {
          mediaFiles.push({
            mediaUrl: result.data.url,
            mediaType: file.type.startsWith('image/') ? 'image' : 'video'
          });
        }
      }
    }

    // 发布动态
    const success = await postsStore.publishPost({
      content: newPost.value.content,
      'medias':mediaFiles
    });

    if (success) {
      // 重置表单
      newPost.value = {
        content: '',
        images: [],
        imagePreviews: []
      };
      showCreatePostModal.value = false;
    }
  } catch (error) {
    console.error('发布动态失败:', error);
  } finally {
    publishing.value = false;
  }
};

// 点赞/取消点赞
const toggleLike = async (post) => {
  await postsStore.toggleLike(post.id, post.liked);
};

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString);
  const now = new Date();
  const diffMs = now - date;
  const diffSec = Math.floor(diffMs / 1000);
  const diffMin = Math.floor(diffSec / 60);
  const diffHour = Math.floor(diffMin / 60);
  const diffDay = Math.floor(diffHour / 24);

  if (diffSec < 60) {
    return '刚刚';
  } else if (diffMin < 60) {
    return `${diffMin}分钟前`;
  } else if (diffHour < 24) {
    return `${diffHour}小时前`;
  } else if (diffDay < 30) {
    return `${diffDay}天前`;
  } else {
    return date.toLocaleDateString();
  }
};
</script>

<style scoped>
.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border-left-color: #3b82f6;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
