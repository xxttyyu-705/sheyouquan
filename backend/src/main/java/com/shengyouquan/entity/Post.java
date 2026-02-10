package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 社区帖子实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("post")
public class Post {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long userId;
    
    private String username;
    
    private String title;
    
    private String content;
    
    private String images; // JSON格式存储图片URL数组
    
    private Integer views; // 浏览数
    
    private Integer likes; // 点赞数
    
    private Integer comments; // 评论数
    
    private Integer status; // 0: 待审核, 1: 已发布, 2: 已删除
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}
