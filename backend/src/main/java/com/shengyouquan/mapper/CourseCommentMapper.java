package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.CourseComment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;
import java.util.Map;

@Mapper
public interface CourseCommentMapper extends BaseMapper<CourseComment> {
    
    @Select("SELECT cc.*, u.username, u.avatar " +
            "FROM course_comment cc " +
            "LEFT JOIN sys_user u ON cc.user_id = u.id " +
            "WHERE cc.course_id = #{courseId} AND cc.status = 1 " +
            "ORDER BY cc.create_time DESC")
    List<CourseComment> selectCommentsByCourseId(Long courseId);
}
