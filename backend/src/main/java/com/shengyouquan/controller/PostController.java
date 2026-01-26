package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Post;
import com.shengyouquan.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 帖子Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/post")
@CrossOrigin
public class PostController {
    
    @Autowired
    private PostService postService;
    
    /**
     * 获取帖子列表
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getPosts(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Map<String, Object> posts = postService.getPosts(keyword, page, size);
        return Result.success(posts);
    }
    
    /**
     * 获取帖子详情
     */
    @GetMapping("/detail/{id}")
    public Result<Post> getPostDetail(@PathVariable Long id) {
        Post post = postService.getPostDetail(id);
        if (post == null) {
            return Result.error("帖子不存在");
        }
        return Result.success(post);
    }
    
    /**
     * 创建帖子
     */
    @PostMapping("/create")
    public Result<String> createPost(
            @RequestHeader(value = "X-User-Id", required = false) Long userId,
            @RequestHeader(value = "X-Username", required = false) String username,
            @RequestBody Post post) {
        
        // 如果没有提供用户ID和用户名，使用默认值（用于测试）
        Long actualUserId = userId != null ? userId : 1L;
        String actualUsername = username != null ? username : "testuser";
        
        post.setUserId(actualUserId);
        post.setUsername(actualUsername);
        
        if (postService.createPost(post)) {
            return Result.success("帖子创建成功");
        }
        return Result.error("帖子创建失败");
    }
    
    /**
     * 点赞帖子
     */
    @PostMapping("/like/{id}")
    public Result<String> likePost(@PathVariable Long id) {
        if (postService.likePost(id)) {
            return Result.success("点赞成功");
        }
        return Result.error("点赞失败");
    }
    
    /**
     * 删除帖子（管理员）
     */
    @PostMapping("/delete/{id}")
    public Result<String> deletePost(@PathVariable Long id) {
        if (postService.deletePost(id)) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }
}
