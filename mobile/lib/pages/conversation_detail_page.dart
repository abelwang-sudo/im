import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_mobile/models/conversation_member_model.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/models/join_request_model.dart';
import 'package:im_mobile/pages/join_requests_page.dart';
import 'package:im_mobile/pages/select_contacts_page.dart';
import 'package:im_mobile/providers/conversation_member_provider.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/providers/user_provider.dart';
import 'package:im_mobile/services/conversation_service.dart';
import 'package:im_mobile/services/group_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';

class ConversationDetailPage extends ConsumerStatefulWidget {
  final int id;

  const ConversationDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConversationDetailPage> createState() =>
      _ConversationDetailPageState();
}

class _ConversationDetailPageState
    extends ConsumerState<ConversationDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(conversationMembersProvider(widget.id).notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    ConversationModel conversationModel = ref.watch(
        conversationControllerProvider
            .select((e) => e.firstWhere((c) => c.id == widget.id)));
    return Scaffold(
        appBar: AppBar(
          title: const Text('会话详情'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(conversationModel),
              if (conversationModel.isGroup)
                _buildMembersList(conversationModel),
              _buildActions(conversationModel),
            ],
          ),
        ));
  }

  Widget _buildHeader(ConversationModel conversation) {
    final isGroup = conversation.type == 'GROUP';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              backgroundImage: conversation.avatar != null
                  ? NetworkImage(conversation.avatar!)
                  : null,
              child: conversation.avatar == null
                  ? Text(
                      _getInitials(conversation.name ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            conversation.member?.displayName ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isGroup && conversation.group != null) ...[
            const SizedBox(height: 8),
            Text(
              '群主: ${conversation.group!.owner?.nickname ?? conversation.group!.owner?.username ?? '未知'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (conversation.group!.description != null &&
                conversation.group!.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '群简介',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.group!.description!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildMembersList(ConversationModel conversation) {
    List<ConversationMemberModel> members =
        ref.watch(conversationMembersProvider(widget.id));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '成员列表 (${members.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                if (conversation.type == 'GROUP' && (conversation.isInvite)) ...[
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      List<int>? ids = await Navigator.of(context).push<List<int>>(
                        MaterialPageRoute(
                          builder: (context) =>
                          const SelectContactsPage(forInvite: true),
                        ),
                      );
                      ref
                          .read(conversationControllerProvider.notifier)
                          .inviteMembers(widget.id, ids);
                    },
                    icon: const Icon(Icons.person_add, size: 18),
                  )
                ],
                //增加进群申请按钮
                if (conversation.requireApproval && conversation.isAdmin)
                  ref.watch(joinRequestsProvider(widget.id)).when(
                      data: (requests) {
                        List<JoinRequestModel> pending = requests.where((r) => r.status == "PENDING").toList();
                        return Badge(
                          isLabelVisible: pending.isNotEmpty,
                          label: Text('${pending.length}'),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => JoinRequestsPage(
                                    conversationId: widget.id,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.approval, size: 18) ,
                          ),
                        );
                      },
                      error: (e, s) => SizedBox(),
                      loading: () => SizedBox())
              ],
            )

          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final isCurrentUser = member.userId == ref.read(userProvider)?.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage:
                    member.avatar != null ? NetworkImage(member.avatar!) : null,
                child: member.avatar == null
                    ? Text(
                        _getInitials(
                            member.displayName ?? member.nickname ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              title: Row(
                children: [
                  Text(member.nickname ?? '未知用户'),
                  if (isCurrentUser)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '我',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              subtitle: Text(member.role ?? '未知用户'),
              trailing: conversation.isGroupAndAdmin && !isCurrentUser
                  ? PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'remove') {
                          showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('移除成员'),
                              content: Text(
                                  '确定要将 ${member.displayName ?? member.nickname ?? "该成员"} 移出群聊吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    ref
                                        .read(conversationControllerProvider
                                            .notifier)
                                        .removeMember(widget.id, member);
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            ),
                          );
                        } else if (value == 'set_admin') {
                          ref
                              .read(conversationControllerProvider.notifier)
                              .setMemberRole(widget.id, member, 'ADMIN');
                        } else if (value == 'set_member') {
                          ref
                              .read(conversationControllerProvider.notifier)
                              .setMemberRole(widget.id, member, 'MEMBER');
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('移除成员'),
                        ),
                        if (member.role == "MEMBER")
                          const PopupMenuItem(
                            value: 'set_admin',
                            child: Text('设为管理员'),
                          ),
                        if (member.role == "ADMIN")
                          const PopupMenuItem(
                            value: 'set_member',
                            child: Text('设为普通成员'),
                          ),
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildActions(ConversationModel conversation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conversation.isGroup) ...[
            if (conversation.isGroupAndAdmin)
              ..._buildGroupSettings(conversation),
            if (conversation.isOwner)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('解散群聊', style: TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('解散群聊'),
                      content: const Text('确定要解散该群聊吗？此操作不可撤销！'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref
                                .read(conversationControllerProvider.notifier)
                                .dissolveGroup(conversation.group!.id);
                            if (mounted) {
                              context.go('/home');
                            }
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.orange),
                title:
                    const Text('退出群聊', style: TextStyle(color: Colors.orange)),
                onTap: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('退出群聊'),
                      content: const Text('确定要退出该群聊吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref
                                .read(conversationControllerProvider.notifier)
                                .quitGroup(conversation.group!.id);
                            Navigator.of(context).pop(true);
                            if (mounted) {
                              // 返回到会话列表页面
                              context.go('/home');
                            }
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildGroupSettings(ConversationModel conversation) {
    return [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          '群组设置',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SwitchListTile(
        title: const Text('加入群聊需要审核'),
        subtitle: const Text('开启后，新成员加入需要群主或管理员审核'),
        value: conversation.requireApproval,
        onChanged: (conversation.isAdmin)
            ? (value) => ref
                .read(conversationControllerProvider.notifier)
                .updateGroupSetting(conversation, 'requireApproval', value)
            : null,
      ),
      SwitchListTile(
        title: const Text('仅管理员可发言'),
        subtitle: const Text('开启后，只有群主和管理员可以发送消息'),
        value: conversation.onlyAdminCanSpeak,
        onChanged: (conversation.isAdmin)
            ? (value) => ref
                .read(conversationControllerProvider.notifier)
                .updateGroupSetting(conversation, 'onlyAdminCanSpeak', value)
            : null,
      ),
      SwitchListTile(
        title: const Text('仅管理员可邀请'),
        subtitle: const Text('开启后，只有群主和管理员可以邀请新成员'),
        value: conversation.onlyAdminCanInvite,
        onChanged: (conversation.isAdmin)
            ? (value) => ref
                .read(conversationControllerProvider.notifier)
                .updateGroupSetting(conversation, 'onlyAdminCanInvite', value)
            : null,
      ),
    ];
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    return name.substring(0, 1).toUpperCase();
  }
}
