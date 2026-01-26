package com.shengyouquan.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Order;
import com.shengyouquan.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * 订单服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class OrderService extends ServiceImpl<OrderMapper, Order> {
    
    @Autowired
    private OrderMapper orderMapper;
    
    /**
     * 创建订单
     */
    public Order createOrder(Long userId, Long itemId, Integer itemType, 
                           String itemName, String itemImage, BigDecimal price, 
                           Integer payType, Integer usePoints) {
        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setItemId(itemId);
        order.setItemType(itemType);
        order.setItemName(itemName);
        order.setItemImage(itemImage);
        order.setPrice(price);
        
        // 计算实际支付金额（积分抵扣）
        BigDecimal payAmount = price;
        if (usePoints != null && usePoints > 0) {
            // 假设1积分 = 0.01元
            BigDecimal pointsValue = new BigDecimal(usePoints).multiply(new BigDecimal("0.01"));
            payAmount = price.subtract(pointsValue);
            if (payAmount.compareTo(BigDecimal.ZERO) < 0) {
                payAmount = BigDecimal.ZERO;
            }
        }
        order.setPayAmount(payAmount);
        order.setPayType(payType);
        order.setPayStatus(0); // 待支付
        order.setUsePoints(usePoints);
        
        save(order);
        return order;
    }
    
    /**
     * 支付订单
     */
    public boolean payOrder(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || order.getPayStatus() != 0) {
            return false;
        }
        
        order.setPayStatus(1);
        order.setPayTime(LocalDateTime.now());
        orderMapper.updateById(order);
        
        return true;
    }
    
    /**
     * 取消订单
     */
    public boolean cancelOrder(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || order.getPayStatus() != 0) {
            return false;
        }
        
        order.setPayStatus(2);
        orderMapper.updateById(order);
        
        return true;
    }
    
    /**
     * 获取用户订单列表
     */
    public Map<String, Object> getUserOrders(Long userId, Integer page, Integer size, Integer payStatus) {
        Page<Order> orderPage = new Page<>(page, size);
        // 这里需要创建自定义查询方法
        Page<Order> result = orderMapper.selectPage(orderPage, null);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", result.getRecords());
        map.put("total", result.getTotal());
        map.put("pages", result.getPages());
        map.put("current", result.getCurrent());
        
        return map;
    }
    
    /**
     * 生成订单编号
     */
    private String generateOrderNo() {
        String timestamp = String.valueOf(System.currentTimeMillis());
        Random random = new Random();
        String randomStr = String.format("%04d", random.nextInt(10000));
        return "ORD" + timestamp + randomStr;
    }
}
