package com.im.backend.model.converter;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.BasicPolymorphicTypeValidator;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;
import com.im.backend.model.message.BaseMessageContent;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class MessageContentConverter implements AttributeConverter<BaseMessageContent, String> {
    
    private static final ObjectMapper objectMapper;
    
    static {
        // 创建类型验证器，只允许指定包下的类进行多态
        PolymorphicTypeValidator ptv = BasicPolymorphicTypeValidator.builder()
                .allowIfSubType("com.im.backend.model.message")
                .build();
        
        objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        // 不使用默认类型，而是依赖@JsonTypeInfo注解
        objectMapper.activateDefaultTyping(ptv, ObjectMapper.DefaultTyping.NON_FINAL);
    }
    
    @Override
    public String convertToDatabaseColumn(BaseMessageContent attribute) {
        try {
            if (attribute == null) {
                return null;
            }
            return objectMapper.writeValueAsString(attribute);
        } catch (Exception e) {
            throw new RuntimeException("转换消息内容到JSON失败", e);
        }
    }
    
    @Override
    public BaseMessageContent convertToEntityAttribute(String dbData) {
        try {
            if (dbData == null || dbData.isEmpty()) {
                return null;
            }
            // 使用BaseMessageContent.class作为目标类型，让Jackson根据@JsonTypeInfo注解决定具体子类
            return objectMapper.readValue(dbData, BaseMessageContent.class);
        } catch (Exception e) {
            throw new RuntimeException("从JSON转换消息内容失败: " + dbData, e);
        }
    }
}