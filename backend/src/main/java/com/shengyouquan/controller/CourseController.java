package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Course;
import com.shengyouquan.service.CourseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 课程控制器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/course")
@Tag(name = "课程管理", description = "课程查询、购买、学习")
public class CourseController {
    
    @Autowired
    private CourseService courseService;
    
    /**
     * 分页查询课程列表
     */
    @GetMapping("/list")
    @Operation(summary = "课程列表", description = "分页查询课程列表")
    public Result<Map<String, Object>> getCourseList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer difficulty) {
        try {
            Map<String, Object> result = courseService.getCourseList(page, size, keyword, categoryId, difficulty);
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace(); // 打印错误堆栈，方便排查数据库连接或SQL问题
            return Result.error("获取课程列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取推荐课程
     */
    @GetMapping("/recommended")
    @Operation(summary = "推荐课程", description = "获取推荐课程列表")
    public Result<Map<String, Object>> getRecommendedCourses(@RequestParam(defaultValue = "6") Integer limit) {
        try {
            Map<String, Object> result = courseService.getRecommendedCourses(limit);
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取推荐课程失败");
        }
    }
    
    /**
     * 获取课程详情
     */
    @GetMapping("/detail/{id}")
    @Operation(summary = "课程详情", description = "获取课程详细信息")
    public Result<Course> getCourseDetail(@PathVariable Long id) {
        try {
            Course course = courseService.getCourseDetail(id);
            if (course == null) {
                return Result.error("课程不存在");
            }
            return Result.success(course);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取课程详情失败");
        }
    }
    
    /**
     * 创建课程
     */
    @PostMapping("/create")
    @Operation(summary = "创建课程", description = "创建新的课程")
    public Result<Course> createCourse(@RequestBody Course course) {
        try {
            Course savedCourse = courseService.createCourse(course);
            return Result.success("创建成功", savedCourse);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("创建课程失败");
        }
    }
    
    /**
     * 更新学习人数
     */
    @PostMapping("/learn/{id}")
    @Operation(summary = "开始学习", description = "更新课程学习人数")
    public Result<String> learnCourse(@PathVariable Long id) {
        try {
            // 从安全上下文中获取当前登录用户ID
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Long actualUserId = (principal instanceof Long) ? (Long) principal : 1L;
            
            courseService.updateStudentCount(id);
            return Result.success("学习记录已更新");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("操作失败");
        }
    }
}
