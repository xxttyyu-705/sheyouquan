package com.shengyouquan.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 用户数据传输对象
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
public class UserDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 用户ID
     */
    private Long id;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 昵称
     */
    private String nickname;
    
    /**
     * 头像URL
     */
    private String avatar;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 手机号
     */
    private String phone;
    
    /**
     * 性别：0-未知，1-男，2-女
     */
    private Integer gender;
    
    /**
     * 个性签名
     */
    private String signature;
    
    /**
     * 所在地
     */
    private String location;
    
    /**
     * 角色：user-普通用户，admin-管理员
     */
    private String role;
    
    /**
     * 状态：0-禁用，1-正常
     */
    private Integer status;
    
    /**
     * 积分余额
     */
    private Integer points;
    
    /**
     * 登录次数
     */
    private Integer loginCount;
    
    /**
     * 最后登录时间
     */
    private String lastLoginTime;
    
    /**
     * 注册时间
     */
    private String registerTime;
}
