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
@TableName("products")
public class Product {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    
    private String description;
    
    private String image;
    
    private Integer points; // 所需积分
    
    private Integer stock; // 库存
    
    private String category; // 分类：equipment-器材, accessories-配件, materials-资料, membership-会员
    
    private Integer status; // 1: 上架, 0: 下架
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}
