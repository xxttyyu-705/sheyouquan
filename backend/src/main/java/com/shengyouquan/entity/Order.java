package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("order")
public class Order implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 订单ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 订单编号
     */
    private String orderNo;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 商品ID
     */
    private Long itemId;
    
    /**
     * 商品类型：1-课程，2-商品
     */
    private Integer itemType;
    
    /**
     * 商品名称
     */
    private String itemName;
    
    /**
     * 商品图片
     */
    private String itemImage;
    
    /**
     * 商品价格
     */
    private BigDecimal price;
    
    /**
     * 实际支付金额
     */
    private BigDecimal payAmount;
    
    /**
     * 支付方式：1-微信，2-支付宝，3-积分
     */
    private Integer payType;
    
    /**
     * 支付状态：0-未支付，1-已支付，2-已取消，3-已退款
     */
    private Integer payStatus;
    
    /**
     * 支付时间
     */
    private LocalDateTime payTime;
    
    /**
     * 使用积分
     */
    private Integer usePoints;
    
    /**
     * 订单备注
     */
    private String remark;
    
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
