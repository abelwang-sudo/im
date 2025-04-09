package com.im.backend.dto;


import com.im.backend.model.types.MessageType;

public class ChatMessageDto {
    private MessageType type;
    private String content;
    private Long sender;
    private Long recipient;
    private Long chatGroupId;
    private Long timestamp;
    private String senderNickname;
    private String senderAvatar;


    public Long getSender() {
        return sender;
    }

    public void setSender(Long sender) {
        this.sender = sender;
    }

    public Long getRecipient() {
        return recipient;
    }

    public void setRecipient(Long recipient) {
        this.recipient = recipient;
    }

    // Getters
    public MessageType getType() {
        return type;
    }

    public String getContent() {
        return content;
    }


    public Long getChatGroupId() {
        return chatGroupId;
    }


    // Setters
    public void setType(MessageType type) {
        this.type = type;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setChatGroupId(Long chatGroupId) {
        this.chatGroupId = chatGroupId;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
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
}