<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

const handleLogin = () => {
  router.push('/login');
};

const handleRegister = () => {
  router.push('/register');
};
</script>

<template>
  <div class="w-full h-screen flex items-center justify-center">
    <div class="w-full max-w-md p-8 bg-white rounded-2xl space-y-8">
      <img src="/welcome_bg.png" alt="Welcome" class="w-full h-48 object-contain rounded-xl mb-6" />
      <div class="text-center space-y-6">
        <h1 class="text-4xl font-bold text-gray-900">IM</h1>
        <p class="text-lg text-gray-600">IM 系统</p>
      </div>

      <div class="space-y-4">
        <button
          @click="handleLogin"
          class="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl text-lg font-semibold text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200"
        >
          Login
        </button>
        <button
          @click="handleRegister"
          class="w-full flex justify-center py-4 px-4 border-2 border-blue-600 rounded-xl text-lg font-semibold text-blue-600 bg-white hover:bg-blue-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200"
        >
          Register
        </button>
      </div>
    </div>
  </div>
</template>
