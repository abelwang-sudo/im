import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/models/group_model.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/providers/user_groups_provider.dart';

class GroupListPage extends ConsumerStatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends ConsumerState<GroupListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的群聊'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索群聊',
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
            child: _buildGroupList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupList() {
    final groups = ref.watch(userGroupsProvider);

    // 根据搜索过滤群组列表
    final filteredGroups = _searchQuery.isEmpty
        ? groups
        : groups.where((group) =>
            group.name.toLowerCase().contains(_searchQuery) ||
            (group.description?.toLowerCase() ?? '').contains(_searchQuery)
          ).toList();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(userGroupsProvider.notifier).refreshGroups();
      },
      child: filteredGroups.isEmpty
          ? ListView(
              // 使用 ListView 而不是 Center 来支持下拉刷新
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 100), // 留出空间以便于下拉
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty
                            ? '未找到符合"$_searchQuery"的群聊'
                            : '暂无群聊',
                        style: TextStyle(color: Colors.grey)
                      ),
                      if (_searchQuery.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                            child: Text('清除搜索'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredGroups.length,
              itemBuilder: (context, index) {
                final group = filteredGroups[index];
                return _buildGroupItem(group);
              },
            ),
    );
  }

  Widget _buildGroupItem(GroupModel group) {
    return ListTile(
      onTap: () async {
        // 创建或获取与该群组的会话

        context.push('/chat/${group.conversationId}');
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        backgroundImage: group.avatar != null ? NetworkImage(group.avatar!) : null,
        child: group.avatar == null
            ? Text(
                _getInitials(group.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        group.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.description != null)
            Text(
              group.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
          if (group.owner != null)
            Text(
              '群主: ${group.owner!.nickname ?? group.owner!.username}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '群聊',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    return name.substring(0, 1).toUpperCase();
  }
}
