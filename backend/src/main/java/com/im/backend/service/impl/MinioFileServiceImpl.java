package com.im.backend.service.impl;

import com.im.backend.config.MinioConfig;
import com.im.backend.service.FileService;
import io.minio.*;
import io.minio.errors.*;
import io.minio.http.Method;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class MinioFileServiceImpl implements FileService {

    @Autowired
    private MinioClient minioClient;

    @Autowired
    private MinioConfig minioConfig;

    @Override
    public Map<String, String> getPresignedUrl(String originalFilename, String contentType) {
        try {
            // 确保bucket存在
            boolean bucketExists = minioClient.bucketExists(BucketExistsArgs.builder()
                    .bucket(minioConfig.getBucketName())
                    .build());
            
            if (!bucketExists) {
                minioClient.makeBucket(MakeBucketArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .build());
            }
            
            // 生成唯一文件名
            String fileExtension = "";
            if (originalFilename.contains(".")) {
                fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String fileName = UUID.randomUUID().toString() + fileExtension;
            
            // 设置文件元数据
            Map<String, String> reqParams = new HashMap<>();
            reqParams.put("Content-Type", contentType);
            
            // 获取上传URL，有效期10分钟
            String presignedUrl = minioClient.getPresignedObjectUrl(
                    GetPresignedObjectUrlArgs.builder()
                            .method(Method.PUT)
                            .bucket(minioConfig.getBucketName())
                            .object(fileName)
                            .expiry(10, TimeUnit.MINUTES)
                            .extraQueryParams(reqParams)
                            .build());
            
            // 构建文件访问URL
            String fileUrl = minioClient.getPresignedObjectUrl(
                    GetPresignedObjectUrlArgs.builder()
                            .method(Method.GET)
                            .bucket(minioConfig.getBucketName())
                            .object(fileName)
                            .expiry(7, TimeUnit.DAYS)
                            .build());
            
            Map<String, String> result = new HashMap<>();
            result.put("uploadUrl", presignedUrl);
            result.put("fileUrl", fileUrl);
            result.put("fileName", fileName);
            
            return result;
        } catch (Exception e) {
            throw new RuntimeException("获取预签名URL失败", e);
        }
    }

    @Override
    public boolean isFileExist(String fileName) {
        try {
            minioClient.statObject(
                    StatObjectArgs.builder()
                            .bucket(minioConfig.getBucketName())
                            .object(fileName)
                            .build());
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}