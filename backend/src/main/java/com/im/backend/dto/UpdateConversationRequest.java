package com.im.backend.dto;

/**
 * 更新会话信息的请求DTO
 */
public class UpdateConversationRequest {
    
    private String name;
    private String avatar;
    private Boolean requireApproval;
    private Boolean onlyAdminCanInvite;
    private Boolean onlyAdminCanSpeak;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Boolean getRequireApproval() {
        return requireApproval;
    }

    public void setRequireApproval(Boolean requireApproval) {
        this.requireApproval = requireApproval;
    }

    public Boolean getOnlyAdminCanInvite() {
        return onlyAdminCanInvite;
    }

    public void setOnlyAdminCanInvite(Boolean onlyAdminCanInvite) {
        this.onlyAdminCanInvite = onlyAdminCanInvite;
    }

    public Boolean getOnlyAdminCanSpeak() {
        return onlyAdminCanSpeak;
    }

    public void setOnlyAdminCanSpeak(Boolean onlyAdminCanSpeak) {
        this.onlyAdminCanSpeak = onlyAdminCanSpeak;
    }
}