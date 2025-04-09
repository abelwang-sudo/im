package com.im.backend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;

@Data
@Entity
@Table(name = "chat_groups")
public class Group  implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    @Column(length = 2048)
    private String avatar;
    
    @Column(length = 4096)
    private String description;
    
    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "conversation_id", nullable = false, unique = true)
    @JsonIgnore
    private Conversation conversation;
    
    @ManyToOne
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;
    
    @Column(columnDefinition = "JSON")
    private String extraSettings;

    public Long getConversationId() {
        return conversation != null ? conversation.getId() : null;
    }

}