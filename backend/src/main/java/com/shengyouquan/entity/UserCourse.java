package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户课程关联实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("user_course")
public class UserCourse implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 课程ID
     */
    private Long courseId;
    
    /**
     * 学习进度(百分比)
     */
    private Integer progress;
    
    /**
     * 最后学习章节
     */
    private Long lastChapterId;
    
    /**
     * 开始学习时间
     */
    private LocalDateTime startTime;
    
    /**
     * 完成学习时间
     */
    private LocalDateTime endTime;
    
    /**
     * 状态: 0-未开始, 1-学习中, 2-已完成
     */
    private Integer status;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
