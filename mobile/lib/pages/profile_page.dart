import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/user_provider.dart';
import 'package:go_router/go_router.dart';

import '../utils/logger.dart'; // 导入 GoRouter

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  // 选择并上传头像
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      
      setState(() {
        _isLoading = true;
      });
      
      // 上传头像
      final File imageFile = File(image.path);
      await ref.read(userProvider.notifier).uploadAvatar(imageFile);
    } catch (e) {
     ToastUtil.show("头像上传失败");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 显示编辑昵称对话框
  void _showEditNicknameDialog() {
    final userState = ref.read(userProvider);
    _nicknameController.text = userState?.nickname ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑昵称'),
        content: TextField(
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: '昵称',
            hintText: '请输入新昵称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              if (_nicknameController.text.trim().isEmpty) {
                ToastUtil.show("昵称不能为空");
                return;
              }
              
              setState(() {
                _isLoading = true;
              });
              
              try {
                await ref.read(userProvider.notifier).updateUserInfo({
                  'nickname': _nicknameController.text.trim()
                });
                
                Navigator.pop(context);
                ToastUtil.show("昵称更新成功");

              } catch (e,s) {
                ToastUtil.show("昵称更新失败");
               Log.e("昵称更新失败", "昵称更新失败",e,s);
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  // 显示退出登录确认对话框
  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              // 清除用户数据
              await ref.read(userProvider.notifier).logout();
              
              // 关闭对话框
              Navigator.pop(context);
              
              // 导航到登录页面
              context.go('/login');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            children: [
              // 头像和用户信息部分
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: userState?.avatar != null && userState!.avatar!.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userState.avatar!),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.lightBlue[100],
                                child: Text(
                                  userState?.nickname?.substring(0, 1).toUpperCase() ?? 'U',
                                  style: const TextStyle(fontSize: 32, color: Colors.white),
                                ),
                              ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userState?.nickname ?? 'Puerto Rico',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${userState?.email ?? 'youremail@domain.com'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 设置选项卡片
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.edit_note,
                      title: '编辑个人资料',
                      onTap: _showEditNicknameDialog,
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: '语言',
                      trailing: '简体中文',
                      trailingColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              
              // 安全设置卡片
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.security,
                      title: '安全',
                      onTap: () {
                        context.push('/change-password');
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingItem(
                      icon: Icons.color_lens,
                      title: '主题',
                      trailing: '浅色模式',
                      trailingColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              
              // 退出登录按钮
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('退出登录', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailing,
    Color? trailingColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing != null 
        ? Text(
            trailing,
            style: TextStyle(
              color: trailingColor ?? Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          )
        : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}