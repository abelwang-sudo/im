package com.im.backend.controller;

import com.im.backend.config.exception.BusinessException;
import com.im.backend.config.security.AuthUserDetails;
import com.im.backend.dto.ApiResponse;
import com.im.backend.dto.CreateConversationRequest;
import com.im.backend.dto.UpdateConversationRequest;
import com.im.backend.model.ChatMessage;
import com.im.backend.model.Conversation;
import com.im.backend.model.ConversationJoinApplication;
import com.im.backend.model.ConversationMember;
import com.im.backend.model.types.ApplicationStatus;
import com.im.backend.model.types.MemberRole;
import com.im.backend.service.ChatMessageService;
import com.im.backend.service.ConversationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/conversations")
public class ConversationController extends BaseController {

    @Autowired
    private ConversationService conversationService;
    
    @Autowired
    private ChatMessageService chatMessageService;

    /**
     * 创建会话
     */
    @PostMapping
    public ApiResponse<Conversation> createConversation(@RequestBody CreateConversationRequest request, @AuthenticationPrincipal AuthUserDetails userDetails) {
        Conversation conversation = conversationService.createConversation(
                request.getType(),
                userDetails.getId(),
                request.getMemberIds(),
                request.getAvatar()
        );
        return ApiResponse.success(conversation);
    }

    /**
     * 获取用户的会话列表
     */
    @GetMapping
    public ApiResponse<List<Conversation>> getUserConversations(
            @AuthenticationPrincipal AuthUserDetails auth) {
        List<Conversation> conversations = conversationService.getUserConversations(auth.getId());
        return ApiResponse.success(conversations);
    }

    /**
     * 邀请成员加入会话
     */
    @PostMapping("/{conversationId}/members")
    public ApiResponse<Void> inviteMembers(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @RequestBody List<Long> memberIds) {
        conversationService.inviteMembers(conversationId, auth.getId(), memberIds);
        return ApiResponse.success(null);
    }

    /**
     *  移除会话成员 (只支持群聊)
     */
    @DeleteMapping("/{conversationId}/members/{memberId}")
    public ApiResponse<Void> removeMember(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @PathVariable Long memberId) {
        // 检查用户是否是管理员或群主
        ConversationMember operator = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(auth.getId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("您不是该群聊的成员"));

        // 检查被移除的成员
        ConversationMember targetMember = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(memberId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("要移除的成员不存在"));

        // 权限检查：
        // 1. 群主可以移除任何人
        // 2. 管理员可以移除普通成员
        // 3. 不能移除群主
        if (targetMember.getRole() == MemberRole.OWNER) {
            return ApiResponse.error(403, "不能移除群主");
        }
        
        if (operator.getRole() != MemberRole.OWNER && 
            (operator.getRole() != MemberRole.ADMIN || targetMember.getRole() == MemberRole.ADMIN)) {
            return ApiResponse.error(403, "您没有权限执行此操作");
        }

        conversationService.removeMember(conversationId, memberId, auth.getId());
        return ApiResponse.success(null);
    }

    /**
     * 设置会话管理员 (只支持群聊)
     */
    @PutMapping("/{conversationId}/members/{memberId}/role")
    public ApiResponse<Void> setMemberRole(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @PathVariable Long memberId,
            @RequestParam boolean isAdmin) {
        // 检查操作者权限
        ConversationMember operator = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(auth.getId()))
                .findFirst()
                .orElseThrow(() -> new BusinessException("您不是该群聊的成员"));

        // 只有群主可以设置管理员
        if (operator.getRole() != MemberRole.OWNER) {
            return ApiResponse.error(403, "只有群主可以设置管理员");
        }

