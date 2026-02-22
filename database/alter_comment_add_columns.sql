-- 为 comment 表添加与实体 Comment 一致的列（仅当列不存在时添加，可重复执行）
-- 执行方式：mysql -u root -p shengyouquan < alter_comment_add_columns.sql

USE shengyouquan;

DELIMITER //

DROP PROCEDURE IF EXISTS add_comment_columns_if_not_exists//

CREATE PROCEDURE add_comment_columns_if_not_exists()
BEGIN
  -- username
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'comment' AND COLUMN_NAME = 'username') THEN
    ALTER TABLE `comment` ADD COLUMN `username` varchar(100) DEFAULT NULL COMMENT '评论者用户名' AFTER `user_id`;
  END IF;
  -- reply_to_user_id
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'comment' AND COLUMN_NAME = 'reply_to_user_id') THEN
    ALTER TABLE `comment` ADD COLUMN `reply_to_user_id` bigint(20) DEFAULT NULL COMMENT '回复的用户ID' AFTER `parent_id`;
  END IF;
  -- reply_to_username
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'comment' AND COLUMN_NAME = 'reply_to_username') THEN
    ALTER TABLE `comment` ADD COLUMN `reply_to_username` varchar(100) DEFAULT NULL COMMENT '回复的用户名' AFTER `reply_to_user_id`;
  END IF;
  -- update_time
  IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'comment' AND COLUMN_NAME = 'update_time') THEN
    ALTER TABLE `comment` ADD COLUMN `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`;
  END IF;
END//

DELIMITER ;

CALL add_comment_columns_if_not_exists();
DROP PROCEDURE add_comment_columns_if_not_exists;
