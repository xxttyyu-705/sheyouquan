package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Comment;
import com.shengyouquan.mapper.CommentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 评论服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class CommentService extends ServiceImpl<CommentMapper, Comment> {
    
    @Autowired
    private CommentMapper commentMapper;
    
    @Autowired
    private PostService postService;
    
    /**
     * 获取帖子评论列表
     */
    public Map<String, Object> getComments(Long postId, Integer page, Integer size) {
        Page<Comment> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Comment> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(Comment::getPostId, postId)
               .eq(Comment::getStatus, 1) // 只显示已发布评论
               .orderByDesc(Comment::getCreateTime);
        
        Page<Comment> resultPage = commentMapper.selectPage(pageObj, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        
        return result;
    }
    
    /**
     * 创建评论
     */
    @Transactional
    public boolean createComment(Comment comment) {
        comment.setStatus(1); // 已发布
        comment.setCreateTime(LocalDateTime.now());
        comment.setUpdateTime(LocalDateTime.now());
        
        boolean success = commentMapper.insert(comment) > 0;
        
        if (success) {
            // 更新帖子评论数
            postService.updateCommentCount(comment.getPostId(), 1);
        }
        
        return success;
    }
    
    /**
     * 回复评论
     */
    @Transactional
    public boolean replyComment(Comment comment) {
        comment.setStatus(1);
        comment.setCreateTime(LocalDateTime.now());
        comment.setUpdateTime(LocalDateTime.now());
        
        boolean success = commentMapper.insert(comment) > 0;
        
        if (success) {
            // 更新帖子评论数
            postService.updateCommentCount(comment.getPostId(), 1);
        }
        
        return success;
    }
    
    /**
     * 删除评论（管理员）
     */
    @Transactional
    public boolean deleteComment(Long id) {
        Comment comment = commentMapper.selectById(id);
        if (comment == null) {
            return false;
        }
        
        comment.setStatus(2); // 已删除
        comment.setUpdateTime(LocalDateTime.now());
        
        boolean success = commentMapper.updateById(comment) > 0;
        
        if (success) {
            // 更新帖子评论数（减少）
            postService.updateCommentCount(comment.getPostId(), -1);
        }
        
        return success;
    }
}
