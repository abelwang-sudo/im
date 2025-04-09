package com.im.backend.model;

import com.im.backend.model.converter.MessageConverter;
import com.im.backend.model.types.ConversationType;
import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;

@Entity
@Table(name = "conversations")
public class Conversation implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "conversation_type")
    private ConversationType type;

    @Column(name = "last_message" ,columnDefinition = "json")
    @Convert(converter = MessageConverter.class)
    private ChatMessage lastMessage;

    @Column(name = "name", length = 255)
    private String name;

    @Column(name = "avatar", length = 2048)
    private String avatar;

    @Column(name = "created_at")
    private Long createdAt;

    @Column(name = "updated_at")
    private Long updatedAt;
    @Transient
    private ConversationMember member;

    @OneToOne(mappedBy = "conversation", fetch = FetchType.LAZY)
    private Group group;

    @Column(name = "require_approval", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean requireApproval = false;
    
    @Column(name = "only_admin_can_invite", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean onlyAdminCanInvite = false;
    
    @Column(name = "only_admin_can_speak", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean onlyAdminCanSpeak = false;


    public Conversation() {
    }

    public Conversation(Conversation conversation,ConversationMember conversationMember) {
        this.id = conversation.getId();
        this.type = conversation.getType();
        this.lastMessage = conversation.getLastMessage();
        this.name = conversation.getName();
        this.avatar = conversation.getAvatar();
        this.createdAt = conversation.getCreatedAt();
        this.updatedAt = conversation.getUpdatedAt();
        this.member = conversationMember;
        this.onlyAdminCanSpeak = conversation.onlyAdminCanSpeak;
        this.onlyAdminCanInvite = conversation.onlyAdminCanInvite;
        this.requireApproval = conversation.requireApproval;
        this.group = conversation.getGroup();
    }

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

    public ConversationType getType() {
        return type;
    }

    public void setType(ConversationType type) {
        this.type = type;
    }

    public ChatMessage getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(ChatMessage lastMessage) {
        this.lastMessage = lastMessage;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public ConversationMember getMember() {
        return member;
    }

    public void setMember(ConversationMember member) {
        this.member = member;
    }

    public boolean isGroupChat() {
        return type == ConversationType.GROUP;
    }

    public Group getGroup() {
        if (!isGroupChat()) {
            return null;
        }
        return group;
    }

    public void setGroup(Group group) {
        this.group = group;
    }

    public boolean isRequireApproval() {
        return requireApproval;
    }

    public void setRequireApproval(boolean requireApproval) {
        this.requireApproval = requireApproval;
    }

    public boolean isOnlyAdminCanInvite() {
        return onlyAdminCanInvite;
    }

    public void setOnlyAdminCanInvite(boolean onlyAdminCanInvite) {
        this.onlyAdminCanInvite = onlyAdminCanInvite;
    }

    public boolean isOnlyAdminCanSpeak() {
        return onlyAdminCanSpeak;
    }

    public void setOnlyAdminCanSpeak(boolean onlyAdminCanSpeak) {
        this.onlyAdminCanSpeak = onlyAdminCanSpeak;
    }
}