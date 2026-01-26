package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 课程实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("course")
public class Course implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 课程ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 课程标题
     */
    private String title;
    
    /**
     * 课程描述
     */
    private String description;
    
    /**
     * 课程封面
     */
    private String coverImage;
    
    /**
     * 课程视频URL
     */
    private String videoUrl;
    
    /**
     * 课程分类
     */
    private String category;
    
    /**
     * 课程难度：1-入门，2-中级，3-高级
     */
    private Integer difficulty;
    
    /**
     * 课程时长（分钟）
     */
    private Integer duration;
    
    /**
     * 价格
     */
    private BigDecimal price;
    
    /**
     * 是否免费：0-收费，1-免费
     */
    private Integer isFree;
    
    /**
     * 讲师ID
     */
    private Long teacherId;
    
    /**
     * 讲师名称
     */
    private String teacherName;
    
    /**
     * 课程状态：0-下架，1-上架
     */
    private Integer status;
    
    /**
     * 学习人数
     */
    private Integer studentCount;
    
    /**
     * 评分
     */
    private BigDecimal score;
    
    /**
     * 逻辑删除：0-未删除，1-已删除
     */
    @TableLogic
    private Integer deleted;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
