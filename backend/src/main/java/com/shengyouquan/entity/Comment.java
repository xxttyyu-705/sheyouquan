package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 评论实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("comment")
public class Comment {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long postId;
    
    private Long userId;
    
    private String username;
    
    private String content;
    
    private Long parentId; // 父评论ID，用于回复功能
    
    private Long replyToUserId; // 回复的用户ID
    
    private String replyToUsername; // 回复的用户名
    
    private Integer status; // 0: 待审核, 1: 已发布, 2: 已删除
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}
