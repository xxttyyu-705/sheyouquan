package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.service.StatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 数据统计Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/stats")
@CrossOrigin
public class StatsController {
    
    @Autowired
    private StatsService statsService;
    
    /**
     * 获取系统概览统计
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> getOverviewStats() {
        Map<String, Object> stats = statsService.getOverviewStats();
        return Result.success(stats);
    }
    
    /**
     * 获取最近7天注册用户统计
     */
    @GetMapping("/user/recent")
    public Result<Map<String, Object>> getRecentUserStats() {
        Map<String, Object> stats = statsService.getRecentUserStats();
        return Result.success(stats);
    }
    
    /**
     * 获取收入统计
     */
    @GetMapping("/income")
    public Result<Map<String, Object>> getIncomeStats() {
        Map<String, Object> stats = statsService.getIncomeStats();
        return Result.success(stats);
    }
    
    /**
     * 获取商品销售统计
     */
    @GetMapping("/product/sales")
    public Result<Map<String, Object>> getProductSalesStats() {
        Map<String, Object> stats = statsService.getProductSalesStats();
        return Result.success(stats);
    }
}
