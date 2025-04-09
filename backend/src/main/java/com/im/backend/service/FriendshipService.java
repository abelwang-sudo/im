package com.im.backend.service;

import com.im.backend.model.Friendship;
import com.im.backend.model.User;

import java.util.List;

public interface FriendshipService {
    /**
     * 发送好友请求
     * @param requesterId 请求者ID
     * @param addresseeId 接收者ID
     * @return 创建的好友关系
     */
    Friendship sendFriendRequest(Long requesterId, Long addresseeId);
    
    /**
     * 接受好友请求
     * @param friendshipId 好友关系ID
     * @param userId 当前用户ID（必须是接收者）
     * @return 更新后的好友关系
     */
    Friendship acceptFriendRequest(Long friendshipId, Long userId);
    
    /**
     * 拒绝好友请求
     * @param friendshipId 好友关系ID
     * @param userId 当前用户ID（必须是接收者）
     * @return 更新后的好友关系
     */
    Friendship rejectFriendRequest(Long friendshipId, Long userId);
    
    /**
     * 获取用户的所有好友
     * @param userId 用户ID
     * @return 好友列表
     */
    List<User> getUserFriends(Long userId);
    
    /**
     * 获取用户收到的所有待处理好友请求
     * @param userId 用户ID
     * @return 待处理的好友请求列表
     */
    List<Friendship> getPendingFriendRequests(Long userId);
    
    /**
     * 检查两个用户是否是好友
     * @param userId1 用户1的ID
     * @param userId2 用户2的ID
     * @return 是否是好友
     */
    boolean areFriends(Long userId1, Long userId2);
    
    /**
     * 删除好友关系
     * @param userId 当前用户ID
     * @param friendId 要删除的好友ID
     * @return 是否删除成功
     */
    boolean deleteFriendship(Long userId, Long friendId);
}