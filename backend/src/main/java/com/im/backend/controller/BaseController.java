package com.im.backend.controller;

import com.im.backend.config.security.AuthUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public abstract class BaseController {

    /**
     * 获取当前登录用户ID
     * @return 当前登录用户ID
     */
    protected Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return ((AuthUserDetails) authentication.getPrincipal()).getId();
    }
}