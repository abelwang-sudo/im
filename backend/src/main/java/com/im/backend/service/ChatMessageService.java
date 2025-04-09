package com.im.backend.service;

import com.im.backend.model.ChatMessage;
import com.im.backend.model.Conversation;
import com.im.backend.model.ConversationMember;
import com.im.backend.repository.ChatMessageRepository;
import com.im.backend.repository.ConversationMemberRepository;
import com.im.backend.repository.ConversationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ChatMessageService {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private ConversationMemberRepository conversationMemberRepository;
    /**
     * 发送私聊消息
     */
    @Transactional
    public ChatMessage saveMessage(ChatMessage message) {
        // 保存消息
        message = chatMessageRepository.save(message);

        // 更新会话的最后一条消息信息
        updateConversationLastMessage(message);

        // 更新会话成员的未读消息计数
        conversationMemberRepository.incrementUnreadCountForMembers(message.getConversationId(), message.getSender());

        return message;
    }

    /**
     * 更新会话的最后一条消息信息
     */
    private void updateConversationLastMessage(ChatMessage message) {
        Conversation conversation = conversationRepository.findById(message.getConversationId())
                .orElse(null);
        if (conversation != null) {
            // 更新最后一条消息ID和时间
            conversation.setLastMessage(message);
            conversationRepository.save(conversation);
        }

    }

    /**
     * 获取会话消息列表
     *
     * @param conversationId 会话ID
     * @param pageable       分页参数
     * @return 消息分页列表
     */
    public Page<ChatMessage> getConversationMessages(Long conversationId, Pageable pageable) {
        return chatMessageRepository.findByConversationId(conversationId, pageable);
    }
}