package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.UserCourseProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 用户课程进度Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface UserCourseProgressMapper extends BaseMapper<UserCourseProgress> {
    
    /**
     * 统计用户课程进度（已完成章节数）
     */
    @Select("SELECT COUNT(*) FROM user_course_progress " +
            "WHERE user_id = #{userId} AND course_id = #{courseId} AND is_completed = 1")
    int countCompletedChapters(@Param("userId") Long userId, @Param("courseId") Long courseId);
}