        // 检查目标成员
        ConversationMember targetMember = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(memberId))
                .findFirst()
                .orElseThrow(() -> new BusinessException("目标成员不存在"));

        // 不能修改群主的角色
        if (targetMember.getRole() == MemberRole.OWNER) {
            return ApiResponse.error(403, "不能修改群主的角色");
        }

        conversationService.updateMemberRole(conversationId, memberId, auth.getId(), isAdmin);
        return ApiResponse.success(null);
    }

    /**
     * 退出会话 (只支持群聊)
     */
    @PostMapping("/{conversationId}/quit")
    public ApiResponse<Void> quitConversation(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId) {
        conversationService.quitConversation(conversationId, auth.getId());
        return ApiResponse.success(null);
    }


    /**
     *  获取请求加入会话的列表 (只支持群聊)
     */
    @GetMapping("/{conversationId}/join-requests")
    public ApiResponse<List<ConversationJoinApplication>> getJoinRequests(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @RequestParam(required = false) ApplicationStatus status) {
        // 检查用户是否是管理员或群主
        ConversationMember member = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(auth.getId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("您不是该群聊的成员"));

        if (member.getRole() != MemberRole.OWNER && member.getRole() != MemberRole.ADMIN) {
            return ApiResponse.error(403, "只有群主或管理员可以查看入群申请");
        }

        List<ConversationJoinApplication> applications = conversationService.getJoinApplications(conversationId, status);
        return ApiResponse.success(applications);
    }

    /**
     * 处理入群申请
     */
    @PostMapping("/{conversationId}/join-requests/{applicationId}")
    public ApiResponse<Void> handleJoinRequest(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @PathVariable Long applicationId,
            @RequestParam boolean approved) {
        // 检查用户是否是管理员或群主
        ConversationMember member = conversationService.getConversationMember(conversationId)
                .stream()
                .filter(m -> m.getUserId().equals(auth.getId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("您不是该群聊的成员"));

        if (member.getRole() != MemberRole.OWNER && member.getRole() != MemberRole.ADMIN) {
            return ApiResponse.error(403, "只有群主或管理员可以处理入群申请");
        }

        conversationService.handleJoinApplication(applicationId, auth.getId(), approved);
        return ApiResponse.success(null);
    }


    /**
     * 获取会话成员列表
     */
    @GetMapping("/{conversationId}/members")
    public ApiResponse<List<ConversationMember>> getConversationMembers(
            @PathVariable Long conversationId) {
        List<ConversationMember> memberIds = conversationService.getConversationMember(conversationId);
        return ApiResponse.success(memberIds);
    }

    /**
     * 修改群聊名称
     */
    @PutMapping("/{conversationId}/name")
    public ApiResponse<Void> updateConversationName(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @RequestParam String name) {
        conversationService.updateConversationName(conversationId, auth.getId(), name);
        return ApiResponse.success(null);
    }
    
    /**
     * 更新会话信息（头像、名称、设置等）
     */
    @PutMapping("/{conversationId}")
    public ApiResponse<Void> updateConversationInfo(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @RequestBody UpdateConversationRequest request) {
        conversationService.updateConversationInfo(conversationId, auth.getId(), request);
        return ApiResponse.success(null);
    }
    
    /**
     * 获取会话消息列表
     */
    @GetMapping("/{conversationId}/messages")
    public ApiResponse<Page<ChatMessage>> getConversationMessages(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        // 检查用户是否是会话成员
        List<Long> memberIds = conversationService.getConversationMemberIds(conversationId);
        if (!memberIds.contains(auth.getId())) {
            return ApiResponse.error(403, "您不是该会话的成员");
        }
        
        // 创建分页请求，按时间倒序排列
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "timestamp"));
        
        // 获取消息列表
        Page<ChatMessage> messages = chatMessageService.getConversationMessages(conversationId, pageRequest);
        return ApiResponse.success(messages);
    }
    
    /**
     * 将会话标记为已读
     */
    @PostMapping("/{conversationId}/read")
    public ApiResponse<Void> markConversationAsRead(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId) {
        // 检查用户是否是会话成员
        List<Long> memberIds = conversationService.getConversationMemberIds(conversationId);
        if (!memberIds.contains(auth.getId())) {
            return ApiResponse.error(403, "您不是该会话的成员");
        }
        
        // 标记会话为已读
        conversationService.markConversationAsRead(conversationId, auth.getId());
        return ApiResponse.success(null);
    }
    
    /**
     * 删除会话及其相关的聊天记录
     */
    @DeleteMapping("/{conversationId}")
    public ApiResponse<Void> deleteConversation(
            @AuthenticationPrincipal AuthUserDetails auth,
            @PathVariable Long conversationId) {
        conversationService.deleteConversation(conversationId, auth.getId());
        return ApiResponse.success(null);
    }
}