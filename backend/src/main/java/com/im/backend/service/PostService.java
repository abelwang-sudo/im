package com.im.backend.service;

import com.im.backend.dto.CreatePostRequest;
import com.im.backend.dto.PostResponse;
import com.im.backend.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * 好友动态服务接口
 */
public interface PostService {
    
    /**
     * 创建动态
     * @param userId 用户ID
     * @param request 创建动态请求
     * @return 创建的动态
     */
    Post createPost(Long userId, CreatePostRequest request);
    
    /**
     * 获取动态详情
     * @param postId 动态ID
     * @param currentUserId 当前用户ID
     * @return 动态响应
     */
    PostResponse getPostById(Long postId, Long currentUserId);
    
    /**
     * 获取用户的动态列表
     * @param userId 用户ID
     * @param currentUserId 当前用户ID
     * @param pageable 分页参数
     * @return 动态响应分页列表
     */
    Page<PostResponse> getUserPosts(Long userId, Long currentUserId, Pageable pageable);
    
    /**
     * 获取好友动态列表（包括自己的动态）
     * @param userId 用户ID
     * @param pageable 分页参数
     * @return 动态响应分页列表
     */
    Page<PostResponse> getFriendPosts(Long userId, Pageable pageable);
    
    /**
     * 点赞动态
     * @param postId 动态ID
     * @param userId 用户ID
     * @return 是否点赞成功
     */
    boolean likePost(Long postId, Long userId);
    
    /**
     * 取消点赞
     * @param postId 动态ID
     * @param userId 用户ID
     * @return 是否取消成功
     */
    boolean unlikePost(Long postId, Long userId);
    
    /**
     * 检查用户是否已点赞动态
     * @param postId 动态ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    boolean isPostLikedByUser(Long postId, Long userId);
    
    /**
     * 获取用户点赞的动态ID列表
     * @param userId 用户ID
     * @return 动态ID列表
     */
    List<Long> getUserLikedPostIds(Long userId);
}