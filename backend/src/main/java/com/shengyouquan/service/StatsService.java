package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shengyouquan.entity.Order;
import com.shengyouquan.entity.User;
import com.shengyouquan.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 数据统计服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class StatsService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private WorkMapper workMapper;
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Autowired
    private OrderMapper orderMapper;
    
    @Autowired
    private PostMapper postMapper;
    
    @Autowired
    private ProductMapper productMapper;
    
    @Autowired
    private PointMapper pointMapper;
    
    /**
     * 获取系统概览统计
     */
    public Map<String, Object> getOverviewStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 用户统计
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.eq(User::getStatus, 1);
        Long userCount = userMapper.selectCount(userWrapper);
        stats.put("userCount", userCount);
        
        // 作品统计
        Long workCount = workMapper.selectCount(null);
        stats.put("workCount", workCount);
        
        // 课程统计
        Long courseCount = courseMapper.selectCount(null);
        stats.put("courseCount", courseCount);
        
        // 订单统计
        Long orderCount = orderMapper.selectCount(null);
        stats.put("orderCount", orderCount);
        
        // 帖子统计
        Long postCount = postMapper.selectCount(null);
        stats.put("postCount", postCount);
        
        // 商品统计
        Long productCount = productMapper.selectCount(null);
        stats.put("productCount", productCount);
        
        // 积分统计
        Long pointCount = pointMapper.selectCount(null);
        stats.put("pointCount", pointCount);
        
        return stats;
    }
    
    /**
     * 获取最近7天的注册用户数
     */
    public Map<String, Object> getRecentUserStats() {
        Map<String, Object> result = new HashMap<>();
        
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        Map<String, Long> dailyStats = new HashMap<>();
        
        for (int i = 6; i >= 0; i--) {
            LocalDateTime date = now.minusDays(i);
            String dateStr = date.format(formatter);
            
            LocalDateTime startOfDay = date.withHour(0).withMinute(0).withSecond(0);
            LocalDateTime endOfDay = date.withHour(23).withMinute(59).withSecond(59);
            
            LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
            wrapper.between(User::getCreateTime, startOfDay, endOfDay);
            
            Long count = userMapper.selectCount(wrapper);
            dailyStats.put(dateStr, count);
        }
        
        result.put("dailyStats", dailyStats);
        return result;
    }
    
    /**
     * 获取收入统计（基于订单）
     */
    public Map<String, Object> getIncomeStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取所有订单
        List<Order> orders = orderMapper.selectList(null);
        
        // 计算总收入（已支付订单）
        double totalIncome = 0;
        int paidCount = 0;
        
        for (Order order : orders) {
            if (order.getPayStatus() == 1) { // 已支付
                totalIncome += order.getPayAmount().doubleValue();
                paidCount++;
            }
        }
        
        stats.put("totalIncome", totalIncome);
        stats.put("orderCount", orders.size());
        stats.put("paidCount", paidCount);
        
        // 支付状态分布
        Map<String, Long> statusDistribution = new HashMap<>();
        long unpaid = 0, paid = 0, cancelled = 0, refunded = 0;
        
        for (Order order : orders) {
            switch (order.getPayStatus()) {
                case 0: unpaid++; break;
                case 1: paid++; break;
                case 2: cancelled++; break;
                case 3: refunded++; break;
            }
        }
        
        statusDistribution.put("未支付", unpaid);
        statusDistribution.put("已支付", paid);
        statusDistribution.put("已取消", cancelled);
        statusDistribution.put("已退款", refunded);
        
        stats.put("statusDistribution", statusDistribution);
        
        return stats;
    }
    
    /**
     * 获取商品销售统计
     */
    public Map<String, Object> getProductSalesStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取所有商品
        List<com.shengyouquan.entity.Product> products = productMapper.selectList(null);
        
        // 获取所有已支付订单（商品类型）
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getPayStatus, 1)
               .eq(Order::getItemType, 2); // 商品类型
        List<Order> orders = orderMapper.selectList(wrapper);
        
        // 统计每个商品的销售数量
        Map<Long, Integer> salesMap = new HashMap<>();
        for (Order order : orders) {
            Long itemId = order.getItemId();
            salesMap.put(itemId, salesMap.getOrDefault(itemId, 0) + 1);
        }
        
        // 构建商品销售排名
        java.util.List<Map<String, Object>> topProducts = new java.util.ArrayList<>();
        
        for (com.shengyouquan.entity.Product product : products) {
            Map<String, Object> productInfo = new HashMap<>();
            productInfo.put("name", product.getName());
            int sales = salesMap.getOrDefault(product.getId(), 0);
            productInfo.put("sales", sales);
            productInfo.put("revenue", sales * product.getPrice().intValue());
            topProducts.add(productInfo);
        }
        
        // 按销量排序
        topProducts.sort((a, b) -> Integer.compare((Integer) b.get("sales"), (Integer) a.get("sales")));
        
        // 取前10
        stats.put("topProducts", topProducts.subList(0, Math.min(10, topProducts.size())));
        
        return stats;
    }
}
