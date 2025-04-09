package com.im.backend.controller;

import com.im.backend.config.security.AuthUserDetails;
import com.im.backend.dto.ApiResponse;
import com.im.backend.dto.LoginRequest;
import com.im.backend.dto.LoginResponse;
import com.im.backend.dto.UserRegistrationDto;
import com.im.backend.dto.ChangePasswordRequest;
import com.im.backend.dto.UpdateUserInfoRequest;
import com.im.backend.model.User;
import com.im.backend.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ApiResponse<User> registerUser(@Valid @RequestBody UserRegistrationDto registrationDto) {
        User user = userService.registerUser(registrationDto);
        return ApiResponse.success("用户注册成功", user);
    }

    @PostMapping("/login")
    public ApiResponse<LoginResponse> loginUser(@Valid @RequestBody LoginRequest loginRequest) {
        LoginResponse loginResponse = userService.loginUser(loginRequest);
        return ApiResponse.success("登录成功", loginResponse);
    }
    
    /**
     * 修改密码
     */
    @PostMapping("/change-password")
    public ApiResponse<?> changePassword(
            @Valid @RequestBody ChangePasswordRequest request,
            @AuthenticationPrincipal AuthUserDetails userDetails) {
        userService.changePassword(userDetails.getId(), request.getOldPassword(), request.getNewPassword());
        return ApiResponse.success("密码修改成功");
    }
    
    /**
     * 修改用户信息
     */
    @PutMapping("/profile")
    public ApiResponse<User> updateUserInfo(
            @Valid @RequestBody UpdateUserInfoRequest request,
            @AuthenticationPrincipal AuthUserDetails userDetails) {
        User updatedUser = userService.updateUserInfo(userDetails.getId(), request);
        return ApiResponse.success("用户信息更新成功", updatedUser);
    }
    
    /**
     * 获取当前用户信息
     */
    @GetMapping("/profile")
    public ApiResponse<User> getCurrentUserInfo(@AuthenticationPrincipal AuthUserDetails userDetails) {
        User user = userService.getUserById(userDetails.getId());
        return ApiResponse.success(user);
    }
}