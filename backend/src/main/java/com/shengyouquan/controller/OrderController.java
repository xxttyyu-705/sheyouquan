package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Order;
import com.shengyouquan.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 订单控制器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/order")
@Tag(name = "订单管理", description = "订单创建、支付、查询")
public class OrderController {
    
    @Autowired
    private OrderService orderService;
    
    /**
     * 创建订单
     */
    @PostMapping("/create")
    @Operation(summary = "创建订单", description = "创建新的订单")
    public Result<Order> createOrder(
            @RequestParam Long itemId,
            @RequestParam Integer itemType,
            @RequestParam String itemName,
            @RequestParam String itemImage,
            @RequestParam BigDecimal price,
            @RequestParam Integer payType,
            @RequestParam(required = false) Integer usePoints) {
        try {
            // 这里应该从token中获取用户ID
            Long userId = 1L; // 暂时写死
            
            Order order = orderService.createOrder(userId, itemId, itemType, itemName, itemImage, price, payType, usePoints);
            return Result.success("订单创建成功", order);
        } catch (Exception e) {
            return Result.error("创建订单失败");
        }
    }
    
    /**
     * 支付订单
     */
    @PostMapping("/pay/{id}")
    @Operation(summary = "支付订单", description = "支付指定订单")
    public Result<String> payOrder(@PathVariable Long id) {
        try {
            boolean success = orderService.payOrder(id);
            if (success) {
                return Result.success("支付成功");
            } else {
                return Result.error("支付失败，订单状态不正确");
            }
        } catch (Exception e) {
            return Result.error("支付失败");
        }
    }
    
    /**
     * 取消订单
     */
    @PostMapping("/cancel/{id}")
    @Operation(summary = "取消订单", description = "取消未支付订单")
    public Result<String> cancelOrder(@PathVariable Long id) {
        try {
            boolean success = orderService.cancelOrder(id);
            if (success) {
                return Result.success("订单已取消");
            } else {
                return Result.error("取消失败，订单状态不正确");
            }
        } catch (Exception e) {
            return Result.error("取消订单失败");
        }
    }
    
    /**
     * 获取用户订单列表
     */
    @GetMapping("/list")
    @Operation(summary = "订单列表", description = "获取用户订单列表")
    public Result<Map<String, Object>> getUserOrders(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer payStatus) {
        try {
            // 这里应该从token中获取用户ID
            Long userId = 1L; // 暂时写死
            
            Map<String, Object> result = orderService.getUserOrders(userId, page, size, payStatus);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("获取订单列表失败");
        }
    }
}
