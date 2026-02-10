package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Course;
import com.shengyouquan.mapper.CourseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

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
     * 获取推荐课程
     */
    public Map<String, Object> getRecommendedCourses(Integer limit) {
        // 暂时返回热门课程（按学习人数排序）
        Page<Course> coursePage = new Page<>(1, limit);
        // 这里应该有自定义查询方法
        Page<Course> result = courseMapper.selectPage(coursePage, null);
        
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
            course.setStudentCount(course.getStudentCount() + 1);
            courseMapper.updateById(course);
        }
    }
}
