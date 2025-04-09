package com.im.backend.dto;

import com.im.backend.model.types.ConversationType;

import java.util.List;

/**
 * 创建会话的请求DTO
 */
public class CreateConversationRequest {
    
    private ConversationType type;
    private List<Long> memberIds;
    private String avatar;
    private String name;

    public ConversationType getType() {
        return type;
    }

    public void setType(ConversationType type) {
        this.type = type;
    }

    public List<Long> getMemberIds() {
        return memberIds;
    }

    public void setMemberIds(List<Long> memberIds) {
        this.memberIds = memberIds;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}