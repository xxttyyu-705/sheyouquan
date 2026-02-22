package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Course;
import com.shengyouquan.entity.CourseChapter;
import com.shengyouquan.entity.UserCourseProgress;
import com.shengyouquan.entity.CourseComment;
import com.shengyouquan.entity.UserCourse;
import com.shengyouquan.mapper.CourseMapper;
import com.shengyouquan.mapper.CourseChapterMapper;
import com.shengyouquan.mapper.UserCourseProgressMapper;
import com.shengyouquan.mapper.CourseCommentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 课程服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class CourseService extends ServiceImpl<CourseMapper, Course> {
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Autowired
    private CourseChapterMapper courseChapterMapper;
    
    @Autowired
    private UserCourseProgressMapper userCourseProgressMapper;
    
    @Autowired
    private com.shengyouquan.mapper.UserCourseMapper userCourseMapper;
    
    @Autowired
    private CourseCommentMapper courseCommentMapper;
    
    /**
     * 分页查询课程列表
     */
    public Map<String, Object> getCourseList(Integer page, Integer size, String keyword, Long categoryId, Integer difficulty) {
        Page<Course> coursePage = new Page<>(page, size);
        LambdaQueryWrapper<Course> wrapper = new LambdaQueryWrapper<>();
        
        // 添加基础过滤条件
        wrapper.eq(Course::getStatus, 1); 
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Course::getTitle, keyword);
        }
        if (categoryId != null) {
            wrapper.eq(Course::getCategoryId, categoryId);
        }
        if (difficulty != null) {
            wrapper.eq(Course::getDifficulty, difficulty);
        }
        
        Page<Course> result = courseMapper.selectPage(coursePage, wrapper);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", result.getRecords());
        map.put("total", result.getTotal());
        map.put("pages", result.getPages());
        map.put("current", result.getCurrent());
        
        return map;
    }

    /**
     * 获取课程评论
     */
    public List<CourseComment> getCourseComments(Long courseId) {
        return courseCommentMapper.selectCommentsByCourseId(courseId);
    }

    /**
     * 发表课程评论
     */
    public boolean createCourseComment(CourseComment comment) {
        comment.setStatus(1); // 默认已发布
        comment.setCreateTime(LocalDateTime.now());
        comment.setUpdateTime(LocalDateTime.now());
        return courseCommentMapper.insert(comment) > 0;
    }
    
    /**
     * 获取推荐课程
     */
    public Map<String, Object> getRecommendedCourses(Integer limit) {
        // 暂时返回热门课程（按学习人数排序）
        Page<Course> coursePage = new Page<>(1, limit);
        LambdaQueryWrapper<Course> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Course::getStatus, 1);
        wrapper.orderByDesc(Course::getStudentCount);
        
        Page<Course> result = courseMapper.selectPage(coursePage, wrapper);
        return new HashMap<String, Object>() {{
            put("list", result.getRecords());
        }};
    }
    
    /**
     * 获取课程详情
     */
    public Course getCourseDetail(Long id) {
        return courseMapper.selectById(id);
    }
    
    /**
     * 创建课程
     */
    public Course createCourse(Course course) {
        course.setStatus(1);
        course.setStudentCount(0);
        course.setScore(null);
        save(course);
        return course;
    }
    
    /**
     * 更新学习人数
     */
    public void updateStudentCount(Long courseId) {
        Course course = courseMapper.selectById(courseId);
        if (course != null) {
            Integer currentCount = course.getStudentCount();
            course.setStudentCount((currentCount == null ? 0 : currentCount) + 1);
            courseMapper.updateById(course);
        }
    }

    /**
     * 获取课程章节列表
     */
    public List<CourseChapter> getCourseChapters(Long courseId) {
        LambdaQueryWrapper<CourseChapter> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CourseChapter::getCourseId, courseId)
               .orderByAsc(CourseChapter::getSortOrder);
        return courseChapterMapper.selectList(wrapper);
    }

    /**
     * 更新学习进度
     */
    public void updateProgress(Long userId, Long courseId, Long chapterId) {
        // 检查记录是否存在
        LambdaQueryWrapper<UserCourseProgress> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCourseProgress::getUserId, userId)
               .eq(UserCourseProgress::getCourseId, courseId)
               .eq(UserCourseProgress::getChapterId, chapterId);
        
        UserCourseProgress progress = userCourseProgressMapper.selectOne(wrapper);
        if (progress == null) {
            progress = new UserCourseProgress();
            progress.setUserId(userId);
            progress.setCourseId(courseId);
            progress.setChapterId(chapterId);
            progress.setIsCompleted(1);
            userCourseProgressMapper.insert(progress);
        } else {
            if (progress.getIsCompleted() == 0) {
                progress.setIsCompleted(1);
                userCourseProgressMapper.updateById(progress);
            }
        }
    }

    /**
     * 获取用户课程进度
     */
    public Map<String, Object> getUserProgress(Long userId, Long courseId) {
        // 获取所有已完成的章节ID
        LambdaQueryWrapper<UserCourseProgress> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCourseProgress::getUserId, userId)
               .eq(UserCourseProgress::getCourseId, courseId)
               .eq(UserCourseProgress::getIsCompleted, 1);
        
        List<UserCourseProgress> progressList = userCourseProgressMapper.selectList(wrapper);
        List<Long> completedChapterIds = progressList.stream()
                .map(UserCourseProgress::getChapterId)
                .collect(Collectors.toList());
        
        // 计算总进度
        int completedCount = completedChapterIds.size();
        
        LambdaQueryWrapper<CourseChapter> chapterWrapper = new LambdaQueryWrapper<>();
        chapterWrapper.eq(CourseChapter::getCourseId, courseId);
        Long totalChapters = courseChapterMapper.selectCount(chapterWrapper);
        
        int percentage = 0;
        if (totalChapters > 0) {
            percentage = (int) ((completedCount * 100.0) / totalChapters);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("completedChapterIds", completedChapterIds);
        result.put("percentage", percentage);
        
        return result;
    }

    /**
     * 获取用户已参与的课程列表（含进度）
     */
    public List<Map<String, Object>> getMyCourseList(Long userId) {
        // 1. 获取用户已购买的课程（查 user_course 表）
        LambdaQueryWrapper<UserCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCourse::getUserId, userId)
               .orderByDesc(UserCourse::getCreateTime);
        
        List<UserCourse> userCourses = userCourseMapper.selectList(wrapper);
        if (userCourses.isEmpty()) {
            return java.util.Collections.emptyList();
        }
        
        List<Long> courseIds = userCourses.stream()
                .map(UserCourse::getCourseId)
                .collect(Collectors.toList());
        
        // 2. 查询课程信息
        List<Course> courses = courseMapper.selectBatchIds(courseIds);
        Map<Long, Course> courseMap = courses.stream()
                .collect(Collectors.toMap(Course::getId, c -> c));
        
        // 3. 组装结果
        return userCourses.stream().map(uc -> {
            Course course = courseMap.get(uc.getCourseId());
            if (course == null) return null;
            
            Map<String, Object> map = new HashMap<>();
            map.put("id", course.getId());
            map.put("title", course.getTitle());
            map.put("coverImage", course.getCoverImage());
            map.put("description", course.getDescription());
            map.put("teacherName", course.getTeacherName());
            
            // 计算进度 (优先使用 user_course 表中的进度，如果没有则实时计算)
            // 这里为了准确性，还是调用 getUserProgress 实时计算一下
            Map<String, Object> progress = getUserProgress(userId, course.getId());
            map.put("progress", progress.get("percentage"));
            
            return map;
        })
        .filter(java.util.Objects::nonNull)
        .collect(Collectors.toList());
    }
}
