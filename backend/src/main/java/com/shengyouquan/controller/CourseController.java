package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Course;
import com.shengyouquan.service.CourseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.shengyouquan.entity.CourseComment;
import com.shengyouquan.entity.CourseChapter;
import java.util.List;
import java.util.Map;


/**
 * 课程控制器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/course")
@CrossOrigin
@Tag(name = "课程管理", description = "课程查询、购买、学习")
public class CourseController {
    
    @Autowired
    private CourseService courseService;
    
    /**
     * 分页查询课程列表
     */
    @GetMapping("/list")
    @Operation(summary = "课程列表", description = "分页查询课程列表")
    public Result<java.util.Map<String, Object>> getCourseList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer difficulty) {
        try {
            java.util.Map<String, Object> result = courseService.getCourseList(page, size, keyword, categoryId, difficulty);
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace(); // 打印错误堆栈，方便排查数据库连接或SQL问题
            return Result.error("获取课程列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取我的课程（含进度）
     */
    @GetMapping("/my")
    @Operation(summary = "我的课程", description = "获取用户参与的课程列表")
    public Result<List<Map<String, Object>>> getMyCourses() {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (!(principal instanceof Long)) {
                return Result.error("用户未登录或Token无效");
            }
            Long userId = (Long) principal;
            
            List<Map<String, Object>> list = courseService.getMyCourseList(userId);
            return Result.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取我的课程失败");
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
            courseService.updateStudentCount(id);
            return Result.success("学习记录已更新");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("操作失败");
        }
    }

    /**
     * 获取课程章节
     */
    @GetMapping("/{id}/chapters")
    @Operation(summary = "获取章节", description = "获取课程的所有章节")
    public Result<List<CourseChapter>> getChapters(@PathVariable Long id) {
        try {
            List<CourseChapter> chapters = courseService.getCourseChapters(id);
            return Result.success(chapters);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取章节失败");
        }
    }

    /**
     * 更新学习进度
     */
    @PostMapping("/{id}/chapter/{chapterId}/complete")
    @Operation(summary = "更新进度", description = "标记章节为已完成")
    public Result<String> updateProgress(@PathVariable Long id, @PathVariable Long chapterId) {
        try {
            // 获取当前登录用户ID
            String userIdStr = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            // 如果principal是"anonymousUser"或其他非ID字符串，这里会抛出异常。
            // 假设JwtAuthenticationFilter正确设置了principal为userId字符串
            Long userId = Long.parseLong(userIdStr);
            
            courseService.updateProgress(userId, id, chapterId);
            return Result.success("进度已更新");
        } catch (NumberFormatException e) {
             return Result.error("用户未登录或Token无效");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新进度失败");
        }
    }

    /**
     * 获取用户学习进度
     */
    @GetMapping("/{id}/progress")
    @Operation(summary = "获取进度", description = "获取用户在某课程的学习进度")
    public Result<Map<String, Object>> getProgress(@PathVariable Long id) {
        try {
            String userIdStr = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Long userId = Long.parseLong(userIdStr);
            
            Map<String, Object> progress = courseService.getUserProgress(userId, id);
            return Result.success(progress);
        } catch (NumberFormatException e) {
             return Result.error("用户未登录或Token无效");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取进度失败");
        }
    }

    /**
     * 获取课程评论
     */
    @GetMapping("/{id}/comments")
    @Operation(summary = "获取评论", description = "获取课程的所有评论")
    public Result<List<CourseComment>> getComments(@PathVariable Long id) {
        try {
            List<CourseComment> comments = courseService.getCourseComments(id);
            return Result.success(comments);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取评论失败");
        }
    }

    /**
     * 发表评论
     */
    @PostMapping("/{id}/comments")
    @Operation(summary = "发表评论", description = "发表课程评论")
    public Result<String> createComment(@PathVariable Long id, @RequestBody CourseComment comment) {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (!(principal instanceof Long)) {
                return Result.error("用户未登录或Token无效");
            }
            Long userId = (Long) principal;
            
            comment.setCourseId(id);
            comment.setUserId(userId);
            
            if (courseService.createCourseComment(comment)) {
                return Result.success("评论成功");
            }
            return Result.error("评论失败");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("评论失败");
        }
    }
}
