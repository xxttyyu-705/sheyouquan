package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.service.ExchangeRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 兑换记录Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/exchange")
@CrossOrigin
public class ExchangeRecordController {
    
    @Autowired
    private ExchangeRecordService exchangeRecordService;
    
    /**
     * 创建兑换记录
     */
    @PostMapping("/create")
    public Result<String> createExchange(
            @RequestHeader("X-User-Id") Long userId,
            @RequestBody ExchangeRequest request) {
        
        boolean success = exchangeRecordService.createExchange(
            userId, 
            request.getProductId(), 
            request.getAddress(), 
            request.getPhone(), 
            request.getRemark()
        );
        
        if (success) {
            return Result.success("兑换成功");
        }
        return Result.error("兑换失败，请检查积分或库存");
    }
    
    /**
     * 获取用户兑换记录
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getUserExchanges(
            @RequestHeader("X-User-Id") Long userId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Map<String, Object> exchanges = exchangeRecordService.getUserExchanges(userId, page, size);
        return Result.success(exchanges);
    }
    
    /**
     * 获取所有兑换记录（管理员）
     */
    @GetMapping("/admin/list")
    public Result<Map<String, Object>> getAllExchanges(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Map<String, Object> exchanges = exchangeRecordService.getAllExchanges(keyword, status, page, size);
        return Result.success(exchanges);
    }
    
    /**
     * 更新兑换状态（管理员）
     */
    @PostMapping("/admin/status/{id}")
    public Result<String> updateExchangeStatus(@PathVariable Long id, @RequestParam Integer status) {
        if (exchangeRecordService.updateExchangeStatus(id, status)) {
            return Result.success("状态更新成功");
        }
        return Result.error("状态更新失败");
    }
}

/**
 * 兑换请求DTO
 */
class ExchangeRequest {
    private Long productId;
    private String address;
    private String phone;
    private String remark;
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRemark() {
        return remark;
    }
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
}
