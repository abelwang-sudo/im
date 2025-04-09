package com.im.backend.config;

import com.im.backend.dto.ApiResponse;
import com.im.backend.config.exception.BusinessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ApiResponse<?> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return ApiResponse.error(400, "参数验证失败").setData(errors);
    }

    @ExceptionHandler(BusinessException.class)
    public ApiResponse<?> handleBusinessException(BusinessException ex) {
        return ApiResponse.error(400, ex.getMessage());
    }

    @ExceptionHandler({DataIntegrityViolationException.class})
    public ApiResponse<?> handleDatabaseException(Exception ex) {
        // 记录实际的数据库异常信息到日志中
        ex.printStackTrace();
        return ApiResponse.error(500, "数据库操作异常，请稍后重试");
    }

    @ExceptionHandler(Exception.class)
    public ApiResponse<?> handleGeneralException(Exception ex) {
        // 记录未知异常信息到日志中
        ex.printStackTrace();
        return ApiResponse.error(500, "系统发生未知错误，请联系管理员");
    }
}