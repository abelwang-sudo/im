import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import RegisterView from '../views/RegisterView.vue'
import { useUserStore } from '@/stores/user'
import WelcomeView from '@/views/WelcomeView.vue'
import ContactsView from '@/views/ContactsView.vue'
import TabBarLayout from '@/components/layout/TabBarLayout.vue'
import ChatDetailView from '@/views/ChatDetailView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'root',
      component: WelcomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView
    },
    {
      path: '/contacts',
      name: 'contacts',
      component: ContactsView,
      keepAlive: true,
      meta: { requiresAuth: true }
    },
    {
      path: '/home',
      name: 'home',
      component: TabBarLayout,
      keepAlive: true,
      meta: { requiresAuth: true }
    },
    {
      path: '/chat/:id',
      name: 'chat-detail',
      component: ChatDetailView,

      meta: { requiresAuth: true }
    },
  ]
})

// 全局前置守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  // 检查路由是否需要认证
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // 如果需要认证且用户未登录，重定向到登录页
    if (!userStore.isAuthenticated) {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
    } else {
      next() // 已登录，正常导航
    }
  } else {
    next() // 不需要认证，正常导航
  }
})

export default router
