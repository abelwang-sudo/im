package com.im.backend.model.message;

import com.im.backend.model.Post;
import com.im.backend.model.User;
import com.im.backend.model.types.MessageContentType;

/**
 * 动态消息内容类
 * 用于WebSocket通知系统，当好友发布新动态或点赞动态时发送通知
 */
public class PostMessageContent extends BaseMessageContent {
    private Post post;
    private User liker;
    private String action;

    public PostMessageContent(Post post, String action) {
        super.setText("新动态");
        setType(MessageContentType.POST.name());
        this.post = post;
        this.action = action;
    }

    public PostMessageContent(Post post, User user, String action) {
        this.post = post;
        this.liker = user;
        this.action = action;
    }

    // 创建新动态通知
    public static PostMessageContent createNewPostNotification(Post post) {
        return new PostMessageContent(post, "create");
    }

    // 创建点赞动态通知
    public static PostMessageContent createLikePostNotification(Post post, User user) {
        return new PostMessageContent(post, user, "liked");
    }

    public Post getPost() {
        return post;
    }

    public void setPost(Post post) {
        this.post = post;
    }

    public User getLiker() {
        return liker;
    }

    public void setLiker(User liker) {
        this.liker = liker;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}