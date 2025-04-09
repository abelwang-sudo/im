package com.im.backend.controller;

import com.im.backend.config.security.AuthUserDetails;
import com.im.backend.dto.*;
import com.im.backend.model.Conversation;
import com.im.backend.model.Group;
import com.im.backend.model.User;
import com.im.backend.service.GroupService;
import com.im.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 群聊相关的控制器
 */
@RestController
@RequestMapping("/api/groups")
public class GroupChatController extends BaseController {

    @Autowired
    private GroupService groupService;

    @Autowired
    private UserService userService;

    /**
     * 创建群聊
     */
    @PostMapping
    public ApiResponse<Conversation> createGroup(
            @AuthenticationPrincipal AuthUserDetails auth,
            @RequestBody CreateGroupRequest request) {
        try {
            // 构建settings
            Map<String, Object> settings = new HashMap<>();
            settings.put("requireApproval", request.getRequireApproval());
            settings.put("onlyAdminCanInvite", request.getOnlyAdminCanInvite());
            settings.put("onlyAdminCanSpeak", request.getOnlyAdminCanSpeak());

            // 获取用户对象
            User owner = userService.getUserById(auth.getId());

            Conversation group = groupService.createGroup(
                    owner,
                    request.getName(),
                    request.getAvatar(),
                    request.getDescription(),
                    request.getMemberIds(),
                    settings
            );

            return ApiResponse.success(group);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

    /**
     * 获取群聊详情
     */
    @GetMapping("/{groupId}")
    public ApiResponse<Group> getGroupDetail(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long groupId) {
        try {
            Group group = groupService.findById(groupId);
            return ApiResponse.success(group);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

    /**
     * 更新群聊信息（名称、头像、简介）
     */
    @PutMapping("/{groupId}")
    public ApiResponse<Group> updateGroupInfo(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long groupId,
            @RequestBody UpdateGroupInfoRequest request) {
        try {
            // 验证名称（如果提供）不为空
            if (request.getName() != null && request.getName().isEmpty()) {
                return ApiResponse.error(400, "群聊名称不能为空");
            }

            // 验证头像（如果提供）不为空
            if (request.getAvatar() != null && request.getAvatar().isEmpty()) {
                return ApiResponse.error(400, "群聊头像不能为空");
            }

            Group group = groupService.updateGroupInfo(
                groupId,
                auth.getId(),
                request.getName(),
                request.getAvatar(),
                request.getDescription()
            );

            return ApiResponse.success(group);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

    /**
     * 更新群聊设置
     */
    @PutMapping("/{groupId}/settings")
    public ApiResponse<Void> updateGroupSettings(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long groupId,
            @RequestBody UpdateGroupSettingsRequest request) {
        try {
            groupService.updateGroupSettings(groupId, auth.getId(), request.toMap());
            return ApiResponse.success(null);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

    /**
     * 解散群聊
     */
    @DeleteMapping("/{groupId}")
    public ApiResponse<Void> dismissGroup(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long groupId) {
        try {
            groupService.dismissGroup(groupId, auth.getId());
            return ApiResponse.success(null);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

    /**
     * 获取用户加入的所有群组
     */
    @GetMapping
    public ApiResponse<List<Group>> getUserGroups(
            @AuthenticationPrincipal AuthUserDetails auth) {
        try {
            List<Group> groups = groupService.getUserGroups(auth.getId());
            return ApiResponse.success(groups);
        } catch (Exception e) {
            return ApiResponse.error(500, e.getMessage());
        }
    }

}