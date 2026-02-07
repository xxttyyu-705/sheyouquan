package com.shengyouquan.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;

/**
 * CORS跨域配置类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Configuration
public class CorsConfig {

    /**
     * CORS过滤器配置
     */
    @Bean
    public CorsFilter corsFilter() {
        // 1. 创建CORS配置对象
        CorsConfiguration config = new CorsConfiguration();
        
        // 允许的前端域名（生产环境建议指定具体域名，避免使用通配符*）
        config.setAllowedOrigins(Arrays.asList(
            "http://localhost:3003",  // 前端开发服务器
            "http://localhost:3004",  // 前端开发服务器（备用端口）
            "http://localhost:3002",
            "http://localhost:3000",
            "http://localhost:5173",
            "http://127.0.0.1:3003",
            "http://127.0.0.1:3004",
            "http://127.0.0.1:3002",
            "http://127.0.0.1:3000",
            "http://127.0.0.1:5173"
        ));
        
        // 允许携带Cookie（若前端需要传递token到本地存储，可开启）
        config.setAllowCredentials(true);
        
        // 允许所有请求方法（GET/POST/PUT/DELETE等）
        config.setAllowedMethods(Arrays.asList(
            "GET", "POST", "PUT", "DELETE", "OPTIONS"
        ));
        
        // 允许所有请求头（如 Authorization/Content-Type 等）
        config.setAllowedHeaders(Arrays.asList(
            "Authorization", 
            "Content-Type", 
            "X-Requested-With", 
            "Accept", 
            "Origin", 
            "Access-Control-Request-Method", 
            "Access-Control-Request-Headers",
            "x-user-id"
        ));
        
        // 暴露响应头（前端需要获取的自定义头，如token相关）
        config.setExposedHeaders(Arrays.asList(
            "Access-Control-Allow-Origin",
            "Access-Control-Allow-Credentials",
            "Authorization"
        ));
        
        // 预检请求有效期（秒），避免频繁OPTIONS请求
        config.setMaxAge(3600L);

        // 2. 配置CORS生效的接口路径（匹配你的后端接口前缀 /api/v1/**）
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/v1/**", config);
        
        // 3. 返回CORS过滤器
        return new CorsFilter(source);
    }

    /**
     * CORS配置源（用于Spring Security集成）
     * 注意：此Bean已在WebSecurityConfig.java中定义，此处注释掉以避免重复定义
     */
    // @Bean
    // public CorsConfigurationSource corsConfigurationSource() {
    //     CorsConfiguration configuration = new CorsConfiguration();
    //     
    //     // 允许的源
    //     configuration.setAllowedOrigins(Arrays.asList(
    //         "http://localhost:3003",  // 前端开发服务器
    //         "http://localhost:3004",  // 前端开发服务器（备用端口）
    //         "http://localhost:3002",
    //         "http://localhost:3000",
    //         "http://localhost:5173",
    //         "http://127.0.0.1:3003",
    //         "http://127.0.0.1:3004",
    //         "http://127.0.0.1:3002",
    //         "http://127.0.0.1:3000",
    //         "http://127.0.0.1:5173"
    //     ));
    //     
    //     // 允许的HTTP方法
    //     configuration.setAllowedMethods(Arrays.asList(
    //         "GET", "POST", "PUT", "DELETE", "OPTIONS"
    //     ));
    //     
    //     // 允许的请求头
    //     configuration.setAllowedHeaders(Arrays.asList(
    //         "Authorization", 
    //         "Content-Type", 
    //         "X-Requested-With", 
    //         "Accept", 
    //         "Origin", 
    //         "Access-Control-Request-Method", 
    //         "Access-Control-Request-Headers",
    //         "x-user-id"
    //     ));
    //     
    //     // 允许携带凭证（如Cookie、Authorization头）
    //     configuration.setAllowCredentials(true);
    //     
    //     // 暴露的响应头
    //     configuration.setExposedHeaders(Arrays.asList(
    //         "Access-Control-Allow-Origin",
    //         "Access-Control-Allow-Credentials",
    //         "Authorization"
    //     ));
    //     
    //     // 预检请求缓存时间（秒）
    //     configuration.setMaxAge(3600L);
    //     
    //     UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    //     source.registerCorsConfiguration("/api/v1/**", configuration);
    //     return source;
    // }
}
