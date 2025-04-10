import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/pages/change_password_page.dart';
import 'package:im_mobile/pages/chat_page.dart';
import 'package:im_mobile/pages/login_page.dart';
import 'package:im_mobile/pages/welcome_page.dart';
import 'package:im_mobile/pages/register_page.dart';
import 'package:im_mobile/pages/home_page.dart';
import 'package:im_mobile/pages/friend_requests_page.dart';
import 'package:im_mobile/pages/select_contacts_page.dart';
import 'package:im_mobile/pages/create_group_page.dart';
import 'package:im_mobile/pages/group_list_page.dart';
import 'package:im_mobile/pages/conversation_detail_page.dart';
import 'package:im_mobile/pages/create_post_page.dart';
import 'package:im_mobile/providers/user_provider.dart';

// 创建一个全局的 ProviderContainer 用于在路由中访问 Provider
final container = ProviderContainer();

final router = GoRouter(
  initialLocation: '/',
  // 添加重定向逻辑
  redirect: (context, state) {
    // 获取当前用户状态
    final user = container.read(userProvider);
    final isLoggedIn = user != null;

    // 不需要登录就能访问的路径
    final publicPaths = ['/login', '/register', '/'];
    final isPublicPath = publicPaths.contains(state.uri.path);

    // 如果用户已登录且访问的是公共页面，重定向到首页
    if (isLoggedIn && isPublicPath) {
      return '/home';
    }

    // 如果用户未登录且访问的不是公共页面，重定向到欢迎页
    if (!isLoggedIn && !isPublicPath) {
      return '/';
    }

    // 其他情况不重定向
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
     GoRoute(
      path: '/chat/:conversationId',
      builder: (context, state) => ChatPage(
        conversationId: int.parse(state.pathParameters['conversationId']!),
      ),
    ),
        GoRoute(
      path: '/change-password',
      builder: (context, state) =>  ChangePasswordPage(),
    ),
    GoRoute(
      path: '/friend-requests',
      builder: (context, state) => const FriendRequestsPage(),
    ),
    GoRoute(
      path: '/select-contacts',
      builder: (context, state) => const SelectContactsPage(),
    ),
    GoRoute(
      path: '/groups',
      builder: (context, state) => const GroupListPage(),
    ),
    GoRoute(
      path: '/create-post',
      builder: (context, state) => const CreatePostPage(),
    ),
  ],
);