package com.shengyouquan.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shengyouquan.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 用户Mapper接口
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
    
    /**
     * 根据用户名查询用户
     */
    @Select("SELECT * FROM sys_user WHERE username = #{username} AND deleted = 0")
    User findByUsername(@Param("username") String username);
    
    /**
     * 根据邮箱查询用户
     */
    @Select("SELECT * FROM sys_user WHERE email = #{email} AND deleted = 0")
    User findByEmail(@Param("email") String email);
    
    /**
     * 根据用户ID查询用户信息（不包含密码）
     */
    @Select("SELECT id, username, nickname, avatar, email, phone, gender, signature, location, role, status, points, login_count, last_login_time, register_time " +
            "FROM sys_user WHERE id = #{id} AND deleted = 0")
    User findUserInfoById(@Param("id") Long id);
    
    /**
     * 更新用户登录信息
     */
    @Update("UPDATE sys_user SET login_count = login_count + 1, last_login_time = NOW() WHERE id = #{id}")
    void updateLoginInfo(@Param("id") Long id);
    
    /**
     * 更新用户积分
     */
    @Update("UPDATE sys_user SET points = points + #{points} WHERE id = #{id}")
    void updatePoints(@Param("id") Long id, @Param("points") Integer points);
    
    /**
     * 根据角色查询用户列表
     */
    @Select("SELECT * FROM sys_user WHERE role = #{role} AND deleted = 0 AND status = 1 ORDER BY create_time DESC")
    List<User> findByRole(@Param("role") String role);
    
    /**
     * 查询活跃用户（登录次数最多的前N个）
     */
    @Select("SELECT * FROM sys_user WHERE deleted = 0 AND status = 1 ORDER BY login_count DESC LIMIT #{limit}")
    List<User> findActiveUsers(@Param("limit") Integer limit);
    
    /**
     * 查询新注册用户
     */
    @Select("SELECT * FROM sys_user WHERE deleted = 0 AND status = 1 ORDER BY register_time DESC LIMIT #{limit}")
    List<User> findNewUsers(@Param("limit") Integer limit);
    
    /**
     * 统计用户总数
     */
    @Select("SELECT COUNT(*) FROM sys_user WHERE deleted = 0")
    Long countUsers();
    
    /**
     * 统计指定状态的用户数
     */
    @Select("SELECT COUNT(*) FROM sys_user WHERE status = #{status} AND deleted = 0")
    Long countUsersByStatus(@Param("status") Integer status);
    
    /**
     * 统计指定角色的用户数
     */
    @Select("SELECT COUNT(*) FROM sys_user WHERE role = #{role} AND deleted = 0")
    Long countUsersByRole(@Param("role") String role);
}
