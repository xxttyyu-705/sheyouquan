package com.shengyouquan.config;

import com.shengyouquan.common.JwtUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * JWT认证过滤器
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        try {
            String jwt = getJwtFromRequest(request);
            
            if (jwt != null && !jwt.isEmpty()) {
                try {
                    // 从JWT中提取用户信息
                    Long userId = jwtUtils.getUserIdFromToken(jwt);
                    String username = jwtUtils.getUsernameFromToken(jwt);
                    String role = jwtUtils.getRoleFromToken(jwt);
                    
                    if (userId != null && username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                        // 创建UserDetails对象
                        UserDetails userDetails = new org.springframework.security.core.userdetails.User(
                                username,
                                "", // 密码不需要
                                java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + role))
                        );
                        
                        // 创建认证令牌
                        UsernamePasswordAuthenticationToken authentication = 
                                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        
                        // 设置认证信息到安全上下文
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    }
                } catch (Exception jwtException) {
                    // JWT验证失败，可能是token无效或过期，记录日志但不中断请求
                    logger.warn("JWT验证失败: " + jwtException.getMessage());
                    // 清除无效的认证信息
                    SecurityContextHolder.clearContext();
                }
            }
        } catch (Exception e) {
            logger.error("处理JWT请求时发生错误", e);
        }
        
        filterChain.doFilter(request, response);
    }

    private String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        // 对公开接口不进行JWT过滤
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // 移除上下文路径，获取相对路径
        String relativePath = path;
        if (contextPath != null && !contextPath.isEmpty() && path.startsWith(contextPath)) {
            relativePath = path.substring(contextPath.length());
        }
        
        return relativePath.startsWith("/user/login") ||
               relativePath.startsWith("/user/register") ||
               relativePath.startsWith("/user/check") ||
               relativePath.startsWith("/work/list") ||
               relativePath.startsWith("/work/detail") ||
               relativePath.startsWith("/work/hot") ||
               relativePath.startsWith("/course/list") ||
               relativePath.startsWith("/course/detail") ||
               relativePath.startsWith("/course/recommended") ||
               relativePath.startsWith("/product/list") ||
               relativePath.startsWith("/product/detail") ||
               relativePath.startsWith("/post/list") ||
               relativePath.startsWith("/post/detail") ||
               relativePath.startsWith("/swagger-ui") ||
               relativePath.startsWith("/v3/api-docs") ||
               relativePath.startsWith("/swagger-resources") ||
               relativePath.startsWith("/webjars");
    }
}
