import { defineStore } from 'pinia';
import { ref } from 'vue';
import {
  getTimelinePosts,
  getMyPosts,
  createPost,
  likePost,
  unlikePost,
  checkLikeStatus
} from '@/api/posts';

export const usePostsStore = defineStore('posts', () => {
  // 状态
  const timelinePosts = ref([]);
  const myPosts = ref([]);
  const isLoading = ref(false);
  const error = ref(null);

  // 获取好友动态列表（包括自己的动态）
  async function fetchTimelinePosts() {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await getTimelinePosts();
      if (response.code === 200) {
        timelinePosts.value = response.data.content;
      } else {
        error.value = response.message || '获取动态列表失败';
      }
    } catch (err) {
      error.value = err.message || '获取动态列表失败';
    } finally {
      isLoading.value = false;
    }
  }

  // 获取当前用户的动态列表
  async function fetchMyPosts() {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await getMyPosts();
      if (response.code === 200) {
        myPosts.value = response.data;
      } else {
        error.value = response.message || '获取我的动态失败';
      }
    } catch (err) {
      error.value = err.message || '获取我的动态失败';
    } finally {
      isLoading.value = false;
    }
  }

  // 发布新动态
  async function publishPost(postData) {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await createPost(postData);
      if (response.code === 200) {
        // 发布成功后刷新动态列表
        await fetchTimelinePosts();
        return true;
      } else {
        error.value = response.message || '发布动态失败';
        return false;
      }
    } catch (err) {
      error.value = err.message || '发布动态失败';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 点赞动态
  async function toggleLike(postId, isLiked) {
    try {
      if (isLiked) {
        await unlikePost(postId);
      } else {
        await likePost(postId);
      }

      // 更新动态列表中的点赞状态
      timelinePosts.value = timelinePosts.value.map(post => {
        if (post.id === postId) {
          return {
            ...post,
            isLiked: !isLiked,
            likeCount: isLiked ? post.likeCount - 1 : post.likeCount + 1
          };
        }
        return post;
      });

      return true;
    } catch (err) {
      error.value = err.message || '操作失败';
      return false;
    }
  }

  // 检查动态点赞状态
  async function checkPostLikeStatus(postId) {
    try {
      const response = await checkLikeStatus(postId);
      if (response.code === 200) {
        return response.data.isLiked;
      }
      return false;
    } catch (err) {
      console.error('检查点赞状态失败:', err);
      return false;
    }
  }

  return {
    timelinePosts,
    myPosts,
    isLoading,
    error,
    fetchTimelinePosts,
    fetchMyPosts,
    publishPost,
    toggleLike,
    checkPostLikeStatus
  };
});
