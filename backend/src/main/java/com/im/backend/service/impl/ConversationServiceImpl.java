package com.im.backend.service.impl;

import com.im.backend.config.exception.BusinessException;
import com.im.backend.dto.UpdateConversationRequest;
import com.im.backend.model.*;
import com.im.backend.model.message.ConversationContent;
import com.im.backend.model.message.MemberContent;
import com.im.backend.model.types.ApplicationStatus;
import com.im.backend.model.types.ConversationType;
import com.im.backend.model.types.MemberRole;
import com.im.backend.repository.ChatMessageRepository;
import com.im.backend.repository.ConversationJoinApplicationRepository;
import com.im.backend.repository.ConversationMemberRepository;
import com.im.backend.repository.ConversationRepository;
import com.im.backend.service.ConversationService;
import com.im.backend.service.UserService;
import com.im.backend.websocket.handler.ChatWebSocketHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ConversationServiceImpl implements ConversationService {

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private ConversationMemberRepository conversationMemberRepository;

    @Autowired
    private ChatWebSocketHandler chatWebSocketHandler;

    @Autowired
    private ConversationJoinApplicationRepository joinApplicationRepository;

    @Override
    @Transactional
    public Conversation createConversation(ConversationType type, Long creatorId, List<Long> memberIds, String avatar) {
        // 确保创建者也是会话成员
        if (!memberIds.contains(creatorId)) {
            memberIds.add(creatorId);
        }

        // 检查是否已存在相同成员的会话
        if (type == ConversationType.PRIVATE) {
            if (memberIds.size() != 2) {
                throw new RuntimeException("单聊会话必须有且仅有两个成员");
            }
            List<Conversation> existingConversations = conversationRepository.findPrivateConversationBetweenUsers(
                    memberIds.get(0), memberIds.get(1));
            if (!existingConversations.isEmpty()) {
                ///已经存在的 之前删除过 恢复显示
                List<ConversationMember> conversationMembers = conversationMemberRepository.findByConversationIdAndUserId(existingConversations.get(0).getId(),creatorId);
                for (ConversationMember conversationMember : conversationMembers) {
                    conversationMember.setVisible(true);
                    conversationMemberRepository.save(conversationMember);
                }
                Conversation conversation =  existingConversations.get(0);
                conversation.setMember(conversationMembers.get(0));
                return conversation;
            }
        }

        // 批量查询所有用户信息
        Map<Long, User> userMap = memberIds.stream()
                .map(userService::getUserById)
                .collect(Collectors.toMap(User::getId, user -> user));

        // 创建新会话
        Conversation conversation = new Conversation();
        conversation.setType(type);

        // 设置会话名称和头像
        if (type == ConversationType.PRIVATE) {
            // 单聊使用对方的昵称
            Long otherUserId = memberIds.stream()
                    .filter(id -> !id.equals(creatorId))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("无法找到对方用户ID"));
            User otherUser = userMap.get(otherUserId);
            conversation.setName(otherUser.getNickname() + " - " + userMap.get(creatorId).getNickname());
            // 单聊使用对方的头像
            conversation.setAvatar(otherUser.getAvatar());
        } else {
            // 群聊使用成员昵称拼接，最长50个字符
            StringBuilder nameBuilder = new StringBuilder();
            for (Long userId : memberIds) {
                User user = userMap.get(userId);
                if (nameBuilder.length() > 0) {
                    nameBuilder.append("、");
                }
                nameBuilder.append(user.getNickname());
                if (nameBuilder.length() >= 47) {
                    nameBuilder.append("...");
                    break;
                }
            }
            conversation.setName(nameBuilder.toString());
            // 群聊使用传入的头像，如果没有则使用默认头像
            conversation.setAvatar(avatar != null ? avatar : "/default-group-avatar.png");
        }

        conversation = conversationRepository.save(conversation);

        // 创建会话成员记录
        List<ConversationMember> members = new ArrayList<>();
        for (Long userId : memberIds) {
            User user = userMap.get(userId);
            ConversationMember member = new ConversationMember();
            member.setConversationId(conversation.getId());
            member.setUserId(userId);
            member.setNickname(user.getNickname());
            member.setAvatar(user.getAvatar());
            // 设置显示名称
            if (type == ConversationType.PRIVATE) {
                // 单聊时，显示名称为对方的昵称
                if (userId.equals(creatorId)) {
                    User otherUser = userMap.get(memberIds.stream()
                            .filter(id -> !id.equals(creatorId))
                            .findFirst()
                            .orElseThrow(() -> new RuntimeException("无法找到对方用户ID")));
                    member.setDisplayName(otherUser.getNickname());
                } else {
                    User creator = userMap.get(creatorId);
                    member.setDisplayName(creator.getNickname());
                }
            } else {
                // 群聊时，显示名称为群聊名称
                member.setDisplayName(conversation.getName());
            }
            members.add(member);
        }

        conversationMemberRepository.saveAll(members);

        // 创建者信息
        User creator = userService.getUserById(creatorId);

        // 创建通知消息
        String messageText = creator.getNickname() + " 创建了群聊 \"" + conversation.getName() + "\"";

        chatWebSocketHandler.sendConversationNotification(conversation.getId(), ConversationContent.ACTION_CREATE, messageText, creatorId);
        // 设置会话的创建者成员信息
        conversation.setMember(members.stream()
                .filter(member -> member.getUserId().equals(creatorId))
                .findFirst()
                .orElse(null));
        return conversation;
    }

    @Override
    public List<Conversation> getUserConversations(Long userId) {
        // 通过会话成员表查询用户参与的所有会话及其显示名称
        return conversationRepository.findByMemberUserIdWithDisplayName(userId);
    }

    @Override
    @Transactional
    public void inviteMembers(Long conversationId, Long inviterId, List<Long> memberIds) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));

        // 检查是否为群聊
        if (conversation.getType() != ConversationType.GROUP) {
            throw new RuntimeException("只能向群聊中邀请成员");
        }

        // 获取邀请者的成员信息
        ConversationMember inviter = conversationMemberRepository.findByConversationIdAndUserId(conversationId, inviterId)
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("邀请者不是群成员"));

        // 检查权限
        if (conversation.isOnlyAdminCanInvite() &&
                inviter.getRole() != MemberRole.OWNER &&
                inviter.getRole() != MemberRole.ADMIN) {
            throw new RuntimeException("只有群主或管理员可以邀请新成员");
        }

        // 获取邀请者信息
        User inviterUser = userService.getUserById(inviterId);

        // 处理每个被邀请成员
        for (Long userId : memberIds) {
            if (!isConversationMember(conversationId, userId)) {
                if (conversation.isRequireApproval() &&
                        inviter.getRole() != MemberRole.OWNER &&
                        inviter.getRole() != MemberRole.ADMIN) {
                    // 需要审批，创建加入申请
                    ConversationJoinApplication application = new ConversationJoinApplication();
                    application.setConversationId(conversationId);
                    application.setApplicant(userService.getUserById(userId));
                    application.setReason("被 " + inviterUser.getNickname() + " 邀请加入群聊");
                    application.setStatus(ApplicationStatus.PENDING);
                    joinApplicationRepository.save(application);

                    // 发送申请通知给管理员
                    String notifyText = inviterUser.getNickname() + " 邀请 " +
                            userService.getUserById(userId).getNickname() +
                            " 加入群聊，等待审批";
                    chatWebSocketHandler.sendMemberChangeNotification(
                            conversationId,
                            MemberContent.ACTION_REQUEST,
                            notifyText,
                            List.of()
                    );
                } else {
                    // 直接添加成员
                    addNewMember(conversation, userId);
                }
            }
        }
    }

    // 添加新成员的辅助方法
    private void addNewMember(Conversation conversation, Long userId) {
        User user = userService.getUserById(userId);
        ConversationMember member = new ConversationMember();
        member.setConversationId(conversation.getId());
        member.setUserId(userId);
        member.setDisplayName(conversation.getName());
        member.setNickname(user.getNickname());
        member.setAvatar(user.getAvatar());
        member.setRole(MemberRole.MEMBER);
        conversationMemberRepository.save(member);

        // 发送成员加入通知
        String messageText = user.getNickname() + " 加入了群聊";
        chatWebSocketHandler.sendMemberChangeNotification(
                conversation.getId(),
                MemberContent.ACTION_JOIN,
                messageText,
                List.of(member)
        );
    }

    @Override
    public void updateLastMessage(Long conversationId, ChatMessage message) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));
        // 更新最后一条消息的ID和时间
        conversation.setLastMessage(message);
        conversationRepository.save(conversation);
    }

    @Override
    public List<Long> getConversationMemberIds(Long conversationId) {
        return conversationRepository.findMemberIdsByConversationId(conversationId);
    }

    private boolean isConversationMember(Long conversationId, Long userId) {
        return conversationRepository.existsByConversationIdAndUserId(conversationId, userId);
    }

    @Override
    @Transactional
    public void updateConversationName(Long conversationId, Long userId, String name) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));

        // 检查是否为群聊
        if (conversation.getType() != ConversationType.GROUP) {
            throw new RuntimeException("只能修改群聊名称");
        }

        // 检查是否是会话成员
        if (!isConversationMember(conversationId, userId)) {
            throw new RuntimeException("只有会话成员才能修改群聊名称");
        }

        // 获取修改者信息
        User modifier = userService.getUserById(userId);

        // 保存旧名称用于通知消息
        String oldName = conversation.getName();

        // 更新会话名称
        conversation.setName(name);
        conversationRepository.save(conversation);

        // 更新会话成员的显示名称
        List<ConversationMember> members = conversationMemberRepository.findByConversationId(conversationId);
        for (ConversationMember member : members) {
            member.setDisplayName(name);
        }
        conversationMemberRepository.saveAll(members);

        // 创建通知消息
        String messageText = modifier.getNickname() + " 将群聊名称从 \"" + oldName + "\" 修改为 \"" + name + "\"";
        chatWebSocketHandler.sendConversationNotification(conversationId, ConversationContent.ACTION_UPDATE, messageText, userId);
    }
    
    @Override
    @Transactional
    public void updateConversationInfo(Long conversationId, Long userId, UpdateConversationRequest request) {
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("会话不存在"));

        // 检查是否为群聊
        if (conversation.getType() != ConversationType.GROUP) {
            throw new RuntimeException("只能修改群聊信息");
        }

        // 检查是否是会话成员
        if (!isConversationMember(conversationId, userId)) {
            throw new RuntimeException("只有会话成员才能修改群聊信息");
        }
        
        // 获取修改者信息
        User modifier = userService.getUserById(userId);
        
        // 获取修改者角色
        ConversationMember member = conversationMemberRepository.findByConversationIdAndUserId(conversationId, userId).get(0);
        
        // 检查权限：只有群主或管理员可以修改群聊设置
        boolean isAdminOrOwner = member.getRole() == MemberRole.OWNER || member.getRole() == MemberRole.ADMIN;
        
        // 记录变更内容，用于通知消息
        StringBuilder changes = new StringBuilder();
        
        // 更新会话名称
        if (request.getName() != null && !request.getName().isEmpty()) {
            String oldName = conversation.getName();
            conversation.setName(request.getName());
            
            // 更新会话成员的显示名称
            List<ConversationMember> members = conversationMemberRepository.findByConversationId(conversationId);
            for (ConversationMember m : members) {
                m.setDisplayName(request.getName());
            }
            conversationMemberRepository.saveAll(members);
            
            changes.append("名称从 \"" + oldName + "\" 修改为 \"" + request.getName() + "\"");
        }
        
        // 更新会话头像
        if (request.getAvatar() != null && !request.getAvatar().isEmpty()) {
            conversation.setAvatar(request.getAvatar());
            if (changes.length() > 0) changes.append("，");
            changes.append("更新了群头像");
        }
        
        // 更新群聊设置（需要管理员或群主权限）
        if (isAdminOrOwner) {
            if (request.getRequireApproval() != null) {
                conversation.setRequireApproval(request.getRequireApproval());
                if (changes.length() > 0) changes.append("，");
                changes.append("加入审批" + (request.getRequireApproval() ? "已开启" : "已关闭"));
            }
            
            if (request.getOnlyAdminCanInvite() != null) {
                conversation.setOnlyAdminCanInvite(request.getOnlyAdminCanInvite());
                if (changes.length() > 0) changes.append("，");
                changes.append("仅管理员邀请" + (request.getOnlyAdminCanInvite() ? "已开启" : "已关闭"));
            }
            
            if (request.getOnlyAdminCanSpeak() != null) {
                conversation.setOnlyAdminCanSpeak(request.getOnlyAdminCanSpeak());
                if (changes.length() > 0) changes.append("，");
                changes.append("仅管理员发言" + (request.getOnlyAdminCanSpeak() ? "已开启" : "已关闭"));
            }
        } else if (request.getRequireApproval() != null || request.getOnlyAdminCanInvite() != null || request.getOnlyAdminCanSpeak() != null) {
            // 如果非管理员尝试修改设置，抛出异常
            throw new RuntimeException("只有群主或管理员才能修改群聊设置");
        }
        
        // 保存更新
        conversationRepository.save(conversation);
        
        // 如果有变更，发送通知消息
        if (changes.length() > 0) {
            String messageText = modifier.getNickname() + " " + changes;
            chatWebSocketHandler.sendConversationNotification(conversationId, ConversationContent.ACTION_UPDATE, messageText, userId);
        }
    }


    @Transactional
    public void markConversationAsRead(Long conversationId, Long userId) {
        // 查找会话成员记录
        List<ConversationMember> members = conversationMemberRepository.findByConversationIdAndUserId(conversationId, userId);
        if (!members.isEmpty()) {
            ConversationMember member = members.get(0);
            member.resetUnreadCount();
            conversationMemberRepository.save(member);
        }
    }

    @Override
    @Transactional
    public void deleteConversation(Long conversationId, Long userId) {
        // 检查用户是否是会话成员
        ConversationMember member = conversationMemberRepository.findByConversationIdAndUserId(conversationId, userId)
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("只有会话成员才能删除会话"));

        member.setVisible(false);
        conversationMemberRepository.save(member);
    }

    @Override
    public List<ConversationMember> getConversationMember(Long conversationId) {
        // 检查会话是否存在
        if (!conversationRepository.existsById(conversationId)) {
            throw new RuntimeException("会话不存在");
        }

        // 获取所有会话成员信息
        return conversationMemberRepository.findByConversationId(conversationId);
    }

    @Transactional
    public void handleJoinApplication(Long applicationId, Long reviewerId, boolean approved) {
        ConversationJoinApplication application = joinApplicationRepository.findById(applicationId)
                .orElseThrow(() -> new RuntimeException("申请不存在"));

        // 检查审核者权限
        ConversationMember reviewer = conversationMemberRepository
                .findByConversationIdAndUserId(application.getConversationId(), reviewerId)
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("无权处理该申请"));

        if (reviewer.getRole() != MemberRole.OWNER && reviewer.getRole() != MemberRole.ADMIN) {
            throw new RuntimeException("只有群主或管理员可以处理入群申请");
        }

        // 更新申请状态
        application.setStatus(approved ? ApplicationStatus.APPROVED : ApplicationStatus.REJECTED);
        application.setReviewerId(reviewerId);
        application.setReviewTime(new Date().getTime());
        joinApplicationRepository.save(application);

        if (approved) {
            // 添加新成员
            addNewMember(
                    conversationRepository.findById(application.getConversationId())
                            .orElseThrow(() -> new RuntimeException("会话不存在")),
                    application.getApplicant().getId()
            );
        }
    }

    @Override
    public List<ConversationJoinApplication> getJoinApplications(Long conversationId, ApplicationStatus status) {
        if (status != null) {
            return joinApplicationRepository.findByConversationIdAndStatus(conversationId, status);
        }
        return joinApplicationRepository.findByConversationId(conversationId);
    }

    @Override
    @Transactional
    public void removeMember(Long conversationId, Long memberId, Long operatorId) {
        List<ConversationMember> conversationMember = conversationMemberRepository.findByConversationIdAndUserId(conversationId, memberId);

        // 删除成员记录
        conversationMemberRepository.deleteByConversationIdAndUserId(conversationId, memberId);

        // 发送通知
        User operator = userService.getUserById(operatorId);
        User removedUser = userService.getUserById(memberId);
        String messageText = operator.getNickname() + " 将 " + removedUser.getNickname() + " 移出群聊";

        chatWebSocketHandler.sendMemberChangeNotification(
                conversationId,
                MemberContent.ACTION_REMOVE,
                messageText,
                conversationMember
        );
    }

    @Override
    @Transactional
    public void updateMemberRole(Long conversationId, Long memberId, Long operatorId, boolean isAdmin) {
        // 获取目标成员
        ConversationMember member = conversationMemberRepository.findByConversationIdAndUserId(conversationId, memberId)
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("成员不存在"));

        // 更新角色
        member.setRole(isAdmin ? MemberRole.ADMIN : MemberRole.MEMBER);
        conversationMemberRepository.save(member);

        // 发送通知
        User operator = userService.getUserById(operatorId);
        User targetUser = userService.getUserById(memberId);
        String action = isAdmin ? "设置" : "取消";
        String messageText = operator.getNickname() + " " + action + " " + targetUser.getNickname() + " 为管理员";

        chatWebSocketHandler.sendMemberChangeNotification(
                conversationId,
                MemberContent.ACTION_UPDATE,
                messageText,
                List.of(member)
        );
    }

    @Override
    @Transactional
    public void quitConversation(Long conversationId, Long userId) {
        // 检查会话是否存在
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new BusinessException("会话不存在"));

        // 检查是否是群聊
        if (conversation.getType() != ConversationType.GROUP) {
            throw new BusinessException("只能退出群聊");
        }
        // 检查用户是否是会话成员
        ConversationMember member = conversationMemberRepository.findByConversationIdAndUserId(conversationId, userId)
                .stream()
                .filter(m -> m.getUserId().equals(userId))
                .findFirst()
                .orElseThrow(() -> new BusinessException("您不是该群聊的成员"));

        // 群主不能退出群聊
        if (member.getRole() == MemberRole.OWNER) {
            throw new BusinessException("群主不能退出群聊，请先转让群主或解散群聊");
        }


        // 获取退出者信息
        User user = userService.getUserById(userId);

        // 删除成员记录
        conversationMemberRepository.deleteByConversationIdAndUserId(conversationId, userId);

        // 发送退出通知
        String messageText = user.getNickname() + " 退出了群聊";
        chatWebSocketHandler.sendMemberChangeNotification(
                conversationId,
                MemberContent.ACTION_MEMBER_QUIT,
                messageText,
                List.of(member)

        );
    }
}