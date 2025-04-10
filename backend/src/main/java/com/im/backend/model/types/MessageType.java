package com.im.backend.model.types;

public enum MessageType {
    CHAT,       // 普通聊天消息
    JOIN,       // 用户加入通知
    LEAVE,      // 用户离开通知
    TYPING,     // 用户正在输入
    HEARTBEAT,  // 心跳消息
    PING,
    NOTICE,
    PONG,
    POST,
}