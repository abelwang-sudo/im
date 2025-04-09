package com.im.backend.model.message;

import com.im.backend.model.types.MessageContentType;
import com.im.backend.model.types.UserStatus;

public class UserStatusMessageContent extends BaseMessageContent {
    private UserStatus status;
    public UserStatusMessageContent(UserStatus userStatus) {
        setText(userStatus.name());
        this.status = userStatus;
        setType(MessageContentType.USER_STATUS.name());
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }
}