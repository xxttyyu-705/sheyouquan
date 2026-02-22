package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shengyouquan.dto.WorkDTO;
import com.shengyouquan.entity.Work;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 作品Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface WorkMapper extends BaseMapper<Work> {
    
    /**
     * 分页查询作品列表
     */
    @Select("<script>" +
            "SELECT w.*, u.nickname as authorNickname, u.avatar as authorAvatar " +
            "FROM work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.status = 1 AND w.deleted = 0 " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (w.title LIKE CONCAT('%', #{keyword}, '%') OR w.description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "<if test='categoryId != null'>" +
            "AND w.category_id = #{categoryId} " +
            "</if>" +
            "<if test='tags != null and tags != \"\"'>" +
            "AND w.tags LIKE CONCAT('%', #{tags}, '%') " +
            "</if>" +
            "ORDER BY w.create_time DESC" +
            "</script>")
    Page<WorkDTO> selectWorkPage(Page<WorkDTO> page, 
                                 @Param("keyword") String keyword,
                                 @Param("categoryId") Long categoryId,
                                 @Param("tags") String tags);
    
    /**
     * 查询用户作品列表
     */
    @Select("SELECT w.*, u.nickname as authorNickname, u.avatar as authorAvatar " +
            "FROM work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.user_id = #{userId} AND w.deleted = 0 " +
            "ORDER BY w.create_time DESC")
    Page<WorkDTO> selectUserWorkPage(Page<WorkDTO> page, @Param("userId") Long userId);
    
    /**
     * 查询热门作品
     */
    @Select("SELECT w.*, u.nickname as authorNickname, u.avatar as authorAvatar " +
            "FROM work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.status = 1 AND w.deleted = 0 " +
            "ORDER BY w.view_count DESC, w.like_count DESC " +
            "LIMIT #{limit}")
    List<WorkDTO> selectHotWorks(@Param("limit") Integer limit);
    
    /**
     * 查询作品详情
     */
    @Select("SELECT w.*, u.nickname as authorNickname, u.avatar as authorAvatar " +
            "FROM work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.id = #{id}")
    WorkDTO selectWorkDetail(@Param("id") Long id);
    
    /**
     * 管理员分页查询作品列表（包含作者信息）
     */
    @Select("<script>" +
            "SELECT w.*, u.nickname as authorNickname, u.avatar as authorAvatar " +
            "FROM work w " +
            "LEFT JOIN sys_user u ON w.user_id = u.id " +
            "WHERE w.deleted = 0 " +
            "<if test='status != null and status != \"\"'>" +
            "AND w.status = #{status} " +
            "</if>" +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (w.title LIKE CONCAT('%', #{keyword}, '%') OR w.description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "ORDER BY w.create_time DESC" +
            "</script>")
    Page<WorkDTO> selectAdminWorkPage(Page<WorkDTO> page,
                                     @Param("status") String status,
                                     @Param("keyword") String keyword);
    
    /**
     * 更新作品统计
     */
    @Update("<script>" +
            "UPDATE work SET " +
            "<if test='type == \"view\"'>view_count = view_count + 1</if>" +
            "<if test='type == \"like\"'>like_count = like_count + 1</if>" +
            "<if test='type == \"collect\"'>collect_count = collect_count + 1</if>" +
            "<if test='type == \"comment\"'>comment_count = comment_count + 1</if>" +
            "WHERE id = #{id}" +
            "</script>")
    int updateWorkStats(@Param("id") Long id, 
                       @Param("type") String type);
}
