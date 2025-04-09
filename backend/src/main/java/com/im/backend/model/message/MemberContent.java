package com.im.backend.model.message;

import com.im.backend.model.Conversation;
import com.im.backend.model.ConversationMember;
import com.im.backend.model.types.MessageContentType;

import java.util.List;

public class MemberContent extends BaseMessageContent{

    public static String ACTION_JOIN = "join";
    public static String ACTION_REMOVE= "update";
    public static String ACTION_UPDATE= "delete";
    public static String ACTION_REQUEST= "request";
    public static String ACTION_MEMBER_QUIT= "exit";


    public MemberContent(String action,List<ConversationMember> member, String text) {
        setText(text);
        setType(MessageContentType.MEMBER.name());
        this.action = action;
        this.member = member;
    }

    // 新建 修改

    private String action;

    private List<ConversationMember> member;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public List<ConversationMember> getMember() {
        return member;
    }

    public void setMember(List<ConversationMember> member) {
        this.member = member;
    }
}
