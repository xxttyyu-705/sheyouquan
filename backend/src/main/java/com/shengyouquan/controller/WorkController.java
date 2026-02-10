package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Work;
import com.shengyouquan.service.WorkService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 作品控制器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/work")
@Tag(name = "作品管理", description = "作品发布、查询、互动")
public class WorkController {
    
    @Autowired
    private WorkService workService;
    
    /**
     * 分页查询作品列表
     */
    @GetMapping("/list")
    @Operation(summary = "作品列表", description = "分页查询作品列表")
    public Result<Map<String, Object>> getWorkList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String tags) {
        try {
            Map<String, Object> result = workService.getWorkList(page, size, keyword, categoryId, tags);
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace(); // 在控制台打印具体的错误堆栈
            return Result.error("获取作品列表失败");
        }
    }
    
    /**
     * 获取热门作品
     */
    @GetMapping("/hot")
    @Operation(summary = "热门作品", description = "获取热门作品列表")
    public Result<Map<String, Object>> getHotWorks(@RequestParam(defaultValue = "10") Integer limit) {
        try {
            Map<String, Object> result = workService.getHotWorks(limit);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("获取热门作品失败");
        }
    }
    
    /**
     * 获取作品详情
     */
    @GetMapping("/detail/{id}")
    @Operation(summary = "作品详情", description = "获取作品详细信息")
    public Result<?> getWorkDetail(@PathVariable Long id) {
        try {
            // 现在可以启用了，因为我们在 Mapper 中添加了注解实现
            workService.updateWorkStats(id, "view");
            
            var workDetail = workService.getWorkDetail(id);
            if (workDetail == null) {
                return Result.error("作品不存在");
            }
            return Result.success(workDetail);
        } catch (Exception e) {
            e.printStackTrace(); // 在后端控制台打印堆栈
            return Result.error("获取作品详情失败: " + e.getMessage()); // 返回具体错误给前端
        }
    }
    
    /**
     * 发布作品
     */
    @PostMapping("/publish")
    @Operation(summary = "发布作品", description = "发布新的摄影作品")
    public Result<Work> publishWork(@RequestBody Work work) {
        try {
            // 从安全上下文中获取当前登录用户ID
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Long userId = (principal instanceof Long) ? (Long) principal : 1L;
            work.setUserId(userId);
            
            Work savedWork = workService.publishWork(work);
            return Result.success("发布成功", savedWork);
        } catch (Exception e) {
            return Result.error("发布作品失败");
        }
    }
    
    /**
     * 点赞作品
     */
    @PostMapping("/like/{id}")
    @Operation(summary = "点赞作品", description = "点赞或取消点赞作品")
    public Result<String> toggleLike(@PathVariable Long id) {
        try {
            // 从安全上下文中获取 userId
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Long actualUserId = (principal instanceof Long) ? (Long) principal : 1L;
            
            workService.toggleLike(id, actualUserId);
            return Result.success("操作成功");
        } catch (Exception e) {
            return Result.error("操作失败");
        }
    }
    
    /**
     * 收藏作品
     */
    @PostMapping("/collect/{id}")
    @Operation(summary = "收藏作品", description = "收藏或取消收藏作品")
    public Result<String> toggleCollect(@PathVariable Long id) {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Long actualUserId = (principal instanceof Long) ? (Long) principal : 1L;
            
            workService.toggleCollect(id, actualUserId);
            return Result.success("操作成功");
        } catch (Exception e) {
            return Result.error("操作失败");
        }
    }
    
    /**
     * 获取用户作品列表
     */
    @GetMapping("/user/{userId}")
    @Operation(summary = "用户作品", description = "获取用户的作品列表")
    public Result<Map<String, Object>> getUserWorks(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        try {
            Map<String, Object> result = workService.getUserWorkList(userId, page, size);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("获取用户作品失败");
        }
    }
}
