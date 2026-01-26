package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Post;
import com.shengyouquan.mapper.PostMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 帖子服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class PostService extends ServiceImpl<PostMapper, Post> {
    
    @Autowired
    private PostMapper postMapper;
    
    /**
     * 分页查询帖子列表
     */
    public Map<String, Object> getPosts(String keyword, Integer page, Integer size) {
        Page<Post> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Post> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(Post::getStatus, 1); // 只显示已发布帖子
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Post::getTitle, keyword)
                   .or().like(Post::getContent, keyword);
        }
        
        wrapper.orderByDesc(Post::getCreateTime);
        
        Page<Post> resultPage = postMapper.selectPage(pageObj, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        
        return result;
    }
    
    /**
     * 获取帖子详情
     */
    public Post getPostDetail(Long id) {
        // 增加浏览数
        Post post = postMapper.selectById(id);
        if (post != null) {
            post.setViews(post.getViews() + 1);
            postMapper.updateById(post);
        }
        return post;
    }
    
    /**
     * 创建帖子
     */
    @Transactional
    public boolean createPost(Post post) {
        post.setViews(0);
        post.setLikes(0);
        post.setComments(0);
        post.setStatus(1); // 已发布
        post.setCreateTime(LocalDateTime.now());
        post.setUpdateTime(LocalDateTime.now());
        return postMapper.insert(post) > 0;
    }
    
    /**
     * 点赞帖子
     */
    @Transactional
    public boolean likePost(Long id) {
        Post post = postMapper.selectById(id);
        if (post == null) {
            return false;
        }
        
        post.setLikes(post.getLikes() + 1);
        post.setUpdateTime(LocalDateTime.now());
        
        return postMapper.updateById(post) > 0;
    }
    
    /**
     * 更新评论数
     */
    @Transactional
    public boolean updateCommentCount(Long id, int count) {
        Post post = postMapper.selectById(id);
        if (post == null) {
            return false;
        }
        
        post.setComments(post.getComments() + count);
        post.setUpdateTime(LocalDateTime.now());
        
        return postMapper.updateById(post) > 0;
    }
    
    /**
     * 删除帖子（管理员）
     */
    @Transactional
    public boolean deletePost(Long id) {
        Post post = postMapper.selectById(id);
        if (post == null) {
            return false;
        }
        
        post.setStatus(2); // 已删除
        post.setUpdateTime(LocalDateTime.now());
        
        return postMapper.updateById(post) > 0;
    }
}
