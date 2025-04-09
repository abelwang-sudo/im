import axios from 'axios';
import {toast} from "@/main.js";

const service = axios.create({
    baseURL: 'http://localhost:8080/api',
    timeout: 5000
});

// 请求拦截器
service.interceptors.request.use(
    config => {
        // 从localStorage获取token
        const token = localStorage.getItem('token');
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    error => {
        console.error('请求错误：', error);
        return Promise.reject(error);
    }
);

// 响应拦截器
service.interceptors.response.use(
    response => {
        const res = response.data;
        // 处理业务层面的错误码
        if (res.code !== 200) {
            const message = res.message || '请求失败';
          toast.add({ severity: 'error', summary: '错误', detail: message, life: 3000 });

        }
        return res;
    },
    error => {
        let message = error.message;
        if (error.response) {
            switch (error.response.status) {
                case 400:
                    message = error.response.data.error || '请求参数错误';
                    break;
                case 401:
                    message = '未授权，请重新登录';
                    // 可以在这里处理登录过期的情况
                    break;
                case 403:
                    message = '拒绝访问';
                    break;
                case 404:
                    message = '请求错误,未找到该资源';
                    break;
                case 500:
                    message = '服务器端出错';
                    break;
                default:
                    message = error.response.data.error || '未知错误';
            }
        }
      toast.add({ severity: 'error', summary: '错误', detail: message, life: 3000 });
      return Promise.reject(error);
    }
);

export default service;
