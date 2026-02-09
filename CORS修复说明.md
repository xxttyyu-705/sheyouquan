# CORS 跨域问题修复说明

## 问题描述
前端运行在 `http://localhost:3003`，后端接口在 `http://localhost:8082`，浏览器默认禁止这种跨端口（跨域）的请求，导致登录注册功能无法使用。

## 修复方案

### 1. 修改 Vite 配置文件 (`frontend/vite.config.js`)
**修改前：**
```javascript
proxy: {
  '/api/v1': {
    target: 'http://localhost:8082',
    changeOrigin: true,
    secure: false,
    ws: true
  }
}
```

**修改后：**
```javascript
proxy: {
  '/user': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/work': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/course': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/product': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/point': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/exchange': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/post': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/comment': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  },
  '/order': {
    target: 'http://localhost:8082/api/v1',
    changeOrigin: true,
    secure: false,
    ws: true
  }
}
```

**说明：** 
- 后端配置了 `context-path: /api/v1`，所以所有接口都需要加上 `/api/v1` 前缀
- 为所有前端使用的 API 路径添加代理规则，包括：`/user`、`/work`、`/course`、`/product`、`/point`、`/exchange`、`/post`、`/comment`、`/order`
- 代理目标地址改为 `http://localhost:8082/api/v1`，这样前端请求 `/user/login` 会被代理到 `http://localhost:8082/api/v1/user/login`

### 2. 修改前端入口文件 (`frontend/src/main.js`)
**修改前：**
```javascript
// 配置axios
axios.defaults.baseURL = 'http://localhost:8082'
axios.defaults.timeout = 10000
```

**修改后：**
```javascript
// 配置axios
axios.defaults.timeout = 10000
```

**说明：** 删除了 `axios.defaults.baseURL` 配置，让 Axios 使用相对路径（如 `/user/login`），这样请求会发送到 Vite 开发服务器（`http://localhost:3003`），然后由 Vite 代理转发到后端（`http://localhost:8082`）。

## 工作原理

### 修复前
```
浏览器 (http://localhost:3003) 
  → 直接请求后端 (http://localhost:8082/user/login)
  → 浏览器阻止跨域请求 (CORS 错误)
```

### 修复后
```
浏览器 (http://localhost:3003) 
  → 请求 Vite 开发服务器 (http://localhost:3003/user/login)
  → Vite 代理转发到后端 (http://localhost:8082/user/login)
  → 后端响应返回给 Vite
  → Vite 返回给浏览器
  → 浏览器正常接收响应 (无 CORS 错误)
```

## 后端 CORS 配置
后端已经在 `WebSecurityConfig.java` 中配置了 CORS，允许 `http://localhost:3003` 访问：
```java
configuration.setAllowedOrigins(Arrays.asList(
    "http://localhost:3003",  // 前端开发服务器
    // ... 其他允许的源
));
```

## 验证修复
1. 启动后端服务（端口 8082）
2. 启动前端开发服务器（端口 3003）
3. 访问 `http://localhost:3003/login` 进行登录测试
4. 访问 `http://localhost:3003/register` 进行注册测试

## 注意事项
- 这些修改只影响开发环境
- 生产环境部署时，前端和后端应该部署在同一个域名下，或者配置正确的 CORS 策略
- 不要修改 `node_modules` 目录下的文件，这些修改会在重新安装依赖时丢失
