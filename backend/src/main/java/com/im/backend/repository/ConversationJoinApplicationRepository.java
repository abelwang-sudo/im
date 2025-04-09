package com.im.backend.repository;

import com.im.backend.model.Group;
import com.im.backend.model.ConversationJoinApplication;
import com.im.backend.model.User;
import com.im.backend.model.types.ApplicationStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConversationJoinApplicationRepository extends JpaRepository<ConversationJoinApplication, Long> {
    List<ConversationJoinApplication> findByConversationIdAndStatus(Long conversationId, ApplicationStatus status);
 List<ConversationJoinApplication> findByConversationId(Long conversationId);
 }

