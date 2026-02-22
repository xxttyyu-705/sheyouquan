package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.service.PointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
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
     * 获取用户积分余额（未登录或 Token 无效时返回 0，避免 401）
     */
    @GetMapping("/balance")
    public Result<Integer> getBalance() {
        Long userId = getCurrentUserId();
        if (userId == null) {
            return Result.success(0);
        }
        Integer balance = pointService.getUserPoints(userId);
        return Result.success(balance);
    }
    
    /**
     * 获取积分记录（未登录或 Token 无效时返回空列表）
     */
    @GetMapping("/history")
    public Result<Map<String, Object>> getHistory(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        Long userId = getCurrentUserId();
        if (userId == null) {
            return Result.success(java.util.Map.of("list", Collections.emptyList(), "total", 0));
        }
        Map<String, Object> history = pointService.getPointHistory(userId, page, size);
        return Result.success(history);
    }

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        Object principal = auth.getPrincipal();
        return (principal instanceof Long) ? (Long) principal : null;
    }
}
