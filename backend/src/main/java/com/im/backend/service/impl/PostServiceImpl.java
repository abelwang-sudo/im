package com.im.backend.service.impl;

import com.im.backend.config.exception.BusinessException;
import com.im.backend.dto.CreatePostRequest;
import com.im.backend.dto.PostResponse;
import com.im.backend.model.*;
import com.im.backend.model.message.PostMessageContent;
import com.im.backend.model.types.MessageType;
import com.im.backend.repository.FriendshipRepository;
import com.im.backend.repository.PostLikeRepository;
import com.im.backend.repository.PostRepository;
import com.im.backend.repository.UserRepository;
import com.im.backend.service.PostService;
import com.im.backend.websocket.handler.ChatWebSocketHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 好友动态服务实现类
 */
@Service
public class PostServiceImpl implements PostService {

    @Autowired
    private PostRepository postRepository;
    
    @Autowired
    private PostLikeRepository postLikeRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private FriendshipRepository friendshipRepository;
    
    @Autowired
    private ChatWebSocketHandler webSocketHandler;

    @Override
    @Transactional
    public Post createPost(Long userId, CreatePostRequest request) {
        // 获取用户信息
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        
        // 创建动态
        Post post = new Post();
        post.setUser(user);
        post.setContent(request.getContent());
        
        // 设置媒体文件
        if (request.getMedias() != null && !request.getMedias().isEmpty()) {
            post.setMediaList(request.getMedias());
        }
        
        // 保存动态
        post = postRepository.save(post);
        
        // 通过WebSocket通知好友有新动态
        notifyNewPost(post);
        
        return post;
    }

    @Override
    public PostResponse getPostById(Long postId, Long currentUserId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new BusinessException("动态不存在"));
        
        // 检查当前用户是否已点赞该动态
        boolean liked = isPostLikedByUser(postId, currentUserId);
        
        return PostResponse.fromPost(post, liked);
    }

    @Override
    public Page<PostResponse> getUserPosts(Long userId, Long currentUserId, Pageable pageable) {
        // 获取用户信息
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        
        // 获取用户点赞的动态ID列表
        List<Long> likedPostIds = getUserLikedPostIds(currentUserId);
        
        // 查询用户的动态列表
        Page<Post> posts = postRepository.findByUserOrderByCreatedAtDesc(user, pageable);
        
        // 转换为响应DTO
        return posts.map(post -> {
            boolean liked = likedPostIds.contains(post.getId());
            return PostResponse.fromPost(post, liked);
        });
    }

    @Override
    public Page<PostResponse> getFriendPosts(Long userId, Pageable pageable) {
        // 获取用户的好友ID列表
        List<Long> friendIds = getFriendIds(userId);
        
        // 获取用户点赞的动态ID列表
        List<Long> likedPostIds = getUserLikedPostIds(userId);
        
        // 查询用户和好友的动态列表
        Page<Post> posts = postRepository.findByUserIdOrFriendIdsOrderByCreatedAtDesc(userId, friendIds, pageable);
        
        // 转换为响应DTO
        return posts.map(post -> {
            boolean liked = likedPostIds.contains(post.getId());
            return PostResponse.fromPost(post, liked);
        });
    }

    @Override
    @Transactional
    public boolean likePost(Long postId, Long userId) {
        // 获取动态信息
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new BusinessException("动态不存在"));
        
        // 获取用户信息
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        
        // 检查用户是否已点赞该动态
        Optional<PostLike> existingLike = postLikeRepository.findByPostAndUser(post, user);
        if (existingLike.isPresent()) {
            return false; // 已点赞，不能重复点赞
        }
        
        // 创建点赞记录
        PostLike postLike = new PostLike();
        postLike.setPost(post);
        postLike.setUser(user);
        postLikeRepository.save(postLike);
        
        // 更新动态点赞数量
        post.setLikeCount(post.getLikeCount() + 1);
        postRepository.save(post);
        
        // 通过WebSocket通知动态作者有新点赞
        notifyPostLike(post, userId);
        
        return true;
    }

    @Override
    @Transactional
    public boolean unlikePost(Long postId, Long userId) {
        // 获取动态信息
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new BusinessException("动态不存在"));
        
        // 获取用户信息
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        
        // 删除点赞记录
        long deletedCount = postLikeRepository.deleteByPostAndUser(post, user);
        
        if (deletedCount > 0) {
            // 更新动态点赞数量
            post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
            postRepository.save(post);
            return true;
        }
        
        return false;
    }

    @Override
    public boolean isPostLikedByUser(Long postId, Long userId) {
        // 获取动态信息
        Post post = postRepository.findById(postId).orElse(null);
        if (post == null) {
            return false;
        }
        
        // 获取用户信息
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }
        
        // 检查用户是否已点赞该动态
        return postLikeRepository.findByPostAndUser(post, user).isPresent();
    }

    @Override
    public List<Long> getUserLikedPostIds(Long userId) {
        return postLikeRepository.findPostIdsByUserId(userId);
    }
    
    /**
     * 获取用户的好友ID列表
     * @param userId 用户ID
     * @return 好友ID列表
     */
    private List<Long> getFriendIds(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        // 查询已接受的好友关系
        List<Friendship> friendships = friendshipRepository.findAllAcceptedFriendships(user);
        
        // 提取好友ID
        List<Long> friendIds = new ArrayList<>();
        for (Friendship friendship : friendships) {
            if (friendship.getRequester().getId().equals(userId)) {
                friendIds.add(friendship.getAddressee().getId());
            } else {
                friendIds.add(friendship.getRequester().getId());
            }
        }
        
        return friendIds;
    }
    
    /**
     * 通知好友有新动态
     * @param post 新发布的动态
     */
    private void notifyNewPost(Post post) {
        // 获取用户的好友ID列表
        List<Long> friendIds = getFriendIds(post.getUser().getId());
        
        // 创建动态消息内容
        PostMessageContent messageContent = PostMessageContent.createNewPostNotification(post);
        ChatMessage message = new ChatMessage();
        message.setType(MessageType.POST);
        message.setContent(messageContent);
        // 通过WebSocket通知好友
        for (Long friendId : friendIds) {
            userRepository.findById(friendId).ifPresent(friend -> webSocketHandler.sendMessageToUser(
                    friend.getId(),
                    message
            ));
        }
    }
    
    /**
     * 通知动态作者有新点赞
     * @param post 被点赞的动态
     * @param likerId 点赞用户ID
     */
    private void notifyPostLike(Post post, Long likerId) {
        // 如果点赞用户不是动态作者，则发送通知
        if (!post.getUser().getId().equals(likerId)) {
            // 获取用户信息
            User user = userRepository.findById(likerId)
                    .orElseThrow(() -> new BusinessException("用户不存在"));
            // 创建点赞消息内容
            PostMessageContent messageContent = PostMessageContent.createLikePostNotification(post, user);
            ChatMessage message = new ChatMessage();
            message.setType(MessageType.POST);
            message.setContent(messageContent);
            // 通过WebSocket通知动态作者
            webSocketHandler.sendMessageToUser(
                    post.getUser().getId(),
                    message
            );
        }
    }
}