package com.im.backend.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Date;

import com.im.backend.model.types.MemberRole;

@Entity
@Table(name = "conversation_members")
public class ConversationMember implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "conversation_id")
    private Long conversationId;

    @Column(name = "user_id")
    private Long userId;

    private String nickname;

    private String displayName;

    @Column(name = "avatar",length = 2048)
    private String avatar;
    
    @Column(name = "unread_count")
    private Integer unreadCount = 0;

    @Column(name = "created_at")
    private Long createdAt;

    @Column(name = "updated_at")
    private Long updatedAt;

    @Enumerated(EnumType.STRING)
    private MemberRole role;

    private boolean visible = true;

    @PrePersist
    protected void onCreate() {
        createdAt = new Date().getTime();
        updatedAt = new Date().getTime();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date().getTime();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getConversationId() {
        return conversationId;
    }

    public void setConversationId(Long conversationId) {
        this.conversationId = conversationId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public Long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Long createdAt) {
        this.createdAt = createdAt;
    }

    public Long getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Long updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Integer getUnreadCount() {
        return unreadCount;
    }
    
    public void setUnreadCount(Integer unreadCount) {
        this.unreadCount = unreadCount;
    }
    
    public void incrementUnreadCount() {
        if (this.unreadCount == null) {
            this.unreadCount = 1;
        } else {
            this.unreadCount++;
        }
    }
    
    public void resetUnreadCount() {
        this.unreadCount = 0;
    }

    public MemberRole getRole() {
        return role;
    }

    public void setRole(MemberRole role) {
        this.role = role;
    }


    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }
}