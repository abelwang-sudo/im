package com.im.backend.repository;

import com.im.backend.model.Friendship;
import com.im.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendshipRepository extends JpaRepository<Friendship, Long> {
    // 根据请求者和接收者查询好友关系
    Optional<Friendship> findByRequesterAndAddressee(User requester, User addressee);
    
    // 查询用户发起的所有好友请求
    List<Friendship> findByRequester(User requester);
    
    // 查询用户收到的所有好友请求
    List<Friendship> findByAddressee(User addressee);
    
    // 查询用户的所有已接受的好友关系（作为请求者）
    List<Friendship> findByRequesterAndStatus(User requester, Friendship.FriendshipStatus status);
    
    // 查询用户的所有已接受的好友关系（作为接收者）
    List<Friendship> findByAddresseeAndStatus(User addressee, Friendship.FriendshipStatus status);
    
    // 查询两个用户之间是否存在好友关系（无论方向）
    @Query("SELECT f FROM Friendship f WHERE ((f.requester = ?1 AND f.addressee = ?2) OR (f.requester = ?2 AND f.addressee = ?1)) AND f.status = 'ACCEPTED'")
    Optional<Friendship> findFriendshipBetweenUsers(User user1, User user2);
    
    // 查询用户的所有好友（已接受状态）
    @Query("SELECT f FROM Friendship f WHERE (f.requester = ?1 OR f.addressee = ?1) AND f.status = 'ACCEPTED'")
    List<Friendship> findAllAcceptedFriendships(User user);
    
    // 检查两个用户之间是否已经存在待处理的好友请求
    boolean existsByRequesterAndAddresseeAndStatus(User requester, User addressee, Friendship.FriendshipStatus status);
    
    // 根据请求者、接收者和状态查询好友关系
    Optional<Friendship> findByRequesterAndAddresseeAndStatus(User requester, User addressee, Friendship.FriendshipStatus status);
}