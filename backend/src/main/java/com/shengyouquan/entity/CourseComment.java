package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 课程评论实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("course_comment")
public class CourseComment {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long courseId;
    
    private Long userId;
    
    @TableField(exist = false)
    private String username;
    
    @TableField(exist = false)
    private String avatar;
    
    private String content;
    
    private Long parentId; // 父评论ID
    
    private Integer status; // 0: 待审核, 1: 已发布, 2: 已删除
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}
