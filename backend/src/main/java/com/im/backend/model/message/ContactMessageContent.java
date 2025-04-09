package com.im.backend.model.message;

import com.im.backend.model.Friendship;
import com.im.backend.model.types.MessageContentType;

public class ContactMessageContent extends BaseMessageContent {
    private String action;
    private  Friendship friendship;

    public ContactMessageContent(String message, String action, Friendship friendship) {
        setText(message);
        setType(MessageContentType.CONTACT.name());
        this.friendship = friendship;
        this.action = action;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Friendship getFriendship() {
        return friendship;
    }

    public void setFriendship(Friendship friendship) {
        this.friendship = friendship;
    }
}