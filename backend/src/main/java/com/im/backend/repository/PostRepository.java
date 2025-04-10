package com.im.backend.repository;

import com.im.backend.model.Post;
import com.im.backend.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 好友动态数据访问层
 */
@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    
    /**
     * 查询指定用户的所有动态
     * @param user 用户
     * @param pageable 分页参数
     * @return 动态分页列表
     */
    Page<Post> findByUserOrderByCreatedAtDesc(User user, Pageable pageable);
    
    /**
     * 查询指定用户ID列表中用户的所有动态
     * @param userIds 用户ID列表
     * @param pageable 分页参数
     * @return 动态分页列表
     */
    @Query("SELECT p FROM Post p WHERE p.user.id IN :userIds ORDER BY p.createdAt DESC")
    Page<Post> findByUserIdInOrderByCreatedAtDesc(@Param("userIds") List<Long> userIds, Pageable pageable);
    
    /**
     * 查询指定用户及其好友的所有动态
     * @param userId 用户ID
     * @param friendIds 好友ID列表
     * @param pageable 分页参数
     * @return 动态分页列表
     */
    @Query("SELECT p FROM Post p WHERE p.user.id = :userId OR p.user.id IN :friendIds ORDER BY p.createdAt DESC")
    Page<Post> findByUserIdOrFriendIdsOrderByCreatedAtDesc(
            @Param("userId") Long userId,
            @Param("friendIds") List<Long> friendIds,
            Pageable pageable);
}