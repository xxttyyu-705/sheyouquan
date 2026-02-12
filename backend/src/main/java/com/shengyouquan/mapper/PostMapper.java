package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shengyouquan.entity.Post;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 帖子Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface PostMapper extends BaseMapper<Post> {
    
    @Select("<script>" +
            "SELECT p.*, u.username " +
            "FROM post p " +
            "LEFT JOIN sys_user u ON p.user_id = u.id " +
            "WHERE p.status = 1 " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (p.title LIKE CONCAT('%', #{keyword}, '%') OR p.content LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY p.create_time DESC" +
            "</script>")
    Page<Post> selectPostPage(Page<Post> page, @Param("keyword") String keyword);

    @Select("SELECT p.*, u.username " +
            "FROM post p " +
            "LEFT JOIN sys_user u ON p.user_id = u.id " +
            "WHERE p.id = #{id}")
    Post selectPostDetail(@Param("id") Long id);
}
