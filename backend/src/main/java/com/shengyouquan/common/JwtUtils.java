package com.shengyouquan.common;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT工具类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Slf4j
@Component
public class JwtUtils {
    
    @Value("${jwt.secret}")
    private String secret;
    
    @Value("${jwt.expiration}")
    private Long expiration;
    
    @Value("${jwt.token-prefix}")
    private String tokenPrefix;
    
    /**
     * 生成Token
     */
    public String generateToken(Long userId, String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("username", username);
        claims.put("role", role);
        return createToken(claims, userId.toString());
    }
    
    /**
     * 创建Token
     */
    private String createToken(Map<String, Object> claims, String subject) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expiration);
        
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                .compact();
    }
    
    /**
     * 从Token中提取用户ID
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("userId", Long.class);
    }
    
    /**
     * 从Token中提取用户名
     */
    public String getUsernameFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("username", String.class);
    }
    
    /**
     * 从Token中提取角色
     */
    public String getRoleFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("role", String.class);
    }
    
    /**
     * 从Token中提取过期时间
     */
    public Date getExpirationDateFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.getExpiration();
    }
    
    /**
     * 验证Token
     */
    public Boolean validateToken(String token, Long userId) {
        try {
            Long tokenUserId = getUserIdFromToken(token);
            return (tokenUserId.equals(userId) && !isTokenExpired(token));
        } catch (Exception e) {
            log.error("Token验证失败: {}", e.getMessage());
            return false;
        }
    }
    
    /**
     * 检查Token是否过期
     */
    public Boolean isTokenExpired(String token) {
        Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }
    
    /**
     * 从Token中提取所有声明
     */
    private Claims getClaimsFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token.replace(tokenPrefix, "").trim())
                .getBody();
    }
    
    /**
     * 获取签名密钥
     */
    private SecretKey getSigningKey() {
        // 使用安全的密钥生成方式，确保密钥长度符合HS512要求（至少512位）
        // 如果配置了secret，则使用它作为种子生成安全密钥
        if (secret != null && !secret.isEmpty()) {
            // 使用secret作为种子生成符合HS512要求的密钥
            byte[] keyBytes = secret.getBytes();
            
            // 确保密钥长度至少为512位（64字节）
            if (keyBytes.length < 64) {
                // 使用 SHA-512 对 secret 进行哈希，生成固定长度的 64 字节密钥
                try {
                    java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-512");
                    byte[] hashedBytes = digest.digest(keyBytes);
                    return Keys.hmacShaKeyFor(hashedBytes);
                } catch (java.security.NoSuchAlgorithmException e) {
                    throw new RuntimeException("SHA-512 algorithm not found", e);
                }
            }
            return Keys.hmacShaKeyFor(keyBytes);
        } else {
            // 如果没有配置secret，直接生成安全密钥
            return Keys.secretKeyFor(SignatureAlgorithm.HS512);
        }
    }
    
    /**
     * 从Token中提取用户信息
     */
    public Map<String, Object> getUserInfoFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("userId", claims.get("userId", Long.class));
        userInfo.put("username", claims.get("username", String.class));
        userInfo.put("role", claims.get("role", String.class));
        return userInfo;
    }
    
    /**
     * 刷新Token
     */
    public String refreshToken(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            Long userId = claims.get("userId", Long.class);
            String username = claims.get("username", String.class);
            String role = claims.get("role", String.class);
            return generateToken(userId, username, role);
        } catch (Exception e) {
            log.error("刷新Token失败: {}", e.getMessage());
            return null;
        }
    }
    
    /**
     * 检查Token是否有效
     */
    public Boolean isTokenValid(String token, Long userId) {
        try {
            Long tokenUserId = getUserIdFromToken(token);
            return (tokenUserId != null && tokenUserId.equals(userId) && !isTokenExpired(token));
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 从Token中提取用户ID（不验证）
     */
    public Long getUserIdFromTokenWithoutValidation(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            return claims.get("userId", Long.class);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 添加Token前缀
     */
    public String addTokenPrefix(String token) {
        return tokenPrefix + " " + token;
    }
    
    /**
     * 移除Token前缀
     */
    public String removeTokenPrefix(String token) {
        if (token != null && token.startsWith(tokenPrefix)) {
            return token.substring(tokenPrefix.length()).trim();
        }
        return token;
    }
}
