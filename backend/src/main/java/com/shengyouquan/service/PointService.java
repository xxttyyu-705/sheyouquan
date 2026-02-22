package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Point;
import com.shengyouquan.entity.User;
import com.shengyouquan.mapper.PointMapper;
import com.shengyouquan.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 积分服务类
 * 积分余额以 sys_user.points 为准，与个人中心、商城、课程等统一；points 表仅作流水记录。
 *
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class PointService extends ServiceImpl<PointMapper, Point> {

    @Autowired
    private PointMapper pointMapper;
    @Autowired
    private UserMapper userMapper;

    /**
     * 获取用户积分余额（从 sys_user.points 读取，与个人中心一致）
     */
    public Integer getUserPoints(Long userId) {
        User user = userMapper.findUserInfoById(userId);
        if (user == null || user.getPoints() == null) {
            return 0;
        }
        return user.getPoints();
    }

    /**
     * 添加积分：写流水并更新 sys_user.points
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
        if (pointMapper.insert(point) <= 0) {
            return false;
        }
        userMapper.updatePoints(userId, points);
        return true;
    }

    /**
     * 消耗积分：先校验 sys_user.points 余额，再写流水并更新 sys_user.points
     */
    @Transactional
    public boolean deductPoints(Long userId, Integer points, String reason) {
        Integer balance = getUserPoints(userId);
        if (balance == null || balance < points) {
            return false;
        }
        Point point = new Point();
        point.setUserId(userId);
        point.setPoints(points);
        point.setReason(reason);
        point.setType(2); // 消耗积分
        point.setCreateTime(LocalDateTime.now());
        point.setUpdateTime(LocalDateTime.now());
        if (pointMapper.insert(point) <= 0) {
            return false;
        }
        userMapper.updatePoints(userId, -points);
        return true;
    }

    /**
     * 获取用户积分记录（分页，来自 points 表流水）
     */
    public Map<String, Object> getPointHistory(Long userId, Integer page, Integer size) {
        LambdaQueryWrapper<Point> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Point::getUserId, userId)
                .orderByDesc(Point::getCreateTime);
        Page<Point> pageObj = new Page<>(page, size);
        Page<Point> resultPage = pointMapper.selectPage(pageObj, wrapper);

        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        return result;
    }
}
