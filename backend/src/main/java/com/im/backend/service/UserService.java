package com.im.backend.service;

import com.im.backend.dto.LoginRequest;
import com.im.backend.dto.LoginResponse;
import com.im.backend.dto.UpdateUserInfoRequest;
import com.im.backend.dto.UserRegistrationDto;
import com.im.backend.model.User;
import com.im.backend.repository.UserRepository;
import com.im.backend.config.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.im.backend.config.exception.BusinessException;


public interface UserService {
    public LoginResponse loginUser(LoginRequest loginRequest);
    // 添加以下方法
    void changePassword(Long userId, String oldPassword, String newPassword);
    User updateUserInfo(Long userId, UpdateUserInfoRequest request);
    public User getUserById(Long userId);

    public User registerUser(UserRegistrationDto registrationDto);
}