package com.im.backend.service;

import com.im.backend.dto.UpdateConversationRequest;
import com.im.backend.model.ChatMessage;
import com.im.backend.model.Conversation;
import com.im.backend.model.ConversationJoinApplication;
import com.im.backend.model.ConversationMember;
import com.im.backend.model.types.ApplicationStatus;
import com.im.backend.model.types.ConversationType;

import java.util.List;

public interface ConversationService {
    /**
     * 创建会话
     *
     * @param type 会话类型（单聊/群聊）
     * @param creatorId 创建者ID
     * @param memberIds 成员ID列表
     * @return 创建的会话
     */
    // 添加新的方法签名，支持传入头像参数
    Conversation createConversation(ConversationType type, Long creatorId, List<Long> memberIds, String avatar);

    /**
     * 获取用户的会话列表
     *
     * @param userId 用户ID
     * @return 会话列表
     */
    List<Conversation> getUserConversations(Long userId);

    /**
     * 邀请成员加入会话
     *
     * @param conversationId 会话ID
     * @param inviterId 邀请人ID
     * @param memberIds 被邀请的成员ID列表
     */
    void inviteMembers(Long conversationId, Long inviterId, List<Long> memberIds);

    /**
     * 更新会话的最后一条消息信息
     *
     * @param conversationId 会话ID
     * @param message 消息ID
     */
    void updateLastMessage(Long conversationId, ChatMessage message);

    /**
     * 获取会话成员ID列表
     *
     * @param conversationId 会话ID
     * @return 成员ID列表
     */
    List<Long> getConversationMemberIds(Long conversationId);

    /**
     * 修改会话名称
     *
     * @param conversationId 会话ID
     * @param userId 操作用户ID
     * @param name 新的会话名称
     */
    void updateConversationName(Long conversationId, Long userId, String name);


    /**
     * 将用户在指定会话中的消息标记为已读
     *
     * @param conversationId 会话ID
     * @param userId         用户ID
     */
    public void markConversationAsRead(Long conversationId, Long userId);
    
    /**
     * 删除会话及其相关的聊天记录
     *
     * @param conversationId 会话ID
     * @param userId 操作用户ID
     */
    void deleteConversation(Long conversationId, Long userId);
    void quitConversation(Long conversationId, Long userId);
    
    /**
     * 更新会话信息
     *
     * @param conversationId 会话ID
     * @param userId 操作用户ID
     * @param request 更新请求
     */
    void updateConversationInfo(Long conversationId, Long userId, UpdateConversationRequest request);

    List<ConversationMember> getConversationMember(Long conversationId);
    List<ConversationJoinApplication> getJoinApplications(Long conversationId, ApplicationStatus status);

    void handleJoinApplication(Long applicationId, Long reviewerId, boolean approved);
    void removeMember(Long conversationId, Long memberId, Long operatorId);
    void updateMemberRole(Long conversationId, Long memberId, Long operatorId, boolean isAdmin);
}