import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_mobile/models/join_request_model.dart';
import 'package:im_mobile/providers/conversation_member_provider.dart';
import 'package:im_mobile/providers/conversation_provider.dart';
import 'package:im_mobile/services/conversation_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/toast_util.dart';

class JoinRequestsPage extends ConsumerStatefulWidget {
  final int conversationId;

  const JoinRequestsPage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  ConsumerState<JoinRequestsPage> createState() => _JoinRequestsPageState();
}

class _JoinRequestsPageState extends ConsumerState<JoinRequestsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleJoinRequest(int applicationId, bool approved) async {
    try {
      await ConversationService.handleJoinRequest(
        widget.conversationId,
        applicationId,
        approved,
      );
      ref.refresh(joinRequestsProvider(widget.conversationId));
      if(approved){
         ref.read(conversationMembersProvider(widget.conversationId).notifier).load();
      }
      ToastUtil.show(approved ? '已通过申请' : '已拒绝申请');
    } catch (e) {
      Log.e('JoinRequestsPage', '处理入群申请失败', e);
      ToastUtil.showError('处理申请失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('入群申请'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ref.watch(joinRequestsProvider(widget.conversationId)).when(
        data: (requests) {
          List<JoinRequestModel> pending =
              requests.where((r) => r.status == "PENDING").toList();
          if (pending.isEmpty) {
            return GestureDetector(
              onTap: () async {
                ref.refresh(joinRequestsProvider(widget.conversationId));
              },
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('暂无入群申请', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(joinRequestsProvider(widget.conversationId));
            },
            child: ListView.builder(
              itemCount: pending.length,
              itemBuilder: (context, index) {
                final request = pending[index];
                return _buildRequestItem(request);
              },
            ),
          );
        },
        error: (e, s) => SizedBox(),
        loading: () => SizedBox());
  }

  Widget _buildRequestItem(JoinRequestModel request) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
            backgroundImage: request.applicant?.avatar != null
                ? NetworkImage(request.applicant!.avatar!)
                : null,
            child: request.applicant?.avatar == null
                ? Text(
                    _getInitials(request.applicant?.nickname ?? ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.applicant?.nickname ?? '未知用户',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request.reason ?? '',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              if (request.status == "PENDING")
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _handleJoinRequest(request.id, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('拒绝'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _handleJoinRequest(request.id, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('通过'),
                    ),
                  ],
                )
            ],
          ))
        ]));
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    return name.substring(0, 1).toUpperCase();
  }
}
