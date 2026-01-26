package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.Course;
import org.apache.ibatis.annotations.Mapper;

/**
 * 课程Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface CourseMapper extends BaseMapper<Course> {
}
