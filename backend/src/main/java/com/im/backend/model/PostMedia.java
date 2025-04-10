package com.im.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;

/**
 * 动态媒体文件嵌入式实体类
 */
@Embeddable
public class PostMedia implements Serializable {
    
    @Column(name = "media_url", length = 1024)
    private String mediaUrl; // 媒体文件URL
    
    @Column(name = "media_type")
    private String mediaType; // 媒体类型：IMAGE, VIDEO
    
    // 默认构造函数
    public PostMedia() {
    }
    
    // 带参数的构造函数
    public PostMedia(String mediaUrl, String mediaType) {
        this.mediaUrl = mediaUrl;
        this.mediaType = mediaType;
    }
    
    // Getters and Setters
    public String getMediaUrl() {
        return mediaUrl;
    }
    
    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }
    
    public String getMediaType() {
        return mediaType;
    }
    
    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }
}