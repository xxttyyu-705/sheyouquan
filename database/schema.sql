-- 摄友圈社区系统数据库设计
-- 数据库名称: shengyouquan
-- 字符集: utf8mb4
-- 排序规则: utf8mb4_unicode_ci

CREATE DATABASE IF NOT EXISTS shengyouquan 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE shengyouquan;

-- ==================== 1. 用户模块相关表 ====================

-- 用户表
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码(加密)',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `gender` TINYINT DEFAULT 0 COMMENT '性别: 0-未知, 1-男, 2-女',
  `birthday` DATE DEFAULT NULL COMMENT '生日',
  `signature` VARCHAR(200) DEFAULT NULL COMMENT '个性签名',
  `location` VARCHAR(100) DEFAULT NULL COMMENT '所在地',
  `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色: user-普通用户, admin-管理员',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `points` INT DEFAULT 0 COMMENT '积分余额',
  `login_count` INT DEFAULT 0 COMMENT '登录次数',
  `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `register_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除: 0-未删除, 1-已删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_status` (`status`),
  KEY `idx_role` (`role`),
  KEY `idx_status_role` (`status`, `role`),
  KEY `idx_points` (`points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 用户关注表
DROP TABLE IF EXISTS `user_follow`;
CREATE TABLE `user_follow` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `follower_id` BIGINT NOT NULL COMMENT '关注者ID',
  `followed_id` BIGINT NOT NULL COMMENT '被关注者ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_follower_followed` (`follower_id`, `followed_id`),
  KEY `idx_follower` (`follower_id`),
  KEY `idx_followed` (`followed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注表';

-- 用户标签表
DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE `user_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '标签描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表';

-- 用户标签关联表
DROP TABLE IF EXISTS `user_tag_relation`;
CREATE TABLE `user_tag_relation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `tag_id` BIGINT NOT NULL COMMENT '标签ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_tag` (`user_id`, `tag_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_tag` (`tag_id`),
  KEY `idx_user_tag` (`user_id`, `tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签关联表';

-- ==================== 2. 内容管理模块表 ====================

-- 帖子/动态表
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `user_id` BIGINT NOT NULL COMMENT '发布者ID',
  `content` TEXT NOT NULL COMMENT '内容',
  `images` JSON DEFAULT NULL COMMENT '图片列表(JSON)',
  `videos` JSON DEFAULT NULL COMMENT '视频列表(JSON)',
  `location` VARCHAR(100) DEFAULT NULL COMMENT '发布地点',
  `privacy` TINYINT DEFAULT 0 COMMENT '隐私设置: 0-公开, 1-好友可见, 2-私密',
  `topic_id` BIGINT DEFAULT NULL COMMENT '话题ID',
  `like_count` INT DEFAULT 0 COMMENT '点赞数',
  `comment_count` INT DEFAULT 0 COMMENT '评论数',
  `share_count` INT DEFAULT 0 COMMENT '分享数',
  `view_count` INT DEFAULT 0 COMMENT '浏览数',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_topic` (`topic_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status` (`status`),
  KEY `idx_user_privacy` (`user_id`, `privacy`),
  KEY `idx_topic_status` (`topic_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子表';

-- 话题表
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '话题ID',
  `name` VARCHAR(100) NOT NULL COMMENT '话题名称',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '话题描述',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
  `post_count` INT DEFAULT 0 COMMENT '帖子数',
  `follow_count` INT DEFAULT 0 COMMENT '关注数',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_status` (`status`),
  KEY `idx_status_follow` (`status`, `follow_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='话题表';

-- 评论表
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` BIGINT NOT NULL COMMENT '帖子ID',
  `user_id` BIGINT NOT NULL COMMENT '评论者ID',
  `parent_id` BIGINT DEFAULT NULL COMMENT '父评论ID',
  `content` VARCHAR(1000) NOT NULL COMMENT '评论内容',
  `like_count` INT DEFAULT 0 COMMENT '点赞数',
  `reply_count` INT DEFAULT 0 COMMENT '回复数',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_post` (`post_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_post_status` (`post_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ==================== 3. 作品模块表 ====================

-- 作品表
DROP TABLE IF EXISTS `work`;
CREATE TABLE `work` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '作品ID',
  `user_id` BIGINT NOT NULL COMMENT '作者ID',
  `title` VARCHAR(200) NOT NULL COMMENT '作品标题',
  `description` TEXT COMMENT '作品描述',
  `images` JSON NOT NULL COMMENT '作品图片列表',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
  `category_id` BIGINT NOT NULL COMMENT '分类ID',
  `tags` JSON DEFAULT NULL COMMENT '标签列表',
  `equipment` VARCHAR(200) DEFAULT NULL COMMENT '拍摄器材',
  `settings` VARCHAR(500) DEFAULT NULL COMMENT '拍摄参数',
  `location` VARCHAR(100) DEFAULT NULL COMMENT '拍摄地点',
  `shoot_time` DATETIME DEFAULT NULL COMMENT '拍摄时间',
  `view_count` INT DEFAULT 0 COMMENT '浏览数',
  `like_count` INT DEFAULT 0 COMMENT '点赞数',
  `comment_count` INT DEFAULT 0 COMMENT '评论数',
  `collect_count` INT DEFAULT 0 COMMENT '收藏数',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `is_public` TINYINT DEFAULT 1 COMMENT '是否公开: 0-私密, 1-公开',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status` (`status`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_category_status` (`category_id`, `status`),
  KEY `idx_view_count` (`view_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作品表';

-- 作品分类表
DROP TABLE IF EXISTS `work_category`;
CREATE TABLE `work_category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID',
  `level` TINYINT DEFAULT 1 COMMENT '层级',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '分类描述',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作品分类表';

-- 作品标签表
DROP TABLE IF EXISTS `work_tag`;
CREATE TABLE `work_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '标签描述',
  `work_count` INT DEFAULT 0 COMMENT '作品数',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作品标签表';

-- 作品标签关联表
DROP TABLE IF EXISTS `work_tag_relation`;
CREATE TABLE `work_tag_relation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `work_id` BIGINT NOT NULL COMMENT '作品ID',
  `tag_id` BIGINT NOT NULL COMMENT '标签ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_work_tag` (`work_id`, `tag_id`),
  KEY `idx_work` (`work_id`),
  KEY `idx_tag` (`tag_id`),
  KEY `idx_work_tag` (`work_id`, `tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作品标签关联表';

-- ==================== 4. 课程与订单模块表 ====================

-- 课程表
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` VARCHAR(200) NOT NULL COMMENT '课程标题',
  `description` TEXT COMMENT '课程描述',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
  `category_id` BIGINT NOT NULL COMMENT '分类ID',
  `teacher_id` BIGINT NOT NULL COMMENT '讲师ID',
  `price` DECIMAL(10,2) DEFAULT 0 COMMENT '价格',
  `original_price` DECIMAL(10,2) DEFAULT 0 COMMENT '原价',
  `is_free` TINYINT DEFAULT 0 COMMENT '是否免费: 0-收费, 1-免费',
  `difficulty` TINYINT DEFAULT 1 COMMENT '难度: 1-入门, 2-中级, 3-高级',
  `duration` INT DEFAULT 0 COMMENT '总时长(分钟)',
  `chapter_count` INT DEFAULT 0 COMMENT '章节数',
  `student_count` INT DEFAULT 0 COMMENT '学生数',
  `score` DECIMAL(3,1) DEFAULT 0 COMMENT '评分',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_status` (`status`),
  KEY `idx_category_status` (`category_id`, `status`),
  KEY `idx_teacher_status` (`teacher_id`, `status`),
  KEY `idx_score` (`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 课程章节表
DROP TABLE IF EXISTS `course_chapter`;
CREATE TABLE `course_chapter` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `course_id` BIGINT NOT NULL COMMENT '课程ID',
  `title` VARCHAR(200) NOT NULL COMMENT '章节标题',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '章节描述',
  `video_url` VARCHAR(500) DEFAULT NULL COMMENT '视频URL',
  `duration` INT DEFAULT 0 COMMENT '时长(分钟)',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `is_free` TINYINT DEFAULT 0 COMMENT '是否免费试看: 0-收费, 1-免费',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_sort` (`sort_order`),
  KEY `idx_course_sort` (`course_id`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程章节表';

-- 课程分类表
DROP TABLE IF EXISTS `course_category`;
CREATE TABLE `course_category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '分类描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程分类表';

-- 订单表
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` VARCHAR(50) NOT NULL COMMENT '订单编号',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `item_id` BIGINT NOT NULL COMMENT '商品ID(课程ID或商品ID)',
  `item_type` TINYINT NOT NULL COMMENT '商品类型: 1-课程, 2-商品',
  `item_name` VARCHAR(200) NOT NULL COMMENT '商品名称',
  `quantity` INT DEFAULT 1 COMMENT '数量',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '订单金额',
  `discount_amount` DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
  `pay_amount` DECIMAL(10,2) NOT NULL COMMENT '实付金额',
  `pay_method` TINYINT DEFAULT NULL COMMENT '支付方式: 1-微信, 2-支付宝, 3-余额',
  `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
  `status` TINYINT DEFAULT 0 COMMENT '状态: 0-待支付, 1-已支付, 2-已取消, 3-已退款',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_item` (`item_id`, `item_type`),
  KEY `idx_pay_time` (`pay_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 用户课程表(已购买课程)
DROP TABLE IF EXISTS `user_course`;
CREATE TABLE `user_course` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `course_id` BIGINT NOT NULL COMMENT '课程ID',
  `progress` INT DEFAULT 0 COMMENT '学习进度(百分比)',
  `last_chapter_id` BIGINT DEFAULT NULL COMMENT '最后学习章节',
  `start_time` DATETIME DEFAULT NULL COMMENT '开始学习时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '完成学习时间',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-未开始, 1-学习中, 2-已完成',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_course` (`user_id`, `course_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_user_progress` (`user_id`, `progress`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户课程表';

-- ==================== 5. 积分与商城模块表 ====================

-- 积分记录表
DROP TABLE IF EXISTS `points_record`;
CREATE TABLE `points_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `points` INT NOT NULL COMMENT '积分数量(正数增加,负数减少)',
  `type` TINYINT NOT NULL COMMENT '类型: 1-注册, 2-发帖, 3-评论, 4-点赞, 5-登录, 6-兑换, 7-签到, 8-管理员',
  `description` VARCHAR(200) NOT NULL COMMENT '描述',
  `balance` INT NOT NULL COMMENT '操作后余额',
  `ref_id` BIGINT DEFAULT NULL COMMENT '关联ID(如订单ID,帖子ID等)',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_user_type` (`user_id`, `type`),
  KEY `idx_ref` (`ref_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分记录表';

-- 商城商品表
DROP TABLE IF EXISTS `mall_goods`;
CREATE TABLE `mall_goods` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` VARCHAR(200) NOT NULL COMMENT '商品名称',
  `description` TEXT COMMENT '商品描述',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
  `images` JSON DEFAULT NULL COMMENT '商品图片列表',
  `category_id` BIGINT NOT NULL COMMENT '分类ID',
  `price` DECIMAL(10,2) NOT NULL COMMENT '价格(积分)',
  `original_price` DECIMAL(10,2) DEFAULT 0 COMMENT '原价',
  `stock` INT DEFAULT 0 COMMENT '库存',
  `sales` INT DEFAULT 0 COMMENT '销量',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商城商品表';

-- 商城商品分类表
DROP TABLE IF EXISTS `mall_category`;
CREATE TABLE `mall_category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '分类描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商城商品分类表';

-- 收货地址表
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `receiver` VARCHAR(50) NOT NULL COMMENT '收货人',
  `phone` VARCHAR(20) NOT NULL COMMENT '联系电话',
  `province` VARCHAR(50) NOT NULL COMMENT '省份',
  `city` VARCHAR(50) NOT NULL COMMENT '城市',
  `district` VARCHAR(50) NOT NULL COMMENT '区县',
  `detail` VARCHAR(200) NOT NULL COMMENT '详细地址',
  `is_default` TINYINT DEFAULT 0 COMMENT '是否默认: 0-否, 1-是',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_user_default` (`user_id`, `is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

-- 兑换记录表
DROP TABLE IF EXISTS `exchange_record`;
CREATE TABLE `exchange_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '兑换ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `goods_id` BIGINT NOT NULL COMMENT '商品ID',
  `goods_name` VARCHAR(200) NOT NULL COMMENT '商品名称',
  `points` INT NOT NULL COMMENT '消耗积分',
  `quantity` INT DEFAULT 1 COMMENT '数量',
  `address_id` BIGINT DEFAULT NULL COMMENT '收货地址ID',
  `tracking_no` VARCHAR(100) DEFAULT NULL COMMENT '物流单号',
  `status` TINYINT DEFAULT 0 COMMENT '状态: 0-待发货, 1-已发货, 2-已完成, 3-已取消',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_goods` (`goods_id`),
  KEY `idx_status` (`status`),
  KEY `idx_status_time` (`status`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='兑换记录表';

-- ==================== 6. 社区互动模块表 ====================

-- 点赞表
DROP TABLE IF EXISTS `like_record`;
CREATE TABLE `like_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `target_id` BIGINT NOT NULL COMMENT '目标ID(帖子/评论/作品)',
  `target_type` TINYINT NOT NULL COMMENT '目标类型: 1-帖子, 2-评论, 3-作品',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`, `target_id`, `target_type`),
  KEY `idx_target` (`target_id`, `target_type`),
  KEY `idx_user` (`user_id`),
  KEY `idx_target_type` (`target_id`, `target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞记录表';

-- 收藏表
DROP TABLE IF EXISTS `collect_record`;
CREATE TABLE `collect_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `target_id` BIGINT NOT NULL COMMENT '目标ID(帖子/作品)',
  `target_type` TINYINT NOT NULL COMMENT '目标类型: 1-帖子, 2-作品',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`, `target_id`, `target_type`),
  KEY `idx_target` (`target_id`, `target_type`),
  KEY `idx_user` (`user_id`),
  KEY `idx_target_type` (`target_id`, `target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏记录表';

-- 私信表
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `sender_id` BIGINT NOT NULL COMMENT '发送者ID',
  `receiver_id` BIGINT NOT NULL COMMENT '接收者ID',
  `content` VARCHAR(1000) NOT NULL COMMENT '消息内容',
  `images` JSON DEFAULT NULL COMMENT '图片列表',
  `is_read` TINYINT DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `deleted_by_sender` TINYINT DEFAULT 0 COMMENT '发送者删除',
  `deleted_by_receiver` TINYINT DEFAULT 0 COMMENT '接收者删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`),
  KEY `idx_sender_receiver` (`sender_id`, `receiver_id`),
  KEY `idx_receiver` (`receiver_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_receiver_read` (`receiver_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='私信表';

-- 通知表
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `type` TINYINT NOT NULL COMMENT '类型: 1-点赞, 2-评论, 3-关注, 4-系统',
  `title` VARCHAR(100) NOT NULL COMMENT '标题',
  `content` VARCHAR(500) DEFAULT NULL COMMENT '内容',
  `target_id` BIGINT DEFAULT NULL COMMENT '目标ID',
  `target_type` TINYINT DEFAULT NULL COMMENT '目标类型',
  `is_read` TINYINT DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_user_read` (`user_id`, `is_read`),
  KEY `idx_user_read_time` (`user_id`, `is_read`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';

-- ==================== 7. 管理员后台模块表 ====================

-- 系统日志表
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `username` VARCHAR(50) DEFAULT NULL COMMENT '用户名',
  `operation` VARCHAR(100) NOT NULL COMMENT '操作描述',
  `module` VARCHAR(50) NOT NULL COMMENT '操作模块',
  `ip` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` VARCHAR(500) DEFAULT NULL COMMENT '用户代理',
  `request_method` VARCHAR(10) DEFAULT NULL COMMENT '请求方法',
  `request_url` VARCHAR(500) DEFAULT NULL COMMENT '请求URL',
  `request_params` TEXT COMMENT '请求参数',
  `response_code` INT DEFAULT NULL COMMENT '响应码',
  `response_msg` VARCHAR(500) DEFAULT NULL COMMENT '响应信息',
  `duration` INT DEFAULT NULL COMMENT '执行时长(ms)',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-失败, 1-成功',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_module` (`module`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_user_time` (`user_id`, `create_time`),
  KEY `idx_module_time` (`module`, `create_time`),
  KEY `idx_status_time` (`status`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';

-- 数据统计表
DROP TABLE IF EXISTS `data_statistics`;
CREATE TABLE `data_statistics` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `stat_date` DATE NOT NULL COMMENT '统计日期',
  `type` TINYINT NOT NULL COMMENT '统计类型: 1-用户, 2-内容, 3-订单, 4-积分',
  `key` VARCHAR(50) NOT NULL COMMENT '统计项',
  `value` BIGINT NOT NULL COMMENT '统计值',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_type_key` (`stat_date`, `type`, `key`),
  KEY `idx_date` (`stat_date`),
  KEY `idx_type` (`type`),
  KEY `idx_date_type` (`stat_date`, `type`),
  KEY `idx_value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据统计表';

-- 系统配置表
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `value` TEXT NOT NULL COMMENT '配置值',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '配置描述',
  `type` TINYINT DEFAULT 1 COMMENT '类型: 1-系统, 2-业务',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_key` (`key`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- ==================== 8. 文件服务模块表 ====================

-- 文件表
DROP TABLE IF EXISTS `file_record`;
CREATE TABLE `file_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `original_name` VARCHAR(255) NOT NULL COMMENT '原始文件名',
  `file_name` VARCHAR(255) NOT NULL COMMENT '存储文件名',
  `file_path` VARCHAR(500) NOT NULL COMMENT '文件路径',
  `file_size` BIGINT NOT NULL COMMENT '文件大小(字节)',
  `file_type` VARCHAR(50) DEFAULT NULL COMMENT '文件类型',
  `mime_type` VARCHAR(100) DEFAULT NULL COMMENT 'MIME类型',
  `hash` VARCHAR(64) DEFAULT NULL COMMENT '文件MD5',
  `uploader_id` BIGINT DEFAULT NULL COMMENT '上传者ID',
  `uploader_type` TINYINT DEFAULT 1 COMMENT '上传者类型: 1-用户, 2-管理员',
  `business_type` VARCHAR(50) DEFAULT NULL COMMENT '业务类型',
  `business_id` BIGINT DEFAULT NULL COMMENT '业务ID',
  `is_public` TINYINT DEFAULT 1 COMMENT '是否公开: 0-私有, 1-公开',
  `status` TINYINT DEFAULT 1 COMMENT '状态: 0-删除, 1-正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_hash` (`hash`),
  KEY `idx_uploader` (`uploader_id`),
  KEY `idx_business` (`business_type`, `business_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_uploader_time` (`uploader_id`, `create_time`),
  KEY `idx_status_time` (`status`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件记录表';

-- ==================== 9. 其他辅助表 ====================

-- 签到表
DROP TABLE IF EXISTS `sign_in`;
CREATE TABLE `sign_in` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '签到ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `sign_date` DATE NOT NULL COMMENT '签到日期',
  `points` INT NOT NULL COMMENT '获得积分',
  `continuous_days` INT DEFAULT 1 COMMENT '连续签到天数',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date` (`user_id`, `sign_date`),
  KEY `idx_user` (`user_id`),
  KEY `idx_date` (`sign_date`),
  KEY `idx_user_date` (`user_id`, `sign_date`),
  KEY `idx_continuous` (`continuous_days`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='签到表';

-- 反馈表
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '反馈ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `type` TINYINT NOT NULL COMMENT '反馈类型: 1-建议, 2-bug, 3-投诉',
  `content` TEXT NOT NULL COMMENT '反馈内容',
  `images` JSON DEFAULT NULL COMMENT '截图',
  `contact` VARCHAR(100) DEFAULT NULL COMMENT '联系方式',
  `status` TINYINT DEFAULT 0 COMMENT '状态: 0-待处理, 1-已处理, 2-已忽略',
  `reply` VARCHAR(500) DEFAULT NULL COMMENT '回复内容',
  `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_type_status` (`type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户反馈表';

-- ==================== 10. 初始化数据 ====================

-- 初始化管理员用户
INSERT INTO `sys_user` (`username`, `password`, `nickname`, `role`, `status`, `points`) 
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '系统管理员', 'admin', 1, 99999);

-- 初始化用户标签
INSERT INTO `user_tag` (`name`, `description`, `sort_order`) VALUES 
('摄影大师', '专业摄影师', 1),
('摄影爱好者', '摄影爱好者', 2),
('新手入门', '摄影初学者', 3);

-- 初始化作品分类
INSERT INTO `work_category` (`name`, `parent_id`, `level`, `description`, `sort_order`) VALUES 
('人像摄影', 0, 1, '人像摄影作品', 1),
('风光摄影', 0, 1, '自然风光作品', 2),
('街拍摄影', 0, 1, '街头摄影作品', 3),
('纪实摄影', 0, 1, '纪实摄影作品', 4),
('创意摄影', 0, 1, '创意摄影作品', 5);

-- 初始化课程分类
INSERT INTO `course_category` (`name`, `parent_id`, `description`, `sort_order`) VALUES 
('摄影基础', 0, '摄影基础知识', 1),
('后期处理', 0, '照片后期处理', 2),
('器材使用', 0, '摄影器材使用技巧', 3),
('专题课程', 0, '专题摄影课程', 4);

-- 初始化商城分类
INSERT INTO `mall_category` (`name`, `parent_id`, `description`, `sort_order`) VALUES 
('摄影器材', 0, '相机、镜头等器材', 1),
('配件', 0, '三脚架、滤镜等配件', 2),
('书籍', 0, '摄影相关书籍', 3),
('周边', 0, '摄影周边产品', 4);

-- 初始化系统配置
INSERT INTO `sys_config` (`key`, `value`, `description`, `type`) VALUES 
('site_name', '摄友圈', '网站名称', 1),
('site_description', '专业摄影爱好者社区', '网站描述', 1),
('points_register', '10', '注册获得积分', 2),
('points_post', '5', '发帖获得积分', 2),
('points_comment', '2', '评论获得积分', 2),
('points_like', '1', '点赞获得积分', 2),
('points_daily_login', '5', '每日登录积分', 2);

-- 初始化话题
INSERT INTO `topic` (`name`, `description`, `post_count`) VALUES 
('每日一图', '分享你每天拍摄的精彩照片', 0),
('摄影技巧', '交流摄影技巧和经验', 0),
('器材讨论', '讨论摄影器材使用心得', 0),
('作品点评', '互相点评摄影作品', 0),
('后期分享', '分享后期处理技巧', 0);

-- 初始化商品
INSERT INTO `mall_goods` (`name`, `description`, `category_id`, `price`, `original_price`, `stock`, `sales`) VALUES 
('摄影入门电子书', '摄影入门必备指南', 3, 500, 800, 999, 0),
('专业三脚架', '铝合金专业三脚架', 2, 2000, 2500, 50, 0),
('相机清洁套装', '专业相机清洁工具', 2, 300, 500, 200, 0),
('摄影技巧手册', '进阶摄影技巧大全', 3, 800, 1200, 500, 0);

-- 初始化课程
INSERT INTO `course` (`title`, `description`, `category_id`, `teacher_id`, `price`, `original_price`, `is_free`, `difficulty`, `duration`, `chapter_count`) VALUES 
('摄影入门完全指南', '从零开始学习摄影，掌握基础理论和实践技巧', 1, 1, 0, 299, 1, 1, 120, 8),
('Lightroom后期精讲', '专业级照片后期处理教程', 2, 1, 199, 399, 0, 2, 180, 12),
('人像摄影实战技巧', '专业人像摄影拍摄技巧', 4, 1, 299, 599, 0, 2, 150, 10);

-- 初始化课程章节
INSERT INTO `course_chapter` (`course_id`, `title`, `duration`, `sort_order`, `is_free`) VALUES 
(1, '相机基础知识', 15, 1, 1),
(1, '光圈快门ISO', 20, 2, 1),
(1, '构图技巧', 15, 3, 0),
(1, '光线运用', 18, 4, 0),
(2, 'Lightroom界面介绍', 12, 1, 1),
(2, '基础调色技巧', 20, 2, 0),
(2, '人像精修方法', 25, 3, 0);

-- 完成数据库设计
