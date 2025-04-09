package com.im.backend.model.converter;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.BasicPolymorphicTypeValidator;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;
import com.im.backend.model.ChatMessage;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class MessageConverter implements AttributeConverter<ChatMessage, String> {
    
    private static final ObjectMapper objectMapper;
    
    static {
        objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }
    
    @Override
    public String convertToDatabaseColumn(ChatMessage attribute) {
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
    public ChatMessage convertToEntityAttribute(String dbData) {
        try {
            if (dbData == null || dbData.isEmpty()) {
                return null;
            }
            // 使用BaseMessageContent.class作为目标类型，让Jackson根据@JsonTypeInfo注解决定具体子类
            return objectMapper.readValue(dbData, ChatMessage.class);
        } catch (Exception e) {
            throw new RuntimeException("从JSON转换消息内容失败: " + dbData, e);
        }
    }
}