package com.im.backend.repository;

import com.im.backend.model.ChatMessage;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    /**
     * 根据会话ID查询消息列表，支持分页
     * 
     * @param conversationId 会话ID
     * @param pageable 分页参数
     * @return 消息分页列表
     */
    Page<ChatMessage> findByConversationId(Long conversationId, Pageable pageable);
    
    /**
     * 根据会话ID删除所有聊天记录
     * 
     * @param conversationId 会话ID
     */
    @Modifying
    @Transactional
    void deleteByConversationId(Long conversationId);
}