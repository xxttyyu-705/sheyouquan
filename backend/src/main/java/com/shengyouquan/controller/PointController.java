package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.service.PointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 积分Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/point")
@CrossOrigin
public class PointController {
    
    @Autowired
    private PointService pointService;
    
    /**
     * 获取用户积分余额
     */
    @GetMapping("/balance")
    public Result<Integer> getBalance() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = (principal instanceof Long) ? (Long) principal : 1L;
        
        Integer balance = pointService.getUserPoints(userId);
        return Result.success(balance);
    }
    
    /**
     * 获取积分记录
     */
    @GetMapping("/history")
    public Result<Map<String, Object>> getHistory(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = (principal instanceof Long) ? (Long) principal : 1L;
        
        Map<String, Object> history = pointService.getPointHistory(userId, page, size);
        return Result.success(history);
    }
}
