-- 课程评论表：若数据库中已存在其他表但缺少 course_comment，可单独执行本脚本
-- 执行前请确认已选择数据库，例如: USE shengyouquan;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `course_comment`;
CREATE TABLE `course_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `content` text NOT NULL COMMENT '评论内容',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父评论ID，用于回复',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-待审核, 1-已发布, 2-已删除',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_course_id`(`course_id`),
  INDEX `idx_user_id`(`user_id`),
  INDEX `idx_course_status`(`course_id`, `status`),
  CONSTRAINT `fk_course_comment_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_course_comment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_course_comment_parent` FOREIGN KEY (`parent_id`) REFERENCES `course_comment` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程评论表';
