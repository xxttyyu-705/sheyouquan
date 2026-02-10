package com.shengyouquan.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.dto.WorkDTO;
import com.shengyouquan.entity.Work;
import com.shengyouquan.mapper.WorkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * 作品服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class WorkService extends ServiceImpl<WorkMapper, Work> {
    
    @Autowired
    private WorkMapper workMapper;
    
    /**
     * 分页查询作品列表
     */
    public Map<String, Object> getWorkList(Integer page, Integer size, String keyword, Long categoryId, String tags) {
        Page<WorkDTO> workPage = new Page<>(page, size);
        Page<WorkDTO> result = workMapper.selectWorkPage(workPage, keyword, categoryId, tags);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", result.getRecords());
        map.put("total", result.getTotal());
        map.put("pages", result.getPages());
        map.put("current", result.getCurrent());
        
        return map;
    }
    
    /**
     * 获取用户作品列表
     */
    public Map<String, Object> getUserWorkList(Long userId, Integer page, Integer size) {
        Page<WorkDTO> workPage = new Page<>(page, size);
        Page<WorkDTO> result = workMapper.selectUserWorkPage(workPage, userId);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", result.getRecords());
        map.put("total", result.getTotal());
        map.put("pages", result.getPages());
        map.put("current", result.getCurrent());
        
        return map;
    }
    
    /**
     * 获取热门作品
     */
    public Map<String, Object> getHotWorks(Integer limit) {
        return new HashMap<String, Object>() {{
            put("list", workMapper.selectHotWorks(limit));
        }};
    }
    
    /**
     * 获取作品详情
     */
    public Work getWorkDetail(Long id) {
        return this.getById(id); // 保持使用 getById 获取实体，统计更新在 Controller 中调用
    }
    
    /**
     * 发布作品
     */
    public Work publishWork(Work work) {
        // 初始化统计信息
        work.setViewCount(0);
        work.setLikeCount(0);
        work.setCommentCount(0);
        work.setCollectCount(0);
        work.setStatus(1);
        
        save(work);
        return work;
    }
    
    /**
     * 更新作品统计
     */
    public void updateWorkStats(Long id, String type) {
        workMapper.updateWorkStats(id, type);
    }
    
    /**
     * 点赞/取消点赞
     */
    public void toggleLike(Long workId, Long userId) {
        // 这里需要创建点赞记录表，暂时简化处理
        updateWorkStats(workId, "like");
    }
    
    /**
     * 收藏/取消收藏
     */
    public void toggleCollect(Long workId, Long userId) {
        // 这里需要创建收藏记录表，暂时简化处理
        updateWorkStats(workId, "collect");
    }
}
