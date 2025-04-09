package com.im.backend.model.message;

import com.im.backend.model.Conversation;
import com.im.backend.model.types.MessageContentType;

public class ConversationContent  extends BaseMessageContent{

    public static String ACTION_CREATE = "create";
    public static String ACTION_UPDATE= "update";
    public static String ACTION_DELETE= "delete";

    public ConversationContent(String action, Conversation conversation,String text) {
        setText(text);
        setType(MessageContentType.CONVERSATION.name());
        this.action = action;
        this.conversation = conversation;
    }

    // 新建 修改

    private String action;

    private Conversation conversation;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Conversation getConversation() {
        return conversation;
    }

    public void setConversation(Conversation conversation) {
        this.conversation = conversation;
    }
}
