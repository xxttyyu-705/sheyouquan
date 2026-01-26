package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 作品实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("work")
public class Work implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 作品ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 作者ID
     */
    private Long userId;
    
    /**
     * 作品标题
     */
    private String title;
    
    /**
     * 作品描述
     */
    private String description;
    
    /**
     * 作品图片列表(JSON)
     */
    private String images;
    
    /**
     * 封面图
     */
    private String coverImage;
    
    /**
     * 分类ID
     */
    private Long categoryId;
    
    /**
     * 标签列表(JSON)
     */
    private String tags;
    
    /**
     * 拍摄器材
     */
    private String equipment;
    
    /**
     * 拍摄参数
     */
    private String settings;
    
    /**
     * 拍摄地点
     */
    private String location;
    
    /**
     * 拍摄时间
     */
    private LocalDateTime shootTime;
    
    /**
     * 浏览数
     */
    private Integer viewCount;
    
    /**
     * 点赞数
     */
    private Integer likeCount;
    
    /**
     * 评论数
     */
    private Integer commentCount;
    
    /**
     * 收藏数
     */
    private Integer collectCount;
    
    /**
     * 状态：0-隐藏，1-正常
     */
    private Integer status;
    
    /**
     * 是否公开：0-私密，1-公开
     */
    private Integer isPublic;
    
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
