import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/contact_model.dart';
import 'package:im_mobile/pages/create_group_page.dart';
import 'package:im_mobile/providers/friendship_provider.dart';

class SelectContactsPage extends ConsumerStatefulWidget {
  final bool forInvite;

  const SelectContactsPage({
    Key? key,
    this.forInvite = false,
  }) : super(key: key);

  @override
  ConsumerState<SelectContactsPage> createState() => _SelectContactsPageState();
}

class _SelectContactsPageState extends ConsumerState<SelectContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<ContactModel> _selectedContacts = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择联系人'),
        actions: [
          TextButton(
            onPressed: _selectedContacts.isEmpty
                ? null
                : () {
                    if (widget.forInvite) {
                      // 如果是邀请成员模式，返回选中的联系人 ID
                      final selectedIds = _selectedContacts.map((c) => c.id).toList();
                      Navigator.of(context).pop(selectedIds);
                    } else {
                      // 如果是创建群聊模式，跳转到创建群聊页面
                      Navigator.of(context).push<List<ContactModel>>(
                        MaterialPageRoute(
                          builder: (context) => CreateGroupPage(
                            initialSelectedContacts: _selectedContacts,
                          ),
                        ),
                      ).then((updatedContacts) {
                        // 如果有更新的联系人列表返回，则更新选中状态
                        if (updatedContacts != null) {
                          setState(() {
                            _selectedContacts.clear();
                            _selectedContacts.addAll(updatedContacts);
                          });
                        }
                      });
                    }
                  },
            child: Text(
              widget.forInvite ? '确定 (${_selectedContacts.length})' : '下一步 (${_selectedContacts.length})',
              style: TextStyle(
                color: _selectedContacts.isEmpty ? Colors.grey : Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索联系人',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    final contacts = ref.watch(contactProvider);

    // 根据搜索过滤好友列表
    final filteredFriends = _searchQuery.isEmpty
        ? contacts
        : contacts
            .where((friend) =>
                friend.username.toLowerCase().contains(_searchQuery) ||
                (friend.nickname?.toLowerCase() ?? '')
                    .contains(_searchQuery))
            .toList();

    if (filteredFriends.isEmpty) {
      return const Center(child: Text('没有找到联系人'));
    }

    return ListView.builder(
      itemCount: filteredFriends.length,
      itemBuilder: (context, index) {
        final friend = filteredFriends[index];
        final isSelected = _selectedContacts.any((c) => c.id == friend.id);

        return ListTile(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedContacts.removeWhere((c) => c.id == friend.id);
              } else {
                _selectedContacts.add(friend);
              }
            });
          },
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: friend.avatar != null ? NetworkImage(friend.avatar!) : null,
                child: friend.avatar == null
                    ? Text(
                        _getInitials(friend.nickname ?? friend.username),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              if (isSelected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            friend.nickname ?? friend.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  if (!isSelected) {
                    _selectedContacts.add(friend);
                  }
                } else {
                  _selectedContacts.removeWhere((c) => c.id == friend.id);
                }
              });
            },
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return '';
  }
}
