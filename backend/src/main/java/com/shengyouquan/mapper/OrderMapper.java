package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.Order;
import org.apache.ibatis.annotations.Mapper;

/**
 * 订单Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
