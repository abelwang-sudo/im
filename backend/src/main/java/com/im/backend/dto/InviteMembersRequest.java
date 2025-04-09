package com.im.backend.dto;

import java.util.List;
import java.util.Map;

public class InviteMembersRequest {
    private List<Long> memberIds;
    
    public List<Long> getMemberIds() {
        return memberIds;
    }
    
    public void setMemberIds(List<Long> memberIds) {
        this.memberIds = memberIds;
    }
} 