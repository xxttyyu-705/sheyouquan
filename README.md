# 摄友圈社区系统

基于Spring Boot + Vue.js的摄影爱好者社区平台，包含完整的社交、课程、商城等功能。

## 技术栈

- **后端**: Java 17 + Spring Boot 3.x + MyBatis Plus
- **前端**: Vue.js 3 + Element Plus + Axios
- **数据库**: MySQL 8.0
- **缓存**: Redis
- **文件存储**: 本地存储/对象存储
- **数据库管理**: Navicat

## 系统架构

```
摄友圈社区系统/
├── backend/              # Spring Boot后端
│   ├── src/main/java/com/shengyouquan/
│   │   ├── config/       # 配置类
│   │   ├── controller/   # 控制器
│   │   ├── service/      # 业务逻辑
│   │   ├── mapper/       # 数据访问
│   │   ├── entity/       # 实体类
│   │   ├── dto/          # 数据传输对象
│   │   ├── vo/           # 视图对象
│   │   └── common/       # 公共类
│   ├── src/main/resources/
│   │   ├── mapper/       # MyBatis映射文件
│   │   └── application.yml
│   └── pom.xml
├── frontend/             # Vue.js前端
│   ├── src/
│   │   ├── api/          # 接口封装
│   │   ├── components/   # 组件
│   │   ├── views/        # 页面
│   │   ├── router/       # 路由
│   │   ├── store/        # 状态管理
│   │   └── utils/        # 工具类
│   └── package.json
└── database/             # 数据库脚本
    └── schema.sql
```

## 功能模块

1. **统一认证与授权模块** - JWT认证、权限管理
2. **用户中心模块** - 用户信息、个人资料、关注关系
3. **全局文件服务模块** - 文件上传、下载、管理
4. **数据统计模块** - 用户活跃度、内容统计、业务分析
5. **内容管理模块** - 帖子、动态、话题管理
6. **作品模块** - 摄影作品展示、分类、标签
7. **课程与订单模块** - 在线课程、购买订单
8. **积分与商城模块** - 积分体系、商品兑换
9. **社区互动模块** - 点赞、评论、收藏、私信
10. **管理员后台模块** - 系统管理、数据监控、运营工具

## 快速开始

### 环境要求
- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Node.js 16+
- Redis (可选)

### 安装步骤
1. 克隆项目
2. 配置数据库
3. 启动后端服务
4. 启动前端服务
5. 访问系统

详细文档请查看各模块目录下的README.md文件。
