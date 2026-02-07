-- 摄友圈社区系统 - 数据初始化脚本（修复版）
-- 根据 schema_mysql5.sql 创建

-- 1. 初始化用户数据（使用REPLACE INTO避免重复）
REPLACE INTO `sys_user` (`username`, `password`, `nickname`, `avatar`, `email`, `phone`, `gender`, `signature`, `location`, `role`, `status`, `points`) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '系统管理员', 'https://picsum.photos/seed/admin-avatar/200/200', 'admin@shengyouquan.com', '13800138000', 1, '摄影让生活更美好', '北京', 'admin', 1, 99999),
('photographer_wang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影师小王', 'https://picsum.photos/seed/wang-avatar/200/200', 'wang@shengyouquan.com', '13900139000', 1, '专注于人像摄影', '上海', 'user', 1, 1500),
('photographer_li', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '摄影达人', 'https://picsum.photos/seed/li-avatar/200/200', 'li@shengyouquan.com', '13700137000', 2, '风光摄影师', '杭州', 'user', 1, 1200),
('photographer_zhang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '风光摄影师', 'https://picsum.photos/seed/zhang-avatar/200/200', 'zhang@shengyouquan.com', '13600136000', 1, '记录美好瞬间', '广州', 'user', 1, 800);

-- 2. 初始化用户标签（使用INSERT IGNORE INTO忽略重复）
INSERT IGNORE INTO `user_tag` (`name`, `description`, `sort_order`, `status`) VALUES 
('摄影大师', '专业摄影师', 1, 1),
('摄影爱好者', '摄影爱好者', 2, 1),
('新手入门', '摄影初学者', 3, 1);

-- 3. 初始化用户标签关联（使用INSERT IGNORE INTO忽略重复）
INSERT IGNORE INTO `user_tag_relation` (`user_id`, `tag_id`) VALUES 
(2, 1), -- 摄影师小王 - 摄影大师
(3, 1), -- 摄影达人 - 摄影大师
(4, 2); -- 风光摄影师 - 摄影爱好者

-- 4. 初始化作品分类（使用INSERT IGNORE INTO忽略重复）
INSERT IGNORE INTO `work_category` (`name`, `parent_id`, `level`, `description`, `sort_order`, `status`) VALUES 
('人像摄影', 0, 1, '人像摄影作品', 1, 1),
('风光摄影', 0, 1, '自然风光作品', 2, 1),
('街拍摄影', 0, 1, '街头摄影作品', 3, 1),
('纪实摄影', 0, 1, '纪实摄影作品', 4, 1),
('创意摄影', 0, 1, '创意摄影作品', 5, 1);

-- 5. 初始化作品标签
INSERT IGNORE INTO `work_tag` (`name`, `description`, `work_count`, `status`) VALUES 
('夜景', '夜间拍摄作品', 0, 1),
('人像', '人像摄影作品', 0, 1),
('风景', '自然风光作品', 0, 1),
('街拍', '街头摄影作品', 0, 1),
('黑白', '黑白摄影作品', 0, 1);

-- 6. 初始化作品数据
INSERT IGNORE INTO `work` (`user_id`, `title`, `description`, `images`, `cover_image`, `category_id`, `tags`, `equipment`, `settings`, `location`, `view_count`, `like_count`, `comment_count`, `status`) VALUES 
(2, '城市夜景', '繁华都市的霓虹灯光，记录城市夜晚的美丽', '["https://picsum.photos/seed/work1-1/800/600", "https://picsum.photos/seed/work1-2/800/600"]', 'https://picsum.photos/seed/work1-cover/400/300', 2, '["夜景"]', 'Canon EOS R5', 'f/8, 1/30s, ISO 800', '上海外滩', 234, 45, 12, 1),
(3, '人像写真', '自然光下的肖像拍摄，展现人物自然美', '["https://picsum.photos/seed/work2-1/800/600"]', 'https://picsum.photos/seed/work2-cover/400/300', 1, '["人像"]', 'Sony A7R4', 'f/1.8, 1/200s, ISO 100', '杭州西湖', 189, 32, 8, 1),
(4, '风光大片', '山川湖海的壮丽景色', '["https://picsum.photos/seed/work3-1/800/600", "https://picsum.photos/seed/work3-2/800/600", "https://picsum.photos/seed/work3-3/800/600"]', 'https://picsum.photos/seed/work3-cover/400/300', 2, '["风景"]', 'Nikon Z7', 'f/11, 1/125s, ISO 200', '黄山', 345, 67, 23, 1),
(2, '街头瞬间', '城市街头的精彩瞬间', '["https://picsum.photos/seed/work4-1/800/600"]', 'https://picsum.photos/seed/work4-cover/400/300', 3, '["街拍"]', 'Fujifilm X-T4', 'f/5.6, 1/500s, ISO 400', '北京三里屯', 156, 28, 6, 1),
(3, '静物之美', '日常生活中的美好细节', '["https://picsum.photos/seed/work5-1/800/600"]', 'https://picsum.photos/seed/work5-cover/400/300', 5, '["黑白"]', 'Leica Q2', 'f/2.8, 1/60s, ISO 400', '家中', 98, 15, 4, 1);

-- 7. 初始化作品标签关联
INSERT IGNORE INTO `work_tag_relation` (`work_id`, `tag_id`) VALUES 
(1, 1), -- 城市夜景 - 夜景
(2, 2), -- 人像写真 - 人像
(3, 3), -- 风光大片 - 风景
(4, 4), -- 街头瞬间 - 街拍
(5, 5); -- 静物之美 - 黑白

-- 8. 初始化帖子数据
INSERT IGNORE INTO `post` (`user_id`, `content`, `images`, `videos`, `location`, `privacy`, `like_count`, `comment_count`, `view_count`, `status`) VALUES 
(2, '新手入门摄影器材推荐\n\n作为一个摄影爱好者，我推荐新手从以下器材开始：\n1. 入门级单反相机\n2. 50mm f/1.8镜头\n3. 三脚架\n4. 相机包\n\n这些器材性价比高，适合练习摄影技巧。', '["https://picsum.photos/seed/post1-1/800/600", "https://picsum.photos/seed/post1-2/800/600"]', NULL, '北京', 0, 23, 8, 156, 1),
(3, '如何拍出好看的夜景照片\n\n夜景摄影技巧分享：\n\n1. 使用三脚架稳定相机\n2. 选择小光圈获得星芒效果\n3. 注意白平衡设置\n4. 善用长曝光\n5. 寻找有趣的前景\n\n希望对大家有帮助！', '["https://picsum.photos/seed/post2-1/800/600"]', NULL, '上海', 0, 45, 12, 234, 1),
(4, '人像摄影的构图技巧\n\n人像摄影构图要点：\n\n1. 三分法构图\n2. 眼睛对焦\n3. 利用前景增加层次感\n4. 注意背景虚化\n5. 捕捉自然表情\n\n多练习，多观察，你也能拍出专业级人像！', '["https://picsum.photos/seed/post3-1/800/600", "https://picsum.photos/seed/post3-2/800/600", "https://picsum.photos/seed/post3-3/800/600"]', NULL, '杭州', 0, 32, 15, 189, 1),
(2, '后期调色心得分享\n\nLightroom调色技巧：\n\n1. 先调整曝光和对比度\n2. 使用曲线工具精细调整\n3. HSL面板调整特定颜色\n4. 分离色调增加氛围\n5. 局部调整工具的妙用\n\n调色是摄影的二次创作，让照片更有个性！', '["https://picsum.photos/seed/post4-1/800/600"]', NULL, '广州', 0, 18, 6, 98, 1),
(3, '日出日落拍摄指南\n\n黄金时刻拍摄技巧：\n\n1. 提前到达拍摄地点\n2. 使用三脚架\n3. 注意曝光补偿\n4. 尝试不同角度\n5. 等待最佳光线\n\n日出日落是风光摄影的黄金时间，不要错过！', '["https://picsum.photos/seed/post5-1/800/600", "https://picsum.photos/seed/post5-2/800/600"]', NULL, '黄山', 0, 28, 10, 167, 1);

-- 9. 初始化评论数据
INSERT IGNORE INTO `comment` (`post_id`, `user_id`, `parent_id`, `content`, `like_count`, `reply_count`, `status`) VALUES 
(1, 3, NULL, '感谢分享！我刚买了50mm镜头，确实很好用', 5, 1, 1),
(1, 4, NULL, '推荐得很详细，新手必备', 3, 0, 1),
(2, 2, NULL, '长曝光确实能拍出很美的光轨', 8, 0, 1),
(2, 4, NULL, '我一般用ISO 100，光圈f/8-f/11', 6, 0, 1),
(3, 2, NULL, '三分法构图很实用，学习了！', 4, 1, 1),
(3, 2, 5, '眼睛对焦是关键，一定要清晰', 7, 0, 1),
(4, 4, NULL, '曲线工具确实强大，需要多练习', 5, 0, 1),
(5, 2, NULL, '黄金时刻光线确实最美', 6, 0, 1);

-- 10. 初始化课程分类
INSERT IGNORE INTO `course_category` (`name`, `parent_id`, `description`, `sort_order`, `status`) VALUES 
('摄影基础', 0, '摄影基础知识', 1, 1),
('后期处理', 0, '照片后期处理', 2, 1),
('器材使用', 0, '摄影器材使用技巧', 3, 1),
('专题课程', 0, '专题摄影课程', 4, 1);

-- 11. 初始化课程数据
INSERT IGNORE INTO `course` (`title`, `description`, `cover_image`, `category_id`, `teacher_id`, `price`, `original_price`, `is_free`, `difficulty`, `duration`, `chapter_count`, `student_count`, `score`, `status`) VALUES 
('摄影入门完全指南', '从零开始学习摄影，掌握基础理论和实践技巧', 'https://picsum.photos/seed/course1/400/300', 1, 1, 0, 299, 1, 1, 120, 8, 156, 4.8, 1),
('Lightroom后期精讲', '专业级照片后期处理教程', 'https://picsum.photos/seed/course2/400/300', 2, 1, 199, 399, 0, 2, 180, 12, 89, 4.9, 1),
('人像摄影实战技巧', '专业人像摄影拍摄技巧', 'https://picsum.photos/seed/course3/400/300', 4, 1, 299, 599, 0, 2, 150, 10, 67, 4.7, 1),
('风光摄影大师课', '自然风光拍摄技巧大全', 'https://picsum.photos/seed/course4/400/300', 4, 1, 249, 499, 0, 2, 200, 15, 45, 4.8, 1),
('手机摄影技巧', '用手机也能拍出专业级照片', 'https://picsum.photos/seed/course5/400/300', 1, 1, 99, 199, 0, 1, 90, 6, 234, 4.6, 1);

-- 12. 初始化课程章节
INSERT IGNORE INTO `course_chapter` (`course_id`, `title`, `description`, `video_url`, `duration`, `sort_order`, `is_free`, `status`) VALUES 
(1, '相机基础知识', '了解相机的基本构造和原理', 'https://example.com/video1.mp4', 15, 1, 1, 1),
(1, '光圈快门ISO', '掌握曝光三要素', 'https://example.com/video2.mp4', 20, 2, 1, 1),
(1, '构图技巧', '学习基本的构图法则', 'https://example.com/video3.mp4', 15, 3, 0, 1),
(1, '光线运用', '如何利用自然光和人造光', 'https://example.com/video4.mp4', 18, 4, 0, 1),
(2, 'Lightroom界面介绍', '熟悉Lightroom的工作界面', 'https://example.com/video5.mp4', 12, 1, 1, 1),
(2, '基础调色技巧', '掌握基本的调色方法', 'https://example.com/video6.mp4', 20, 2, 0, 1),
(2, '人像精修方法', '专业人像照片精修技巧', 'https://example.com/video7.mp4', 25, 3, 0, 1);

-- 13. 初始化商城分类
INSERT IGNORE INTO `mall_category` (`name`, `parent_id`, `description`, `sort_order`, `status`) VALUES 
('摄影器材', 0, '相机、镜头等器材', 1, 1),
('配件', 0, '三脚架、滤镜等配件', 2, 1),
('书籍', 0, '摄影相关书籍', 3, 1),
('周边', 0, '摄影周边产品', 4, 1);

-- 14. 初始化商城商品数据
INSERT IGNORE INTO `mall_goods` (`name`, `description`, `cover_image`, `images`, `category_id`, `price`, `original_price`, `stock`, `sales`, `status`) VALUES 
('专业相机包', '防水防震，适合单反相机和镜头', 'https://picsum.photos/seed/goods1/400/300', '["https://picsum.photos/seed/goods1-1/800/600"]', 1, 500, 800, 50, 12, 1),
('三脚架', '铝合金材质，承重10kg，便携折叠', 'https://picsum.photos/seed/goods2/400/300', '["https://picsum.photos/seed/goods2-1/800/600"]', 2, 800, 1200, 30, 8, 1),
('摄影灯', 'LED补光灯，可调色温', 'https://picsum.photos/seed/goods3/400/300', '["https://picsum.photos/seed/goods3-1/800/600"]', 2, 600, 900, 40, 15, 1),
('Lightroom软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods4/400/300', '["https://picsum.photos/seed/goods4-1/800/600"]', 3, 1200, 1800, 100, 23, 1),
('Photoshop软件', '正版授权，终身使用', 'https://picsum.photos/seed/goods5/400/300', '["https://picsum.photos/seed/goods5-1/800/600"]', 3, 1500, 2200, 80, 18, 1),
('摄影T恤', '纯棉材质，舒适透气', 'https://picsum.photos/seed/goods6/400/300', '["https://picsum.photos/seed/goods6-1/800/600"]', 4, 300, 500, 100, 45, 1),
('摄影徽章', '限量版金属徽章', 'https://picsum.photos/seed/goods7/400/300', '["https://picsum.photos/seed/goods7-1/800/600"]', 4, 150, 250, 200, 67, 1),
('摄影笔记本', '高品质笔记本，适合记录灵感', 'https://picsum.photos/seed/goods8/400/300', '["https://picsum.photos/seed/goods8-1/800/600"]', 4, 200, 350, 150, 34, 1);

-- 15. 初始化积分记录数据
INSERT IGNORE INTO `points_record` (`user_id`, `points`, `type`, `description`, `balance`, `ref_id`) VALUES 
(2, 10, 1, '注册用户', 10, NULL),
(2, 5, 2, '发布帖子', 15, 1),
(2, 2, 3, '发表评论', 17, 1),
(2, 1, 4, '获得点赞', 18, NULL),
(2, 5, 7, '每日签到', 23, NULL),
(3, 10, 1, '注册用户', 10, NULL),
(3, 5, 2, '发布帖子', 15, 2),
(4, 10, 1, '注册用户', 10, NULL),
(4, 5, 2, '发布帖子', 15, 3),
(1, 100, 8, '管理员奖励', 100999, NULL);

-- 16. 初始化兑换记录数据
INSERT IGNORE INTO `exchange_record` (`user_id`, `goods_id`, `goods_name`, `points`, `quantity`, `address_id`, `status`, `remark`) VALUES 
(2, 1, '专业相机包', 500, 1, NULL, 2, '请尽快发货'),
(3, 4, 'Lightroom软件', 1200, 1, NULL, 1, ''),
(4, 7, '摄影徽章', 150, 2, NULL, 0, '希望有赠品');

-- 17. 初始化话题数据
INSERT IGNORE INTO `topic` (`name`, `description`, `post_count`, `status`) VALUES 
('每日一图', '分享你每天拍摄的精彩照片', 0, 1),
('摄影技巧', '交流摄影技巧和经验', 0, 1),
('器材讨论', '讨论摄影器材使用心得', 0, 1),
('作品点评', '互相点评摄影作品', 0, 1),
('后期分享', '分享后期处理技巧', 0, 1);

-- 18. 初始化系统配置数据
INSERT IGNORE INTO `sys_config` (`key`, `value`, `description`, `type`, `status`) VALUES 
('site_name', '摄友圈', '网站名称', 1, 1),
('site_description', '专业摄影爱好者社区', '网站描述', 1, 1),
('points_register', '10', '注册获得积分', 2, 1),
('points_post', '5', '发帖获得积分', 2, 1),
('points_comment', '2', '评论获得积分', 2, 1),
('points_like', '1', '点赞获得积分', 2, 1),
('points_daily_login', '5', '每日登录积分', 2, 1);

-- 19. 初始化点赞记录数据
INSERT IGNORE INTO `like_record` (`user_id`, `target_id`, `target_type`) VALUES 
(2, 1, 1), -- 点赞帖子1
(3, 1, 1), -- 点赞帖子1
(4, 1, 1), -- 点赞帖子1
(2, 2, 1), -- 点赞帖子2
(3, 2, 1), -- 点赞帖子2
(2, 1, 3), -- 点赞作品1
(3, 2, 3), -- 点赞作品2
(4, 3, 3); -- 点赞作品3

-- 20. 初始化收藏记录数据
INSERT IGNORE INTO `collect_record` (`user_id`, `target_id`, `target_type`) VALUES 
(2, 1, 1), -- 收藏帖子1
(3, 2, 1), -- 收藏帖子2
(2, 1, 2), -- 收藏作品1
(3, 2, 2), -- 收藏作品2
(4, 3, 2); -- 收藏作品3

-- 21. 初始化用户课程数据
INSERT IGNORE INTO `user_course` (`user_id`, `course_id`, `progress`, `last_chapter_id`, `status`) VALUES 
(2, 1, 50, 2, 1), -- 摄影师小王学习摄影入门完全指南，进度50%
(3, 2, 30, 2, 1), -- 摄影达人学习Lightroom后期精讲，进度30%
(4, 1, 100, 4, 2); -- 风光摄影师完成摄影入门完全指南，进度100%

-- 22. 初始化收货地址数据
INSERT IGNORE INTO `user_address` (`user_id`, `receiver`, `phone`, `province`, `city`, `district`, `detail`, `is_default`) VALUES 
(2, '王小明', '13800138001', '上海市', '浦东新区', '陆家嘴街道', '世纪大道100号', 1),
(3, '李小红', '13900139002', '浙江省', '杭州市', '西湖区', '文三路456号', 1),
(4, '张小刚', '13700137003', '广东省', '广州市', '天河区', '体育东路789号', 1);

-- 23. 初始化订单数据
INSERT IGNORE INTO `order` (`order_no`, `user_id`, `item_id`, `item_type`, `item_name`, `quantity`, `amount`, `discount_amount`, `pay_amount`, `pay_method`, `pay_time`, `status`) VALUES 
('20240101123456', 2, 2, 2, '三脚架', 1, 800, 0, 800, 2, '2024-01-01 12:34:56', 1),
('20240102234567', 3, 4, 2, 'Lightroom软件', 1, 1200, 0, 1200, 1, '2024-01-02 23:45:67', 1),
('20240103345678', 4, 7, 2, '摄影徽章', 2, 300, 0, 300, 3, NULL, 0);

-- 24. 初始化签到数据
INSERT IGNORE INTO `sign_in` (`user_id`, `sign_date`, `points`, `continuous_days`) VALUES 
(2, CURDATE() - INTERVAL 1 DAY, 5, 1),
(3, CURDATE() - INTERVAL 1 DAY, 5, 1),
(4, CURDATE() - INTERVAL 1 DAY, 5, 1),
(2, CURDATE(), 5, 2);

-- 25. 初始化通知数据
INSERT IGNORE INTO `notification` (`user_id`, `type`, `title`, `content`, `target_id`, `target_type`) VALUES 
(2, 1, '点赞通知', '有人点赞了你的帖子', 1, 1),
(2, 2, '评论通知', '有人评论了你的帖子', 1, 1),
(3, 1, '点赞通知', '有人点赞了你的作品', 2, 3),
(4, 3, '关注通知', '有人关注了你', 2, 1);

-- 26. 初始化文件记录数据
INSERT IGNORE INTO `file_record` (`original_name`, `file_name`, `file_path`, `file_size`, `file_type`, `mime_type`, `hash`, `uploader_id`, `uploader_type`, `business_type`, `is_public`) VALUES 
('avatar1.jpg', 'avatar1_20240101.jpg', '/uploads/shengyouquan/avatar/avatar1_20240101.jpg', 102400, 'image/jpeg', 'image/jpeg', 'abc123', 2, 1, 'avatar', 1),
('avatar2.jpg', 'avatar2_20240101.jpg', '/uploads/shengyouquan/avatar/avatar2_20240101.jpg', 153600, 'image/jpeg', 'image/jpeg', 'def456', 3, 1, 'avatar', 1),
('avatar3.jpg', 'avatar3_20240101.jpg', '/uploads/shengyouquan/avatar/avatar3_20240101.jpg', 122880, 'image/jpeg', 'image/jpeg', 'ghi789', 4, 1, 'avatar', 1);

-- 数据初始化完成！