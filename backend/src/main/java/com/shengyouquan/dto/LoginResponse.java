package com.shengyouquan.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 登录响应DTO
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
public class LoginResponse implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 访问令牌
     */
    private String token;
    
    /**
     * 令牌类型
     */
    private String tokenType;
    
    /**
     * 过期时间（秒）
     */
    private Long expiresIn;
    
    /**
     * 用户信息
     */
    private UserDTO userInfo;
    
    public LoginResponse() {
        this.tokenType = "Bearer";
    }
    
    public LoginResponse(String token, Long expiresIn, UserDTO userInfo) {
        this.token = token;
        this.expiresIn = expiresIn;
        this.userInfo = userInfo;
        this.tokenType = "Bearer";
    }
}
