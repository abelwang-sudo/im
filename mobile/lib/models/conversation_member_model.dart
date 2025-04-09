import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/conversation_member_model.freezed.dart';
part '../generated/models/conversation_member_model.g.dart';

@freezed
abstract class ConversationMemberModel with _$ConversationMemberModel {
    const ConversationMemberModel._(); // 添加私有构造函数以支持自定义方法

    const factory ConversationMemberModel({
        /// id
        required int id,

        /// conversationId
        required int conversationId,

        /// userId
        required int userId,

        /// nickname
        required String? nickname,

        /// displayName
        required String? displayName,

        /// avatar
        String? avatar,
        String? role,

        /// unreadCount
        required int unreadCount,

        /// createdAt
        required int createdAt,

        /// updatedAt
        required int updatedAt,
    }) = _ConversationMemberModel;

    /// 从JSON映射创建ConversationMemberModel实例
    factory ConversationMemberModel.fromJson(Map<String, dynamic> json) => 
        _$ConversationMemberModelFromJson(json);

}