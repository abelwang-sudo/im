import request from '@/utils/request';
import axios from 'axios';

export function register(data) {
  return request({
    url: '/users/register',
    method: 'post',
    data
  });
}

export function login(data) {
  return request({
    url: '/users/login',
    method: 'post',
    data
  });
}

export function getUserInfo() {
  return request({
    url: '/users/info',
    method: 'get'
  });
}

export function updateUserProfile(data) {
  return request({
    url: '/users/profile',
    method: 'put',
    data
  });
}

// 获取文件上传预签名URL
export function getUploadUrl(fileName, contentType) {
  return request({
    url: '/files/upload-url',
    method: 'get',
    params: {
      fileName,
      contentType
    }
  });
}

// 使用预签名URL上传文件
export async function uploadFileWithPresignedUrl(file) {
  try {
    // 1. 获取预签名URL
    const response = await getUploadUrl(file.name, file.type);

    if (response.code !== 200) {
      throw new Error('获取上传URL失败');
    }

    const { uploadUrl, fileUrl } = response.data;

    // 2. 使用预签名URL直接上传到MinIO
    await axios.put(uploadUrl, file, {
      headers: {
        'Content-Type': file.type
      }
    });

    // 3. 返回文件的访问URL
    return {
      code: 200,
      data: {
        url: fileUrl
      }
    };
  } catch (error) {
    console.error('文件上传失败:', error);
    return {
      code: 500,
      message: '文件上传失败'
    };
  }
}

// 替换原来的uploadAvatar方法
export function uploadAvatar(file) {
  return uploadFileWithPresignedUrl(file);
}

// 添加修改密码API
export function changePassword(data) {
  return request({
    url: '/users/change-password',
    method: 'post',
    data
  });
}