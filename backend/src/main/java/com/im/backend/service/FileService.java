package com.im.backend.service;

import java.util.Map;

public interface FileService {
    /**
     * 获取文件上传的预签名URL
     * @param fileName 文件名
     * @param contentType 文件类型
     * @return 预签名URL和文件访问URL
     */
    Map<String, String> getPresignedUrl(String fileName, String contentType);
    
    /**
     * 检查文件是否存在
     * @param fileName 文件名
     * @return 是否存在
     */
    boolean isFileExist(String fileName);
}