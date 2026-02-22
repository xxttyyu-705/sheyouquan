-- 创建 exchange_records 表（与实体 ExchangeRecord 对应，解决 Table 'shengyouquan.exchange_records' doesn't exist）
-- 在 MySQL 中执行：USE shengyouquan; 然后执行本脚本，或 mysql -u root -p shengyouquan < create_exchange_records.sql

USE shengyouquan;

DROP TABLE IF EXISTS `exchange_records`;

CREATE TABLE `exchange_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `product_name` varchar(200) NOT NULL COMMENT '商品名称',
  `points` int(11) NOT NULL COMMENT '消耗积分',
  `address` varchar(500) DEFAULT NULL COMMENT '收货地址',
  `phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态: 0-待处理, 1-已发货, 2-已完成, 3-已取消',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分商城兑换记录表';
