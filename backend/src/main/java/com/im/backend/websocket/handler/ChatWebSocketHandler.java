package com.im.backend.websocket.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.im.backend.config.exception.BusinessException;
import com.im.backend.model.ChatMessage;
import com.im.backend.model.Conversation;
import com.im.backend.model.ConversationMember;
import com.im.backend.model.User;
import com.im.backend.model.message.ConversationContent;
import com.im.backend.model.message.MemberContent;
import com.im.backend.model.message.UserStatusMessageContent;
import com.im.backend.model.types.MessageType;
import com.im.backend.model.types.UserStatus;
import com.im.backend.repository.ConversationRepository;
import com.im.backend.repository.UserRepository;
import com.im.backend.service.ChatMessageService;
import com.im.backend.service.UserService;
import com.im.backend.util.JsonUtil;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 处理WebSocket连接和消息的处理器
 */
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    // 存储所有活跃的WebSocket会话，键为用户名
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private ChatMessageService chatMessageService;

    @Resource
    private ConversationRepository conversationRepository;

    @Resource
    private UserRepository userRepository;

    /**
     * 从会话中提取用户名
     * 注意：实际应用中，这里应该从认证信息中获取用户名
     */
    private String extractUsername(WebSocketSession session) {
        // 从会话属性中获取用户名
        // 这里假设在握手时已经将用户名存入了会话属性
        return (String) session.getAttributes().get("username");
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        // 连接建立时的处理
        String username = extractUsername(session);
        if (username != null) {
            sessions.put(username, session);
            logger.info("用户连接成功: {}", username);
            // 可以发送一个系统消息通知其他用户该用户已上线
            broadcastUserStatus(username, MessageType.JOIN,UserStatus.ONLINE);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        String username = extractUsername(session);
        if (username != null) {
            sessions.remove(username);
            logger.info("用户断开连接: {}, 状态: {}", username, status);

            // 广播用户离线消息
            broadcastUserStatus(username, MessageType.LEAVE,UserStatus.OFFLINE);
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        String username = extractUsername(session);
        if (username == null) {
            logger.warn("收到未认证会话的消息");
            return;
        }

        try {

            // 直接将JSON消息反序列化为ChatMessage对象
            ChatMessage chatMessage = JsonUtil.fromJson(message.getPayload(), ChatMessage.class);
            // 根据消息类型处理
            switch (chatMessage.getType()) {
                case CHAT:
                    handleChatMessage(chatMessage);
                    break;
                case PING:
                    handleHeartbeat(session, username);
                    break;
                case JOIN:

                    break;
                default:
                    logger.warn("未知的消息类型: {}", chatMessage.getType());
            }
        } catch (Exception e) {
            logger.error("处理消息时出错", e);
        }
    }


    /**
     * 处理聊天消息
     */
    private void handleChatMessage(ChatMessage chatMessage) {
        try {
            // 从消息对象中获取接收者或群组ID
            Long conversationId = chatMessage.getConversationId();

            // 保存消息并广播给群组成员
            ChatMessage savedMessage = chatMessageService.saveMessage(chatMessage);
            broadcastGroupMessage(conversationId, savedMessage);
            ///发送最新消息变更
            sendConversationNotification(conversationId, ConversationContent.ACTION_UPDATE, chatMessage.getContent().getText(), chatMessage.getSender());
        } catch (Exception e) {
            logger.error("处理聊天消息时出错", e);
        }
    }

    /**
     * 处理心跳消息
     */
    private void handleHeartbeat(WebSocketSession session, String username) {
        try {
            // 创建心跳响应
            Map<String, Object> response = Map.of(
                    "type", MessageType.PONG,
                    "timestamp", new Date().getTime()
            );

            // 发送响应
            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(response)));
        } catch (IOException e) {
            logger.error("发送心跳响应失败", e);
        }
    }

    /**
     * 广播用户状态变更消息
     */
    private void broadcastUserStatus(String username, MessageType type,UserStatus userStatus) {
        try {
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setType(type);
            chatMessage.setSender(Long.parseLong(username));
            UserStatusMessageContent statusMessageContent = new UserStatusMessageContent(userStatus);
            chatMessage.setContent(statusMessageContent);
            chatMessage.setTimestamp(new Date().getTime());
            // 广播给所有连接的用户
            for (WebSocketSession session : sessions.values()) {
                if (session.isOpen()) {
                    session.sendMessage(new TextMessage(JsonUtil.toJson(chatMessage)));
                }
            }
            Optional<User> user = userRepository.findById(Long.parseLong(username));
            if(user.isPresent()){
                user.get().setStatus(userStatus);
                userRepository.save(user.get());
            }

        } catch (IOException e) {
            logger.error("广播用户状态消息失败", e);
        }
    }

    /**
     * 发送消息给特定用户
     */
    public void sendMessageToUser(Long username, ChatMessage chatMessage) {
        chatMessage.setTimestamp(new Date().getTime());
        WebSocketSession session = sessions.get(username.toString());
        if (session != null && session.isOpen()) {
            try {
                // 使用JsonUtil工具类序列化消息对象，自动过滤空字段
                String message = JsonUtil.toJson(chatMessage);
                if (message != null) {
                    session.sendMessage(new TextMessage(message));
                }
            } catch (IOException e) {
                logger.error("发送消息给用户 {} 失败", username, e);
            }
        }
    }

    /**
     * 广播消息给群组成员
     */
    private void broadcastGroupMessage(Long conversationId, ChatMessage chatMessage) {
        // 获取会话的所有成员ID
        List<Long> memberIds = conversationRepository.findMemberIdsByConversationId(conversationId);

        // 只向会话成员广播消息
        for (Long memberId : memberIds) {
            WebSocketSession session = sessions.get(memberId.toString());
            if (session != null && session.isOpen()) {
                sendMessageToUser(memberId, chatMessage);
            }
        }
    }

    /**
     * 发送会话通知给所有会话成员
     *
     * @param conversationId 会话ID
     * @param excludeUserId  需要排除的用户ID（可选，例如不需要通知操作的发起者）
     */
    public void sendConversationNotification(Long conversationId, String action, String text, Long... excludeUserId) {
        try {
            // 创建通知消息
            ChatMessage notification = new ChatMessage();
            notification.setType(MessageType.NOTICE);
            notification.setSender(0L); // 系统消息
            notification.setConversationId(conversationId);
            notification.setTimestamp(new Date().getTime());


            // 获取会话的所有成员ID
            List<Long> memberIds = conversationRepository.findMemberIdsByConversationId(conversationId);

            // 创建排除用户ID的列表
            List<Long> excludeList = excludeUserId != null ? Arrays.asList(excludeUserId) : Collections.emptyList();


            // 只向会话成员广播消息，排除指定的用户
            for (Long memberId : memberIds) {
                if (!excludeList.contains(memberId)) {
                    Conversation conversation = conversationRepository.findByConversationId(conversationId, memberId);
                    ConversationContent content = new ConversationContent(action, conversation, text);
                    notification.setContent(content);
                    sendMessageToUser(memberId, notification);
                }
            }

            logger.info("已发送会话通知到会话 {} 的成员", conversationId);
        } catch (Exception e) {
            logger.error("发送会话通知失败", e);
        }
    }
    /**
     * 发送会话通知给所有会话管理员
     *
     * @param conversationId 会话ID
     * @param excludeUserId  需要排除的用户ID（可选，例如不需要通知操作的发起者）
     */
    public void sendConversationAdminNotification(Long conversationId, String action, String text, Long... excludeUserId) {
        try {
            // 创建通知消息
            ChatMessage notification = new ChatMessage();
            notification.setType(MessageType.NOTICE);
            notification.setSender(0L); // 系统消息
            notification.setConversationId(conversationId);
            notification.setTimestamp(new Date().getTime());

            // 获取会话的管理员ID
            List<Long> memberIds = conversationRepository.findAdminIdsByConversationId(conversationId);

            // 创建排除用户ID的列表
            List<Long> excludeList = excludeUserId != null ? Arrays.asList(excludeUserId) : Collections.emptyList();
            
            // 只向会话成员广播消息，排除指定的用户
            for (Long memberId : memberIds) {
                if (!excludeList.contains(memberId)) {
                    Conversation conversation = conversationRepository.findByConversationId(conversationId, memberId);
                    ConversationContent content = new ConversationContent(action, conversation, text);
                    notification.setContent(content);
                    sendMessageToUser(memberId, notification);
                }
            }

            logger.info("已发送会话通知到会话 {} 的成员", conversationId);
        } catch (Exception e) {
            logger.error("发送会话通知失败", e);
        }
    }

    public void sendMemberChangeNotification(Long conversationId, String action, String text, List<ConversationMember> members) {
        try {
            // 创建通知消息
            ChatMessage notification = new ChatMessage();
            notification.setType(MessageType.NOTICE);
            notification.setSender(0L); // 系统消息
            notification.setConversationId(conversationId);
            notification.setTimestamp(new Date().getTime());
            // 获取会话的管理员ID
            List<Long> memberIds = conversationRepository.findAdminIdsByConversationId(conversationId);


            // 只向会话成员广播消息，排除指定的用户
            for (Long memberId : memberIds) {
                MemberContent content = new MemberContent(action, members, text);
                notification.setContent(content);
                sendMessageToUser(memberId, notification);
            }

            logger.info("已发送会话通知到会话 {} 的成员", conversationId);
        } catch (Exception e) {
            logger.error("发送会话通知失败", e);
        }
    }


    /**
     * 发送会话通知给指定用户
     *
     * @param conversationId 会话ID
     */
    public void sendMemberNotification(Long conversationId, String action, String text, List<Long> memberIds) {
        try {
            // 创建通知消息
            ChatMessage notification = new ChatMessage();
            notification.setType(MessageType.NOTICE);
            notification.setSender(0L); // 系统消息
            notification.setConversationId(conversationId);
            notification.setTimestamp(new Date().getTime());

            // 只向会话成员广播消息
            for (Long memberId : memberIds) {
                Conversation conversation = conversationRepository.findByConversationId(conversationId, memberId);
                ConversationContent content = new ConversationContent(action, conversation, text);
                notification.setContent(content);
                sendMessageToUser(memberId, notification);
            }

            logger.info("已发送会话通知到会话 {} 的成员", conversationId);
        } catch (Exception e) {
            logger.error("发送会话通知失败", e);
        }
    }
}