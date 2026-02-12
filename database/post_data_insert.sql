-- 帖子表测试数据
-- 基于提供的表结构，包含 title 字段以及兼容的 count 字段

INSERT INTO `post` 
(`user_id`, `title`, `content`, `images`, `videos`, `location`, `privacy`, `topic_id`, `views`, `likes`, `comments`, `like_count`, `comment_count`, `share_count`, `view_count`, `status`, `create_time`) 
VALUES 
(2, '魔都的夜景永远看不腻', '今晚的外滩灯光璀璨，随手一拍就是大片。#夜景 #上海', '["https://picsum.photos/seed/shanghai/800/600", "https://picsum.photos/seed/night/800/600"]', NULL, '上海市·外滩', 0, 1, 1250, 88, 15, 88, 15, 10, 1250, 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, '人像摄影中的光影艺术', '利用自然光拍摄人像，关键在于寻找光线的方向。这张是在下午四点左右拍摄的，逆光效果很棒。', '["https://picsum.photos/seed/portrait/800/600"]', NULL, '杭州市·西湖', 0, 2, 3400, 210, 45, 210, 45, 32, 3400, 1, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, '新入手的索尼A7M4开箱', '终于等到你！对焦速度真的提升巨大，视频能力也很强。周末去试拍！', '["https://picsum.photos/seed/camera/800/600", "https://picsum.photos/seed/lens/800/600"]', NULL, '北京市·朝阳区', 0, 3, 5600, 320, 88, 320, 88, 15, 5600, 1, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(2, '街头偶遇的小确幸', '在弄堂里发现的一家很有特色的小店，猫咪很粘人。', '["https://picsum.photos/seed/cat/800/600"]', NULL, '上海市·静安区', 0, 1, 890, 56, 12, 56, 12, 5, 890, 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, '日系小清新后期调色分享', '很多人问这张照片怎么调的，其实很简单。降低对比度，提高亮度，色温偏蓝一点...详细参数见评论。', '["https://picsum.photos/seed/color/800/600"]', NULL, '杭州市', 0, 5, 2100, 150, 60, 150, 60, 45, 2100, 1, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(4, '黄山云海，美不胜收', '运气爆棚，爬山遇到了难得一见的云海奇观。大自然的鬼斧神工令人敬畏。', '["https://picsum.photos/seed/mountain/800/600", "https://picsum.photos/seed/cloud/800/600"]', NULL, '黄山风景区', 0, 1, 4500, 420, 56, 420, 56, 88, 4500, 1, DATE_SUB(NOW(), INTERVAL 1 WEEK));
