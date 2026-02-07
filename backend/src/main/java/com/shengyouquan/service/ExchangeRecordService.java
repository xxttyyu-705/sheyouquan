package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.ExchangeRecord;
import com.shengyouquan.entity.Product;
import com.shengyouquan.mapper.ExchangeRecordMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 兑换记录服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class ExchangeRecordService extends ServiceImpl<ExchangeRecordMapper, ExchangeRecord> {
    
    @Autowired
    private ExchangeRecordMapper exchangeRecordMapper;
    
    @Autowired
    private PointService pointService;
    
    @Autowired
    private ProductService productService;
    
    /**
     * 创建兑换记录
     */
    @Transactional
    public boolean createExchange(Long userId, Long productId, String address, String phone, String remark) {
        // 获取商品信息
        Product product = productService.getProductDetail(productId);
        if (product == null || product.getStock() <= 0) {
            return false;
        }
        
        // 检查积分余额
        Integer userPoints = pointService.getUserPoints(userId);
        Integer productPoints = product.getPrice().intValue();
        if (userPoints < productPoints) {
            return false;
        }
        
        // 扣减积分
        if (!pointService.deductPoints(userId, productPoints, "兑换商品: " + product.getName())) {
            return false;
        }
        
        // 扣减库存
        if (!productService.deductStock(productId, 1)) {
            // 如果扣减库存失败，回滚积分
            pointService.addPoints(userId, productPoints, "兑换失败回滚");
            return false;
        }
        
        // 创建兑换记录
        ExchangeRecord record = new ExchangeRecord();
        record.setUserId(userId);
        record.setProductId(productId);
        record.setProductName(product.getName());
        record.setPoints(productPoints);
        record.setAddress(address);
        record.setPhone(phone);
        record.setRemark(remark);
        record.setStatus(0); // 待处理
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        
        return exchangeRecordMapper.insert(record) > 0;
    }
    
    /**
     * 获取用户兑换记录
     */
    public Map<String, Object> getUserExchanges(Long userId, Integer page, Integer size) {
        Page<ExchangeRecord> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<ExchangeRecord> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(ExchangeRecord::getUserId, userId)
               .orderByDesc(ExchangeRecord::getCreateTime);
        
        Page<ExchangeRecord> resultPage = exchangeRecordMapper.selectPage(pageObj, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        
        return result;
    }
    
    /**
     * 获取所有兑换记录（管理员）
     */
    public Map<String, Object> getAllExchanges(String keyword, Integer status, Integer page, Integer size) {
        Page<ExchangeRecord> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<ExchangeRecord> wrapper = new LambdaQueryWrapper<>();
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(ExchangeRecord::getProductName, keyword)
                   .or().like(ExchangeRecord::getPhone, keyword);
        }
        
        if (status != null) {
            wrapper.eq(ExchangeRecord::getStatus, status);
        }
        
        wrapper.orderByDesc(ExchangeRecord::getCreateTime);
        
        Page<ExchangeRecord> resultPage = exchangeRecordMapper.selectPage(pageObj, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        
        return result;
    }
    
    /**
     * 更新兑换状态
     */
    @Transactional
    public boolean updateExchangeStatus(Long id, Integer status) {
        ExchangeRecord record = exchangeRecordMapper.selectById(id);
        if (record == null) {
            return false;
        }
        
        record.setStatus(status);
        record.setUpdateTime(LocalDateTime.now());
        
        return exchangeRecordMapper.updateById(record) > 0;
    }
}
