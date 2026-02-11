package com.shengyouquan.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import java.util.Arrays;

/**
 * Web Security配置类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Configuration
@EnableWebSecurity
public class WebSecurityConfig {
    
    /**
     * 密码编码器
     */
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    /**
     * 安全过滤器链配置
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
            // 禁用CSRF（为了API测试方便，生产环境建议启用）
            .csrf(csrf -> csrf.disable())
            // 配置CORS
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            // 配置URL访问权限
            .authorizeHttpRequests(auth -> auth
                // 公开接口 - 允许匿名访问
                .requestMatchers(
                    "/user/register", "/api/v1/user/register",
                    "/user/login", "/api/v1/user/login",
                    "/user/check/**", "/api/v1/user/check/**",
                    "/user/info", "/api/v1/user/info",
                    "/work/list", "/api/v1/work/list",
                    "/work/detail/**", "/api/v1/work/detail/**",
                    "/work/hot", "/api/v1/work/hot",
                    "/course/list", "/api/v1/course/list",
                    "/course/learn/**", "/api/v1/course/learn/**",
                    "/course/detail/**", "/api/v1/course/detail/**",
                    "/course/recommended", "/api/v1/course/recommended",
                    "/product/list", "/api/v1/product/list",
                    "/product/detail/**", "/api/v1/product/detail/**",
                    "/post/list", "/api/v1/post/list",
                    "/post/detail/**", "/api/v1/post/detail/**",
                    "/comment/list", "/api/v1/comment/list",
                    "/point/balance", "/api/v1/point/balance",
                    "/point/history", "/api/v1/point/history",
                    "/exchange/list", "/api/v1/exchange/list",
                    "/file/upload/**", "/api/v1/file/upload/**",
                    "/file/**", "/api/v1/file/**",
                    "/swagger-ui/**",
                    "/v3/api-docs/**",
                    "/swagger-resources/**",
                    "/webjars/**"
                ).permitAll()
                // 其他接口需要认证
                .anyRequest().authenticated()
            )
            // 添加JWT认证过滤器
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
    
    /**
     * CORS配置源（用于Spring Security集成）
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // 允许的源
        configuration.setAllowedOrigins(Arrays.asList(
            "http://localhost:3003",  // 前端开发服务器
            "http://localhost:3004",  // 前端开发服务器（备用端口）
            "http://localhost:3002",
            "http://localhost:3000",
            "http://localhost:5173",
            "http://127.0.0.1:3003",
            "http://127.0.0.1:3004",
            "http://127.0.0.1:3002",
            "http://127.0.0.1:3000",
            "http://127.0.0.1:5173",
            "http://192.168.226.1:3003"  // 前端实际运行地址
        ));
        
        // 允许的HTTP方法
        configuration.setAllowedMethods(Arrays.asList(
            "GET", "POST", "PUT", "DELETE", "OPTIONS"
        ));
        
        // 允许的请求头
        configuration.setAllowedHeaders(Arrays.asList(
            "Authorization", 
            "Content-Type", 
            "X-Requested-With", 
            "Accept", 
            "Origin", 
            "Access-Control-Request-Method", 
            "Access-Control-Request-Headers",
            "x-user-id"
        ));
        
        // 允许携带凭证（如Cookie、Authorization头）
        configuration.setAllowCredentials(true);
        
        // 暴露的响应头
        configuration.setExposedHeaders(Arrays.asList(
            "Access-Control-Allow-Origin",
            "Access-Control-Allow-Credentials",
            "Authorization"
        ));
        
        // 预检请求缓存时间（秒）
        configuration.setMaxAge(3600L);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
    
    /**
     * CORS配置源（用于Spring Security集成）
     * 注意：此Bean已在CorsConfig.java中定义，此处注释掉以避免重复定义
     */
    // @Bean
    // public CorsConfigurationSource corsConfigurationSource() {
    //     CorsConfiguration configuration = new CorsConfiguration();
    //     // 允许的源
    //     configuration.setAllowedOrigins(Arrays.asList(
    //         "http://localhost:3003",  // 添加前端3003端口
    //         "http://localhost:3002",
    //         "http://localhost:3000",
    //         "http://localhost:5173",
    //         "http://127.0.0.1:3003",  // 添加前端3003端口
    //         "http://127.0.0.1:3002",
    //         "http://127.0.0.1:3000",
    //         "http://127.0.0.1:5173"
    //     ));
    //     // 允许的HTTP方法
    //     configuration.setAllowedMethods(Arrays.asList(
    //         "GET", "POST", "PUT", "DELETE", "OPTIONS"
    //     ));
    //     // 允许的请求头
    //     configuration.setAllowedHeaders(Arrays.asList(
    //         "Authorization", "Content-Type", "X-Requested-With", "Accept", "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers", "x-user-id"
    //     ));
    //     // 允许携带凭证（如Cookie、Authorization头）
    //     configuration.setAllowCredentials(true);
    //     // 暴露的响应头
    //     configuration.setExposedHeaders(Arrays.asList(
    //         "Access-Control-Allow-Origin", "Access-Control-Allow-Credentials"
    //     ));
    //     // 预检请求缓存时间（秒）
    //     configuration.setMaxAge(3600L);
    //     
    //     UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    //     source.registerCorsConfiguration("/**", configuration);
    //     return source;
    // }

}
