package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 商城商品实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("mall_goods")
public class Product {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    
    private String description;
    
    private String coverImage; // 对应 cover_image
    
    private Integer stock; // 库存
    
    private Integer status; // 1: 上架, 0: 下架
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
    
    // 数据库字段映射
    private Long categoryId; // 对应 category_id
    private BigDecimal price; // 价格
    private BigDecimal originalPrice; // 原价
    private Integer sales; // 销量
    private Integer deleted; // 逻辑删除
}
