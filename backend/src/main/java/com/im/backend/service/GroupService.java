package com.im.backend.service;

import com.im.backend.model.Conversation;
import com.im.backend.model.Group;
import com.im.backend.model.User;

import java.util.List;
import java.util.Map;

/**
 * 群聊服务接口
 */
public interface GroupService {
    /**
     * 创建群聊
     */
    Conversation createGroup(User owner, String name, String avatar, String description, List<Long> initialMemberIds, Map<String, Object> settings);

    /**
     * 更新群聊信息
     */
    Group updateGroupInfo(Long groupId, Long userId, String name, String avatar, String description);

    /**
     * 更新群聊设置
     */
    void updateGroupSettings(Long groupId, Long userId, Map<String, Object> settings);

    /**
     * 解散群聊
     */
    void dismissGroup(Long groupId, Long userId);

    /**
     * 获取用户加入的所有群组
     *
     * @param userId 用户ID
     * @return 用户加入的群组列表
     */
    List<Group> getUserGroups(Long userId);

    Group findById(Long groupId);
}
