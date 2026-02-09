# CORS跨域问题修复总结

## 问题描述
前端运行在 `http://localhost:3003`，后端运行在 `http://localhost:8082`，在进行登录注册请求时出现CORS错误：

```
Access to XMLHttpRequest at 'http://localhost:8082/user/login' from origin 'http://localhost:3003' 
has been blocked by CORS policy: Response to preflight request doesn't pass access control check: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## 问题原因
1. **CORS配置冲突**：`CorsConfig.java` 和 `WebSecurityConfig.java` 中都定义了CORS配置，导致冲突
2. **API路径不正确**：后端服务使用了上下文路径 `/api/v1`，但测试时使用了错误的路径
3. **预检请求处理**：OPTIONS预检请求没有正确处理

## 修复步骤

### 1. 解决CORS配置冲突
**文件**: `backend/src/main/java/com/shengyouquan/config/CorsConfig.java`

**修改前**：
```java
@Configuration
public class CorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        // ... CORS配置
        return new CorsFilter(source);
    }
}
```

**修改后**：
```java
@Configuration
public class CorsConfig {
    // 注释掉corsFilter()，避免与WebSecurityConfig中的配置冲突
    // @Bean
    // public CorsFilter corsFilter() {
    //     // ... CORS配置
    //     return new CorsFilter(source);
    // }
}
```

### 2. 确保WebSecurityConfig正确配置
**文件**: `backend/src/main/java/com/shengyouquan/config/WebSecurityConfig.java`

确保以下配置存在：
```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
    http
        .csrf(csrf -> csrf.disable())
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))  // 使用corsConfigurationSource
        .authorizeHttpRequests(auth -> auth
            .requestMatchers(
                AntPathRequestMatcher.antMatcher("/user/register"),
                AntPathRequestMatcher.antMatcher("/user/login"),
                // ... 其他公开接口
            ).permitAll()
            .anyRequest().authenticated()
        )
        .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
    
    return http.build();
}

@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    
    // 允许的源
    configuration.setAllowedOrigins(Arrays.asList(
        "http://localhost:3003",
        "http://localhost:3004",
        "http://localhost:3002",
        "http://localhost:3000",
        "http://localhost:5173",
        "http://127.0.0.1:3003",
        "http://127.0.0.1:3004",
        "http://127.0.0.1:3002",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:5173",
        "http://192.168.226.1:3003"
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
    
    // 允许携带凭证
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
```

### 3. 重新编译和打包
```bash
cd backend
mvn clean package -DskipTests
```

### 4. 启动后端服务
```bash
java -jar target/shengyouquan-backend-1.0.0.jar
```

## 验证结果

### 1. CORS预检请求测试
```bash
curl -X OPTIONS http://localhost:8082/api/v1/user/login \
  -H "Origin: http://localhost:3003" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type,Authorization" \
  -v
```

**成功响应**：
```
HTTP/1.1 200
Access-Control-Allow-Origin: http://localhost:3003
Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Allow-Credentials: true
Access-Control-Max-Age: 3600
```

### 2. 登录请求测试
```bash
Invoke-WebRequest -Uri "http://localhost:8082/api/v1/user/login" \
  -Method POST \
  -Headers @{"Origin"="http://localhost:3003";"Content-Type"="application/json"} \
  -Body '{"username":"test","password":"test123"}' \
  -UseBasicParsing
```

**成功响应**：
```
StatusCode: 200
Content: {"code":500,"message":"用户名或密码错误","timestamp":1770556983084}
Headers: {
  Access-Control-Allow-Origin: http://localhost:3003,
  Access-Control-Allow-Credentials: true
}
```

## 关键要点

1. **避免配置冲突**：不要在多个地方定义CORS配置，Spring Security的`.cors()`配置优先级更高
2. **使用正确的API路径**：注意后端服务的上下文路径（如`/api/v1`）
3. **允许OPTIONS方法**：预检请求使用OPTIONS方法，必须在允许的方法列表中
4. **允许必要的请求头**：确保包含`Content-Type`、`Authorization`等常用头
5. **允许携带凭证**：设置`setAllowCredentials(true)`以支持token传递

## 前端配置建议

在前端的API请求中，确保：
1. 使用正确的后端URL：`http://localhost:8082/api/v1/user/login`
2. 如果需要传递token，在请求头中添加：`Authorization: Bearer <token>`
3. 如果使用axios，可以配置：
```javascript
axios.defaults.baseURL = 'http://localhost:8082/api/v1'
axios.defaults.withCredentials = true
```

## 测试脚本

项目中提供了测试脚本：
- `测试注册登录CORS修复.bat` - 完整的启动和测试脚本
- `测试CORS修复详细.bat` - 详细的CORS测试脚本

运行这些脚本可以验证CORS修复是否成功。

## 修复时间
2026年2月8日

## 修复人员
摄友圈开发团队
