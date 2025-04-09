package com.im.backend.service.impl;

import com.im.backend.model.*;
import com.im.backend.model.message.ConversationContent;
import com.im.backend.model.types.ConversationType;
import com.im.backend.model.types.MemberRole;
import com.im.backend.repository.*;
import com.im.backend.service.GroupService;
import com.im.backend.util.JsonUtil;
import com.im.backend.websocket.handler.ChatWebSocketHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class GroupServiceImpl implements GroupService {

    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private ChatWebSocketHandler chatWebSocketHandler;

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ConversationMemberRepository conversationMemberRepository;

    /**
     * 创建群聊
     */
    @Override
    @Transactional
    public Conversation createGroup(User owner, String name, String avatar, String description, List<Long> initialMemberIds, Map<String, Object> settings) {
        // 创建会话
        Conversation conversation = new Conversation();
        conversation.setType(ConversationType.GROUP);
        conversation.setName(name);
        conversation.setAvatar(avatar);
        conversation = conversationRepository.save(conversation);

        // 使用会话创建群组信息
        Group group = new Group();
        group.setName(name);
        group.setAvatar(avatar);
        group.setDescription(description);
        group.setConversation(conversation);
        group.setOwner(owner);

        if (settings != null) {
            group.setExtraSettings(JsonUtil.toJson(settings));
        }

        // 保存群组信息
        groupRepository.save(group);

        // 批量添加成员（包括群主）
        List<ConversationMember> members = new ArrayList<>();

        // 添加群主
        ConversationMember ownerMember = createMember(conversation.getId(), owner.getId(), MemberRole.OWNER, name);
        members.add(ownerMember);

        // 添加初始成员
        if (initialMemberIds != null && !initialMemberIds.isEmpty()) {
            for (Long memberId : initialMemberIds) {
                if (!memberId.equals(owner.getId())) {  // 避免重复添加群主
                    ConversationMember member = createMember(conversation.getId(), memberId, MemberRole.MEMBER, name);
                    members.add(member);
                }
            }
        }

        // 批量保存所有成员
        conversationMemberRepository.saveAll(members);
        String messageText = owner.getNickname() + " 创建了群聊 \"" + conversation.getName() + "\"";

        Conversation conversation1 = conversationRepository.findByConversationId(group.getConversationId(),owner.getId());
        chatWebSocketHandler.sendConversationNotification(conversation.getId(), ConversationContent.ACTION_CREATE, messageText, owner.getId());
        return conversation1;
    }

    /**
     * 创建会话成员对象（不保存到数据库）
     */
    private ConversationMember createMember(Long conversationId, Long userId, MemberRole role, String displayName) {
        // 获取用户信息
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("用户不存在"));

        // 创建会话成员对象
        ConversationMember member = new ConversationMember();
        member.setConversationId(conversationId);
        member.setNickname(user.getNickname());
        member.setAvatar(user.getAvatar());
        member.setDisplayName(displayName);
        member.setUserId(userId);
        member.setRole(role);
        member.setUnreadCount(0);

        return member;
    }
    /**
     * 更新群聊信息
     */
    @Override
    @Transactional
    public Group updateGroupInfo(Long groupId, Long userId, String name, String avatar, String description) {
        Group group = validateGroupAndPermission(groupId, userId);

        boolean updated = false;

        if (name != null && !name.isEmpty() && !name.equals(group.getName())) {
            group.setName(name);
            updated = true;
        }

        if (avatar != null && !avatar.equals(group.getAvatar())) {
            group.setAvatar(avatar);
            updated = true;
        }

        if (description != null && !description.equals(group.getDescription())) {
            group.setDescription(description);
            updated = true;
        }

        if (updated) {
            group = groupRepository.save(group);

            // 如果群名或头像更新了，同步更新会话信息
            Conversation conversation = group.getConversation();
            if (name != null && !name.isEmpty()) {
                conversation.setName(name);
            }

            if (avatar != null) {
                conversation.setAvatar(avatar);
            }

            if (name != null || avatar != null) {
                conversationRepository.save(conversation);
            }
        }

        return group;
    }

    /**
     * 判断用户是否是群主或管理员
     */
    private boolean isOwnerOrAdmin(Group group, Long userId) {
        // 如果是群主（从Group表检查）
        if (group.getOwner().getId().equals(userId)) {
            return true;
        }

        // 检查是否是管理员或群主（从会话成员表检查）
        Long conversationId = group.getConversation().getId();

        // 检查是否是群主（双重保障）
        if(conversationMemberRepository.findByConversationIdAndUserIdAndRole(
            conversationId, userId, MemberRole.OWNER).isPresent()){
            return true;
        }

        // 检查是否是管理员
        return conversationMemberRepository.findByConversationIdAndUserIdAndRole(
            conversationId, userId, MemberRole.ADMIN).isPresent();
    }

    /**
     * 验证群聊和权限
     */
    private Group validateGroupAndPermission(Long groupId, Long userId) {
        Group group = groupRepository.findById(groupId)
                .orElseThrow(() -> new RuntimeException("群聊不存在"));

        if (!isOwnerOrAdmin(group, userId)) {
            throw new RuntimeException("没有操作权限");
        }

        return group;
    }


    /**
     * 更新群聊设置
     */
    @Override
    @Transactional
    public void updateGroupSettings(Long groupId, Long userId, Map<String, Object> settings) {
        Group group = validateGroupAndPermission(groupId, userId);
        groupRepository.save(group);
    }

    /**
     * 解散群聊
     */
    @Override
    @Transactional
    public void dismissGroup(Long groupId, Long userId) {
        Group group = groupRepository.findById(groupId)
            .orElseThrow(() -> new RuntimeException("群聊不存在"));

        // 只有群主可以解散群聊
        if (!group.getOwner().getId().equals(userId)) {
            throw new RuntimeException("只有群主可以解散群聊");
        }


        // 删除群聊信息
        groupRepository.deleteById(groupId);

        // 删除会话
        conversationRepository.deleteById(group.getConversationId());

        chatWebSocketHandler.sendConversationNotification(group.getConversationId(), ConversationContent.ACTION_DELETE,"", userId);
    }

    /**
     * 获取用户加入的所有群组
     */
    @Override
    public List<Group> getUserGroups(Long userId) {
        return groupRepository.findGroupsByUserId(userId);
    }

    @Override
    public Group findById(Long groupId) {
        return groupRepository.findById(groupId).get();
    }
}