<script setup>
import { ref } from 'vue';
import { register } from '@/api/user';
import { useRouter } from 'vue-router';
import { useForm, useField } from 'vee-validate';
import * as yup from 'yup';

const router = useRouter();
const errorMessage = ref('');
const loading = ref(false);

const schema = yup.object().shape({
  email: yup.string().required('请输入邮箱').email('请输入有效的邮箱地址'),
  password: yup.string().required('请输入密码').min(6, '密码至少6个字符'),
  confirmPassword: yup.string().required('请确认密码').oneOf([yup.ref('password')], '两次输入的密码不一致')
});

const { handleSubmit } = useForm({
  validationSchema: schema
});

const { value: email, errorMessage: emailError } = useField('email');
const { value: password, errorMessage: passwordError } = useField('password');
const { value: confirmPassword, errorMessage: confirmPasswordError } = useField('confirmPassword');

const handleSignUp = handleSubmit(async (values) => {
  loading.value = true;
  errorMessage.value = '';

  try {
    const response = await register({
      email: values.email,
      password: values.password
    });
    if(response.code === 200){
      router.push('/login');
    }
  } catch (error) {
    errorMessage.value = error.response?.data?.error || '注册失败，请重试';
  } finally {
    loading.value = false;
  }
});
</script>

<template>
  <div class="w-full h-screen flex items-center justify-center bg-gray-50">
    <div class="w-full max-w-md p-8 bg-white rounded-2xl space-y-8 shadow-lg">
      <div class="text-center space-y-2">
        <h1 class="text-3xl font-bold text-gray-900">注册账号</h1>
      </div>

      <form class="space-y-6" @submit.prevent="handleSignUp">
        <div class="space-y-2">
          <input
            v-model="email"
            type="email"
            placeholder="邮件"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition-colors duration-200"
            required
            autocomplete="username"
          />
          <span v-if="emailError" class="text-red-500 text-sm">{{ emailError }}</span>
        </div>

        <div class="space-y-2">
          <input
            v-model="password"
            type="password"
            placeholder="密码"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition-colors duration-200"
            required
            autocomplete="new-password"
          />
          <span v-if="passwordError" class="text-red-500 text-sm">{{ passwordError }}</span>
        </div>

        <div class="space-y-2">
          <input
            v-model="confirmPassword"
            type="password"
            placeholder="确认密码"
            class="w-full px-4 py-3 rounded-xl border border-gray-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition-colors duration-200"
            required
            autocomplete="new-password"
          />
          <span v-if="confirmPasswordError" class="text-red-500 text-sm">{{ confirmPasswordError }}</span>
        </div>

        <div v-if="errorMessage" class="text-red-500 text-sm text-center">
          {{ errorMessage }}
        </div>

        <button
          type="submit"
          class="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl text-lg font-semibold text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
          :disabled="loading"
        >
          <span v-if="loading">注册中...</span>
          <span v-else>注册</span>
        </button>
      </form>

      <p class="text-center text-gray-600">
       已经有账号?
        <a href="/login" class="text-blue-600 hover:text-blue-700 font-semibold">登录</a>
      </p>
    </div>
  </div>
</template>
