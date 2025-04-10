package com.im.backend.dto;

import com.im.backend.model.PostMedia;

import java.util.List;

/**
 * 创建动态请求DTO
 */
public class CreatePostRequest {
    private String content; // 动态文字内容
    private List<PostMedia> medias; // 媒体文件URL列表
    private String mediaType; // 媒体类型：IMAGE, VIDEO, MIXED

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
}