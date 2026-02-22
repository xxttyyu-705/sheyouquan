-- 创建 points 表（与实体 Point 对应，解决 Table 'shengyouquan.points' doesn't exist）
-- 积分流水表：type 1=获得 2=消耗，用于商城积分余额与历史
-- 执行方式：mysql -u root -p shengyouquan < create_points.sql

USE shengyouquan;

DROP TABLE IF EXISTS `points`;

CREATE TABLE `points` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `points` int(11) NOT NULL COMMENT '积分数量',
  `reason` varchar(500) DEFAULT NULL COMMENT '原因/描述',
  `type` tinyint(4) NOT NULL COMMENT '类型: 1-获得, 2-消耗',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分流水表(商城)';
