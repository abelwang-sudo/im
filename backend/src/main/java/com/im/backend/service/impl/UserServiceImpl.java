package com.im.backend.service.impl;

import com.im.backend.config.exception.BusinessException;
import com.im.backend.config.security.JwtTokenProvider;
import com.im.backend.dto.LoginRequest;
import com.im.backend.dto.LoginResponse;
import com.im.backend.dto.UpdateUserInfoRequest;
import com.im.backend.dto.UserRegistrationDto;
import com.im.backend.model.User;
import com.im.backend.repository.UserRepository;
import com.im.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Value("${app.user.default-avatar}")
    private String defaultAvatarUrl;

    public LoginResponse loginUser(LoginRequest loginRequest) {
        // 根据用户名查找用户
        User user = userRepository.findByUsername(loginRequest.getUsername())
                .orElseThrow(() -> new BusinessException("用户名或密码错误"));

        // 验证密码
        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }

        // 生成JWT token
        String token = jwtTokenProvider.createToken(user.getId());

        // 创建登录响应
        LoginResponse response = new LoginResponse();
        response.setToken(token);
        response.setUsername(user.getUsername());
        response.setNickname(user.getNickname());
        response.setEmail(user.getEmail());
        response.setId(user.getId());
        response.setAvatar(user.getAvatar());

        return response;
    }

    public User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("用户不存在"));
    }

    public User registerUser(UserRegistrationDto registrationDto) {
        // 检查用户名是否已存在
        if (userRepository.existsByUsername(registrationDto.getUsername())) {
            throw new BusinessException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (userRepository.existsByEmail(registrationDto.getEmail())) {
            throw new BusinessException("邮箱已被注册");
        }

        // 创建新用户
        User user = new User();
        // 如果username为空，则使用email作为默认值
        String username = registrationDto.getUsername();
        if (username == null || username.trim().isEmpty()) {
            username = registrationDto.getEmail();
        }
        if(registrationDto.getNickname() == null){
            user.setNickname(registrationDto.getEmail());
        }else{
            user.setNickname(registrationDto.getNickname());
        }
        user.setUsername(username);
        user.setEmail(registrationDto.getEmail());

        // 加密密码
        String encodedPassword = passwordEncoder.encode(registrationDto.getPassword());
        user.setPassword(encodedPassword);

        // 设置默认头像
        if (registrationDto.getAvatar() == null || registrationDto.getAvatar().trim().isEmpty()) {
            // 如果默认头像URL包含 {username} 占位符，则替换为实际用户名
            user.setAvatar(defaultAvatarUrl);
        } else {
            user.setAvatar(registrationDto.getAvatar());
        }

        // 保存用户
        return userRepository.save(user);
    }

    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = getUserById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 验证旧密码
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new BusinessException("旧密码不正确");
        }

        // 更新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    public User updateUserInfo(Long userId, UpdateUserInfoRequest request) {
        User user = getUserById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        // 更新用户信息
        if (request.getNickname() != null && !request.getNickname().isEmpty()) {
            user.setNickname(request.getNickname());
        }

        if (request.getAvatar() != null) {
            user.setAvatar(request.getAvatar());
        }
        return userRepository.save(user);
    }
}