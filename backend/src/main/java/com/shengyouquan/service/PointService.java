package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Point;
import com.shengyouquan.mapper.PointMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 积分服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class PointService extends ServiceImpl<PointMapper, Point> {
    
    @Autowired
    private PointMapper pointMapper;
    
    /**
     * 获取用户积分余额
     */
    public Integer getUserPoints(Long userId) {
        LambdaQueryWrapper<Point> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Point::getUserId, userId);
        List<Point> points = pointMapper.selectList(wrapper);
        
        Integer total = 0;
        for (Point point : points) {
            if (point.getType() == 1) {
                total += point.getPoints();
            } else if (point.getType() == 2) {
                total -= point.getPoints();
            }
        }
        
        return total;
    }
    
    /**
     * 添加积分记录
     */
    @Transactional
    public boolean addPoints(Long userId, Integer points, String reason) {
        Point point = new Point();
        point.setUserId(userId);
        point.setPoints(points);
        point.setReason(reason);
        point.setType(1); // 获得积分
        point.setCreateTime(LocalDateTime.now());
        point.setUpdateTime(LocalDateTime.now());
        
        return pointMapper.insert(point) > 0;
    }
    
    /**
     * 消耗积分
     */
    @Transactional
    public boolean deductPoints(Long userId, Integer points, String reason) {
        // 检查余额
        Integer balance = getUserPoints(userId);
        if (balance < points) {
            return false;
        }
        
        Point point = new Point();
        point.setUserId(userId);
        point.setPoints(points);
        point.setReason(reason);
        point.setType(2); // 消耗积分
        point.setCreateTime(LocalDateTime.now());
        point.setUpdateTime(LocalDateTime.now());
        
        return pointMapper.insert(point) > 0;
    }
    
    /**
     * 获取用户积分记录
     */
    public Map<String, Object> getPointHistory(Long userId, Integer page, Integer size) {
        LambdaQueryWrapper<Point> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Point::getUserId, userId)
               .orderByDesc(Point::getCreateTime);
        
        List<Point> list = pointMapper.selectList(wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", list.size());
        
        return result;
    }
}
