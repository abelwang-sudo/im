package com.im.backend.dto;

import com.im.backend.model.Conversation;
import com.im.backend.model.Group;
import com.im.backend.model.User;
import lombok.Data;

@Data
public class GroupDto {
    private Long id;
    private String name;
    private String avatar;

    private String description;

    private Conversation conversation;

    private User owner;

    private String extraSettings;

    public GroupDto(Group group) {
        this.id = group.getId();
        this.name = group.getName();
        this.avatar = group.getAvatar();
        this.description = group.getDescription();
        this.conversation = group.getConversation();
        this.owner = group.getOwner();
        this.extraSettings = group.getExtraSettings();
    }
}
