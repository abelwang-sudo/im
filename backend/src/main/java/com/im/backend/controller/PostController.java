package com.im.backend.controller;

import com.im.backend.dto.ApiResponse;
import com.im.backend.dto.CreatePostRequest;
import com.im.backend.dto.PostResponse;
import com.im.backend.model.Post;
import com.im.backend.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

/**
 * 好友动态控制器
 */
@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PostController extends BaseController {

    @Autowired
    private PostService postService;

    /**
     * 创建动态
     * @param request 创建动态请求
     * @return 创建的动态
     */
    @PostMapping
    public ApiResponse<PostResponse> createPost(@RequestBody CreatePostRequest request) {
        Long userId = getCurrentUserId();
        Post post = postService.createPost(userId, request);
        return ApiResponse.success("动态发布成功", PostResponse.fromPost(post,false));
    }

    /**
     * 获取动态详情
     * @param postId 动态ID
     * @return 动态详情
     */
    @GetMapping("/{postId}")
    public ApiResponse<PostResponse> getPostById(@PathVariable Long postId) {
        Long userId = getCurrentUserId();
        PostResponse post = postService.getPostById(postId, userId);
        return ApiResponse.success(post);
    }

    /**
     * 获取用户的动态列表
     * @param userId 用户ID，如果为空则获取当前用户的动态
     * @param page 页码
     * @param size 每页大小
     * @return 动态列表
     */
    @GetMapping("/user/{userId}")
    public ApiResponse<Page<PostResponse>> getUserPosts(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long currentUserId = getCurrentUserId();
        Pageable pageable = PageRequest.of(page, size);
        Page<PostResponse> posts = postService.getUserPosts(userId, currentUserId, pageable);
        return ApiResponse.success(posts);
    }

    /**
     * 获取当前用户的动态列表
     * @param page 页码
     * @param size 每页大小
     * @return 动态列表
     */
    @GetMapping("/my")
    public ApiResponse<Page<PostResponse>> getMyPosts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long userId = getCurrentUserId();
        Pageable pageable = PageRequest.of(page, size);
        Page<PostResponse> posts = postService.getUserPosts(userId, userId, pageable);
        return ApiResponse.success(posts);
    }

    /**
     * 获取好友动态列表（包括自己的动态）
     * @param page 页码
     * @param size 每页大小
     * @return 动态列表
     */
    @GetMapping("/timeline")
    public ApiResponse<Page<PostResponse>> getFriendPosts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long userId = getCurrentUserId();
        Pageable pageable = PageRequest.of(page, size);
        Page<PostResponse> posts = postService.getFriendPosts(userId, pageable);
        return ApiResponse.success(posts);
    }

    /**
     * 点赞动态
     * @param postId 动态ID
     * @return 点赞结果
     */
    @PostMapping("/{postId}/like")
    public ApiResponse<Boolean> likePost(@PathVariable Long postId) {
        Long userId = getCurrentUserId();
        boolean result = postService.likePost(postId, userId);
        return ApiResponse.success(result ? "点赞成功" : "已点赞，无需重复操作", result);
    }

    /**
     * 取消点赞
     * @param postId 动态ID
     * @return 取消点赞结果
     */
    @DeleteMapping("/{postId}/like")
    public ApiResponse<Boolean> unlikePost(@PathVariable Long postId) {
        Long userId = getCurrentUserId();
        boolean result = postService.unlikePost(postId, userId);
        return ApiResponse.success(result ? "取消点赞成功" : "未点赞，无需取消", result);
    }

    /**
     * 检查用户是否已点赞动态
     * @param postId 动态ID
     * @return 是否已点赞
     */
    @GetMapping("/{postId}/like/status")
    public ApiResponse<Boolean> isPostLikedByUser(@PathVariable Long postId) {
        Long userId = getCurrentUserId();
        boolean liked = postService.isPostLikedByUser(postId, userId);
        return ApiResponse.success(liked);
    }
}