package com.im.backend.model;

import com.im.backend.model.message.BaseMessageContent;
import com.im.backend.model.converter.MessageContentConverter;
import com.im.backend.model.types.MessageType;
import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "chat_messages")
@Data
public class ChatMessage implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    private MessageType type;
    
    @Column(columnDefinition = "json")
    @Convert(converter = MessageContentConverter.class)
    private BaseMessageContent content;
    
    private Long sender;

    @Column(name = "sender_nickname",length = 255)
    private String senderNickname;
    @Column(name = "sender_avatar",length = 2048)
    private String senderAvatar;
    
    @Column(name = "conversation_id")
    private Long conversationId;
    
    private Long timestamp;
    
    @Column(name = "is_read")
    private boolean read = false;
    
    @PrePersist
    protected void onCreate() {
        timestamp = new Date().getTime();
    }
    
    // Getters
    public Long getId() {
        return id;
    }
    
    public MessageType getType() {
        return type;
    }



    
    public boolean isRead() {
        return read;
    }
    
    // Setters
    public void setId(Long id) {
        this.id = id;
    }
    
    public void setType(MessageType type) {
        this.type = type;
    }
    
    public void setRead(boolean read) {
        this.read = read;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    public Long getSender() {
        return sender;
    }

    public void setSender(Long sender) {
        this.sender = sender;
    }

    public String getSenderNickname() {
        return senderNickname;
    }

    public void setSenderNickname(String senderNickname) {
        this.senderNickname = senderNickname;
    }

    public String getSenderAvatar() {
        return senderAvatar;
    }

    public void setSenderAvatar(String senderAvatar) {
        this.senderAvatar = senderAvatar;
    }

    public BaseMessageContent getContent() {
        return content;
    }

    public void setContent(BaseMessageContent content) {
        this.content = content;
    }
}