package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.Product;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface ProductMapper extends BaseMapper<Product> {
}
