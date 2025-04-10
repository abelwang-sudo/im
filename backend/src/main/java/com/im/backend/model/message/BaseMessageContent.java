package com.im.backend.model.message;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

import java.io.Serializable;

@JsonTypeInfo(
        use = JsonTypeInfo.Id.NONE,
        include = JsonTypeInfo.As.EXTERNAL_PROPERTY,
        property = "type",
        visible = true
)
@JsonSubTypes({
    @JsonSubTypes.Type(value = TextMessageContent.class, name = "TEXT"),
    @JsonSubTypes.Type(value = ContactMessageContent.class, name = "CONTACT"),
    @JsonSubTypes.Type(value = ConversationContent.class, name = "CONVERSATION"),
    @JsonSubTypes.Type(value = UserStatusMessageContent.class, name = "USER_STATUS"),
    @JsonSubTypes.Type(value = PostMessageContent.class, name = "POST")
})
public  class BaseMessageContent implements Serializable {
    private String type;
    private String text;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}