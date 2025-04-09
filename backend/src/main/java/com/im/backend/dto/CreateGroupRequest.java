package com.im.backend.dto;

import java.util.List;
import java.util.Map;

public class CreateGroupRequest {
    private String name;
    private String avatar;
    private String description;
    private List<Long> memberIds;
    private Boolean requireApproval;
    private Boolean onlyAdminCanInvite;
    private Boolean onlyAdminCanSpeak;
    
    // Getters and Setters
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
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<Long> getMemberIds() {
        return memberIds;
    }
    
    public void setMemberIds(List<Long> memberIds) {
        this.memberIds = memberIds;
    }
    
    public Boolean getRequireApproval() {
        return requireApproval != null ? requireApproval : false;
    }
    
    public void setRequireApproval(Boolean requireApproval) {
        this.requireApproval = requireApproval;
    }
    
    public Boolean getOnlyAdminCanInvite() {
        return onlyAdminCanInvite != null ? onlyAdminCanInvite : false;
    }
    
    public void setOnlyAdminCanInvite(Boolean onlyAdminCanInvite) {
        this.onlyAdminCanInvite = onlyAdminCanInvite;
    }
    
    public Boolean getOnlyAdminCanSpeak() {
        return onlyAdminCanSpeak != null ? onlyAdminCanSpeak : false;
    }
    
    public void setOnlyAdminCanSpeak(Boolean onlyAdminCanSpeak) {
        this.onlyAdminCanSpeak = onlyAdminCanSpeak;
    }
} 