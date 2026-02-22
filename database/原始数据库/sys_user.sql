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

 Date: 12/02/2026 19:35:40
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
INSERT INTO `sys_user` VALUES (2, 'yuyuyu', '$2a$10$xEajtcGuusoepqmNnYlTJeQol/NmiRWxh066hziK7tMQSE0xcRc5u', 'yuyuyu', 'https://picsum.photos/seed/yu-avatar/200/200', '2905618300@qq.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 11, '2026-02-11 16:10:48', '2026-01-25 20:47:33', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (3, 'yuxintong', '$2a$10$uVXq6lMAuS5VyGvLOUA0/en.1UuJ.QpnH3COmdx1LtTQU.hBS7xbW', 'yuxintong', 'https://picsum.photos/seed/yuxintong-avatar/200/200', '222@163.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-04 16:30:45', '2026-02-04 16:30:36', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (4, '123456', '$2a$10$8Yrvy5At1oaLxoZxTJql1ert.g4.qabhbzI.mwU8Ed1XPMuus5Cua', '123456', NULL, '11@qq.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-06 17:05:44', '2026-02-06 17:05:36', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (41, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '系统管理员', 'https://picsum.photos/seed/admin-avatar/200/200', 'admin@shengyouquan.com', '13800138000', 1, NULL, '摄影让生活更美好', '北京', 'admin', 1, 99999, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (42, 'photographer_wang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影师小王', 'https://picsum.photos/seed/wang-avatar/200/200', 'wang@shengyouquan.com', '13900139000', 1, NULL, '专注于人像摄影', '上海', 'user', 1, 1500, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (43, 'photographer_li', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影达人', 'https://picsum.photos/seed/li-avatar/200/200', 'li@shengyouquan.com', '13700137000', 2, NULL, '风光摄影师', '杭州', 'user', 1, 1200, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (44, 'photographer_zhang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '风光摄影师', 'https://picsum.photos/seed/zhang-avatar/200/200', 'zhang@shengyouquan.com', '13600136000', 1, NULL, '记录美好瞬间', '广州', 'user', 1, 800, 0, NULL, '2026-02-07 13:32:47', 0, '2026-02-07 13:32:47', '2026-02-07 13:32:47');
INSERT INTO `sys_user` VALUES (45, 'testuser3', '$2a$10$gKq6wVxVViB9UJjKjhg.DuOecDuel3RoZnkq9wMjTZDWNeDmehNBi', 'testuser3', NULL, 'test3@example.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-07 19:47:36', '2026-02-07 19:47:25', 0, NULL, NULL);
INSERT INTO `sys_user` VALUES (46, 'testuser123', '$2a$10$EqDFhGAjEF9Soq4o9bxuLOS2Yq7cZ0rJBUjXH0XB3BI2zCLEpbe9e', 'testuser123', NULL, 'test123@example.com', NULL, 0, NULL, NULL, NULL, 'user', 1, 10, 1, '2026-02-08 00:22:41', '2026-02-08 00:22:27', 0, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
