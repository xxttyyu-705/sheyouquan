## 摄友圈社区系统本地部署说明

### 一、环境准备

- **操作系统**: Windows 10 或以上
- **JDK**: JDK 17（推荐）
- **Node.js**: 建议 16+ 或 18+
- **MySQL**: 5.7 或 8.0，root 密码配置为 `123456`
- **Redis**: 可选（按需启动，默认连接 `localhost:6379`）
- **构建工具**: Maven（后端），npm 或 pnpm（前端）
- **数据库工具**: Navicat（或命令行客户端）

---

### 二、数据库初始化

1. **创建数据库并初始化表结构**

   使用 Navicat 或 MySQL 命令行连接本地 MySQL：

   ```sql
   -- 创建数据库（如果不存在）
   CREATE DATABASE IF NOT EXISTS shengyouquan 
     DEFAULT CHARACTER SET utf8mb4 
     DEFAULT COLLATE utf8mb4_unicode_ci;

   USE shengyouquan;
   ```

2. **执行项目中的 SQL 脚本**

   建议按顺序执行（在 `sheyouquan/database` 目录下）：

   - 先执行 `schema.sql`（创建所有业务表和部分初始化数据，包括管理员账号）
   - 再根据需要执行：
     - `init_data.sql`（额外的示例/测试数据，如有需要）
     - `sys_user.sql`（补充用户数据；已包含一个管理员账号记录）

3. **管理员账号说明**

   数据库中已初始化管理员账号（`schema.sql` 与修正后的 `sys_user.sql` 一致）：

   - **用户名**: `admin`
   - **密码**: `admin123456`
   - **角色字段**: `role = 'admin'`

   登录失败时，请确认：

   ```sql
   SELECT username, role, status, password FROM sys_user WHERE username = 'admin';
   ```

   其中 `status` 应为 `1`，`role` 为 `admin`。

---

### 三、后端服务（Spring Boot）启动

1. **检查配置**

   后端配置文件在 `backend/src/main/resources/application.yml`，关键数据库配置为：

   - `spring.datasource.url = jdbc:mysql://localhost:3306/shengyouquan?...`
   - `spring.datasource.username = root`
   - `spring.datasource.password = 123456`

   如本地 MySQL 用户名或密码不同，请同步修改此处。

2. **使用 Maven 启动后端**

   在命令行进入后端目录：

   ```bash
   cd sheyouquan/backend
   mvn clean package
   mvn spring-boot:run
   ```

   启动成功后，后端服务默认地址为：

   - 基础地址：`http://localhost:8082`
   - API 前缀：`/api/v1`
   - 示例：`http://localhost:8082/api/v1/user/login`

3. **JWT 与管理员登录**

   - 普通/管理员登录接口：`POST /api/v1/user/login`
   - 登录成功后返回 `token`，前端在请求时通过 `Authorization: Bearer <token>` 访问需要认证的接口（如发帖、评论、管理后台等）。

---

### 四、前端服务（Vue 3 + Vite）启动

1. **安装依赖**

   在命令行进入前端目录：

   ```bash
   cd sheyouquan/frontend
   npm install
   ```

2. **启动开发服务器**

   推荐使用与后端 CORS 已配置的端口（例如 3003 或 5173）：

   ```bash
   # 方式一：默认端口（通常为 5173）
   npm run dev

   # 方式二：显式指定端口 3003
   npm run dev -- --port 3003
   ```

3. **访问前端页面**

   - 前台站点入口：`http://localhost:3003`（或 Vite 实际提示的地址）
   - 主要页面：
     - 首页：`/`
     - 社区帖子：`/community`
     - 课程中心：`/courses`
     - 积分商城：`/mall`
     - 用户中心：`/profile`
     - 管理后台：`/admin`

   在前端登录后，浏览器会保存 `token`，后续请求会带上 `Authorization` 头，用于访问发帖、评论、后台管理等需要认证的接口。

---

### 五、社区互动模块说明（已实现）

- **帖子相关**
  - 前端：`Community.vue`，调用接口：
    - `GET /api/v1/post/list`：帖子列表，支持分页与关键词搜索
    - `POST /api/v1/post/create`：发布帖子（需登录）
    - `POST /api/v1/post/like/{id}`：点赞帖子（需登录）
- **评论相关**
  - 前端：`Community.vue` 内部的评论/回复 UI 与逻辑
  - 后端：`CommentController` + `CommentService` + `CommentMapper`
    - `GET /api/v1/comment/list`：按帖子 ID 分页获取评论
    - `POST /api/v1/comment/create`：发表评论（需登录，已从 Spring Security 中读取当前用户）
    - `POST /api/v1/comment/reply`：回复评论（需登录）
    - `POST /api/v1/comment/delete/{id}`：删除评论（管理员权限）

只要前端在用户登录后正确携带 `Authorization: Bearer <token>` 请求上述接口，帖子发布、评论、回复、点赞等社区互动功能即可正常使用。

---

### 六、管理员后台模块说明（已实现）

- **前端**：`Admin.vue`，通过标签页分区实现：
  - 用户管理（列表、禁用/启用、删除）
  - 作品管理（列表、上下架、删除）
  - 课程管理（列表、上下架、添加课程、删除）
  - 订单管理（列表、退款操作，部分示例数据）
  - 数据统计（核心指标和图表占位）

- **后端**：`AdminController` 等相关服务与 Mapper
  - `GET /api/v1/admin/dashboard`：后台总览统计
  - `GET /api/v1/admin/users`：用户分页查询
  - `GET /api/v1/admin/works` + `POST /api/v1/admin/works/{id}/review`：作品列表与审核
  - `GET /api/v1/admin/orders`：订单分页
  - `GET /api/v1/admin/posts` + `POST /api/v1/admin/posts/{id}/review`：帖子列表与审核
  - `GET/POST/PUT/DELETE /api/v1/admin/products`：商城商品管理

管理员登录成功后，访问前端 `/admin` 页面即可进入管理后台，对用户、作品、课程、订单、商品及统计数据进行管理。

---

### 七、常见问题

- **1. Admin 账号登录不了？**
  - 确认已经执行了 `schema.sql`（或 `sys_user.sql` 中的管理员记录），并且 `sys_user` 表中存在：
    - `username = 'admin'`
    - `role = 'admin'`
    - `status = 1`
  - 使用账号 `admin` / 密码 `admin123456` 登录。

- **2. 评论/回复接口返回未登录？**
  - 请确认前端请求 headers 中是否包含：`Authorization: Bearer <登录返回的 token>`。
  - 后端通过 `JwtAuthenticationFilter` 从 token 中解析用户信息，`CommentController` 已统一从 `SecurityContext` 读取当前用户。

如在本地部署过程中遇到报错信息，可以将错误日志和具体操作步骤一并提供，便于进一步排查。

