package com.im.backend.service.impl;

import com.im.backend.config.FriendshipConfig;
import com.im.backend.config.exception.BusinessException;
import com.im.backend.model.Friendship;
import com.im.backend.model.User;
import com.im.backend.repository.FriendshipRepository;
import com.im.backend.repository.UserRepository;
import com.im.backend.service.FriendshipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FriendshipServiceImpl implements FriendshipService {

    @Autowired
    private FriendshipRepository friendshipRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FriendshipConfig friendshipConfig;

    @Override
    @Transactional
    public Friendship sendFriendRequest(Long requesterId, Long addresseeId) {
        // 检查用户是否存在
        User requester = userRepository.findById(requesterId)
                .orElseThrow(() -> new BusinessException("请求者用户不存在"));
        User addressee = userRepository.findById(addresseeId)
                .orElseThrow(() -> new BusinessException("接收者用户不存在"));

        // 检查是否是自己
        if (requesterId.equals(addresseeId)) {
            throw new BusinessException("不能添加自己为好友");
        }

        // 检查是否已经是好友
        if (areFriends(requesterId, addresseeId)) {
            throw new BusinessException("已经是好友关系");
        }

        // 检查是否已经有待处理的好友请求
        if (friendshipRepository.existsByRequesterAndAddresseeAndStatus(
                requester, addressee, Friendship.FriendshipStatus.PENDING)) {
            throw new BusinessException("已经发送过好友请求，请等待对方确认");
        }

        // 检查对方是否已经发送了好友请求
        Optional<Friendship> existingRequest = friendshipRepository.findByRequesterAndAddresseeAndStatus(
                addressee, requester, Friendship.FriendshipStatus.PENDING);
        if (existingRequest.isPresent()) {
            // 如果对方已经发送了好友请求，直接接受该请求
            Friendship friendship = existingRequest.get();
            friendship.setStatus(Friendship.FriendshipStatus.ACCEPTED);
            return friendshipRepository.save(friendship);
        }

        // 创建好友关系
        Friendship friendship = new Friendship();
        friendship.setRequester(requester);
        friendship.setAddressee(addressee);

        // 根据配置决定是否需要确认
        if (friendshipConfig.isRequireConfirmation()) {
            friendship.setStatus(Friendship.FriendshipStatus.PENDING);
        } else {
            friendship.setStatus(Friendship.FriendshipStatus.ACCEPTED);
        }

        return friendshipRepository.save(friendship);
    }

    @Override
    @Transactional
    public Friendship acceptFriendRequest(Long friendshipId, Long userId) {
        Friendship friendship = friendshipRepository.findById(friendshipId)
                .orElseThrow(() -> new BusinessException("好友请求不存在"));

        // 检查当前用户是否是接收者
        if (!friendship.getAddressee().getId().equals(userId)) {
            throw new BusinessException("无权操作此好友请求");
        }

        // 检查状态是否是待确认
        if (friendship.getStatus() != Friendship.FriendshipStatus.PENDING) {
            throw new BusinessException("该好友请求已处理");
        }

        // 更新状态为已接受
        friendship.setStatus(Friendship.FriendshipStatus.ACCEPTED);
        return friendshipRepository.save(friendship);
    }

    @Override
    @Transactional
    public Friendship rejectFriendRequest(Long friendshipId, Long userId) {
        Friendship friendship = friendshipRepository.findById(friendshipId)
                .orElseThrow(() -> new BusinessException("好友请求不存在"));

        // 检查当前用户是否是接收者
        if (!friendship.getAddressee().getId().equals(userId)) {
            throw new BusinessException("无权操作此好友请求");
        }

        // 检查状态是否是待确认
        if (friendship.getStatus() != Friendship.FriendshipStatus.PENDING) {
            throw new BusinessException("该好友请求已处理");
        }

        // 更新状态为已拒绝
        friendship.setStatus(Friendship.FriendshipStatus.REJECTED);
        return friendshipRepository.save(friendship);
    }

    @Override
    public List<User> getUserFriends(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));

        // 获取用户的所有已接受的好友关系
        List<Friendship> friendships = friendshipRepository.findAllAcceptedFriendships(user);

        // 提取好友用户
        List<User> friends = new ArrayList<>();
        for (Friendship friendship : friendships) {
            if (friendship.getRequester().getId().equals(userId)) {
                friends.add(friendship.getAddressee());
            } else {
                friends.add(friendship.getRequester());
            }
        }

        return friends;
    }

    @Override
    public List<Friendship> getPendingFriendRequests(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));

        // 获取用户收到的所有待确认的好友请求
        return friendshipRepository.findByAddresseeAndStatus(user, Friendship.FriendshipStatus.PENDING);
    }

    @Override
    public boolean areFriends(Long userId1, Long userId2) {
        User user1 = userRepository.findById(userId1)
                .orElseThrow(() -> new BusinessException("用户1不存在"));
        User user2 = userRepository.findById(userId2)
                .orElseThrow(() -> new BusinessException("用户2不存在"));

        // 查询两个用户之间是否存在已接受的好友关系
        Optional<Friendship> friendship = friendshipRepository.findFriendshipBetweenUsers(user1, user2);
        return friendship.isPresent() && friendship.get().getStatus() == Friendship.FriendshipStatus.ACCEPTED;
    }

    @Override
    @Transactional
    public boolean deleteFriendship(Long userId, Long friendId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new BusinessException("好友不存在"));

        // 查询两个用户之间的好友关系
        Optional<Friendship> friendship = friendshipRepository.findFriendshipBetweenUsers(user, friend);
        if (friendship.isPresent() && friendship.get().getStatus() == Friendship.FriendshipStatus.ACCEPTED) {
            friendshipRepository.delete(friendship.get());
            return true;
        }
        return false;
    }
}