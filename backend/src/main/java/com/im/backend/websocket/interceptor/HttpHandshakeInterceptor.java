package com.im.backend.websocket.interceptor;

import com.im.backend.config.security.JwtTokenProvider;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.List;
import java.util.Map;

/**
 * WebSocket握手拦截器
 * 用于在WebSocket握手阶段提取用户信息并存储到会话属性中
 */
@Component
public class HttpHandshakeInterceptor implements HandshakeInterceptor {
    @Resource
   JwtTokenProvider jwtTokenProvider;

    private static final Logger logger = LoggerFactory.getLogger(HttpHandshakeInterceptor.class);

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) {
        if (request instanceof ServletServerHttpRequest servletRequest) {
            HttpServletRequest httpServletRequest = servletRequest.getServletRequest();
            String token = httpServletRequest.getParameter("token");
            
            if (token != null && !token.isEmpty()) {
                if (jwtTokenProvider.validateToken(token)) {
                    // 将用户名存储在WebSocket会话属性中
                    String username = jwtTokenProvider.getUsernameFromToken(token);
                    attributes.put("username", username);
                    logger.info("WebSocket握手: 用户 '{}' 已通过URL参数认证", username);
                    return true;
                } else {
                    logger.warn("WebSocket握手: URL参数中的token无效");
                }
            }
        }
        
        logger.warn("WebSocket握手: 未提供有效的认证信息");
        return false;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {
        logger.info("执行握手拦截器: afterHandshake");
        // 握手后的处理，通常不需要特殊操作
    }
}