package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shengyouquan.dto.WorkDTO;
import com.shengyouquan.entity.Work;
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
    Page<WorkDTO> selectWorkPage(Page<WorkDTO> page, 
                                 @Param("keyword") String keyword,
                                 @Param("categoryId") Long categoryId,
                                 @Param("tags") String tags);
    
    /**
     * 查询用户作品列表
     */
    Page<WorkDTO> selectUserWorkPage(Page<WorkDTO> page, @Param("userId") Long userId);
    
    /**
     * 查询热门作品
     */
    List<WorkDTO> selectHotWorks(@Param("limit") Integer limit);
    
    /**
     * 查询作品详情
     */
    WorkDTO selectWorkDetail(@Param("id") Long id);
    
    /**
     * 更新作品统计
     */
    int updateWorkStats(@Param("id") Long id, 
                       @Param("type") String type);
}
