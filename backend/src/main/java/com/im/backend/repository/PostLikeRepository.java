package com.im.backend.repository;

import com.im.backend.model.Post;
import com.im.backend.model.PostLike;
import com.im.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 动态点赞数据访问层
 */
@Repository
public interface PostLikeRepository extends JpaRepository<PostLike, Long> {
    
    /**
     * 查询用户是否已点赞某动态
     * @param post 动态
     * @param user 用户
     * @return 点赞记录
     */
    Optional<PostLike> findByPostAndUser(Post post, User user);
    
    /**
     * 查询动态的所有点赞记录
     * @param post 动态
     * @return 点赞记录列表
     */
    List<PostLike> findByPostOrderByCreatedAtDesc(Post post);
    
    /**
     * 查询用户点赞的所有动态ID
     * @param userId 用户ID
     * @return 动态ID列表
     */
    @Query("SELECT pl.post.id FROM PostLike pl WHERE pl.user.id = :userId")
    List<Long> findPostIdsByUserId(@Param("userId") Long userId);
    
    /**
     * 统计动态的点赞数量
     * @param postId 动态ID
     * @return 点赞数量
     */
    long countByPostId(Long postId);
    
    /**
     * 删除用户对动态的点赞
     * @param post 动态
     * @param user 用户
     * @return 删除的记录数
     */
    long deleteByPostAndUser(Post post, User user);
}