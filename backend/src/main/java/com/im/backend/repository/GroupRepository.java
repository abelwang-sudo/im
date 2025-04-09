package com.im.backend.repository;

import com.im.backend.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {
    // 可以根据需要添加自定义查询方法

    /**
     * 查询用户加入的所有群组
     *
     * @param userId 用户ID
     * @return 用户加入的群组列表
     */
    @Query("SELECT g FROM Group g JOIN g.conversation c JOIN ConversationMember m ON c.id = m.conversationId " +
           "WHERE m.userId = :userId AND m.visible = true " +
           "ORDER BY c.updatedAt DESC")
    List<Group> findGroupsByUserId(@Param("userId") Long userId);
}