package com.shengyouquan.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.common.JwtUtils;
import com.shengyouquan.dto.LoginRequest;
import com.shengyouquan.dto.LoginResponse;
import com.shengyouquan.dto.RegisterRequest;
import com.shengyouquan.dto.UserDTO;
import com.shengyouquan.entity.User;
import com.shengyouquan.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * 用户服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Slf4j
@Service
public class UserService extends ServiceImpl<UserMapper, User> {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private JwtUtils jwtUtils;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    @Value("${points.register}")
    private Integer registerPoints;
    
    /**
     * 用户注册
     */
    @Transactional(rollbackFor = Exception.class)
    public UserDTO register(RegisterRequest request) {
        // 验证密码一致性
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("两次输入的密码不一致");
        }
        
        // 检查用户名是否已存在
        User existingUser = userMapper.findByUsername(request.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("用户名已存在");
        }
        
        // 检查邮箱是否已存在
        User existingEmail = userMapper.findByEmail(request.getEmail());
        if (existingEmail != null) {
            throw new RuntimeException("邮箱已被注册");
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setNickname(request.getNickname() != null ? request.getNickname() : request.getUsername());
        user.setRole("user");
        user.setStatus(1);
        user.setPoints(registerPoints);
        user.setLoginCount(0);
        user.setRegisterTime(LocalDateTime.now());
        
        // 保存用户
        userMapper.insert(user);
        
        log.info("用户注册成功: {}", user.getUsername());
        
        // 转换为DTO
        UserDTO userDTO = new UserDTO();
        BeanUtils.copyProperties(user, userDTO);
        userDTO.setRegisterTime(user.getRegisterTime().toString());
        
        return userDTO;
    }
    
    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        // 查询用户
        User user = userMapper.findByUsername(request.getUsername());
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }
        
        // 检查用户状态
        if (user.getStatus() == 0) {
            throw new RuntimeException("用户已被禁用");
        }
        
        // 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }
        
        // 更新登录信息
        userMapper.updateLoginInfo(user.getId());
        
        // 生成JWT令牌
        String token = jwtUtils.generateToken(user.getId(), user.getUsername(), user.getRole());
        
        // 转换为DTO
        UserDTO userDTO = new UserDTO();
        BeanUtils.copyProperties(user, userDTO);
        if (user.getLastLoginTime() != null) {
            userDTO.setLastLoginTime(user.getLastLoginTime().toString());
        }
        if (user.getRegisterTime() != null) {
            userDTO.setRegisterTime(user.getRegisterTime().toString());
        }
        
        log.info("用户登录成功: {}", user.getUsername());
        
        return new LoginResponse(token, 86400L, userDTO);
    }
    
    /**
     * 根据ID获取用户信息
     */
    public UserDTO getUserInfo(Long userId) {
        User user = userMapper.findUserInfoById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        UserDTO userDTO = new UserDTO();
        BeanUtils.copyProperties(user, userDTO);
        if (user.getLastLoginTime() != null) {
            userDTO.setLastLoginTime(user.getLastLoginTime().toString());
        }
        if (user.getRegisterTime() != null) {
            userDTO.setRegisterTime(user.getRegisterTime().toString());
        }
        
        return userDTO;
    }
    
    /**
     * 更新用户信息
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateUserInfo(Long userId, UserDTO userDTO) {
        User user = new User();
        BeanUtils.copyProperties(userDTO, user);
        user.setId(userId);
        
        userMapper.updateById(user);
        log.info("用户信息更新成功: {}", userId);
    }
    
    /**
     * 更新用户积分
     */
    @Transactional(rollbackFor = Exception.class)
    public void updatePoints(Long userId, Integer points) {
        userMapper.updatePoints(userId, points);
        log.info("用户积分更新成功: {}, 积分变化: {}", userId, points);
    }
    
    /**
     * 检查用户是否存在
     */
    public boolean existsByUsername(String username) {
        return userMapper.findByUsername(username) != null;
    }
    
    /**
     * 检查邮箱是否存在
     */
    public boolean existsByEmail(String email) {
        return userMapper.findByEmail(email) != null;
    }
    
    /**
     * 根据用户名获取用户
     */
    public User getUserByUsername(String username) {
        return userMapper.findByUsername(username);
    }
    
    /**
     * 根据邮箱获取用户
     */
    public User getUserByEmail(String email) {
        return userMapper.findByEmail(email);
    }
    
    /**
     * 获取活跃用户
     */
    public java.util.List<UserDTO> getActiveUsers(Integer limit) {
        java.util.List<User> users = userMapper.findActiveUsers(limit);
        return users.stream().map(user -> {
            UserDTO dto = new UserDTO();
            BeanUtils.copyProperties(user, dto);
            if (user.getRegisterTime() != null) {
                dto.setRegisterTime(user.getRegisterTime().toString());
            }
            return dto;
        }).collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * 获取新注册用户
     */
    public java.util.List<UserDTO> getNewUsers(Integer limit) {
        java.util.List<User> users = userMapper.findNewUsers(limit);
        return users.stream().map(user -> {
            UserDTO dto = new UserDTO();
            BeanUtils.copyProperties(user, dto);
            if (user.getRegisterTime() != null) {
                dto.setRegisterTime(user.getRegisterTime().toString());
            }
            return dto;
        }).collect(java.util.stream.Collectors.toList());
    }
    
    /**
     * 统计用户总数
     */
    public Long countUsers() {
        return userMapper.countUsers();
    }
    
    /**
     * 统计指定状态的用户数
     */
    public Long countUsersByStatus(Integer status) {
        return userMapper.countUsersByStatus(status);
    }
    
    /**
     * 统计指定角色的用户数
     */
    public Long countUsersByRole(String role) {
        return userMapper.countUsersByRole(role);
    }
}
