package com.im.backend.controller;

import com.im.backend.dto.ApiResponse;
import com.im.backend.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/files")
@CrossOrigin(origins = "*", maxAge = 3600)
public class FileController {

    @Autowired
    private FileService fileService;

    /**
     * 获取文件上传的预签名URL
     */
    @GetMapping("/upload-url")
    public ApiResponse<Map<String, String>> getUploadUrl(
            @RequestParam String fileName,
            @RequestParam String contentType,
            @AuthenticationPrincipal UserDetails userDetails) {
        
        Map<String, String> urlInfo = fileService.getPresignedUrl(fileName, contentType);
        return ApiResponse.success("获取上传URL成功", urlInfo);
    }
}