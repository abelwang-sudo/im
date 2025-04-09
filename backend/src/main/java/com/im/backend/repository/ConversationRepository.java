package com.im.backend.repository;

import com.im.backend.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface ConversationRepository extends JpaRepository<Conversation, Long> {
    /**
     * 查询用户参与的所有会话
     */
    @Query("SELECT new Conversation(c,m)  FROM Conversation c " +
            "JOIN ConversationMember m ON c.id = m.conversationId " +
            "WHERE m.userId = :userId AND m.visible = true " +
            "ORDER BY c.updatedAt DESC")
    List<Conversation> findByMemberUserIdWithDisplayName(@Param("userId") Long userId);

    @Query("SELECT new Conversation(c, m) FROM Conversation c JOIN ConversationMember m ON c.id = m.conversationId WHERE c.id = :conversationId AND m.userId = :userId")
    Conversation findByConversationId(@Param("conversationId") Long conversationId, @Param("userId") Long userId);

    /**
     * 查询会话的所有成员ID
     */
    /**
     * 根据会话ID查询所有成员ID
     */
    @Query("SELECT cm.userId FROM ConversationMember cm WHERE cm.conversationId = :conversationId")
    List<Long> findMemberIdsByConversationId(@Param("conversationId") Long conversationId);

    /**
     * 检查用户是否是会话成员
     */
    @Query("SELECT COUNT(m) > 0 FROM ConversationMember m WHERE m.conversationId = :conversationId AND m.userId = :userId")
    boolean existsByConversationIdAndUserId(@Param("conversationId") Long conversationId, @Param("userId") Long userId);

    /**
     * 查找两个用户之间的单聊会话
     */
    @Query("SELECT c FROM Conversation c WHERE c.type = 'PRIVATE' AND c.id IN " +
            "(SELECT m1.conversationId FROM ConversationMember m1 WHERE m1.userId = :userId1 AND m1.conversationId IN " +
            "(SELECT m2.conversationId FROM ConversationMember m2 WHERE m2.userId = :userId2))")
    List<Conversation> findPrivateConversationBetweenUsers(@Param("userId1") Long userId1, @Param("userId2") Long userId2);

    /**
     * 查找具有完全相同成员的群聊会话
     */
    @Query("SELECT c FROM Conversation c WHERE c.type = 'GROUP' AND " +
            "(SELECT COUNT(DISTINCT m1.userId) FROM ConversationMember m1 WHERE m1.conversationId = c.id) = :memberCount AND " +
            "NOT EXISTS (SELECT 1 FROM ConversationMember m2 WHERE m2.conversationId = c.id AND m2.userId NOT IN :memberIds) AND " +
            "(SELECT COUNT(DISTINCT m3.userId) FROM ConversationMember m3 WHERE m3.conversationId = c.id AND m3.userId IN :memberIds) = :memberCount")
    List<Conversation> findGroupConversationWithSameMembers(@Param("memberIds") List<Long> memberIds, @Param("memberCount") int memberCount);

    @Query("SELECT cm.userId FROM ConversationMember cm WHERE cm.conversationId = :conversationId AND cm.role IN ('OWNER', 'ADMIN')")
    List<Long> findAdminIdsByConversationId(@Param("conversationId") Long conversationId);
}