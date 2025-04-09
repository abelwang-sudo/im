package com.im.backend.repository;

import com.im.backend.model.ConversationMember;
import com.im.backend.model.types.MemberRole;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConversationMemberRepository extends JpaRepository<ConversationMember, Long> {
    /**
     * 根据会话ID和用户ID查询会话成员
     * 
     * @param conversationId 会话ID
     * @param userId 用户ID
     * @return 会话成员列表
     */
    List<ConversationMember> findByConversationIdAndUserId(Long conversationId, Long userId);
    
    List<ConversationMember> findByConversationId(Long conversationId);

    @Modifying
    @Transactional
    @Query("UPDATE ConversationMember cm SET cm.unreadCount = cm.unreadCount + 1 WHERE cm.conversationId = :conversationId AND cm.userId != :senderId")
    int incrementUnreadCountForMembers(Long conversationId, Long senderId);
    
    /**
     * 根据会话ID删除所有会话成员
     * 
     * @param conversationId 会话ID
     */
    @Modifying
    @Transactional
    void deleteByConversationId(Long conversationId);

    /**
     * 检查指定用户是否是指定会话的成员
     * 
     * @param conversationId 会话ID
     * @param userId 用户ID
     * @return 如果用户是会话成员则返回true，否则返回false
     */
    boolean existsByConversationIdAndUserId(Long conversationId, Long userId);

    /**
     * 根据会话ID和角色查询会话成员
     * 
     * @param conversationId 会话ID
     * @param role 角色
     * @return 会话成员列表
     */
    List<ConversationMember> findByConversationIdAndRole(Long conversationId, MemberRole role);
    
    /**
     * 根据会话ID和用户ID以及角色查询会话成员
     * 
     * @param conversationId 会话ID
     * @param userId 用户ID
     * @param role 角色
     * @return 会话成员对象
     */
    Optional<ConversationMember> findByConversationIdAndUserIdAndRole(Long conversationId, Long userId, MemberRole role);
    
    /**
     * 删除指定会话中的指定成员
     */
    void deleteByConversationIdAndUserId(Long conversationId, Long userId);
}