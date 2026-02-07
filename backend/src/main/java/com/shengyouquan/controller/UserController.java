package com.shengyouquan.controller;

import com.shengyouquan.common.JwtUtils;
import com.shengyouquan.common.Result;
import com.shengyouquan.dto.LoginRequest;
import com.shengyouquan.dto.LoginResponse;
import com.shengyouquan.dto.RegisterRequest;
import com.shengyouquan.dto.UserDTO;
import com.shengyouquan.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 用户控制器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/user")
@Tag(name = "用户管理", description = "用户注册、登录、信息管理")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    @Operation(summary = "用户注册", description = "新用户注册")
    public Result<UserDTO> register(@Valid @RequestBody RegisterRequest request) {
        try {
            UserDTO userDTO = userService.register(request);
            return Result.success("注册成功", userDTO);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    @Operation(summary = "用户登录", description = "用户登录获取令牌")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = userService.login(request);
            return Result.success("登录成功", response);
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
    
    /**
     * 获取当前用户信息
     */
    @GetMapping("/info")
    @Operation(summary = "获取用户信息", description = "获取当前登录用户的信息")
    public Result<UserDTO> getCurrentUserInfo(@RequestHeader("Authorization") String token) {
        try {
            // 从token中提取用户ID（这里简化处理，实际应该通过拦截器或过滤器获取）
            Long userId = extractUserIdFromToken(token);
            UserDTO userDTO = userService.getUserInfo(userId);
            return Result.success(userDTO);
        } catch (Exception e) {
            return Result.error("获取用户信息失败");
        }
    }
    
    /**
     * 更新用户信息
     */
    @PutMapping("/info")
    @Operation(summary = "更新用户信息", description = "更新当前用户的信息")
    public Result<String> updateUserInfo(@RequestHeader("Authorization") String token, 
                                        @RequestBody UserDTO userDTO) {
        try {
            Long userId = extractUserIdFromToken(token);
            userService.updateUserInfo(userId, userDTO);
            return Result.success("更新成功");
        } catch (Exception e) {
            return Result.error("更新失败");
        }
    }
    
    /**
     * 检查用户名是否存在
     */
    @GetMapping("/check/username/{username}")
    @Operation(summary = "检查用户名", description = "检查用户名是否已存在")
    public Result<Boolean> checkUsername(@PathVariable String username) {
        boolean exists = userService.existsByUsername(username);
        return Result.success(!exists);
    }
    
    /**
     * 检查邮箱是否存在
     */
    @GetMapping("/check/email/{email}")
    @Operation(summary = "检查邮箱", description = "检查邮箱是否已注册")
    public Result<Boolean> checkEmail(@PathVariable String email) {
        boolean exists = userService.existsByEmail(email);
        return Result.success(!exists);
    }
    
    /**
     * 从token中提取用户ID
     */
    private Long extractUserIdFromToken(String token) {
        try {
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            // 使用JwtUtils解析token获取用户ID
            return jwtUtils.getUserIdFromToken(token);
        } catch (Exception e) {
            throw new RuntimeException("无效的token");
        }
    }
    
    /**
     * 注入JwtUtils
     */
    @Autowired
    private JwtUtils jwtUtils;
}
