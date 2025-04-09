package com.im.backend.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "app.friendship")
public class FriendshipConfig {
    
    // 是否需要确认才能成为好友，默认为true（需要确认）
    private boolean requireConfirmation = true;
    
    public boolean isRequireConfirmation() {
        return requireConfirmation;
    }
    
    public void setRequireConfirmation(boolean requireConfirmation) {
        this.requireConfirmation = requireConfirmation;
    }
}