package com.shengyouquan.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 兑换记录实体类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
@TableName("exchange_records")
public class ExchangeRecord {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long userId;
    
    private Long productId;
    
    private String productName;
    
    private Integer points;
    
    private String address;
    
    private String phone;
    
    private String remark;
    
    private Integer status; // 0: 待处理, 1: 已发货, 2: 已完成, 3: 已取消
    
    private LocalDateTime createTime;
    
    private LocalDateTime updateTime;
}
