import 'package:im_mobile/models/group_model.dart';
import 'package:im_mobile/services/group_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/providers/user_groups_provider.g.dart';

@Riverpod(keepAlive: true)
class UserGroups extends _$UserGroups {
  @override
  List<GroupModel> build() {
    // 初始化时加载群组列表
    loadUserGroups();
    return [];
  }

  // 加载用户加入的群组列表
  Future<void> loadUserGroups() async {
    try {
      final groups = await GroupService.getUserGroups();
      state = groups;
      Log.i('UserGroups', '加载群组列表成功: ${groups.length}个群组');
    } catch (e, stackTrace) {
      Log.e('UserGroups', '加载群组列表失败', e, stackTrace);
    }
  }

  // 刷新群组列表
  Future<void> refreshGroups() async {
    await loadUserGroups();
  }
}
