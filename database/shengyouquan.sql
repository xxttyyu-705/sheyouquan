/*
 Navicat Premium Data Transfer

 Source Server         : bishe
 Source Server Type    : MySQL
 Source Server Version : 50721
 Source Host           : localhost:3306
 Source Schema         : shengyouquan

 Target Server Type    : MySQL
 Target Server Version : 50721
 File Encoding         : 65001

 Date: 13/02/2026 17:33:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码(加密)',
  `nickname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `gender` tinyint(4) NULL DEFAULT 0 COMMENT '性别: 0-未知, 1-男, 2-女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `signature` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '个性签名',
  `location` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所在地',
  `role` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'user' COMMENT '角色: user-普通用户, admin-管理员',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `points` int(11) NULL DEFAULT 0 COMMENT '积分余额',
  `login_count` int(11) NULL DEFAULT 0 COMMENT '登录次数',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `register_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '注册时间',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除: 0-未删除, 1-已删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username`) USING BTREE,
  UNIQUE INDEX `uk_email`(`email`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE,
  INDEX `idx_status_role`(`status`, `role`) USING BTREE,
  INDEX `idx_points`(`points`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (2, 'yuyuyu', '$2a$10$xEajtcGuusoepqmNnYlTJeQol/NmiRWxh066hziK7tMQSE0xcRc5u', 'yuyuyu', 'https://picsum.photos/seed/yu-avatar/200/200', '2905618300@qq.com', '15015976289', 2, NULL, NULL, NULL, 'user', 1, 10, 22, '2026-02-13 17:18:22', '2026-01-25 20:47:33', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (3, 'yuxintong', '$2a$10$uVXq6lMAuS5VyGvLOUA0/en.1UuJ.QpnH3COmdx1LtTQU.hBS7xbW', 'yuxintong', 'https://picsum.photos/seed/yuxintong-avatar/200/200', '222@163.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-04 16:30:45', '2026-02-04 16:30:36', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (4, '123456', '$2a$10$8Yrvy5At1oaLxoZxTJql1ert.g4.qabhbzI.mwU8Ed1XPMuus5Cua', '123456', NULL, '11@qq.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-06 17:05:44', '2026-02-06 17:05:36', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (41, 'admin', '$2a$10$xEajtcGuusoepqmNnYlTJeQol/NmiRWxh066hziK7tMQSE0xcRc5u', '系统管理员', 'https://picsum.photos/seed/admin-avatar/200/200', 'admin@shengyouquan.com', '13800138000', 1, NULL, '摄影让生活更美好', '北京', 'admin', 1, 99999, 1, '2026-02-12 20:10:36', '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (42, 'photographer_wang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影师小王', 'https://picsum.photos/seed/wang-avatar/200/200', 'wang@shengyouquan.com', '13900139000', 1, NULL, '专注于人像摄影', '上海', 'user', 1, 1500, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (43, 'photographer_li', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影达人', 'https://picsum.photos/seed/li-avatar/200/200', 'li@shengyouquan.com', '13700137000', 2, NULL, '风光摄影师', '杭州', 'user', 1, 1200, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (44, 'photographer_zhang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '风光摄影师', 'https://picsum.photos/seed/zhang-avatar/200/200', 'zhang@shengyouquan.com', '13600136000', 1, NULL, '记录美好瞬间', '广州', 'user', 1, 800, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (45, 'testuser3', '$2a$10$gKq6wVxVViB9UJjKjhg.DuOecDuel3RoZnkq9wMjTZDWNeDmehNBi', 'testuser3', NULL, 'test3@example.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-07 19:47:36', '2026-02-07 19:47:25', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (46, 'testuser123', '$2a$10$EqDFhGAjEF9Soq4o9bxuLOS2Yq7cZ0rJBUjXH0XB3BI2zCLEpbe9e', 'testuser123', NULL, 'test123@example.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-08 00:22:41', '2026-02-08 00:22:27', 0, NULL, NULL);

-- ----------------------------
-- Table structure for collect_record
-- ----------------------------
DROP TABLE IF EXISTS `collect_record`;
CREATE TABLE `collect_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `target_id` bigint(20) NOT NULL COMMENT '目标ID(帖子/作品)',
  `target_type` tinyint(4) NOT NULL COMMENT '目标类型: 1-帖子, 2-作品',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id`, `target_id`, `target_type`) USING BTREE,
  INDEX `idx_target`(`target_id`, `target_type`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_target_type`(`target_id`, `target_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收藏记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collect_record
-- ----------------------------
INSERT INTO `collect_record` VALUES (1, 2, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `collect_record` VALUES (2, 3, 2, 1, '2026-02-07 13:32:45');
INSERT INTO `collect_record` VALUES (3, 2, 1, 2, '2026-02-07 13:32:45');
INSERT INTO `collect_record` VALUES (4, 3, 2, 2, '2026-02-07 13:32:45');
INSERT INTO `collect_record` VALUES (5, 4, 3, 2, '2026-02-07 13:32:45');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '评论者ID',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父评论ID',
  `content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '评论内容',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `reply_count` int(11) NULL DEFAULT 0 COMMENT '回复数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post`(`post_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_post_status`(`post_id`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 1, 3, NULL, '感谢分享！我刚买了50mm镜头，确实很好用', 5, 1, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (2, 1, 4, NULL, '推荐得很详细，新手必备', 3, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (3, 2, 2, NULL, '长曝光确实能拍出很美的光轨', 8, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (4, 2, 4, NULL, '我一般用ISO 100，光圈f/8-f/11', 6, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (5, 3, 2, NULL, '三分法构图很实用，学习了！', 4, 1, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (6, 3, 2, 5, '眼睛对焦是关键，一定要清晰', 7, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (7, 4, 4, NULL, '曲线工具确实强大，需要多练习', 5, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (8, 5, 2, NULL, '黄金时刻光线确实最美', 6, 0, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `comment` VALUES (9, 1, 3, NULL, '感谢分享！我刚买了50mm镜头，确实很好用', 5, 1, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (10, 1, 4, NULL, '推荐得很详细，新手必备', 3, 0, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (11, 2, 2, NULL, '长曝光确实能拍出很美的光轨', 8, 0, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (12, 2, 4, NULL, '我一般用ISO 100，光圈f/8-f/11', 6, 0, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (13, 3, 2, NULL, '三分法构图很实用，学习了！', 4, 1, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (14, 3, 2, 5, '眼睛对焦是关键，一定要清晰', 7, 0, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (15, 4, 4, NULL, '曲线工具确实强大，需要多练习', 5, 0, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `comment` VALUES (16, 5, 2, NULL, '黄金时刻光线确实最美', 6, 0, 1, 0, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '课程标题',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '课程描述',
  `cover_image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `teacher_id` bigint(20) NOT NULL COMMENT '讲师ID',
  `price` decimal(10, 2) NULL COMMENT '价格',
  `original_price` decimal(10, 2) NULL COMMENT '原价',
  `is_free` tinyint(4) NULL DEFAULT 0 COMMENT '是否免费: 0-收费, 1-免费',
  `difficulty` tinyint(4) NULL DEFAULT 1 COMMENT '难度: 1-入门, 2-中级, 3-高级',
  `duration` int(11) NULL DEFAULT 0 COMMENT '总时长(分钟)',
  `chapter_count` int(11) NULL DEFAULT 0 COMMENT '章节数',
  `student_count` int(11) NULL DEFAULT 0 COMMENT '学生数',
  `score` decimal(3, 1) NULL COMMENT '评分',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id`) USING BTREE,
  INDEX `idx_teacher`(`teacher_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_category_status`(`category_id`, `status`) USING BTREE,
  INDEX `idx_teacher_status`(`teacher_id`, `status`) USING BTREE,
  INDEX `idx_score`(`score`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '摄影入门完全指南', '从零开始学习摄影，掌握基础理论和实践技巧', 'https://picsum.photos/seed/course1/400/300', 1, 42, 0.00, 299.00, 1, 1, 120, 8, 15, 0.0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `course` VALUES (2, 'Lightroom后期精讲', '专业级照片后期处理教程', 'https://picsum.photos/seed/course2/400/300', 2, 42, 199.00, 399.00, 0, 2, 180, 12, 0, 0.0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `course` VALUES (3, '人像摄影实战技巧', '专业人像摄影拍摄技巧', 'https://picsum.photos/seed/course2/400/300', 4, 42, 299.00, 599.00, 0, 2, 150, 10, 0, 0.0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `course` VALUES (4, '摄影入门完全指南', '从零开始学习摄影，掌握基础理论和实践技巧', 'https://picsum.photos/seed/course1/400/300', 1, 42, 0.00, 299.00, 1, 1, 120, 8, 156, 4.8, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `course` VALUES (5, 'Lightroom后期精讲', '专业级照片后期处理教程', 'https://picsum.photos/seed/course2/400/300', 2, 42, 199.00, 399.00, 0, 2, 180, 12, 89, 4.9, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `course` VALUES (6, '人像摄影实战技巧', '专业人像摄影拍摄技巧', 'https://picsum.photos/seed/course3/400/300', 4, 42, 299.00, 599.00, 0, 2, 150, 10, 67, 4.7, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `course` VALUES (7, '风光摄影大师课', '自然风光拍摄技巧大全', 'https://picsum.photos/seed/course4/400/300', 4, 42, 249.00, 499.00, 0, 2, 200, 15, 45, 4.8, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `course` VALUES (8, '手机摄影技巧', '用手机也能拍出专业级照片', 'https://picsum.photos/seed/course5/400/300', 1, 42, 99.00, 199.00, 0, 1, 90, 6, 234, 4.6, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `course` VALUES (9, '摄影入门完全指南', '从零开始学习摄影，掌握基础理论和实践技巧', 'https://picsum.photos/seed/course1/400/300', 1, 42, 0.00, 299.00, 1, 1, 120, 8, 156, 4.8, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `course` VALUES (10, 'Lightroom后期精讲', '专业级照片后期处理教程', 'https://picsum.photos/seed/course2/400/300', 2, 42, 199.00, 399.00, 0, 2, 180, 12, 89, 4.9, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `course` VALUES (11, '人像摄影实战技巧', '专业人像摄影拍摄技巧', 'https://picsum.photos/seed/course3/400/300', 4, 42, 299.00, 599.00, 0, 2, 150, 10, 67, 4.7, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `course` VALUES (12, '风光摄影大师课', '自然风光拍摄技巧大全', 'https://picsum.photos/seed/course4/400/300', 4, 42, 249.00, 499.00, 0, 2, 200, 15, 45, 4.8, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `course` VALUES (13, '手机摄影技巧', '用手机也能拍出专业级照片', 'https://picsum.photos/seed/course5/400/300', 1, 42, 99.00, 199.00, 0, 1, 90, 6, 234, 4.6, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for course_category
-- ----------------------------
DROP TABLE IF EXISTS `course_category`;
CREATE TABLE `course_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类描述',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '课程分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_category
-- ----------------------------
INSERT INTO `course_category` VALUES (1, '摄影基础', 0, '摄影基础知识', 1, 1, '2025-12-31 10:12:42');
INSERT INTO `course_category` VALUES (2, '后期处理', 0, '照片后期处理', 2, 1, '2025-12-31 10:12:42');
INSERT INTO `course_category` VALUES (3, '器材使用', 0, '摄影器材使用技巧', 3, 1, '2025-12-31 10:12:42');
INSERT INTO `course_category` VALUES (4, '专题课程', 0, '专题摄影课程', 4, 1, '2025-12-31 10:12:42');
INSERT INTO `course_category` VALUES (5, '摄影基础', 0, '摄影基础知识', 1, 1, '2026-02-07 13:32:45');
INSERT INTO `course_category` VALUES (6, '后期处理', 0, '照片后期处理', 2, 1, '2026-02-07 13:32:45');
INSERT INTO `course_category` VALUES (7, '器材使用', 0, '摄影器材使用技巧', 3, 1, '2026-02-07 13:32:45');
INSERT INTO `course_category` VALUES (8, '专题课程', 0, '专题摄影课程', 4, 1, '2026-02-07 13:32:45');
INSERT INTO `course_category` VALUES (9, '摄影基础', 0, '摄影基础知识', 1, 1, '2026-02-07 13:32:47');
INSERT INTO `course_category` VALUES (10, '后期处理', 0, '照片后期处理', 2, 1, '2026-02-07 13:32:47');
INSERT INTO `course_category` VALUES (11, '器材使用', 0, '摄影器材使用技巧', 3, 1, '2026-02-07 13:32:47');
INSERT INTO `course_category` VALUES (12, '专题课程', 0, '专题摄影课程', 4, 1, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for course_chapter
-- ----------------------------
DROP TABLE IF EXISTS `course_chapter`;
CREATE TABLE `course_chapter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '章节标题',
  `description` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '章节描述',
  `video_url` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '视频URL',
  `duration` int(11) NULL DEFAULT 0 COMMENT '时长(分钟)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `is_free` tinyint(4) NULL DEFAULT 0 COMMENT '是否免费试看: 0-收费, 1-免费',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course`(`course_id`) USING BTREE,
  INDEX `idx_sort`(`sort_order`) USING BTREE,
  INDEX `idx_course_sort`(`course_id`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '课程章节表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_chapter
-- ----------------------------
INSERT INTO `course_chapter` VALUES (1, 1, '相机基础知识', NULL, NULL, 15, 1, 1, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (2, 1, '光圈快门ISO', NULL, NULL, 20, 2, 1, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (3, 1, '构图技巧', NULL, NULL, 15, 3, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (4, 1, '光线运用', NULL, NULL, 18, 4, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (5, 2, 'Lightroom界面介绍', NULL, NULL, 12, 1, 1, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (6, 2, '基础调色技巧', NULL, NULL, 20, 2, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (7, 2, '人像精修方法', NULL, NULL, 25, 3, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `course_chapter` VALUES (8, 1, '相机基础知识', '了解相机的基本构造和原理', 'https://example.com/video1.mp4', 15, 1, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (9, 1, '光圈快门ISO', '掌握曝光三要素', 'https://example.com/video2.mp4', 20, 2, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (10, 1, '构图技巧', '学习基本的构图法则', 'https://example.com/video3.mp4', 15, 3, 0, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (11, 1, '光线运用', '如何利用自然光和人造光', 'https://example.com/video4.mp4', 18, 4, 0, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (12, 2, 'Lightroom界面介绍', '熟悉Lightroom的工作界面', 'https://example.com/video5.mp4', 12, 1, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (13, 2, '基础调色技巧', '掌握基本的调色方法', 'https://example.com/video6.mp4', 20, 2, 0, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (14, 2, '人像精修方法', '专业人像照片精修技巧', 'https://example.com/video7.mp4', 25, 3, 0, 1, '2026-02-07 13:32:45');
INSERT INTO `course_chapter` VALUES (15, 1, '相机基础知识', '了解相机的基本构造和原理', 'https://example.com/video1.mp4', 15, 1, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (16, 1, '光圈快门ISO', '掌握曝光三要素', 'https://example.com/video2.mp4', 20, 2, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (17, 1, '构图技巧', '学习基本的构图法则', 'https://example.com/video3.mp4', 15, 3, 0, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (18, 1, '光线运用', '如何利用自然光和人造光', 'https://example.com/video4.mp4', 18, 4, 0, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (19, 2, 'Lightroom界面介绍', '熟悉Lightroom的工作界面', 'https://example.com/video5.mp4', 12, 1, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (20, 2, '基础调色技巧', '掌握基本的调色方法', 'https://example.com/video6.mp4', 20, 2, 0, 1, '2026-02-07 13:32:47');
INSERT INTO `course_chapter` VALUES (21, 2, '人像精修方法', '专业人像照片精修技巧', 'https://example.com/video7.mp4', 25, 3, 0, 1, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for data_statistics
-- ----------------------------
DROP TABLE IF EXISTS `data_statistics`;
CREATE TABLE `data_statistics`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `type` tinyint(4) NOT NULL COMMENT '统计类型: 1-用户, 2-内容, 3-订单, 4-积分',
  `key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '统计项',
  `value` bigint(20) NOT NULL COMMENT '统计值',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_date_type_key`(`stat_date`, `type`, `key`) USING BTREE,
  INDEX `idx_date`(`stat_date`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_date_type`(`stat_date`, `type`) USING BTREE,
  INDEX `idx_value`(`value`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '数据统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for exchange_record
-- ----------------------------
DROP TABLE IF EXISTS `exchange_record`;
CREATE TABLE `exchange_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '兑换ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `goods_id` bigint(20) NOT NULL COMMENT '商品ID',
  `goods_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `points` int(11) NOT NULL COMMENT '消耗积分',
  `quantity` int(11) NULL DEFAULT 1 COMMENT '数量',
  `address_id` bigint(20) NULL DEFAULT NULL COMMENT '收货地址ID',
  `tracking_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-待发货, 1-已发货, 2-已完成, 3-已取消',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_status_time`(`status`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '兑换记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exchange_record
-- ----------------------------
INSERT INTO `exchange_record` VALUES (1, 2, 1, '专业相机包', 500, 1, NULL, NULL, 2, '请尽快发货', 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `exchange_record` VALUES (2, 3, 4, 'Lightroom软件', 1200, 1, NULL, NULL, 1, '', 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `exchange_record` VALUES (3, 4, 7, '摄影徽章', 150, 2, NULL, NULL, 0, '希望有赠品', 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `exchange_record` VALUES (4, 2, 1, '专业相机包', 500, 1, NULL, NULL, 2, '请尽快发货', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `exchange_record` VALUES (5, 3, 4, 'Lightroom软件', 1200, 1, NULL, NULL, 1, '', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `exchange_record` VALUES (6, 4, 7, '摄影徽章', 150, 2, NULL, NULL, 0, '希望有赠品', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '反馈ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `type` tinyint(4) NOT NULL COMMENT '反馈类型: 1-建议, 2-bug, 3-投诉',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '反馈内容',
  `images` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '截图(存储JSON字符串)',
  `contact` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-待处理, 1-已处理, 2-已忽略',
  `reply` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回复内容',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_type_status`(`type`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户反馈表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for file_record
-- ----------------------------
DROP TABLE IF EXISTS `file_record`;
CREATE TABLE `file_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `original_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '原始文件名',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '存储文件名',
  `file_path` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint(20) NOT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  `mime_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'MIME类型',
  `hash` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件MD5',
  `uploader_id` bigint(20) NULL DEFAULT NULL COMMENT '上传者ID',
  `uploader_type` tinyint(4) NULL DEFAULT 1 COMMENT '上传者类型: 1-用户, 2-管理员',
  `business_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务类型',
  `business_id` bigint(20) NULL DEFAULT NULL COMMENT '业务ID',
  `is_public` tinyint(4) NULL DEFAULT 1 COMMENT '是否公开: 0-私有, 1-公开',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-删除, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hash`(`hash`) USING BTREE,
  INDEX `idx_uploader`(`uploader_id`) USING BTREE,
  INDEX `idx_business`(`business_type`, `business_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_uploader_time`(`uploader_id`, `create_time`) USING BTREE,
  INDEX `idx_status_time`(`status`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of file_record
-- ----------------------------
INSERT INTO `file_record` VALUES (1, 'avatar1.jpg', 'avatar1_20240101.jpg', '/uploads/shengyouquan/avatar/avatar1_20240101.jpg', 102400, 'image/jpeg', 'image/jpeg', 'abc123', 2, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `file_record` VALUES (2, 'avatar2.jpg', 'avatar2_20240101.jpg', '/uploads/shengyouquan/avatar/avatar2_20240101.jpg', 153600, 'image/jpeg', 'image/jpeg', 'def456', 3, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `file_record` VALUES (3, 'avatar3.jpg', 'avatar3_20240101.jpg', '/uploads/shengyouquan/avatar/avatar3_20240101.jpg', 122880, 'image/jpeg', 'image/jpeg', 'ghi789', 4, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `file_record` VALUES (4, 'avatar1.jpg', 'avatar1_20240101.jpg', '/uploads/shengyouquan/avatar/avatar1_20240101.jpg', 102400, 'image/jpeg', 'image/jpeg', 'abc123', 2, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `file_record` VALUES (5, 'avatar2.jpg', 'avatar2_20240101.jpg', '/uploads/shengyouquan/avatar/avatar2_20240101.jpg', 153600, 'image/jpeg', 'image/jpeg', 'def456', 3, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `file_record` VALUES (6, 'avatar3.jpg', 'avatar3_20240101.jpg', '/uploads/shengyouquan/avatar/avatar3_20240101.jpg', 122880, 'image/jpeg', 'image/jpeg', 'ghi789', 4, 1, 'avatar', NULL, 1, 1, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for like_record
-- ----------------------------
DROP TABLE IF EXISTS `like_record`;
CREATE TABLE `like_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `target_id` bigint(20) NOT NULL COMMENT '目标ID(帖子/评论/作品)',
  `target_type` tinyint(4) NOT NULL COMMENT '目标类型: 1-帖子, 2-评论, 3-作品',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id`, `target_id`, `target_type`) USING BTREE,
  INDEX `idx_target`(`target_id`, `target_type`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_target_type`(`target_id`, `target_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '点赞记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of like_record
-- ----------------------------
INSERT INTO `like_record` VALUES (1, 2, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (2, 3, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (3, 4, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (4, 2, 2, 1, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (5, 3, 2, 1, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (6, 2, 1, 3, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (7, 3, 2, 3, '2026-02-07 13:32:45');
INSERT INTO `like_record` VALUES (8, 4, 3, 3, '2026-02-07 13:32:45');

-- ----------------------------
-- Table structure for mall_category
-- ----------------------------
DROP TABLE IF EXISTS `mall_category`;
CREATE TABLE `mall_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类描述',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商城商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mall_category
-- ----------------------------
INSERT INTO `mall_category` VALUES (1, '摄影器材', 0, '相机、镜头等器材', 1, 1, '2025-12-31 10:12:42');
INSERT INTO `mall_category` VALUES (2, '配件', 0, '三脚架、滤镜等配件', 2, 1, '2025-12-31 10:12:42');
INSERT INTO `mall_category` VALUES (3, '书籍', 0, '摄影相关书籍', 3, 1, '2025-12-31 10:12:42');
INSERT INTO `mall_category` VALUES (4, '周边', 0, '摄影周边产品', 4, 1, '2025-12-31 10:12:42');
INSERT INTO `mall_category` VALUES (5, '摄影器材', 0, '相机、镜头等器材', 1, 1, '2026-02-07 13:32:45');
INSERT INTO `mall_category` VALUES (6, '配件', 0, '三脚架、滤镜等配件', 2, 1, '2026-02-07 13:32:45');
INSERT INTO `mall_category` VALUES (7, '书籍', 0, '摄影相关书籍', 3, 1, '2026-02-07 13:32:45');
INSERT INTO `mall_category` VALUES (8, '周边', 0, '摄影周边产品', 4, 1, '2026-02-07 13:32:45');
INSERT INTO `mall_category` VALUES (9, '摄影器材', 0, '相机、镜头等器材', 1, 1, '2026-02-07 13:32:47');
INSERT INTO `mall_category` VALUES (10, '配件', 0, '三脚架、滤镜等配件', 2, 1, '2026-02-07 13:32:47');
INSERT INTO `mall_category` VALUES (11, '书籍', 0, '摄影相关书籍', 3, 1, '2026-02-07 13:32:47');
INSERT INTO `mall_category` VALUES (12, '周边', 0, '摄影周边产品', 4, 1, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for mall_goods
-- ----------------------------
DROP TABLE IF EXISTS `mall_goods`;
CREATE TABLE `mall_goods`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '商品描述',
  `cover_image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `images` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '商品图片列表(存储JSON字符串)',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `price` decimal(10, 2) NOT NULL COMMENT '价格(积分)',
  `original_price` decimal(10, 2) NULL COMMENT '原价',
  `stock` int(11) NULL DEFAULT 0 COMMENT '库存',
  `sales` int(11) NULL DEFAULT 0 COMMENT '销量',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商城商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mall_goods
-- ----------------------------
INSERT INTO `mall_goods` VALUES (1, '摄影入门电子书', '摄影入门必备指南', NULL, NULL, 3, 500.00, 800.00, 999, 0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `mall_goods` VALUES (2, '专业三脚架', '铝合金专业三脚架', NULL, NULL, 2, 2000.00, 2500.00, 50, 0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `mall_goods` VALUES (3, '相机清洁套装', '专业相机清洁工具', NULL, NULL, 2, 300.00, 500.00, 200, 0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `mall_goods` VALUES (4, '摄影技巧手册', '进阶摄影技巧大全', NULL, NULL, 3, 800.00, 1200.00, 500, 0, 1, 0, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `mall_goods` VALUES (5, '专业相机包', '防水防震，适合单反相机和镜头', 'https://picsum.photos/seed/goods1/400/300', '[\"https://picsum.photos/seed/goods1-1/800/600\"]', 1, 500.00, 800.00, 50, 12, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (6, '三脚架', '铝合金材质，承重10kg，便携折叠', 'https://picsum.photos/seed/goods2/400/300', '[\"https://picsum.photos/seed/goods2-1/800/600\"]', 2, 800.00, 1200.00, 30, 8, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (7, '摄影灯', 'LED补光灯，可调色温', 'https://picsum.photos/seed/goods3/400/300', '[\"https://picsum.photos/seed/goods3-1/800/600\"]', 2, 600.00, 900.00, 40, 15, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (8, 'Lightroom软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods4/400/300', '[\"https://picsum.photos/seed/goods4-1/800/600\"]', 3, 1200.00, 1800.00, 100, 23, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (9, 'Photoshop软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods5/400/300', '[\"https://picsum.photos/seed/goods5-1/800/600\"]', 3, 1500.00, 2200.00, 80, 18, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (10, '摄影T恤', '纯棉材质，舒适透气', 'https://picsum.photos/seed/goods6/400/300', '[\"https://picsum.photos/seed/goods6-1/800/600\"]', 4, 300.00, 500.00, 100, 45, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (11, '摄影徽章', '限量版金属徽章', 'https://picsum.photos/seed/goods7/400/300', '[\"https://picsum.photos/seed/goods7-1/800/600\"]', 4, 150.00, 250.00, 200, 67, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (12, '摄影笔记本', '高品质笔记本，适合记录灵感', 'https://picsum.photos/seed/goods8/400/300', '[\"https://picsum.photos/seed/goods8-1/800/600\"]', 4, 200.00, 350.00, 150, 34, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `mall_goods` VALUES (13, '专业相机包', '防水防震，适合单反相机和镜头', 'https://picsum.photos/seed/goods1/400/300', '[\"https://picsum.photos/seed/goods1-1/800/600\"]', 1, 500.00, 800.00, 50, 12, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (14, '三脚架', '铝合金材质，承重10kg，便携折叠', 'https://picsum.photos/seed/goods2/400/300', '[\"https://picsum.photos/seed/goods2-1/800/600\"]', 2, 800.00, 1200.00, 30, 8, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (15, '摄影灯', 'LED补光灯，可调色温', 'https://picsum.photos/seed/goods3/400/300', '[\"https://picsum.photos/seed/goods3-1/800/600\"]', 2, 600.00, 900.00, 40, 15, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (16, 'Lightroom软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods4/400/300', '[\"https://picsum.photos/seed/goods4-1/800/600\"]', 3, 1200.00, 1800.00, 100, 23, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (17, 'Photoshop软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods5/400/300', '[\"https://picsum.photos/seed/goods5-1/800/600\"]', 3, 1500.00, 2200.00, 80, 18, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (18, '摄影T恤', '纯棉材质，舒适透气', 'https://picsum.photos/seed/goods6/400/300', '[\"https://picsum.photos/seed/goods6-1/800/600\"]', 4, 300.00, 500.00, 100, 45, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (19, '摄影徽章', '限量版金属徽章', 'https://picsum.photos/seed/goods7/400/300', '[\"https://picsum.photos/seed/goods7-1/800/600\"]', 4, 150.00, 250.00, 200, 67, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `mall_goods` VALUES (20, '摄影笔记本', '高品质笔记本，适合记录灵感', 'https://picsum.photos/seed/goods8/400/300', '[\"https://picsum.photos/seed/goods8-1/800/600\"]', 4, 200.00, 350.00, 150, 34, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `sender_id` bigint(20) NOT NULL COMMENT '发送者ID',
  `receiver_id` bigint(20) NOT NULL COMMENT '接收者ID',
  `content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息内容',
  `images` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '图片列表(存储JSON字符串)',
  `is_read` tinyint(4) NULL DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `deleted_by_sender` tinyint(4) NULL DEFAULT 0 COMMENT '发送者删除',
  `deleted_by_receiver` tinyint(4) NULL DEFAULT 0 COMMENT '接收者删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sender_receiver`(`sender_id`, `receiver_id`) USING BTREE,
  INDEX `idx_receiver`(`receiver_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_receiver_read`(`receiver_id`, `is_read`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '私信表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message
-- ----------------------------

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `type` tinyint(4) NOT NULL COMMENT '类型: 1-点赞, 2-评论, 3-关注, 4-系统',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `content` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容',
  `target_id` bigint(20) NULL DEFAULT NULL COMMENT '目标ID',
  `target_type` tinyint(4) NULL DEFAULT NULL COMMENT '目标类型',
  `is_read` tinyint(4) NULL DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_is_read`(`is_read`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_user_read`(`user_id`, `is_read`) USING BTREE,
  INDEX `idx_user_read_time`(`user_id`, `is_read`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------
INSERT INTO `notification` VALUES (1, 2, 1, '点赞通知', '有人点赞了你的帖子', 1, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `notification` VALUES (2, 2, 2, '评论通知', '有人评论了你的帖子', 1, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `notification` VALUES (3, 3, 1, '点赞通知', '有人点赞了你的作品', 2, 3, 0, '2026-02-07 13:32:45');
INSERT INTO `notification` VALUES (4, 4, 3, '关注通知', '有人关注了你', 2, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `notification` VALUES (5, 2, 1, '点赞通知', '有人点赞了你的帖子', 1, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `notification` VALUES (6, 2, 2, '评论通知', '有人评论了你的帖子', 1, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `notification` VALUES (7, 3, 1, '点赞通知', '有人点赞了你的作品', 2, 3, 0, '2026-02-07 13:32:47');
INSERT INTO `notification` VALUES (8, 4, 3, '关注通知', '有人关注了你', 2, 1, 0, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `item_id` bigint(20) NOT NULL COMMENT '商品ID(课程ID或商品ID)',
  `item_type` tinyint(4) NOT NULL COMMENT '商品类型: 1-课程, 2-商品',
  `item_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `quantity` int(11) NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '订单金额',
  `discount_amount` decimal(10, 2) NULL COMMENT '优惠金额',
  `pay_amount` decimal(10, 2) NOT NULL COMMENT '实付金额',
  `pay_method` tinyint(4) NULL DEFAULT NULL COMMENT '支付方式: 1-微信, 2-支付宝, 3-余额',
  `pay_time` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-待支付, 1-已支付, 2-已取消, 3-已退款',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_item`(`item_id`, `item_type`) USING BTREE,
  INDEX `idx_pay_time`(`pay_time`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (1, '20240101123456', 2, 2, 2, '三脚架', 1, 800.00, 0.00, 800.00, 2, '2024-01-01 12:34:56', 1, NULL, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `order` VALUES (2, '20240102234567', 3, 4, 2, 'Lightroom软件', 1, 1200.00, 0.00, 1200.00, 1, NULL, 1, NULL, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `order` VALUES (3, '20240103345678', 4, 7, 2, '摄影徽章', 2, 300.00, 0.00, 300.00, 3, NULL, 0, NULL, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `order` VALUES (4, 'ORD17709743118820481', 2, 2, 1, 'Lightroom后期精讲', 1, 199.00, 0.00, 199.00, 1, '2026-02-13 17:18:32', 1, NULL, 0, NULL, NULL);
INSERT INTO `order` VALUES (5, 'ORD17709750518050189', 2, 2, 1, 'Lightroom后期精讲', 1, 199.00, 0.00, 199.00, 1, '2026-02-13 17:30:52', 1, NULL, 0, NULL, NULL);

-- ----------------------------
-- Table structure for points_record
-- ----------------------------
DROP TABLE IF EXISTS `points_record`;
CREATE TABLE `points_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `points` int(11) NOT NULL COMMENT '积分数量(正数增加,负数减少)',
  `type` tinyint(4) NOT NULL COMMENT '类型: 1-注册, 2-发帖, 3-评论, 4-点赞, 5-登录, 6-兑换, 7-签到, 8-管理员',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '描述',
  `balance` int(11) NOT NULL COMMENT '操作后余额',
  `ref_id` bigint(20) NULL DEFAULT NULL COMMENT '关联ID(如订单ID,帖子ID等)',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_user_type`(`user_id`, `type`) USING BTREE,
  INDEX `idx_ref`(`ref_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '积分记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of points_record
-- ----------------------------
INSERT INTO `points_record` VALUES (1, 2, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (2, 2, 5, 2, '发布帖子', 15, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (3, 2, 2, 3, '发表评论', 17, 1, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (4, 2, 1, 4, '获得点赞', 18, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (5, 2, 5, 7, '每日签到', 23, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (6, 3, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (7, 3, 5, 2, '发布帖子', 15, 2, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (8, 4, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (9, 4, 5, 2, '发布帖子', 15, 3, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (10, 1, 100, 8, '管理员奖励', 100999, NULL, 0, '2026-02-07 13:32:45');
INSERT INTO `points_record` VALUES (11, 2, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (12, 2, 5, 2, '发布帖子', 15, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (13, 2, 2, 3, '发表评论', 17, 1, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (14, 2, 1, 4, '获得点赞', 18, NULL, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (15, 2, 5, 7, '每日签到', 23, NULL, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (16, 3, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (17, 3, 5, 2, '发布帖子', 15, 2, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (18, 4, 10, 1, '注册用户', 10, NULL, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (19, 4, 5, 2, '发布帖子', 15, 3, 0, '2026-02-07 13:32:47');
INSERT INTO `points_record` VALUES (20, 1, 100, 8, '管理员奖励', 100999, NULL, 0, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '发布者ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `images` json NULL COMMENT '图片列表(JSON)',
  `videos` json NULL COMMENT '视频列表(JSON)',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发布地点',
  `privacy` tinyint(4) NULL DEFAULT 0 COMMENT '隐私设置: 0-公开, 1-好友可见, 2-私密',
  `topic_id` bigint(20) NULL DEFAULT NULL COMMENT '话题ID',
  `views` int(11) NULL DEFAULT 0 COMMENT '浏览数',
  `likes` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `comments` int(11) NULL DEFAULT 0 COMMENT '评论数',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数(兼容字段，可选)',
  `comment_count` int(11) NULL DEFAULT 0 COMMENT '评论数(兼容字段，可选)',
  `share_count` int(11) NULL DEFAULT 0 COMMENT '分享数',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览数(兼容字段，可选)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_topic`(`topic_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_user_privacy`(`user_id`, `privacy`) USING BTREE,
  INDEX `idx_topic_status`(`topic_id`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (1, 2, '魔都的夜景永远看不腻', '今晚的外滩灯光璀璨，随手一拍就是大片。#夜景 #上海', '[\"https://picsum.photos/seed/shanghai/800/600\", \"https://picsum.photos/seed/night/800/600\"]', NULL, '上海市·外滩', 0, 1, 1250, 88, 15, 88, 15, 10, 1250, 1, 0, '2026-02-11 20:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (2, 3, '人像摄影中的光影艺术', '利用自然光拍摄人像，关键在于寻找光线的方向。这张是在下午四点左右拍摄的，逆光效果很棒。', '[\"https://picsum.photos/seed/portrait/800/600\"]', NULL, '杭州市·西湖', 0, 2, 3400, 210, 45, 210, 45, 32, 3400, 1, 0, '2026-02-09 20:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (3, 4, '新入手的索尼A7M4开箱', '终于等到你！对焦速度真的提升巨大，视频能力也很强。周末去试拍！', '[\"https://picsum.photos/seed/camera/800/600\", \"https://picsum.photos/seed/lens/800/600\"]', NULL, '北京市·朝阳区', 0, 3, 5600, 320, 88, 320, 88, 15, 5600, 1, 0, '2026-02-12 15:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (4, 2, '街头偶遇的小确幸', '在弄堂里发现的一家很有特色的小店，猫咪很粘人。', '[\"https://picsum.photos/seed/cat/800/600\"]', NULL, '上海市·静安区', 0, 1, 890, 56, 12, 56, 12, 5, 890, 1, 0, '2026-02-10 20:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (5, 3, '日系小清新后期调色分享', '很多人问这张照片怎么调的，其实很简单。降低对比度，提高亮度，色温偏蓝一点...详细参数见评论。', '[\"https://picsum.photos/seed/color/800/600\"]', NULL, '杭州市', 0, 5, 2100, 150, 60, 150, 60, 45, 2100, 1, 0, '2026-02-08 20:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (6, 4, '黄山云海，美不胜收', '运气爆棚，爬山遇到了难得一见的云海奇观。大自然的鬼斧神工令人敬畏。', '[\"https://picsum.photos/seed/mountain/800/600\", \"https://picsum.photos/seed/cloud/800/600\"]', NULL, '黄山风景区', 0, 1, 4500, 420, 56, 420, 56, 88, 4500, 1, 0, '2026-02-05 20:53:06', '2026-02-12 20:53:06');
INSERT INTO `post` VALUES (7, 2, '魔都的夜景永远看不腻', '今晚的外滩灯光璀璨，随手一拍就是大片。#夜景 #上海', '[\"https://picsum.photos/seed/shanghai/800/600\", \"https://picsum.photos/seed/night/800/600\"]', NULL, '上海市·外滩', 0, 1, 1250, 88, 15, 88, 15, 10, 1250, 1, 0, '2026-02-11 20:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (8, 3, '人像摄影中的光影艺术', '利用自然光拍摄人像，关键在于寻找光线的方向。这张是在下午四点左右拍摄的，逆光效果很棒。', '[\"https://picsum.photos/seed/portrait/800/600\"]', NULL, '杭州市·西湖', 0, 2, 3400, 210, 45, 210, 45, 32, 3400, 1, 0, '2026-02-09 20:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (9, 4, '新入手的索尼A7M4开箱', '终于等到你！对焦速度真的提升巨大，视频能力也很强。周末去试拍！', '[\"https://picsum.photos/seed/camera/800/600\", \"https://picsum.photos/seed/lens/800/600\"]', NULL, '北京市·朝阳区', 0, 3, 5600, 320, 88, 320, 88, 15, 5600, 1, 0, '2026-02-12 15:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (10, 2, '街头偶遇的小确幸', '在弄堂里发现的一家很有特色的小店，猫咪很粘人。', '[\"https://picsum.photos/seed/cat/800/600\"]', NULL, '上海市·静安区', 0, 1, 890, 56, 12, 56, 12, 5, 890, 1, 0, '2026-02-10 20:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (11, 3, '日系小清新后期调色分享', '很多人问这张照片怎么调的，其实很简单。降低对比度，提高亮度，色温偏蓝一点...详细参数见评论。', '[\"https://picsum.photos/seed/color/800/600\"]', NULL, '杭州市', 0, 5, 2100, 150, 60, 150, 60, 45, 2100, 1, 0, '2026-02-08 20:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (12, 4, '黄山云海，美不胜收', '运气爆棚，爬山遇到了难得一见的云海奇观。大自然的鬼斧神工令人敬畏。', '[\"https://picsum.photos/seed/mountain/800/600\", \"https://picsum.photos/seed/cloud/800/600\"]', NULL, '黄山风景区', 0, 1, 4500, 420, 56, 420, 56, 88, 4500, 1, 0, '2026-02-05 20:53:09', '2026-02-12 20:53:09');
INSERT INTO `post` VALUES (13, 2, '魔都的夜景永远看不腻', '今晚的外滩灯光璀璨，随手一拍就是大片。#夜景 #上海', '[\"https://picsum.photos/seed/shanghai/800/600\", \"https://picsum.photos/seed/night/800/600\"]', NULL, '上海市·外滩', 0, 1, 1250, 88, 15, 88, 15, 10, 1250, 1, 0, '2026-02-11 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (14, 3, '人像摄影中的光影艺术', '利用自然光拍摄人像，关键在于寻找光线的方向。这张是在下午四点左右拍摄的，逆光效果很棒。', '[\"https://picsum.photos/seed/portrait/800/600\"]', NULL, '杭州市·西湖', 0, 2, 3400, 210, 45, 210, 45, 32, 3400, 1, 0, '2026-02-09 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (15, 4, '新入手的索尼A7M4开箱', '终于等到你！对焦速度真的提升巨大，视频能力也很强。周末去试拍！', '[\"https://picsum.photos/seed/camera/800/600\", \"https://picsum.photos/seed/lens/800/600\"]', NULL, '北京市·朝阳区', 0, 3, 5600, 320, 88, 320, 88, 15, 5600, 1, 0, '2026-02-12 15:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (16, 2, '街头偶遇的小确幸', '在弄堂里发现的一家很有特色的小店，猫咪很粘人。', '[\"https://picsum.photos/seed/cat/800/600\"]', NULL, '上海市·静安区', 0, 1, 890, 56, 12, 56, 12, 5, 890, 1, 0, '2026-02-10 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (17, 3, '日系小清新后期调色分享', '很多人问这张照片怎么调的，其实很简单。降低对比度，提高亮度，色温偏蓝一点...详细参数见评论。', '[\"https://picsum.photos/seed/color/800/600\"]', NULL, '杭州市', 0, 5, 2100, 150, 60, 150, 60, 45, 2100, 1, 0, '2026-02-08 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (18, 4, '黄山云海，美不胜收', '运气爆棚，爬山遇到了难得一见的云海奇观。大自然的鬼斧神工令人敬畏。', '[\"https://picsum.photos/seed/mountain/800/600\", \"https://picsum.photos/seed/cloud/800/600\"]', NULL, '黄山风景区', 0, 1, 4500, 420, 56, 420, 56, 88, 4500, 1, 0, '2026-02-05 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (19, 2, '魔都的夜景永远看不腻', '今晚的外滩灯光璀璨，随手一拍就是大片。#夜景 #上海', '[\"https://picsum.photos/seed/shanghai/800/600\", \"https://picsum.photos/seed/night/800/600\"]', NULL, '上海市·外滩', 0, 1, 1250, 88, 15, 88, 15, 10, 1250, 1, 0, '2026-02-11 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (20, 3, '人像摄影中的光影艺术', '利用自然光拍摄人像，关键在于寻找光线的方向。这张是在下午四点左右拍摄的，逆光效果很棒。', '[\"https://picsum.photos/seed/portrait/800/600\"]', NULL, '杭州市·西湖', 0, 2, 3400, 210, 45, 210, 45, 32, 3400, 1, 0, '2026-02-09 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (21, 4, '新入手的索尼A7M4开箱', '终于等到你！对焦速度真的提升巨大，视频能力也很强。周末去试拍！', '[\"https://picsum.photos/seed/camera/800/600\", \"https://picsum.photos/seed/lens/800/600\"]', NULL, '北京市·朝阳区', 0, 3, 5600, 320, 88, 320, 88, 15, 5600, 1, 0, '2026-02-12 15:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (22, 2, '街头偶遇的小确幸', '在弄堂里发现的一家很有特色的小店，猫咪很粘人。', '[\"https://picsum.photos/seed/cat/800/600\"]', NULL, '上海市·静安区', 0, 1, 890, 57, 12, 56, 12, 5, 890, 1, 0, '2026-02-10 20:53:10', '2026-02-13 13:53:54');
INSERT INTO `post` VALUES (23, 3, '日系小清新后期调色分享', '很多人问这张照片怎么调的，其实很简单。降低对比度，提高亮度，色温偏蓝一点...详细参数见评论。', '[\"https://picsum.photos/seed/color/800/600\"]', NULL, '杭州市', 0, 5, 2100, 150, 60, 150, 60, 45, 2100, 1, 0, '2026-02-08 20:53:10', '2026-02-12 20:53:10');
INSERT INTO `post` VALUES (24, 4, '黄山云海，美不胜收', '运气爆棚，爬山遇到了难得一见的云海奇观。大自然的鬼斧神工令人敬畏。', '[\"https://picsum.photos/seed/mountain/800/600\", \"https://picsum.photos/seed/cloud/800/600\"]', NULL, '黄山风景区', 0, 1, 4500, 420, 56, 420, 56, 88, 4500, 1, 0, '2026-02-05 20:53:10', '2026-02-12 20:53:10');

-- ----------------------------
-- Table structure for sign_in
-- ----------------------------
DROP TABLE IF EXISTS `sign_in`;
CREATE TABLE `sign_in`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '签到ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `sign_date` date NOT NULL COMMENT '签到日期',
  `points` int(11) NOT NULL COMMENT '获得积分',
  `continuous_days` int(11) NULL DEFAULT 1 COMMENT '连续签到天数',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `sign_date`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_date`(`sign_date`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `sign_date`) USING BTREE,
  INDEX `idx_continuous`(`continuous_days`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '签到表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sign_in
-- ----------------------------
INSERT INTO `sign_in` VALUES (1, 2, '2026-02-06', 5, 1, '2026-02-07 13:32:45');
INSERT INTO `sign_in` VALUES (2, 3, '2026-02-06', 5, 1, '2026-02-07 13:32:45');
INSERT INTO `sign_in` VALUES (3, 4, '2026-02-06', 5, 1, '2026-02-07 13:32:45');
INSERT INTO `sign_in` VALUES (4, 2, '2026-02-07', 5, 2, '2026-02-07 13:32:45');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '配置键',
  `value` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '配置值',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '配置描述',
  `type` tinyint(4) NULL DEFAULT 1 COMMENT '类型: 1-系统, 2-业务',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_key`(`key`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'site_name', '摄友圈', '网站名称', 1, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (2, 'site_description', '专业摄影爱好者社区', '网站描述', 1, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (3, 'points_register', '10', '注册获得积分', 2, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (4, 'points_post', '5', '发帖获得积分', 2, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (5, 'points_comment', '2', '评论获得积分', 2, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (6, 'points_like', '1', '点赞获得积分', 2, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');
INSERT INTO `sys_config` VALUES (7, 'points_daily_login', '5', '每日登录积分', 2, 1, '2025-12-31 10:12:42', '2025-12-31 10:12:42');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作描述',
  `module` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作模块',
  `ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户代理',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `request_url` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '请求参数',
  `response_code` int(11) NULL DEFAULT NULL COMMENT '响应码',
  `response_msg` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '响应信息',
  `duration` int(11) NULL DEFAULT NULL COMMENT '执行时长(ms)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-失败, 1-成功',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_module`(`module`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `create_time`) USING BTREE,
  INDEX `idx_module_time`(`module`, `create_time`) USING BTREE,
  INDEX `idx_status_time`(`status`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_log
-- ----------------------------


-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '话题ID',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '话题名称',
  `description` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '话题描述',
  `cover_image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `post_count` int(11) NULL DEFAULT 0 COMMENT '帖子数',
  `follow_count` int(11) NULL DEFAULT 0 COMMENT '关注数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_status_follow`(`status`, `follow_count`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------
INSERT INTO `topic` VALUES (1, '每日一图', '分享你每天拍摄的精彩照片', NULL, 0, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `topic` VALUES (2, '摄影技巧', '交流摄影技巧和经验', NULL, 0, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `topic` VALUES (3, '器材讨论', '讨论摄影器材使用心得', NULL, 0, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `topic` VALUES (4, '作品点评', '互相点评摄影作品', NULL, 0, 0, 1, '2025-12-31 10:12:42');
INSERT INTO `topic` VALUES (5, '后期分享', '分享后期处理技巧', NULL, 0, 0, 1, '2025-12-31 10:12:42');

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `receiver` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系电话',
  `province` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '区县',
  `detail` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint(4) NULL DEFAULT 0 COMMENT '是否默认: 0-否, 1-是',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_user_default`(`user_id`, `is_default`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_address
-- ----------------------------
INSERT INTO `user_address` VALUES (1, 2, '王小明', '13800138001', '上海市', '浦东新区', '陆家嘴街道', '世纪大道100号', 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_address` VALUES (2, 3, '李小红', '13900139002', '浙江省', '杭州市', '西湖区', '文三路456号', 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_address` VALUES (3, 4, '张小刚', '13700137003', '广东省', '广州市', '天河区', '体育东路789号', 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_address` VALUES (4, 2, '王小明', '13800138001', '上海市', '浦东新区', '陆家嘴街道', '世纪大道100号', 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `user_address` VALUES (5, 3, '李小红', '13900139002', '浙江省', '杭州市', '西湖区', '文三路456号', 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `user_address` VALUES (6, 4, '张小刚', '13700137003', '广东省', '广州市', '天河区', '体育东路789号', 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for user_course
-- ----------------------------
DROP TABLE IF EXISTS `user_course`;
CREATE TABLE `user_course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `progress` int(11) NULL DEFAULT 0 COMMENT '学习进度(百分比)',
  `last_chapter_id` bigint(20) NULL DEFAULT NULL COMMENT '最后学习章节',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始学习时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '完成学习时间',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-未开始, 1-学习中, 2-已完成',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_course`(`user_id`, `course_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_course`(`course_id`) USING BTREE,
  INDEX `idx_user_progress`(`user_id`, `progress`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_course
-- ----------------------------
INSERT INTO `user_course` VALUES (1, 2, 1, 50, 2, NULL, NULL, 1, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_course` VALUES (2, 3, 2, 30, 2, NULL, NULL, 1, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_course` VALUES (3, 4, 1, 100, 4, NULL, NULL, 2, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `user_course` VALUES (4, 2, 2, 0, NULL, NULL, NULL, 0, '2026-02-13 17:30:52', '2026-02-13 17:30:51');

-- ----------------------------
-- Table structure for user_follow
-- ----------------------------
DROP TABLE IF EXISTS `user_follow`;
CREATE TABLE `user_follow`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `follower_id` bigint(20) NOT NULL COMMENT '关注者ID',
  `followed_id` bigint(20) NOT NULL COMMENT '被关注者ID',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '关注时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_follower_followed`(`follower_id`, `followed_id`) USING BTREE,
  INDEX `idx_follower`(`follower_id`) USING BTREE,
  INDEX `idx_followed`(`followed_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户关注表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_follow
-- ----------------------------

-- ----------------------------
-- Table structure for user_tag
-- ----------------------------
DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE `user_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签描述',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_tag
-- ----------------------------
INSERT INTO `user_tag` VALUES (1, '摄影大师', '专业摄影师', 1, 1, '2025-12-31 10:12:42');
INSERT INTO `user_tag` VALUES (2, '摄影爱好者', '摄影爱好者', 2, 1, '2025-12-31 10:12:42');
INSERT INTO `user_tag` VALUES (3, '新手入门', '摄影初学者', 3, 1, '2025-12-31 10:12:42');

-- ----------------------------
-- Table structure for user_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `user_tag_relation`;
CREATE TABLE `user_tag_relation`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `tag_id` bigint(20) NOT NULL COMMENT '标签ID',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_tag`(`user_id`, `tag_id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_tag`(`tag_id`) USING BTREE,
  INDEX `idx_user_tag`(`user_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_tag_relation
-- ----------------------------
INSERT INTO `user_tag_relation` VALUES (1, 2, 1, '2026-02-07 13:32:45');
INSERT INTO `user_tag_relation` VALUES (2, 3, 1, '2026-02-07 13:32:45');
INSERT INTO `user_tag_relation` VALUES (3, 4, 2, '2026-02-07 13:32:45');

-- ----------------------------
-- Table structure for work
-- ----------------------------
DROP TABLE IF EXISTS `work`;
CREATE TABLE `work`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '作品ID',
  `user_id` bigint(20) NOT NULL COMMENT '作者ID',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '作品标题',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '作品描述',
  `images` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '作品图片列表(存储JSON字符串)',
  `cover_image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `tags` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '标签列表(存储JSON字符串)',
  `equipment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拍摄器材',
  `settings` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拍摄参数',
  `location` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拍摄地点',
  `shoot_time` datetime(0) NULL DEFAULT NULL COMMENT '拍摄时间',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览数',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int(11) NULL DEFAULT 0 COMMENT '评论数',
  `collect_count` int(11) NULL DEFAULT 0 COMMENT '收藏数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-隐藏, 1-正常',
  `is_public` tinyint(4) NULL DEFAULT 1 COMMENT '是否公开: 0-私密, 1-公开',
  `deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_category`(`category_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_category_status`(`category_id`, `status`) USING BTREE,
  INDEX `idx_view_count`(`view_count`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '作品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of work
-- ----------------------------
INSERT INTO `work` VALUES (1, 2, '城市夜景', '繁华都市的霓虹灯光，记录城市夜晚的美丽', '[\"https://picsum.photos/seed/work1-1/800/600\", \"https://picsum.photos/seed/work1-2/800/600\"]', 'https://picsum.photos/seed/work1-cover/400/300', 2, '[\"夜景\"]', 'Canon EOS R5', 'f/8, 1/30s, ISO 800', '上海外滩', NULL, 237, 45, 12, 0, 1, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `work` VALUES (2, 3, '人像写真', '自然光下的肖像拍摄，展现人物自然美', '[\"https://picsum.photos/seed/work2-1/800/600\"]', 'https://picsum.photos/seed/work2-cover/400/300', 1, '[\"人像\"]', 'Sony A7R4', 'f/1.8, 1/200s, ISO 100', '杭州西湖', NULL, 190, 32, 8, 0, 1, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `work` VALUES (3, 4, '风光大片', '山川湖海的壮丽景色', '[\"https://picsum.photos/seed/work3-1/800/600\", \"https://picsum.photos/seed/work3-2/800/600\", \"https://picsum.photos/seed/work3-3/800/600\"]', 'https://picsum.photos/seed/work3-cover/400/300', 2, '[\"风景\"]', 'Nikon Z7', 'f/11, 1/125s, ISO 200', '黄山', NULL, 345, 67, 23, 0, 1, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `work` VALUES (4, 2, '街头瞬间', '城市街头的精彩瞬间', '[\"https://picsum.photos/seed/work4-1/800/600\"]', 'https://picsum.photos/seed/work4-cover/400/300', 3, '[\"街拍\"]', 'Fujifilm X-T4', 'f/5.6, 1/500s, ISO 400', '北京三里屯', NULL, 156, 28, 6, 0, 1, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `work` VALUES (5, 3, '静物之美', '日常生活中的美好细节', '[\"https://picsum.photos/seed/work5-1/800/600\"]', 'https://picsum.photos/seed/work5-cover/400/300', 5, '[\"黑白\"]', 'Leica Q2', 'f/2.8, 1/60s, ISO 400', '家中', NULL, 98, 15, 4, 0, 1, 1, 0, '2026-02-07 13:32:45', '2026-02-07 13:32:45');
INSERT INTO `work` VALUES (6, 2, '城市夜景', '繁华都市的霓虹灯光，记录城市夜晚的美丽', '[\"https://picsum.photos/seed/work1-1/800/600\", \"https://picsum.photos/seed/work1-2/800/600\"]', 'https://picsum.photos/seed/work1-cover/400/300', 2, '[\"夜景\"]', 'Canon EOS R5', 'f/8, 1/30s, ISO 800', '上海外滩', NULL, 257, 45, 12, 0, 1, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `work` VALUES (7, 3, '人像写真', '自然光下的肖像拍摄，展现人物自然美', '[\"https://picsum.photos/seed/work2-1/800/600\"]', 'https://picsum.photos/seed/work2-cover/400/300', 1, '[\"人像\"]', 'Sony A7R4', 'f/1.8, 1/200s, ISO 100', '杭州西湖', NULL, 202, 32, 8, 0, 1, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `work` VALUES (8, 4, '风光大片', '山川湖海的壮丽景色', '[\"https://picsum.photos/seed/work3-1/800/600\", \"https://picsum.photos/seed/work3-2/800/600\", \"https://picsum.photos/seed/work3-3/800/600\"]', 'https://picsum.photos/seed/work3-cover/400/300', 2, '[\"风景\"]', 'Nikon Z7', 'f/11, 1/125s, ISO 200', '黄山', NULL, 349, 67, 23, 0, 1, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `work` VALUES (9, 2, '街头瞬间', '城市街头的精彩瞬间', '[\"https://picsum.photos/seed/work4-1/800/600\"]', 'https://picsum.photos/seed/work4-cover/400/300', 3, '[\"街拍\"]', 'Fujifilm X-T4', 'f/5.6, 1/500s, ISO 400', '北京三里屯', NULL, 159, 28, 6, 0, 1, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `work` VALUES (10, 3, '静物之美', '日常生活中的美好细节', '[\"https://picsum.photos/seed/work5-1/800/600\"]', 'https://picsum.photos/seed/work5-cover/400/300', 5, '[\"黑白\"]', 'Leica Q2', 'f/2.8, 1/60s, ISO 400', '家中', NULL, 100, 15, 4, 0, 1, 1, 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `work` VALUES (11, 2, '11', '11', '', '/file/2026/02/13/5329605b-4a9d-486a-a541-2795ec25a964.jpg', 1, '[]', '', '', '', NULL, 5, 0, 0, 0, 1, 1, 0, NULL, NULL);
INSERT INTO `work` VALUES (12, 2, '11', '11', '', '/file/2026/02/13/579afa91-6d55-4d67-8ccc-669d85a68872.jpg', 4, '[]', '', '', '', NULL, 2, 0, 0, 0, 1, 1, 0, NULL, NULL);
INSERT INTO `work` VALUES (13, 2, '高中', '11', '', '/file/2026/02/13/531f0c48-17d8-4539-a827-3813c57c8a96.jpg', 1, '[]', '', '', '斗门一中', NULL, 2, 0, 0, 0, 1, 1, 0, NULL, NULL);
INSERT INTO `work` VALUES (14, 2, '11', '11', '', '/file/2026/02/13/b169f846-bd48-4d96-91df-3c0fdb06de31.jpg', 5, '[]', '', '', '', NULL, 0, 0, 0, 0, 1, 1, 0, NULL, NULL);
INSERT INTO `work` VALUES (15, 2, '11', '11', '[\"/file/2026/02/13/4295c4f1-60fb-4ea5-89b6-189ec2c50604.jpg\",\"/file/2026/02/13/44137aa1-9f3e-4c8a-9254-7586090e4a3e.jpg\"]', '/file/2026/02/13/ceb2f249-5671-467a-8764-6dc522df8596.jpg', 2, '[]', '', '', '', NULL, 1, 0, 0, 0, 1, 1, 0, '2026-02-13 14:08:44', '2026-02-13 14:08:44');
INSERT INTO `work` VALUES (16, 2, '后背', '前桌的后背', '[\"/file/2026/02/13/34967e58-cd1f-4084-8e0d-10e2d00ea5c7.jpg\"]', '/file/2026/02/13/e49d9656-bac5-49d4-8442-6b4c87835b71.jpg', 1, '[]', '', '', '', '2022-02-01 03:12:00', 2, 0, 0, 0, 1, 1, 0, '2026-02-13 14:09:59', '2026-02-13 14:09:59');

-- ----------------------------
-- Table structure for work_category
-- ----------------------------
DROP TABLE IF EXISTS `work_category`;
CREATE TABLE `work_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID',
  `level` tinyint(4) NULL DEFAULT 1 COMMENT '层级',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类描述',
  `cover_image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '作品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of work_category
-- ----------------------------
INSERT INTO `work_category` VALUES (1, '人像摄影', 0, 1, '人像摄影作品', NULL, 1, 1, '2025-12-31 10:12:42');
INSERT INTO `work_category` VALUES (2, '风光摄影', 0, 1, '自然风光作品', NULL, 2, 1, '2025-12-31 10:12:42');
INSERT INTO `work_category` VALUES (3, '街拍摄影', 0, 1, '街头摄影作品', NULL, 3, 1, '2025-12-31 10:12:42');
INSERT INTO `work_category` VALUES (4, '纪实摄影', 0, 1, '纪实摄影作品', NULL, 4, 1, '2025-12-31 10:12:42');
INSERT INTO `work_category` VALUES (5, '创意摄影', 0, 1, '创意摄影作品', NULL, 5, 1, '2025-12-31 10:12:42');
INSERT INTO `work_category` VALUES (6, '人像摄影', 0, 1, '人像摄影作品', NULL, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `work_category` VALUES (7, '风光摄影', 0, 1, '自然风光作品', NULL, 2, 1, '2026-02-07 13:32:45');
INSERT INTO `work_category` VALUES (8, '街拍摄影', 0, 1, '街头摄影作品', NULL, 3, 1, '2026-02-07 13:32:45');
INSERT INTO `work_category` VALUES (9, '纪实摄影', 0, 1, '纪实摄影作品', NULL, 4, 1, '2026-02-07 13:32:45');
INSERT INTO `work_category` VALUES (10, '创意摄影', 0, 1, '创意摄影作品', NULL, 5, 1, '2026-02-07 13:32:45');
INSERT INTO `work_category` VALUES (11, '人像摄影', 0, 1, '人像摄影作品', NULL, 1, 1, '2026-02-07 13:32:47');
INSERT INTO `work_category` VALUES (12, '风光摄影', 0, 1, '自然风光作品', NULL, 2, 1, '2026-02-07 13:32:47');
INSERT INTO `work_category` VALUES (13, '街拍摄影', 0, 1, '街头摄影作品', NULL, 3, 1, '2026-02-07 13:32:47');
INSERT INTO `work_category` VALUES (14, '纪实摄影', 0, 1, '纪实摄影作品', NULL, 4, 1, '2026-02-07 13:32:47');
INSERT INTO `work_category` VALUES (15, '创意摄影', 0, 1, '创意摄影作品', NULL, 5, 1, '2026-02-07 13:32:47');

-- ----------------------------
-- Table structure for work_tag
-- ----------------------------
DROP TABLE IF EXISTS `work_tag`;
CREATE TABLE `work_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签描述',
  `work_count` int(11) NULL DEFAULT 0 COMMENT '作品数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '作品标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of work_tag
-- ----------------------------
INSERT INTO `work_tag` VALUES (1, '夜景', '夜间拍摄作品', 0, 1, '2026-02-07 13:32:45');
INSERT INTO `work_tag` VALUES (2, '人像', '人像摄影作品', 0, 1, '2026-02-07 13:32:45');
INSERT INTO `work_tag` VALUES (3, '风景', '自然风光作品', 0, 1, '2026-02-07 13:32:45');
INSERT INTO `work_tag` VALUES (4, '街拍', '街头摄影作品', 0, 1, '2026-02-07 13:32:45');
INSERT INTO `work_tag` VALUES (5, '黑白', '黑白摄影作品', 0, 1, '2026-02-07 13:32:45');

-- ----------------------------
-- Table structure for work_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `work_tag_relation`;
CREATE TABLE `work_tag_relation`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `work_id` bigint(20) NOT NULL COMMENT '作品ID',
  `tag_id` bigint(20) NOT NULL COMMENT '标签ID',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_work_tag`(`work_id`, `tag_id`) USING BTREE,
  INDEX `idx_work`(`work_id`) USING BTREE,
  INDEX `idx_tag`(`tag_id`) USING BTREE,
  INDEX `idx_work_tag`(`work_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '作品标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of work_tag_relation
-- ----------------------------
INSERT INTO `work_tag_relation` VALUES (1, 1, 1, '2026-02-07 13:32:45');
INSERT INTO `work_tag_relation` VALUES (2, 2, 2, '2026-02-07 13:32:45');
INSERT INTO `work_tag_relation` VALUES (3, 3, 3, '2026-02-07 13:32:45');
INSERT INTO `work_tag_relation` VALUES (4, 4, 4, '2026-02-07 13:32:45');
INSERT INTO `work_tag_relation` VALUES (5, 5, 5, '2026-02-07 13:32:45');




-- ----------------------------
-- 1. 处理 course_category 表的外键
-- ----------------------------
UPDATE `course_category` SET `parent_id` = NULL WHERE `parent_id` = 0;
ALTER TABLE `course_category` MODIFY COLUMN `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父分类ID';
ALTER TABLE `course_category` ADD CONSTRAINT `fk_course_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `course_category` (`id`) ON DELETE SET NULL;

-- ----------------------------
-- 2. 处理 mall_category 表的外键
-- ----------------------------
UPDATE `mall_category` SET `parent_id` = NULL WHERE `parent_id` = 0;
ALTER TABLE `mall_category` MODIFY COLUMN `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父分类ID';
ALTER TABLE `mall_category` ADD CONSTRAINT `fk_mall_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `mall_category` (`id`) ON DELETE SET NULL;

-- ----------------------------
-- 3. 处理 work_category 表的外键
-- ----------------------------
UPDATE `work_category` SET `parent_id` = NULL WHERE `parent_id` = 0;
ALTER TABLE `work_category` MODIFY COLUMN `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父分类ID';
ALTER TABLE `work_category` ADD CONSTRAINT `fk_work_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `work_category` (`id`) ON DELETE SET NULL;

-- ----------------------------
-- 4. 添加其他表的外键约束
-- ----------------------------

-- collect_record
ALTER TABLE `collect_record` ADD CONSTRAINT `fk_collect_record_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- comment
ALTER TABLE `comment` ADD CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE;
ALTER TABLE `comment` ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `comment` ADD CONSTRAINT `fk_comment_parent` FOREIGN KEY (`parent_id`) REFERENCES `comment` (`id`) ON DELETE CASCADE;

-- course
ALTER TABLE `course` ADD CONSTRAINT `fk_course_category` FOREIGN KEY (`category_id`) REFERENCES `course_category` (`id`);
ALTER TABLE `course` ADD CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `sys_user` (`id`);

-- course_chapter
ALTER TABLE `course_chapter` ADD CONSTRAINT `fk_course_chapter_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE;

-- exchange_record
ALTER TABLE `exchange_record` ADD CONSTRAINT `fk_exchange_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`);
ALTER TABLE `exchange_record` ADD CONSTRAINT `fk_exchange_goods` FOREIGN KEY (`goods_id`) REFERENCES `mall_goods` (`id`);
ALTER TABLE `exchange_record` ADD CONSTRAINT `fk_exchange_address` FOREIGN KEY (`address_id`) REFERENCES `user_address` (`id`);

-- feedback
ALTER TABLE `feedback` ADD CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`);

-- like_record
ALTER TABLE `like_record` ADD CONSTRAINT `fk_like_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- mall_goods
ALTER TABLE `mall_goods` ADD CONSTRAINT `fk_mall_goods_category` FOREIGN KEY (`category_id`) REFERENCES `mall_category` (`id`);

-- message
ALTER TABLE `message` ADD CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `message` ADD CONSTRAINT `fk_message_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- notification
ALTER TABLE `notification` ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- order
ALTER TABLE `order` ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`);

-- points_record
ALTER TABLE `points_record` ADD CONSTRAINT `fk_points_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- post
ALTER TABLE `post` ADD CONSTRAINT `fk_post_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `post` ADD CONSTRAINT `fk_post_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE SET NULL;

-- sign_in
ALTER TABLE `sign_in` ADD CONSTRAINT `fk_sign_in_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- sys_log
ALTER TABLE `sys_log` ADD CONSTRAINT `fk_sys_log_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL;

-- user_address
ALTER TABLE `user_address` ADD CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- user_course
ALTER TABLE `user_course` ADD CONSTRAINT `fk_user_course_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_course` ADD CONSTRAINT `fk_user_course_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_course` ADD CONSTRAINT `fk_user_course_chapter` FOREIGN KEY (`last_chapter_id`) REFERENCES `course_chapter` (`id`) ON DELETE SET NULL;

-- user_follow
ALTER TABLE `user_follow` ADD CONSTRAINT `fk_follow_follower` FOREIGN KEY (`follower_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_follow` ADD CONSTRAINT `fk_follow_followed` FOREIGN KEY (`followed_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- user_tag_relation
ALTER TABLE `user_tag_relation` ADD CONSTRAINT `fk_relation_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_tag_relation` ADD CONSTRAINT `fk_relation_tag` FOREIGN KEY (`tag_id`) REFERENCES `user_tag` (`id`) ON DELETE CASCADE;

-- work
ALTER TABLE `work` ADD CONSTRAINT `fk_work_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `work` ADD CONSTRAINT `fk_work_category` FOREIGN KEY (`category_id`) REFERENCES `work_category` (`id`);

-- work_tag_relation
ALTER TABLE `work_tag_relation` ADD CONSTRAINT `fk_work_relation_work` FOREIGN KEY (`work_id`) REFERENCES `work` (`id`) ON DELETE CASCADE;
ALTER TABLE `work_tag_relation` ADD CONSTRAINT `fk_work_relation_tag` FOREIGN KEY (`tag_id`) REFERENCES `work_tag` (`id`) ON DELETE CASCADE;
