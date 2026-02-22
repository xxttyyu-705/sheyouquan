-- 将 sys_user.points 与 points 表流水汇总结果对齐（修复历史数据）
-- 执行前请备份数据库。执行方式：mysql -u root -p shengyouquan < fix_sys_user_points_from_points_table.sql

USE shengyouquan;

-- 1. 用 points 表按用户汇总余额，更新到 sys_user.points（type=1 获得加，type=2 消耗减）
UPDATE sys_user u
INNER JOIN (
  SELECT
    user_id,
    SUM(CASE WHEN type = 1 THEN points ELSE -points END) AS balance
  FROM points
  GROUP BY user_id
) p ON u.id = p.user_id
SET u.points = p.balance;

-- 2. 对在 points 表中没有任何流水的用户，将积分置为 0（与“以 sys_user.points 为准”一致）
UPDATE sys_user u
LEFT JOIN (SELECT DISTINCT user_id FROM points) p ON u.id = p.user_id
SET u.points = 0
WHERE p.user_id IS NULL;
