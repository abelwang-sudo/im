import 'package:im_mobile/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/join_request_model.freezed.dart';
part '../generated/models/join_request_model.g.dart';

/// 群聊加入申请数据模型
@freezed
abstract class JoinRequestModel with _$JoinRequestModel {
  const factory JoinRequestModel({
    /// 申请ID
    required int id,
    
    /// 申请用户信息
    @JsonKey(name: 'applicant')
    UserModel? applicant,
    
    /// 会话ID
    @JsonKey(name: 'conversationId')
    required int conversationId,
    
    /// 申请理由
    @JsonKey(name: 'reason')
    String? reason,
    
    /// 申请状态：PENDING, APPROVED, REJECTED
    @JsonKey(name: 'status')
    required String status,
    
    /// 创建时间
    @JsonKey(name: 'createdAt')
    int? createdAt,
    
    /// 更新时间
    @JsonKey(name: 'updatedAt')
    int? updatedAt,
  }) = _JoinRequestModel;

  /// 从JSON映射创建JoinRequestModel实例
  factory JoinRequestModel.fromJson(Map<String, dynamic> json) => 
      _$JoinRequestModelFromJson(json);
}