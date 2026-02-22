
-- ----------------------------
-- 外键约束
-- ----------------------------

-- 用户课程关联表外键
ALTER TABLE `user_course` ADD CONSTRAINT `fk_user_course_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_course` ADD CONSTRAINT `fk_user_course_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE;

-- 课程表外键
ALTER TABLE `course` ADD CONSTRAINT `fk_course_category` FOREIGN KEY (`category_id`) REFERENCES `course_category` (`id`);
ALTER TABLE `course` ADD CONSTRAINT `fk_course_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `sys_user` (`id`);

-- 订单表外键
ALTER TABLE `order` ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`);
-- 注意：item_id可能是课程ID也可能是商品ID，这里无法直接建立简单外键，除非拆分表或使用逻辑关联。
-- 如果业务逻辑确定 item_type=1 时 item_id 必须是 course.id，可以在应用层保证，或者拆分 order_course 和 order_goods 表。
-- 暂时只添加 user_id 外键。

-- 课程章节表外键
ALTER TABLE `course_chapter` ADD CONSTRAINT `fk_chapter_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE;

-- 评论表外键
ALTER TABLE `comment` ADD CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
-- post_id 关联 post 表
ALTER TABLE `comment` ADD CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE;

-- 收藏记录表外键
ALTER TABLE `collect_record` ADD CONSTRAINT `fk_collect_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
-- target_id 根据 target_type 变化，无法建立简单外键

-- 作品表外键
ALTER TABLE `work` ADD CONSTRAINT `fk_work_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `work` ADD CONSTRAINT `fk_work_category` FOREIGN KEY (`category_id`) REFERENCES `work_category` (`id`);

-- 消息通知表外键
ALTER TABLE `notification` ADD CONSTRAINT `fk_notification_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `notification` ADD CONSTRAINT `fk_notification_sender` FOREIGN KEY (`sender_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL;

-- 积分记录表外键
ALTER TABLE `points_record` ADD CONSTRAINT `fk_points_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;

-- 兑换记录表外键
ALTER TABLE `exchange_record` ADD CONSTRAINT `fk_exchange_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
-- goods_id 关联 goods 表 (如果存在)

-- 帖子表外键
ALTER TABLE `post` ADD CONSTRAINT `fk_post_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `post` ADD CONSTRAINT `fk_post_topic` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE SET NULL;

-- 用户标签关联表外键
ALTER TABLE `user_tag_relation` ADD CONSTRAINT `fk_user_tag_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_tag_relation` ADD CONSTRAINT `fk_user_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `user_tag` (`id`) ON DELETE CASCADE;

-- 作品标签关联表外键
ALTER TABLE `work_tag_relation` ADD CONSTRAINT `fk_work_tag_work` FOREIGN KEY (`work_id`) REFERENCES `work` (`id`) ON DELETE CASCADE;
ALTER TABLE `work_tag_relation` ADD CONSTRAINT `fk_work_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `work_tag` (`id`) ON DELETE CASCADE;
