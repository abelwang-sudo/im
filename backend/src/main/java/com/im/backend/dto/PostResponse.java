package com.im.backend.dto;

import com.im.backend.model.Post;
import com.im.backend.model.PostMedia;
import com.im.backend.model.User;

import java.util.List;

/**
 * 动态响应DTO
 */
public class PostResponse {
    private Long id; // 动态ID
    private Long userId; // 用户ID
    private String username; // 用户名
    private String nickname; // 昵称
    private String avatar; // 头像
    private String content; // 动态内容
    private List<PostMedia> medias; // 媒体文件URL列表
    private String mediaType; // 媒体类型
    private Integer likeCount; // 点赞数量
    private Boolean liked; // 当前用户是否已点赞
    private Long createdAt; // 创建时间

    public PostResponse() {
    }

    // 从Post实体转换为PostResponse
    public static PostResponse fromPost(Post post, boolean liked) {
        PostResponse response = new PostResponse();
        response.setId(post.getId());
        
        User user = post.getUser();
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setNickname(user.getNickname());
        response.setAvatar(user.getAvatar());
        
        response.setContent(post.getContent());
        response.setLikeCount(post.getLikeCount());
        response.setMedias(post.getMediaList());
        response.setLiked(liked);
        response.setCreatedAt(post.getCreatedAt());
        
        return response;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public List<PostMedia> getMedias() {
        return medias;
    }

    public void setMedias(List<PostMedia> medias) {
        this.medias = medias;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Boolean getLiked() {
        return liked;
    }

    public void setLiked(Boolean liked) {
        this.liked = liked;
    }

    public Long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Long createdAt) {
        this.createdAt = createdAt;
    }
}