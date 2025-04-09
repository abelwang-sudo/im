package com.im.backend.dto;

public class UpdateGroupSettingsRequest {
    private Boolean requireApproval;
    private Boolean onlyAdminCanInvite;
    private Boolean onlyAdminCanSpeak;
    
    // Getters and Setters
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
    
    // 转换为Map的辅助方法
    public java.util.Map<String, Object> toMap() {
        java.util.Map<String, Object> map = new java.util.HashMap<>();
        if (requireApproval != null) {
            map.put("requireApproval", requireApproval);
        }
        if (onlyAdminCanInvite != null) {
            map.put("onlyAdminCanInvite", onlyAdminCanInvite);
        }
        if (onlyAdminCanSpeak != null) {
            map.put("onlyAdminCanSpeak", onlyAdminCanSpeak);
        }
        return map;
    }
} 