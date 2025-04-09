import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/providers/user_provider.dart';
import 'package:im_mobile/services/group_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:im_mobile/models/contact_model.dart';
import 'package:im_mobile/utils/toast_util.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  final List<ContactModel> initialSelectedContacts;

  const CreateGroupPage({
    Key? key,
    required this.initialSelectedContacts,
  }) : super(key: key);

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _avatarFile;
  bool _isLoading = false;
  late List<ContactModel> _selectedContacts;

  @override
  void initState() {
    super.initState();
    // 初始化选中的联系人列表
    _selectedContacts = List.from(widget.initialSelectedContacts);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarFile = File(image.path);
      });
    }
  }

  Future<void> _createGroup() async {
    if (_nameController.text.trim().isEmpty) {
      ToastUtil.show('请输入群名称');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 上传头像（如果有）
      String? avatarUrl;
      if (_avatarFile != null) {
        final success = await ref.read(userProvider.notifier).uploadAvatar(_avatarFile!);
        if (success) {
          final user = ref.read(userProvider);
          avatarUrl = user?.avatar;
        }
      }

      // 获取所有选中联系人的ID
      final List<int> memberIds = _selectedContacts.map((c) => c.id).toList();

      // 创建群组
      final conversation = await GroupService.createGroup(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        memberIds: memberIds,
        avatar: avatarUrl,
      );

      if (conversation != null) {
        ToastUtil.show('群组创建成功');
        ref.read(conversationControllerProvider.notifier).addConversation(conversation);
        // 创建成功后，返回到会话页面
        if (mounted) {
          context.go('/home');
        }
      } else {
        ToastUtil.show('群组创建失败');
      }
    } catch (e) {
      ToastUtil.show('发生错误: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建群聊'),
        // 添加返回按钮的点击事件，确保在点击返回时也传递更新后的联系人列表
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_selectedContacts);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _avatarFile != null
                                ? FileImage(_avatarFile!)
                                : null,
                            child: _avatarFile == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '群名称',
                      hintText: '请输入群名称',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: '群简介',
                      hintText: '请输入群简介',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '群成员',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('已选择 ${_selectedContacts.length} 位联系人'),
                            if (_selectedContacts.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedContacts.clear();
                                  });
                                },
                                child: const Text('清除全部', style: TextStyle(color: Colors.red)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedContacts.map((contact) {
                            return Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  _getInitials(contact.nickname ?? contact.username),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              label: Text(contact.nickname ?? contact.username),
                              deleteIcon: const Icon(Icons.cancel, size: 18),
                              onDeleted: () {
                                setState(() {
                                  _selectedContacts.removeWhere((c) => c.id == contact.id);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        if (_selectedContacts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Text('请至少选择一位联系人', style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedContacts.isEmpty ? null : _createGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedContacts.isEmpty ? Colors.grey[300] : Colors.blue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[500],
                      ),
                      child: const Text(
                        '创建群聊',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    return name.substring(0, 1).toUpperCase();
  }
}
