package com.im.backend.model.types;

/**
 * 会话成员角色枚举
 */
public enum MemberRole {
    /**
     * 群主
     */
    OWNER,
    
    /**
     * 管理员
     */
    ADMIN,
    
    /**
     * 普通成员
     */
    MEMBER;
    
    /**
     * 判断角色是否为管理员或更高权限
     * 
     * @return 如果角色是管理员或群主则返回true
     */
    public boolean isAdminOrAbove() {
        return this == ADMIN || this == OWNER;
    }
    
    /**
     * 判断角色是否为群主
     * 
     * @return 如果角色是群主则返回true
     */
    public boolean isOwner() {
        return this == OWNER;
    }
} 