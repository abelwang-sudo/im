<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useForm, useField } from 'vee-validate';
import * as yup from 'yup';
import { useUserStore } from '@/stores/user';
import websocketService from "@/services/websocket.service.js";

const router = useRouter();
const userStore = useUserStore();
const errorMessage = ref('');
const loading = ref(false);

const schema = yup.object().shape({
    email: yup.string().required('请输入邮箱').email('请输入有效的邮箱地址'),
    password: yup.string().required('请输入密码').min(6, '密码至少6个字符')
});

const { handleSubmit } = useForm({
    validationSchema: schema
});

const { value: email, errorMessage: emailError } = useField('email');
const { value: password, errorMessage: passwordError } = useField('password');

const handleSignIn = handleSubmit(async (values) => {
    loading.value = true;
    errorMessage.value = '';
    try {
        // 使用userStore保存用户信息
        const loginSuccess = await userStore.login({
            username: values.email,
            password: values.password
        });

        if (loginSuccess) {
          // 初始化WebSocket服务并设置用户相关的监听器
          router.push('/home');
        } else {
            errorMessage.value = '登录失败，请重试';
        }
    } catch (error) {
        errorMessage.value = error.response?.data?.error || '登录失败，请重试';
    } finally {
        loading.value = false;
    }
});
</script>

<template>
    <div class="w-full h-screen flex items-center justify-center bg-gray-50">
        <div class="w-full max-w-md p-8 bg-white rounded-2xl space-y-8 shadow-lg">
            <div class="text-center space-y-2">
                <h1 class="text-3xl font-bold text-blue-600">登录</h1>
                <p class="text-gray-600">欢迎回来，我们想念你！</p>
            </div>

            <form class="space-y-6" @submit.prevent="handleSignIn">
                <div class="space-y-2">
                    <input v-model="email" type="email" placeholder="邮箱"
                        class="w-full px-4 py-3 rounded-xl border border-gray-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition-colors duration-200"
                        required autocomplete="username"/>
                    <p v-if="emailError" class="text-red-500 text-sm">{{ emailError }}</p>
                </div>

                <div class="space-y-2">
                    <input v-model="password" type="password" placeholder="密码"
                        class="w-full px-4 py-3 rounded-xl border border-gray-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition-colors duration-200"
                        required   autocomplete="current-password"/>
                    <p v-if="passwordError" class="text-red-500 text-sm">{{ passwordError }}</p>
                </div>

                <div class="flex justify-end">
                    <a href="#" class="text-blue-600 hover:text-blue-700 text-sm">忘记密码?</a>
                </div>

                <p v-if="errorMessage" class="text-red-500 text-sm text-center">{{ errorMessage }}</p>

                <button type="submit" :disabled="loading"
                    class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed">
                    <span>登录</span>
                </button>
            </form>

            <div class="text-center">
                <a href="/register" class="text-gray-600 hover:text-gray-800">注册新账号</a>
            </div>
<!--          -->

<!--            <div class="grid grid-cols-3 gap-4">-->
<!--                <button type="button"-->
<!--                    class="flex items-center justify-center p-3 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors duration-200">-->
<!--                    <img src="@/assets/google.png" alt="Google" class="w-6 h-6" />-->
<!--                </button>-->
<!--                <button type="button"-->
<!--                    class="flex items-center justify-center p-3 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors duration-200">-->
<!--                    <img src="@/assets/facebook.png" alt="Facebook" class="w-6 h-6" />-->
<!--                </button>-->
<!--                <button type="button"-->
<!--                    class="flex items-center justify-center p-3 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors duration-200">-->
<!--                    <img src="@/assets/apple.png" alt="Apple" class="w-6 h-6" />-->
<!--                </button>-->
<!--            </div>-->
        </div>
    </div>
</template>
