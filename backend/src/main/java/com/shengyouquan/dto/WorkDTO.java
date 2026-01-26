package com.shengyouquan.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 作品数据传输对象
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
public class WorkDTO {
    
    /**
     * 作品ID
     */
    private Long id;
    
    /**
     * 作者ID
     */
    private Long userId;
    
    /**
     * 作者昵称
     */
    private String authorNickname;
    
    /**
     * 作者头像
     */
    private String authorAvatar;
    
    /**
     * 作品标题
     */
    private String title;
    
    /**
     * 作品描述
     */
    private String description;
    
    /**
     * 作品图片列表
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
     * 分类名称
     */
    private String categoryName;
    
    /**
     * 标签列表
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
     * 是否已点赞
     */
    private Boolean liked;
    
    /**
     * 是否已收藏
     */
    private Boolean collected;
    
    /**
     * 是否公开
     */
    private Integer isPublic;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
