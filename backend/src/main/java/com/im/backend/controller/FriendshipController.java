package com.im.backend.controller;

import com.im.backend.dto.ApiResponse;
import com.im.backend.model.ChatMessage;
import com.im.backend.model.Friendship;
import com.im.backend.model.types.MessageType;
import com.im.backend.model.User;
import com.im.backend.model.message.ContactMessageContent;
import com.im.backend.service.FriendshipService;
import com.im.backend.websocket.handler.ChatWebSocketHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/friendships")
@CrossOrigin(origins = "*", maxAge = 3600)
public class FriendshipController extends BaseController {

    @Autowired
    private FriendshipService friendshipService;

    @Autowired
    private ChatWebSocketHandler chatWebSocketHandler;

    /**
     * 发送好友请求
     * @param addresseeId 接收者ID
     * @return 创建的好友关系
     */
    @PostMapping("/request/{addresseeId}")
    public ApiResponse<Friendship> sendFriendRequest(@PathVariable Long addresseeId) {
        Long requesterId = getCurrentUserId();
        
        Friendship friendship = friendshipService.sendFriendRequest(requesterId, addresseeId);
        
        // 发送好友请求通知
        ChatMessage notification = new ChatMessage();
        notification.setType(MessageType.NOTICE);
        notification.setSender(requesterId);
        notification.setContent(new ContactMessageContent("用户 " + requesterId + " 请求添加好友","request",friendship));
        chatWebSocketHandler.sendMessageToUser(addresseeId, notification);
        
        return ApiResponse.success("好友请求已发送", friendship);
    }

    /**
     * 接受好友请求
     * @param friendshipId 好友关系ID
     * @return 更新后的好友关系
     */
    @PutMapping("/accept/{friendshipId}")
    public ApiResponse<Friendship> acceptFriendRequest(@PathVariable Long friendshipId) {
        Long userId = getCurrentUserId();
        
        Friendship friendship = friendshipService.acceptFriendRequest(friendshipId, userId);
        
        // 发送接受好友请求通知
        ChatMessage notification = new ChatMessage();
        notification.setType(MessageType.NOTICE);
        notification.setSender(userId);
        notification.setContent(new ContactMessageContent("同意好友请求","accept",friendship));
        chatWebSocketHandler.sendMessageToUser(friendship.getRequester().getId(), notification);
        
        return ApiResponse.success("已接受好友请求", friendship);
    }

    /**
     * 拒绝好友请求
     * @param friendshipId 好友关系ID
     * @return 更新后的好友关系
     */
    @PutMapping("/reject/{friendshipId}")
    public ApiResponse<Friendship> rejectFriendRequest(@PathVariable Long friendshipId) {
        Long userId = getCurrentUserId();
        
        Friendship friendship = friendshipService.rejectFriendRequest(friendshipId, userId);
        
        // 发送拒绝好友请求通知
        ChatMessage notification = new ChatMessage();
        notification.setType(MessageType.NOTICE);
        notification.setSender(userId);
        notification.setContent(new ContactMessageContent("用户 " + userId + " 已拒绝您的好友请求","reject",friendship));
        chatWebSocketHandler.sendMessageToUser(friendship.getRequester().getId(), notification);
        
        return ApiResponse.success("已拒绝好友请求", friendship);
    }

    /**
     * 获取用户的所有好友
     * @return 好友列表
     */
    @GetMapping("/friends")
    public ApiResponse<List<User>> getUserFriends() {
        Long userId = getCurrentUserId();

        List<User> friends = friendshipService.getUserFriends(userId);
        return ApiResponse.success("获取好友列表成功", friends);
    }

    /**
     * 获取用户收到的所有待处理好友请求
     * @return 待处理的好友请求列表
     */
    @GetMapping("/pending")
    public ApiResponse<List<Friendship>> getPendingFriendRequests() {
        Long userId = getCurrentUserId();
        
        List<Friendship> pendingRequests = friendshipService.getPendingFriendRequests(userId);
        return ApiResponse.success("获取待处理好友请求成功", pendingRequests);
    }

    /**
     * 检查与指定用户是否是好友
     * @param userId 要检查的用户ID
     * @return 是否是好友
     */
    @GetMapping("/check/{userId}")
    public ApiResponse<Boolean> checkFriendship(@PathVariable Long userId) {
        Long currentUserId = getCurrentUserId();
        
        boolean areFriends = friendshipService.areFriends(currentUserId, userId);
        return ApiResponse.success("检查好友关系成功", areFriends);
    }

    /**
     * 删除好友关系
     * @param friendId 要删除的好友ID
     * @return 是否删除成功
     */
    @DeleteMapping("/{friendId}")
    public ApiResponse<Boolean> deleteFriendship(@PathVariable Long friendId) {
        Long userId = getCurrentUserId();
        
        boolean deleted = friendshipService.deleteFriendship(userId, friendId);
        
        if (deleted) {
            // 发送删除好友通知
            ChatMessage notification = new ChatMessage();
            notification.setType(MessageType.NOTICE);
            notification.setSender(userId);
            notification.setContent(new ContactMessageContent("用户 " + userId + " 已将您删除好友","delete",null));
            chatWebSocketHandler.sendMessageToUser(friendId, notification);
        }
        
        return ApiResponse.success("删除好友关系" + (deleted ? "成功" : "失败"), deleted);
    }
}