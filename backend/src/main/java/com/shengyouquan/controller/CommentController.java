package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.dto.UserDTO;
import com.shengyouquan.entity.Comment;
import com.shengyouquan.service.CommentService;
import com.shengyouquan.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 评论Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/comment")
@CrossOrigin
public class CommentController {
    
    @Autowired
    private CommentService commentService;
    @Autowired
    private UserService userService;

    private String getDisplayName(Long userId) {
        try {
            UserDTO dto = userService.getUserInfo(userId);
            return (dto.getNickname() != null && !dto.getNickname().isEmpty()) ? dto.getNickname() : dto.getUsername();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取帖子评论列表
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getComments(
            @RequestParam Long postId,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Map<String, Object> comments = commentService.getComments(postId, page, size);
        return Result.success(comments);
    }
    
    /**
     * 创建评论
     * 统一从 Spring Security 上下文中获取当前登录用户，避免前端单独传用户信息。
     */
    @PostMapping("/create")
    public Result<String> createComment(@RequestBody Comment comment) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null) {
            return Result.error("未登录或登录已失效");
        }

        // 在 JwtAuthenticationFilter 中，principal 存的是 userId
        Long userId = (authentication.getPrincipal() instanceof Long)
                ? (Long) authentication.getPrincipal()
                : null;
        if (userId == null) {
            return Result.error("获取用户信息失败");
        }
        String displayName = getDisplayName(userId);
        comment.setUserId(userId);
        comment.setUsername(displayName != null ? displayName : String.valueOf(userId));

        if (commentService.createComment(comment)) {
            return Result.success("评论成功");
        }
        return Result.error("评论失败");
    }
    
    /**
     * 回复评论
     * 同样从安全上下文中获取当前登录用户。
     */
    @PostMapping("/reply")
    public Result<String> replyComment(@RequestBody Comment comment) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null) {
            return Result.error("未登录或登录已失效");
        }

        Long userId = (authentication.getPrincipal() instanceof Long)
                ? (Long) authentication.getPrincipal()
                : null;
        if (userId == null) {
            return Result.error("获取用户信息失败");
        }
        String displayName = getDisplayName(userId);
        comment.setUserId(userId);
        comment.setUsername(displayName != null ? displayName : String.valueOf(userId));

        if (commentService.replyComment(comment)) {
            return Result.success("回复成功");
        }
        return Result.error("回复失败");
    }
    
    /**
     * 删除评论（管理员）
     */
    @PostMapping("/delete/{id}")
    public Result<String> deleteComment(@PathVariable Long id) {
        if (commentService.deleteComment(id)) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }
}
