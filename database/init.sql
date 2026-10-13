/*
Navicat MySQL Data Transfer

Source Server         : daaa
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : fssoa-net

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2026-10-13 22:19:56
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `casbin_rule`
-- ----------------------------
DROP TABLE IF EXISTS `casbin_rule`;
CREATE TABLE `casbin_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ptype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '策略类型: p(权限) / g(角色继承) / g2(部门继承)',
  `v0` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第1个参数: 用户ID/角色ID/部门ID',
  `v1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第2个参数: 资源/角色/部门',
  `v2` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第3个参数: 操作/动作',
  `v3` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第4个参数: 扩展字段',
  `v4` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第5个参数: 扩展字段',
  `v5` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '第6个参数: 扩展字段',
  PRIMARY KEY (`id`),
  KEY `idx_ptype` (`ptype`),
  KEY `idx_v0` (`v0`),
  KEY `idx_v1` (`v1`),
  KEY `idx_v0_v1` (`v0`,`v1`)
) ENGINE=InnoDB AUTO_INCREMENT=2431 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Casbin权限规则表';

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES ('886', 'p', '1', '/api/api/core/system/user', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1196', 'p', 'ceo', '/api/core/console', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1197', 'p', 'ceo', '/api/core/console/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1198', 'p', 'ceo', '/api/core/console/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1202', 'g', '105', 'ceo', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1204', 'g', '101', 'ceo', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1278', 'p', 'JTCEO', '/api/core/console', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1279', 'p', 'JTCEO', '/api/core/console/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1280', 'p', 'JTCEO', '/api/core/console/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1281', 'p', 'JTCEO', '/api/tool/crontab', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1282', 'p', 'JTCEO', '/api/tool/crontab', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1283', 'p', 'JTCEO', '/api/tool/crontab', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1284', 'p', 'JTCEO', '/api/tool/code', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1285', 'p', 'JTCEO', '/api/tool/code', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1544', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1545', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1546', 'p', '2', '/api/core/user', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1547', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1548', 'p', '2', '/api/core/user', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1549', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1550', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1551', 'p', '2', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1552', 'p', '2', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1553', 'p', '2', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1554', 'p', '2', '/api/core/dept', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1555', 'p', '2', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1556', 'p', '2', '/api/core/dept', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1557', 'p', '2', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1558', 'p', '2', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1559', 'p', '2', '/api/core/role', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1560', 'p', '2', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1561', 'p', '2', '/api/core/role', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1562', 'p', '2', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1563', 'p', '2', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1564', 'p', '2', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1565', 'p', '2', '/api/core/post', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1566', 'p', '2', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1567', 'p', '2', '/api/core/post', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1568', 'p', '2', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1569', 'p', '2', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1570', 'p', '2', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1571', 'p', '2', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1572', 'p', '2', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1573', 'p', '2', '/api/core/menu', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1574', 'p', '2', '/api/core/menu', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1575', 'p', '2', '/api/core/config', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1576', 'p', '2', '/api/core/config', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1577', 'p', '2', '/api/core/config', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1578', 'p', '2', '/api/core/dict', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1579', 'p', '2', '/api/core/dict', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1580', 'p', '2', '/api/core/attachment', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1581', 'p', '2', '/api/core/attachment', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1582', 'p', '2', '/api/core/database', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1583', 'p', '2', '/api/core/database', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1584', 'p', '2', '/api/core/recycle', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1585', 'p', '2', '/api/core/recycle', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1586', 'p', '2', '/api/core/logs', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1587', 'p', '2', '/api/core/logs', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1588', 'p', '2', '/api/core/logs', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1589', 'p', '2', '/api/core/logs', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1590', 'p', '2', '/api/core/email', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1591', 'p', '2', '/api/core/email', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1592', 'p', '2', '/api/core/server', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1593', 'p', '2', '/api/core/server', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1594', 'p', '2', '/api/core/server', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1595', 'p', '2', '/api/core/console', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1596', 'p', '2', '/api/core/console/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1597', 'p', '2', '/api/core/console/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1598', 'p', '2', '/api/tool/crontab', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1599', 'p', '2', '/api/tool/crontab', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1600', 'p', '2', '/api/tool/crontab', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1601', 'p', '2', '/api/tool/code', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1602', 'p', '2', '/api/tool/code', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1603', 'p', '2', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1604', 'p', '2', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1605', 'p', '2', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1606', 'p', '2', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1607', 'p', '2', '/api/core/tenant', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1608', 'p', '2', '/api/core/tenant', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1609', 'p', '2', '/api/core/server', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1610', 'p', '2', '/flow', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1611', 'p', '2', '/api/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1612', 'p', '2', '/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1613', 'p', '2', '/flow/category/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1614', 'p', '2', '/api/flow/template', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1615', 'p', '2', '/flow/template', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1616', 'p', '2', '/flow/template/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1617', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1618', 'p', '2', '/flow/instance/my-started', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1619', 'p', '2', '/flow/instance/my-started/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1620', 'p', '2', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1621', 'p', '2', '/flow/task/pending', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1622', 'p', '2', '/flow/task/pending/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1623', 'p', '2', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1624', 'p', '2', '/flow/task/completed', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1625', 'p', '2', '/flow/task/completed/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1626', 'p', '2', '/api/flow/template', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1627', 'p', '2', '/flow/template/design/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1628', 'p', '2', '/flow/template/design/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1629', 'p', '2', '/api/flow/template', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1630', 'p', '2', '/flow/template/form-design/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1631', 'p', '2', '/flow/template/form-design/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1632', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1633', 'p', '2', '/flow/instance/start/:templateId', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1634', 'p', '2', '/flow/instance/start/:templateId/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1635', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1636', 'p', '2', '/flow/instance/detail/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1637', 'p', '2', '/flow/instance/detail/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1638', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1639', 'p', '2', '/flow/form/leave-request', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1640', 'p', '2', '/flow/form/leave-request/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1641', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1642', 'p', '2', '/flow/form/expense-claim', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1643', 'p', '2', '/flow/form/expense-claim/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1644', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1645', 'p', '2', '/flow/form/purchase-request', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1646', 'p', '2', '/flow/form/purchase-request/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1647', 'p', '2', '/api/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1648', 'p', '2', '/api/flow/category', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1649', 'p', '2', '/api/flow/category', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1650', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1651', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1652', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1653', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1654', 'p', '2', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1655', 'p', '2', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1656', 'p', '2', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1657', 'p', '2', '/flow/task/copy-me', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1658', 'p', '2', '/flow/task/copy-me/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1659', 'g', '2', 'ceo', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1791', 'g', '119', 'ceo', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1792', 'g', '120', 'bg_president', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1793', 'g', '121', 'gm', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1839', 'g', '123', 'ceo', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1840', 'g', '122', 'bg_president', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2111', 'g', '10', 'staff', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2132', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2133', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2134', 'p', '100', '/api/core/user', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2135', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2136', 'p', '100', '/api/core/user', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2137', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2138', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2139', 'p', '100', '/api/core/user', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2140', 'p', '100', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2141', 'p', '100', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2142', 'p', '100', '/api/core/dept', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2143', 'p', '100', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2144', 'p', '100', '/api/core/dept', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2145', 'p', '100', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2146', 'p', '100', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2147', 'p', '100', '/api/core/role', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2148', 'p', '100', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2149', 'p', '100', '/api/core/role', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2150', 'p', '100', '/api/core/role', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2151', 'p', '100', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2152', 'p', '100', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2153', 'p', '100', '/api/core/post', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2154', 'p', '100', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2155', 'p', '100', '/api/core/post', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2156', 'p', '100', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2157', 'p', '100', '/api/core/post', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2158', 'p', '100', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2159', 'p', '100', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2160', 'p', '100', '/api/core/menu', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2161', 'p', '100', '/api/core/menu', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2162', 'p', '100', '/api/core/menu', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2163', 'p', '100', '/api/core/config', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2164', 'p', '100', '/api/core/config', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2165', 'p', '100', '/api/core/config', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2166', 'p', '100', '/api/core/console', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2167', 'p', '100', '/api/core/console/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2168', 'p', '100', '/api/core/console/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2169', 'p', '100', '/api/core/dept', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2170', 'p', '100', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2171', 'p', '100', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2172', 'p', '100', '/api/core/tenant', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2173', 'p', '100', '/api/core/tenant', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2174', 'p', '100', '/api/core/tenant', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2175', 'p', '100', '/template', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2176', 'p', '100', '/flow', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2177', 'p', '100', '/api/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2178', 'p', '100', '/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2179', 'p', '100', '/flow/category/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2180', 'p', '100', '/api/flow/template', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2181', 'p', '100', '/flow/template', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2182', 'p', '100', '/flow/template/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2183', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2184', 'p', '100', '/flow/instance/my-started', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2185', 'p', '100', '/flow/instance/my-started/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2186', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2187', 'p', '100', '/flow/task/pending', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2188', 'p', '100', '/flow/task/pending/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2189', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2190', 'p', '100', '/flow/task/completed', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2191', 'p', '100', '/flow/task/completed/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2192', 'p', '100', '/api/flow/template', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2193', 'p', '100', '/flow/template/design/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2194', 'p', '100', '/flow/template/design/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2195', 'p', '100', '/api/flow/template', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2196', 'p', '100', '/flow/template/form-design/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2197', 'p', '100', '/flow/template/form-design/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2198', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2199', 'p', '100', '/flow/instance/start/:templateId', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2200', 'p', '100', '/flow/instance/start/:templateId/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2201', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2202', 'p', '100', '/flow/instance/detail/:id', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2203', 'p', '100', '/flow/instance/detail/:id/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2204', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2205', 'p', '100', '/flow/form/leave-request', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2206', 'p', '100', '/flow/form/leave-request/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2207', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2208', 'p', '100', '/flow/form/expense-claim', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2209', 'p', '100', '/flow/form/expense-claim/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2210', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2211', 'p', '100', '/flow/form/purchase-request', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2212', 'p', '100', '/flow/form/purchase-request/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2213', 'p', '100', '/api/flow/category', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2214', 'p', '100', '/api/flow/category', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2215', 'p', '100', '/api/flow/category', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2216', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2217', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2218', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2219', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2220', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2221', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2222', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2223', 'p', '100', '/flow/task/copy-me', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2224', 'p', '100', '/flow/task/copy-me/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2225', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2226', 'p', '100', '/flow/task/reverted-canceled', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2227', 'p', '100', '/flow/task/reverted-canceled/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2228', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2229', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2230', 'p', '100', '/api/flow/task', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2231', 'p', '100', '/api/flow/instance', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2232', 'p', '100', '/flow/instance/resubmit/:instanceId', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2233', 'p', '100', '/flow/instance/resubmit/:instanceId/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2234', 'p', '100', '/api/flow/center', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2235', 'p', '100', '/flow/center', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2236', 'p', '100', '/flow/center/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2237', 'p', '100', '/api/flow/delegate', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2238', 'p', '100', '/flow/delegate', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2239', 'p', '100', '/flow/delegate/*', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2240', 'p', '100', '/api/flow/delegate', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2241', 'p', '100', '/api/flow/delegate', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2242', 'p', '100', '/api/flow/delegate', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2243', 'p', '100', '/api/flow/delegate', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2244', 'p', '100', '/api/flow/message', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2245', 'p', '100', '/flow/message', '*', '', '', '');
INSERT INTO `casbin_rule` VALUES ('2246', 'p', '100', '/flow/message/*', '*', '', '', '');

-- ----------------------------
-- Table structure for `migrations`
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of migrations
-- ----------------------------
INSERT INTO `migrations` VALUES ('1', '1782230400000', 'CreateTaixuTables1782230400000');
INSERT INTO `migrations` VALUES ('2', '1782319590380', 'CreateTaixuUserProfile1782319590380');

-- ----------------------------
-- Table structure for `platform_video`
-- ----------------------------
DROP TABLE IF EXISTS `platform_video`;
CREATE TABLE `platform_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `url` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始视频链接',
  `title` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `uploader` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传作者',
  `description` mediumtext COLLATE utf8mb4_unicode_ci COMMENT '视频描述',
  `source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '来源(youtube/bilibili等)',
  `best_resolution` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最佳分辨率',
  `thumbnail` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '缩略图URL',
  `duration` int(11) DEFAULT NULL COMMENT '时长(秒)',
  `info_json` json DEFAULT NULL COMMENT 'yt-dlp完整JSON',
  `status` int(11) NOT NULL COMMENT '元数据状态(0未获取1成功-1失败)',
  `error_msg` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '元数据失败原因',
  `local_dir` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近成功下载目录',
  `active_job_id` int(11) DEFAULT NULL COMMENT '当前活跃下载任务ID',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `tenant_id` int(11) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`),
  KEY `ix_platform_video_status` (`status`),
  KEY `ix_platform_video_tenant_id` (`tenant_id`)
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='视频元数据表';

-- ----------------------------
-- Records of platform_video
-- ----------------------------
INSERT INTO `platform_video` VALUES ('57', 'https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click', '寻找世界上最大的章鱼，口感居然如此软糯！', '不良玩家IPFM', null, 'BiliBili', '1920x1080', 'http://i2.hdslb.com/bfs/archive/8c19c1df230faf5670f62fa5fb6a7ad572fb4de1.jpg', '557', '{\"id\": \"BV1N5Hk6JErG\", \"ext\": \"mp4\", \"title\": \"寻找世界上最大的章鱼，口感居然如此软糯！\", \"width\": 1920, \"height\": 1080, \"formats\": [{\"abr\": 65.573, \"ext\": \"m4a\", \"tbr\": 65.573, \"url\": \"https://xy113x207x104x13xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30216.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=65656&cdnid=6591&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=696517&traceid=trHLXNuEKDToYo_0_e_N&uipk=5&uparams=e%2Cnbs%2Coi%2Cdeadline%2Cuipk%2Cgen%2Cos%2Cog%2Ctrid%2Cplatform%2Cmid&upsig=0fcd7f7cd67f386f1a7a846e88004685\", \"vbr\": 0, \"acodec\": \"mp4a.40.2\", \"format\": \"30216 - audio only\", \"vcodec\": \"none\", \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"m4a\", \"format_id\": \"30216\", \"video_ext\": \"none\", \"resolution\": \"audio only\", \"aspect_ratio\": null, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"filesize_approx\": 4569897}, {\"abr\": 91.33, \"ext\": \"m4a\", \"tbr\": 91.33, \"url\": \"https://xy106x117x209x8xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30232.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=91438&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=hwo1bv&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=3ab000&traceid=treQfzDphztkbJ_0_e_N&uipk=5&uparams=e%2Cplatform%2Cnbs%2Coi%2Ctrid%2Cdeadline%2Cuipk%2Cmid%2Cgen%2Cos%2Cog&upsig=c060f3eb571bb0da17de79aa923db751\", \"vbr\": 0, \"acodec\": \"mp4a.40.2\", \"format\": \"30232 - audio only\", \"vcodec\": \"none\", \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"m4a\", \"format_id\": \"30232\", \"video_ext\": \"none\", \"resolution\": \"audio only\", \"aspect_ratio\": null, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"filesize_approx\": 6364947}, {\"abr\": 116.372, \"ext\": \"m4a\", \"tbr\": 116.372, \"url\": \"https://xy116x196x140x58xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30280.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=116503&cdnid=6591&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=f336be&traceid=trRpXpklvDsbQU_0_e_N&uipk=5&uparams=e%2Cgen%2Cos%2Coi%2Ctrid%2Cuipk%2Cog%2Cdeadline%2Cplatform%2Cmid%2Cnbs&upsig=b4b999d8f77362c391ba44e659b4a314\", \"vbr\": 0, \"acodec\": \"mp4a.40.2\", \"format\": \"30280 - audio only\", \"vcodec\": \"none\", \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"m4a\", \"format_id\": \"30280\", \"video_ext\": \"none\", \"resolution\": \"audio only\", \"aspect_ratio\": null, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"filesize_approx\": 8110168}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 728.79, \"url\": \"https://cn-zjjh-ct-04-06.bilivideo.com/upgcxcode/99/75/42445637599/42445637599-1-30016.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&oi=248802347&uipk=5&platform=pc&mid=0&nbs=1&os=bcache&og=cos&trid=00004b6cca2a63024fb88dd34b9e963257cu&deadline=1791903743&gen=playurlv3&upsig=1b23b50dc67e6734b1e7aa200b223ed1&uparams=e,oi,uipk,platform,mid,nbs,os,og,trid,deadline,gen&cdnid=6591&bvc=vod&nettype=0&bw=729443&lrs=13&agrr=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&build=0&dl=0&f=u_0_0&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&orderid=0,3\", \"vbr\": 728.79, \"width\": 640, \"acodec\": \"none\", \"format\": \"360P 流畅\", \"height\": 360, \"vcodec\": \"avc1.64001E\", \"quality\": 16, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30016\", \"video_ext\": \"mp4\", \"resolution\": \"640x360\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 50790650}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 391.203, \"url\": \"https://xy116x196x155x21xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30011.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=391562&cdnid=6588&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=cos&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=1be7a7&traceid=trwmVzyglSowau_0_e_N&uipk=5&uparams=e%2Cos%2Cog%2Coi%2Ctrid%2Cuipk%2Cplatform%2Cmid%2Cnbs%2Cdeadline%2Cgen&upsig=28c0e1c7713fa2f6ef811222566a38dc\", \"vbr\": 391.203, \"width\": 640, \"acodec\": \"none\", \"format\": \"360P 流畅\", \"height\": 360, \"vcodec\": \"hvc1.1.6.L120.90\", \"quality\": 16, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30011\", \"video_ext\": \"mp4\", \"resolution\": \"640x360\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 27263621}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 421.685, \"url\": \"https://xy120x220x70x21xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-100022.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=422071&cdnid=6588&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=1c8bcd&traceid=trSTiiaoqunPkr_0_e_N&uipk=5&uparams=e%2Cplatform%2Cnbs%2Cos%2Cog%2Cuipk%2Cmid%2Coi%2Ctrid%2Cdeadline%2Cgen&upsig=4733962918f7d079a06cf948c47c2f87\", \"vbr\": 421.685, \"width\": 640, \"acodec\": \"none\", \"format\": \"360P 流畅\", \"height\": 360, \"vcodec\": \"av01.0.08M.08.0.110.01.01.01.0\", \"quality\": 16, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"100022\", \"video_ext\": \"mp4\", \"resolution\": \"640x360\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 29387965}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 840.934, \"url\": \"https://xy116x196x147x78xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30032.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=841684&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=cos&oi=248802347&orderid=0%2C3&os=coso1bv&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=590336&traceid=trIHTUfRcnOjfH_0_e_N&uipk=5&uparams=e%2Coi%2Ctrid%2Cuipk%2Cplatform%2Cmid%2Cgen%2Cos%2Cog%2Cdeadline%2Cnbs&upsig=266be918e30f5e68bdb8920524b66ef8\", \"vbr\": 840.934, \"width\": 852, \"acodec\": \"none\", \"format\": \"480P 标清\", \"height\": 480, \"vcodec\": \"avc1.64001F\", \"quality\": 32, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30032\", \"video_ext\": \"mp4\", \"resolution\": \"852x480\", \"aspect_ratio\": 1.77, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 58606162}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 638.207, \"url\": \"https://xy58x19x174x138xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30033.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=638780&cdnid=6588&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=ali&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=33378e&traceid=trNzWPYtLZNUZr_0_e_N&uipk=5&uparams=e%2Cplatform%2Cmid%2Ctrid%2Cdeadline%2Cgen%2Cuipk%2Cnbs%2Coi%2Cos%2Cog&upsig=560395e28e59d1426d55b0cc1b91874f\", \"vbr\": 638.207, \"width\": 852, \"acodec\": \"none\", \"format\": \"480P 标清\", \"height\": 480, \"vcodec\": \"hvc1.1.6.L120.90\", \"quality\": 32, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30033\", \"video_ext\": \"mp4\", \"resolution\": \"852x480\", \"aspect_ratio\": 1.77, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 44477762}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 638.29, \"url\": \"https://xy116x196x140x7xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-100023.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=638864&cdnid=6588&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=cos&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=2aeb07&traceid=trzLxrPlFvegVU_0_e_N&uipk=5&uparams=e%2Ctrid%2Cdeadline%2Cuipk%2Cmid%2Cgen%2Cplatform%2Cnbs%2Cos%2Cog%2Coi&upsig=8f9252ea71b066f68106b0449a4b75a3\", \"vbr\": 638.29, \"width\": 852, \"acodec\": \"none\", \"format\": \"480P 标清\", \"height\": 480, \"vcodec\": \"av01.0.08M.08.0.110.01.01.01.0\", \"quality\": 32, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"100023\", \"video_ext\": \"mp4\", \"resolution\": \"852x480\", \"aspect_ratio\": 1.77, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 44483547}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 1741.874, \"url\": \"https://upos-sz-mirrorcoso1.bilivideo.com/upgcxcode/99/75/42445637599/42445637599-1-30064.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&os=coso1bv&oi=248802347&platform=pc&nbs=1&og=cos&trid=4b6cca2a63024fb88dd34b9e963257cu&deadline=1791903743&uipk=5&mid=0&gen=playurlv3&upsig=afa6cabbd9335267bf57878e9ff50e33&uparams=e,os,oi,platform,nbs,og,trid,deadline,uipk,mid,gen&bvc=vod&nettype=0&bw=1743406&lrs=13&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&agrr=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&build=0&dl=0&f=u_0_0&orderid=0,3\", \"vbr\": 1741.874, \"width\": 1280, \"acodec\": \"none\", \"format\": \"720P 准高清\", \"height\": 720, \"vcodec\": \"avc1.640028\", \"quality\": 64, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30064\", \"video_ext\": \"mp4\", \"resolution\": \"1280x720\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 121394247}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 1187.806, \"url\": \"https://xy36x156x63x29xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30066.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=1188857&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=hwbv&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=784976&traceid=trFgkgDZqxiOem_0_e_N&uipk=5&uparams=e%2Coi%2Cgen%2Cuipk%2Cplatform%2Cmid%2Cnbs%2Ctrid%2Cdeadline%2Cos%2Cog&upsig=4d5dca474e570927de7cb30e95049844\", \"vbr\": 1187.806, \"width\": 1280, \"acodec\": \"none\", \"format\": \"720P 准高清\", \"height\": 720, \"vcodec\": \"hvc1.1.6.L120.90\", \"quality\": 64, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30066\", \"video_ext\": \"mp4\", \"resolution\": \"1280x720\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 82780278}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 1197.659, \"url\": \"https://cn-zjjh-ct-04-06.bilivideo.com/upgcxcode/99/75/42445637599/42445637599-1-100024.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&platform=pc&nbs=1&os=bcache&og=hw&mid=0&gen=playurlv3&oi=248802347&trid=00004b6cca2a63024fb88dd34b9e963257cu&deadline=1791903743&uipk=5&upsig=b005cc5e22705e1996e576cf2b8745e8&uparams=e,platform,nbs,os,og,mid,gen,oi,trid,deadline,uipk&cdnid=6591&bvc=vod&nettype=0&bw=1198718&lrs=13&agrr=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&build=0&dl=0&f=u_0_0&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&orderid=0,3\", \"vbr\": 1197.659, \"width\": 1280, \"acodec\": \"none\", \"format\": \"720P 准高清\", \"height\": 720, \"vcodec\": \"av01.0.08M.08.0.110.01.01.01.0\", \"quality\": 64, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"100024\", \"video_ext\": \"mp4\", \"resolution\": \"1280x720\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 83466951}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 4047.044, \"url\": \"https://xy113x207x85x214xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30080.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=4050576&cdnid=6591&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=hw&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=8f1819&traceid=trJkNyaMMRmtqo_0_e_N&uipk=5&uparams=e%2Cnbs%2Ctrid%2Cuipk%2Cgen%2Cos%2Cplatform%2Cmid%2Coi%2Cdeadline%2Cog&upsig=4d435bc4fdd716dd523a8cddea838e0a\", \"vbr\": 4047.044, \"width\": 1920, \"acodec\": \"none\", \"format\": \"1080P 高清\", \"height\": 1080, \"vcodec\": \"avc1.640032\", \"quality\": 80, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30080\", \"video_ext\": \"mp4\", \"resolution\": \"1920x1080\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 282045578}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 2586.574, \"url\": \"https://xy122x191x72x6xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-30077.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=2588838&cdnid=6591&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=cos&oi=248802347&orderid=0%2C3&os=bcache&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=82bd6d&traceid=trRhUMUDcObCFM_0_e_N&uipk=5&uparams=e%2Cuipk%2Cgen%2Cog%2Cmid%2Coi%2Cos%2Cplatform%2Cnbs%2Ctrid%2Cdeadline&upsig=71aed3d80772f6d272e217b1ab48c485\", \"vbr\": 2586.574, \"width\": 1920, \"acodec\": \"none\", \"format\": \"1080P 高清\", \"height\": 1080, \"vcodec\": \"hvc1.1.6.L150.90\", \"quality\": 80, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"30077\", \"video_ext\": \"mp4\", \"resolution\": \"1920x1080\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 180262868}, {\"abr\": 0, \"ext\": \"mp4\", \"fps\": 30.001, \"tbr\": 2632.647, \"url\": \"https://xy116x196x140x57xy.mcdn.bilivideo.cn:8082/v1/resource/upgcxcode/99/75/42445637599/42445637599-1-100026.m4s?agrr=0&build=0&buvid=5236798D-4DA0-63D0-7099-B42D7758E73342320infoc&bvc=vod&bw=2634952&deadline=1791903743&dl=0&e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M%3D&f=u_0_0&gen=playurlv3&lrs=13&mid=0&nbs=1&nettype=0&og=cos&oi=248802347&orderid=0%2C3&os=cosbv&platform=pc&qn_dyeid=90c290dd72629a3c001549a96ace2bdf&sign=2c5ad4&traceid=trjKhYLHGtckPS_0_e_N&uipk=5&uparams=e%2Coi%2Ctrid%2Cdeadline%2Cuipk%2Cnbs%2Cgen%2Cos%2Cplatform%2Cmid%2Cog&upsig=fb40cbd3055f185ba64d858e0cf642f7\", \"vbr\": 2632.647, \"width\": 1920, \"acodec\": \"none\", \"format\": \"1080P 高清\", \"height\": 1080, \"vcodec\": \"av01.0.08M.08.0.110.01.01.01.0\", \"quality\": 80, \"filesize\": null, \"protocol\": \"https\", \"audio_ext\": \"none\", \"format_id\": \"100026\", \"video_ext\": \"mp4\", \"resolution\": \"1920x1080\", \"aspect_ratio\": 1.78, \"http_headers\": {\"Accept\": \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\", \"Referer\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"User-Agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36\", \"Sec-Fetch-Mode\": \"navigate\", \"Accept-Language\": \"en-us,en;q=0.5\"}, \"dynamic_range\": \"SDR\", \"filesize_approx\": 183473776}], \"duration\": 557.534, \"uploader\": \"不良玩家IPFM\", \"thumbnail\": \"http://i2.hdslb.com/bfs/archive/8c19c1df230faf5670f62fa5fb6a7ad572fb4de1.jpg\", \"webpage_url\": \"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446&spm_id_from=333.1007.tianma.3-1-7.click\", \"extractor_key\": \"BiliBili\"}', '1', null, 'static\\videos\\57_47', '47', '2026-10-13 21:02:24', '2026-10-13 21:12:02', null);

-- ----------------------------
-- Table structure for `platform_video_download`
-- ----------------------------
DROP TABLE IF EXISTS `platform_video_download`;
CREATE TABLE `platform_video_download` (
  `video_id` int(11) NOT NULL COMMENT '关联视频',
  `mode` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'best/custom/audio/subs',
  `options_json` json DEFAULT NULL COMMENT '自定义下载选项',
  `status` int(11) NOT NULL COMMENT '任务状态',
  `progress` float NOT NULL COMMENT '进度0-100',
  `downloaded_bytes` bigint(20) NOT NULL COMMENT '已下载字节',
  `total_bytes` bigint(20) DEFAULT NULL COMMENT '总字节',
  `speed` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '下载速度',
  `eta` int(11) DEFAULT NULL COMMENT '剩余秒数',
  `error_msg` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '失败/停止原因',
  `local_dir` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '本次输出目录',
  `priority` int(11) NOT NULL COMMENT '优先级(越大越先)',
  `started_at` datetime DEFAULT NULL COMMENT '开始时间',
  `finished_at` datetime DEFAULT NULL COMMENT '结束时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `tenant_id` int(11) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`),
  KEY `ix_platform_video_download_status` (`status`),
  KEY `ix_platform_video_download_tenant_id` (`tenant_id`),
  KEY `ix_platform_video_download_video_id` (`video_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='视频下载任务表';

-- ----------------------------
-- Records of platform_video_download
-- ----------------------------
INSERT INTO `platform_video_download` VALUES ('5', 'custom', '{\"height\": 1080, \"format_id\": \"248\", \"audio_format\": \"249\"}', '3', '100', '5213283', '5213283', '5.86MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\特朗普出手机了！美国总统卖的手机有多离谱？Trump Phone 开箱_e4da3b', '0', '2026-07-19 11:53:27', '2026-07-19 11:54:18', '8', '2026-07-19 11:53:27', '2026-07-19 11:54:18', null);
INSERT INTO `platform_video_download` VALUES ('5', 'best', 'null', '3', '100', '25682', null, '72.78KiB/s', null, null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\特朗普出手机了！美国总统卖的手机有多离谱？Trump Phone 开箱_e4da3b', '0', '2026-07-19 11:55:20', '2026-07-19 11:55:28', '9', '2026-07-19 11:55:20', '2026-07-19 11:55:28', null);
INSERT INTO `platform_video_download` VALUES ('5', 'best', 'null', '3', '100', '25682', null, '246.11KiB/s', null, null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\特朗普出手机了！美国总统卖的手机有多离谱？Trump Phone 开箱_e4da3b', '0', '2026-07-19 12:02:42', '2026-07-19 12:02:53', '10', '2026-07-19 12:02:42', '2026-07-19 12:02:53', null);
INSERT INTO `platform_video_download` VALUES ('6', 'best', 'null', '3', '100', '0', null, null, null, null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\探秘韩国财阀超市！9个桃子20万！到底有多离谱？_167909', '0', '2026-07-19 12:03:28', '2026-07-19 12:03:34', '11', '2026-07-19 12:03:28', '2026-07-19 12:03:34', null);
INSERT INTO `platform_video_download` VALUES ('9', 'best', 'null', '3', '100', '190260581', '190260581', '9.81MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\台湾为何对大陆感情复杂？ 初三课文里竟藏着残酷真相_45c48c', '0', '2026-07-19 12:25:09', '2026-07-19 12:26:48', '12', '2026-07-19 12:25:08', '2026-07-19 12:26:48', null);
INSERT INTO `platform_video_download` VALUES ('10', 'best', 'null', '3', '100', '448251556', '595855284', '3.80MiB/s', '37', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\帝王厚黑学之明朝篇 _ 从乞丐到皇帝的史上最强逆袭 一口气看完《明太祖朱元璋》 全程高燃！_d3d944', '0', '2026-07-19 12:29:14', '2026-07-19 12:35:08', '13', '2026-07-19 12:29:13', '2026-07-19 12:36:09', '2026-07-19 12:36:09');
INSERT INTO `platform_video_download` VALUES ('1', 'best', 'null', '3', '100', '30905128', '30905128', '2.49MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\【蒋介石】到处嫖娼，当绿帽奴，都是真的吗？_c4ca42', '0', '2026-07-19 12:36:29', '2026-07-19 12:38:04', '14', '2026-07-19 12:36:29', '2026-07-19 12:38:04', null);
INSERT INTO `platform_video_download` VALUES ('24', 'best', 'null', '3', '100', '2236136', '2236136', '31.70KiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\Jan - Just look at these sweet moments! A tiny toddler bravely reaching ou_1ff1de', '0', '2026-07-19 13:16:18', '2026-07-19 13:19:01', '15', '2026-07-19 13:16:18', '2026-07-19 13:19:01', null);
INSERT INTO `platform_video_download` VALUES ('38', 'best', 'null', '3', '100', '9480024', '9480024', '5.47MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p13 13-初中数学十三（反比例函数和相似）基础篇_a5771b', '0', '2026-07-19 13:29:51', '2026-07-19 13:29:59', '16', '2026-07-19 13:29:51', '2026-07-19 13:29:59', null);
INSERT INTO `platform_video_download` VALUES ('37', 'best', 'null', '3', '100', '7412670', '7412670', '339.21KiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p12 12-初中数学十二（旋转、园和概率初步）基础篇_a5bfc9', '0', '2026-07-19 14:08:36', '2026-07-19 14:09:02', '17', '2026-07-19 14:08:36', '2026-07-19 14:09:02', null);
INSERT INTO `platform_video_download` VALUES ('36', 'best', 'null', '3', '100', '11491584', '11491584', '10.65MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p11 11-初中数学十一（一元二次方程和二次函数）基础篇_19ca14', '0', '2026-07-19 14:08:38', '2026-07-19 14:09:04', '18', '2026-07-19 14:08:37', '2026-07-19 14:09:04', null);
INSERT INTO `platform_video_download` VALUES ('35', 'best', 'null', '3', '100', '1024', '9865695', null, '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p10 10-初中数学十（一次函数和数据的分析）基础篇_1c383c', '0', '2026-07-19 14:27:30', '2026-07-19 14:27:34', '22', '2026-07-19 14:26:11', '2026-07-19 14:27:34', null);
INSERT INTO `platform_video_download` VALUES ('26', 'best', 'null', '3', '100', '21980994', '21980994', '6.10MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p01 01-初中数学一（有理数和整式的加减）基础篇_4e732c', '0', '2026-07-19 14:21:41', '2026-07-19 14:23:22', '21', '2026-07-19 14:21:41', '2026-07-19 14:23:22', null);
INSERT INTO `platform_video_download` VALUES ('23', 'best', 'null', '-1', '29.87', '146516336', '490586163', '825.70KiB/s', '406', 'Instance <VideoDownloadModel at 0x1b404f19010> is not bound to a Session; attribute refresh operation cannot proceed (Background on this error at: https://sqlalche.me/e/20/bhk3)', 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\#精品讲坛 从落魄放牛娃到布衣和尚再到乱世英雄 朱元璋自此开启逆袭人生《明太祖朱元璋》第1-6集 _ CCTV百家讲坛官方频道_37693c', '0', '2026-07-19 14:15:00', '2026-07-19 14:15:12', '20', '2026-07-19 14:15:00', '2026-07-19 14:19:33', null);
INSERT INTO `platform_video_download` VALUES ('37', 'best', 'null', '3', '100', '13039071', '13039071', '2.86MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\一口气学完初中数学，全程干货无废话，快速学完初中数学 p12 12-初中数学十二（旋转、园和概率初步）基础篇_a5bfc9', '0', '2026-07-19 14:28:46', '2026-07-19 14:28:52', '23', '2026-07-19 14:28:46', '2026-07-19 14:28:52', null);
INSERT INTO `platform_video_download` VALUES ('39', 'best', 'null', '3', '100', '51464', '51464', '9.35KiB/s', '27', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\いろは _ AI美女家庭教師 - 暑さに耐えきれなくて。_d67d8a', '0', '2026-07-19 14:35:22', '2026-07-19 14:36:02', '24', '2026-07-19 14:35:22', '2026-07-19 14:36:02', null);
INSERT INTO `platform_video_download` VALUES ('40', 'best', 'null', '3', '100', '13467140', '13467140', '1.93MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\XiaoHongShu video #64cb0107000000001201f8a3_d64592', '0', '2026-07-19 14:48:36', '2026-07-19 14:48:44', '25', '2026-07-19 14:48:36', '2026-07-19 14:48:44', null);
INSERT INTO `platform_video_download` VALUES ('43', 'best', 'null', '3', '100', '100027280', '100371696', '1.09MiB/s', '2', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\猎艳者_17e621', '0', '2026-07-19 22:19:29', '2026-07-19 22:20:42', '26', '2026-07-19 22:19:29', '2026-07-19 22:20:42', null);
INSERT INTO `platform_video_download` VALUES ('45', 'best', 'null', '3', '100', '7758760', '8354156', '2.01MiB/s', '1', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\重庆彭水山体崩塌的成因是什么，为什么破坏力惊人？_6c8349', '0', '2026-07-19 22:23:22', '2026-07-19 22:23:26', '27', '2026-07-19 22:23:22', '2026-07-19 22:23:26', null);
INSERT INTO `platform_video_download` VALUES ('45', 'best', 'null', '3', '100', '15517520', '16112916', '3.27MiB/s', '1', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\重庆彭水山体崩塌的成因是什么，为什么破坏力惊人？_6c8349', '0', '2026-07-19 22:24:05', '2026-07-19 22:24:08', '28', '2026-07-19 22:24:05', '2026-07-19 22:24:08', null);
INSERT INTO `platform_video_download` VALUES ('48', 'best', 'null', '3', '100', '42201343', '42201343', '3.06MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\vqq-video video #l3202o6lgu1_642e92', '0', '2026-07-19 22:31:14', '2026-07-19 22:31:28', '29', '2026-07-19 22:31:14', '2026-08-24 23:21:46', '2026-08-24 23:21:46');
INSERT INTO `platform_video_download` VALUES ('48', 'best', 'null', '3', '100', '42201343', '42201343', '4.97MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\vqq-video video -l3202o6lgu1_642e92', '0', '2026-07-19 22:33:40', '2026-07-19 22:33:52', '30', '2026-07-19 22:33:40', '2026-08-24 23:21:46', '2026-08-24 23:21:46');
INSERT INTO `platform_video_download` VALUES ('48', 'best', 'null', '3', '100', '42201343', '42201343', '5.76MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\vqq-video video -l3202o6lgu1_642e92', '0', '2026-07-19 22:35:49', '2026-07-19 22:35:57', '31', '2026-07-19 22:35:49', '2026-08-24 23:21:46', '2026-08-24 23:21:46');
INSERT INTO `platform_video_download` VALUES ('49', 'best', 'null', '3', '100', '4730450', '4730450', '8.13MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\准初三开学，一定不能有的joker行为_f457c5', '0', '2026-08-24 23:15:16', '2026-08-24 23:15:25', '32', '2026-08-24 23:15:15', '2026-08-24 23:15:25', null);
INSERT INTO `platform_video_download` VALUES ('50', 'best', 'null', '3', '100', '192372877', '192372877', '4.11MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\ӡ��0�ǾƵ���ʳVS5�ǾƵ���ʳ���۸����40���ж����ף�_c0c7c7', '0', '2026-08-25 21:31:33', '2026-08-25 21:32:21', '33', '2026-08-25 21:31:33', '2026-08-25 21:32:21', null);
INSERT INTO `platform_video_download` VALUES ('51', 'best', 'null', '3', '100', '4574002', '4574002', '509.22KiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\static\\videos\\��������Ҳ���ǣ�������ܸ���ʲô����ѹ�ȸ�ʮ�㡱_283802', '0', '2026-08-25 21:37:56', '2026-08-25 21:38:13', '34', '2026-08-25 21:37:56', '2026-08-25 21:38:13', null);
INSERT INTO `platform_video_download` VALUES ('53', 'best', 'null', '3', '100', '96804', '96804', '21.27KiB/s', '20', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\Murat Bozkurt - Günaydın, sıkıyorsa beğenmeyin?_d82c8d', '0', '2026-08-30 05:11:45', '2026-08-30 05:12:05', '35', '2026-08-30 12:11:45', '2026-08-30 12:12:05', null);
INSERT INTO `platform_video_download` VALUES ('55', 'best', 'null', '3', '100', '14324806', '14324806', '59.21KiB/s', '3', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\奶盖小熊猫 - chudai_b53b3a', '0', '2026-08-30 05:23:22', '2026-08-30 05:35:36', '36', '2026-08-30 12:23:22', '2026-08-30 12:35:36', null);
INSERT INTO `platform_video_download` VALUES ('54', 'best', 'null', '3', '100', '721168', '721168', '57.74KiB/s', '4', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\知更鸟 - -反差 -母狗_a684ec', '0', '2026-08-30 06:05:55', '2026-08-30 06:07:30', '37', '2026-08-30 13:05:55', '2026-08-30 13:07:30', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '3', '100', '121330369', '121330369', '4.31MiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\大庆赶海，退潮后发现和手一样大的蛏子王，撒一点盐往上跑_72b32a', '0', '2026-09-25 11:24:55', '2026-09-25 11:25:30', '38', '2026-09-21 23:25:03', '2026-09-25 18:25:30', null);
INSERT INTO `platform_video_download` VALUES ('58', 'best', '{}', '-2', '19.68', '17719670', '90043906', null, '59', '服务关闭', 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\茂名｜发现一个小渔村，逛海边市场，到本地人推荐的餐厅加工，省钱又好吃！_66f041', '0', '2026-09-25 11:25:16', '2026-09-25 11:25:34', '39', '2026-09-21 23:58:39', '2026-09-25 18:25:34', null);
INSERT INTO `platform_video_download` VALUES ('58', 'best', 'null', '3', '100', '90043906', '90043906', '706.19KiB/s', '0', null, 'C:\\Users\\Administrator\\Desktop\\fssadmin_nestjs\\FastAdmin\\FssAdmin_Python\\server\\static\\videos\\茂名｜发现一个小渔村，逛海边市场，到本地人推荐的餐厅加工，省钱又好吃！_66f041', '0', '2026-09-25 11:30:50', '2026-09-25 11:32:31', '40', '2026-09-25 18:30:50', '2026-09-25 18:32:31', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '100', '0', null, '3.83MiB/s', null, null, 'static\\videos\\57_41', '0', '2026-10-13 21:02:59', null, '41', '2026-10-13 21:02:59', '2026-10-13 21:04:09', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '100', '0', null, '3.71MiB/s', null, null, 'static\\videos\\57_42', '0', '2026-10-13 21:03:44', null, '42', '2026-10-13 21:03:44', '2026-10-13 21:04:19', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '90', '0', null, '183.27KiB/s', null, null, 'static\\videos\\57_43', '0', '2026-10-13 21:04:27', null, '43', '2026-10-13 21:04:27', '2026-10-13 21:19:28', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '100', '0', null, '5.41MiB/s', null, null, 'static\\videos\\57_44', '0', '2026-10-13 21:08:56', null, '44', '2026-10-13 21:08:56', '2026-10-13 21:12:54', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '100', '0', null, '4.62MiB/s', null, null, 'static\\videos\\57_45', '0', '2026-10-13 21:10:03', null, '45', '2026-10-13 21:10:03', '2026-10-13 21:10:28', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '100', '0', null, '4.93MiB/s', null, null, 'static\\videos\\57_46', '0', '2026-10-13 21:10:27', null, '46', '2026-10-13 21:10:27', '2026-10-13 21:10:56', null);
INSERT INTO `platform_video_download` VALUES ('57', 'best', '{}', '1', '30.6', '0', null, '123.44KiB/s', null, null, 'static\\videos\\57_47', '0', '2026-10-13 21:12:02', null, '47', '2026-10-13 21:12:02', '2026-10-13 21:19:28', null);

-- ----------------------------
-- Table structure for `plugin_migrations`
-- ----------------------------
DROP TABLE IF EXISTS `plugin_migrations`;
CREATE TABLE `plugin_migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plugin_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `migration_file` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plugin_name` (`plugin_name`),
  KEY `idx_migration_name` (`migration_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='插件安装表';

-- ----------------------------
-- Records of plugin_migrations
-- ----------------------------

-- ----------------------------
-- Table structure for `sa_article`
-- ----------------------------
DROP TABLE IF EXISTS `sa_article`;
CREATE TABLE `sa_article` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `category_id` int(10) NOT NULL COMMENT '分类id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '文章标题',
  `author` varchar(255) DEFAULT NULL COMMENT '文章作者',
  `dept_id` mediumint(10) DEFAULT '0' COMMENT '部门id',
  `tenant_id` mediumint(10) DEFAULT NULL COMMENT '租户id',
  `image` varchar(1000) DEFAULT '' COMMENT '文章图片',
  `describe` varchar(1000) NOT NULL COMMENT '文章简介',
  `content` text NOT NULL COMMENT '文章内容',
  `summary` varchar(500) DEFAULT NULL COMMENT '文章摘要',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片',
  `category` varchar(100) DEFAULT NULL COMMENT '分类',
  `tags` varchar(500) DEFAULT NULL COMMENT '标签(逗号分隔)',
  `views` int(11) DEFAULT '0' COMMENT '浏览次数',
  `sort` int(10) unsigned DEFAULT '100' COMMENT '排序',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '状态',
  `is_link` tinyint(1) DEFAULT '2' COMMENT '是否外链',
  `link_url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `is_hot` tinyint(1) unsigned DEFAULT '2' COMMENT '是否热门',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_category_id` (`category_id`) USING BTREE,
  KEY `idx_tenant_dept` (`tenant_id`,`dept_id`) USING BTREE,
  KEY `idx_created_by` (`created_by`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='文章表';

-- ----------------------------
-- Records of sa_article
-- ----------------------------
INSERT INTO `sa_article` VALUES ('1', '1', '科技为农业强国建设插上腾飞之翼', '新华网', '3', '1', 'https://www.news.cn/tech/20251203/51066a5dc41545fa849d49423770ad70/2025120351066a5dc41545fa849d49423770ad70_202512037a03214ec26c4f029d6e1599d07c3779.png', '“十四五”规划提出，完善农业科技创新体系，创新农技推广服务方式，建设智慧农业。5年来，在科技创新的强劲支撑下，14亿人的饭碗端得更牢、农业现代化水平显著提升、产业新动能持续增强，农业强国建设迈上新台阶。', '<p style=\"text-align: justify;\"> &nbsp; &nbsp; &nbsp; &nbsp;“平均亩产1209.1公斤，这标志着全国首个两百万亩玉米‘吨粮田’成功创建。”金秋时节，新疆伊犁哈萨克自治州传来喜讯。这一纪录的诞生，离不开中国农业科学院研发的“玉米密植高产精准调控技术”支撑。依托该技术，位于伊犁的200余万亩玉米高产田亩保苗株数从传统的不足5000株提升到7000—8000株，玉米收获穗数大幅提升。</p><p style=\"text-align: justify;\">　　这只是我国科技强农、粮食增产增收的一个缩影。“十四五”以来，我国粮食总产量始终保持在1.3万亿斤以上。2024年粮食总产量更是首次突破1.4万亿斤，比2020年增产740亿斤。</p><p style=\"text-align: justify;\">　　习近平总书记强调，发展现代农业，建设农业强国，必须依靠科技进步，让科技为农业现代化插上腾飞的翅膀。</p><p style=\"text-align: justify;\">　　“十四五”规划提出，完善农业科技创新体系，创新农技推广服务方式，建设智慧农业。5年来，在科技创新的强劲支撑下，14亿人的饭碗端得更牢、农业现代化水平显著提升、产业新动能持续增强，农业强国建设迈上新台阶。</p><p style=\"text-align: justify;\">　　科技铸“芯”，夯实大国粮仓之基</p><p style=\"text-align: justify;\">　　国以农为本，农以种为先，种子被誉为农业的“芯片”。前不久，四川省富顺县水稻百亩超高产攻关片进行实割实测，再生稻亩产达到494.81公斤，加上此前测产中稻亩产807.13公斤，合计亩产突破1300公斤。取得这一成绩的背后，是“甬优4949”等高产突破性品种的选育和“中稻+再生稻”生产模式的推广。</p><p style=\"text-align: justify;\">　　水稻是我国第一大口粮。“十四五”时期全国多地选育出一批水稻突破性品种：安徽农业大学水稻栽培团队推广自育水稻品种，帮助当地农户水稻亩产增至800公斤；湖南杂交水稻研究中心选育出“西子3号”，推动解决部分受重金属污染地区“镉大米”问题；国家耐盐碱水稻技术创新中心培育出“箐两优3261”，填补了我国华南滨海盐碱区暂无强耐盐、多抗、优质杂交稻品种的空白……</p><p style=\"text-align: justify;\">　　习近平总书记指出，中国人的饭碗要牢牢端在自己手中，就必须把种子牢牢攥在自己手里。</p><p style=\"text-align: justify;\">　　作为我国另一大口粮，小麦育种的创新步伐也不断提速。2025年，西北农林科技大学一次性通过国家审定12个新品种，覆盖半冬性、冬性、春性类型，在抗倒伏等方面实现全面突破。这些为不同生态区“量身定制”的品种，在丰富我国小麦品种的同时，也大幅提升了小麦产能潜力。截至目前，西农小麦系列品种累计推广面积已达18亿亩，为保障国家粮食安全提供了坚实的种源支撑。</p><p style=\"text-align: justify;\">　　“十四五”以来，我国深入实施种业振兴行动，育成了一批生产急需的重大品种，选育出优质高产水稻、节水抗病小麦、机收籽粒玉米、高油高产大豆等急需品种，农作物自主选育品种面积占比超过了95%，做到了“中国粮”主要用“中国种”。</p><p style=\"text-align: justify;\">　　“去年全国粮食亩产394.7公斤，比‘十三五’末提高了12.5公斤，单产提升对我国粮食产量增长的贡献超过60%，有些年份会超过80%。”农业农村部党组书记、部长韩俊表示，“十四五”以来，农业农村部深入实施国家粮食安全战略，“以我为主、立足国内、确保产能、适度进口、科技支撑”，坚持产量产能、生产生态、增产增收一起抓，强化藏粮于地、藏粮于技，全方位夯实粮食安全根基。</p><p style=\"text-align: justify;\">　　智慧提“效”，驱动耕作方式变革</p><p style=\"text-align: justify;\">　　气象墒情传感器、智能虫情测报站等设备如同“千里眼”，与空中无人机巡航、地面机器狗巡检形成立体监测网络。这是日前科技日报记者在北京市昌平区的天汇园果园见到的一幕。</p><p style=\"text-align: justify;\">　　“目前，该果园环境和土壤墒情覆盖10余项指标，虫情识别准确率达90%，种植生产信息化率超过95%，同时土壤成分快检技术能在30分钟内完成土壤成分‘体检’，辅助实现果园虫情和灾情等早预警、早干预。”北京市智慧农业创新团队岗位专家吴建伟介绍，该果园管理从“经验驱动”转向“数据驱动”，为果树生长提供了全天候守护。</p><p style=\"text-align: justify;\">　　在四川省成都市新都区稻菜现代农业园区，当地自主研发的农业巡检机器人已代替人工开展巡检工作；在浙江省衢州市龙游县田间地头，一架植保无人机3小时就能完成300亩农田的喷药流程，相当于40多个人整整一天的工作量……</p><p style=\"text-align: justify;\">　　“十四五”以来，类似的农业新场景新模式不断涌现，现代农业设施装备持续普及应用。我国先后支持建设国家智慧农业创新应用项目116个，深入开展国产化智慧农业技术的中试熟化、推广应用，探索形成了一批信息技术与农机农艺相融合的节本增产增效技术模式。</p><p style=\"text-align: justify;\">　　习近平总书记指出，农业科技创新要着力提升创新体系整体效能，农业科技工作要突出应用导向，把论文写在大地上。</p><p style=\"text-align: justify;\">　　5年来，我国农业科技创新体系整体效能显著提升。我国充分利用物联网、大数据、人工智能等现代信息技术发展智慧农业，并研制出一批先进智能适用的农机装备。</p><p style=\"text-align: justify;\">　　“随着智能农机加快推广，全国安装北斗终端的农机约200万台，植保无人机年作业面积超过4.1亿亩。人工智能、农业机器人等新技术与农业生产经营加速融合，精准播种、变量施肥、智慧灌溉、精准饲喂、环境控制等逐渐普及。”农业农村部市场与信息化司司长雷刘功介绍。</p><p style=\"text-align: justify;\">　　这些前沿技术的落地应用，正是农业科技现代化推动农业现代化的生动实践。“十四五”以来，我国坚持用现代设施装备武装农业，用现代科学技术服务农业，推动农业现代化水平不断提高。2024年底，农业科技进步贡献率已经达到了63.2%，农作物耕种收综合机械化率超过75%。</p><p style=\"text-align: justify;\">　　创新延“链”，拓宽食物供给版图</p><p style=\"text-align: justify;\">　　近日，蒙牛集团携多款产品参加第八届中国国际进口博览会，展示其发展新质生产力的最新成果。“我们打造的全球液态奶行业首座‘灯塔工厂’，已成为全球乳业最高人效比的新标杆，是中国乳业抢占全球智能制造新高地的生动写照。”中粮集团副总经理、蒙牛乳业董事长庆立军介绍。这座“灯塔工厂”通过实施30多项第四次工业革命技术，实现了“百人百亿”的极致人效比——100名员工，年产能达百万吨，创造产值百亿元。</p><p style=\"text-align: justify;\">　　今天，科研创新已成为发展现代化海洋牧场的强大引擎。南方海洋实验室研发“珠海琴”等多功能融合的新型组合式结构加强型养殖平台，为海洋养殖带来新变革；珠海市海洋集团形成海工型养殖装备设计、建造、施工和运维等全产业链条，成功研发“格盛一号”养殖平台，订单水体总量相当于新开拓28.25万亩耕地。</p><p style=\"text-align: justify;\">　　习近平总书记指出，要树立大农业观、大食物观，农林牧渔并举，构建多元化食物供给体系。</p><p style=\"text-align: justify;\">　　“十四五”以来，我国突出科技支撑，强化要素保障，努力向森林要食物，向草原要食物，向江河湖海要食物，向设施农业要食物，向植物动物微生物要热量、要蛋白，多元化食物供给体系加快构建。</p><p style=\"text-align: justify;\">　　一组数据表明，农业科技创新正通过看得见的方式，让老百姓的餐桌品类变得愈发丰富——2024年，我国肉蛋奶等畜产品总量达到1.75亿吨，比2020年增加2778万吨，增长18.8%；水产品总产量达到7358万吨，比2020年增长12.3%，水产品总产量持续36年居全球第一。</p><p style=\"text-align: justify;\">　　党的二十届四中全会审议通过的《中共中央关于制定国民经济和社会发展第十五个五年规划的建议》提出，“统筹发展科技农业、绿色农业、质量农业、品牌农业，把农业建成现代化大产业”。科技创新能够催生新产业、新模式、新动能，是发展新质生产力的核心要素。韩俊表示，加快建设农业强国，必须清醒认识到农业科技国际竞争新形势，把农业科技创新放在更加突出的位置，紧盯世界农业科技前沿，加快突破农业关键核心技术，努力抢占农业科技创新制高点，塑造农业农村发展新动能新优势，培育壮大农业新质生产力。</p>', null, null, null, null, '5', '100', '1', '2', '', '2', '100', '1', '2024-06-02 22:55:25', '2026-01-10 11:13:25', null);
INSERT INTO `sa_article` VALUES ('2', '1', '商业航天稳步快跑 “太空旅游”渐行渐近', '新华网', '3', '1', 'https://www.news.cn/tech/20251124/c7cb9d4e405c4c82b78a8f861889cb22/20251124c7cb9d4e405c4c82b78a8f861889cb22_20251124044f95bbab864da2b0c30861aa41279b.png', '业界普遍认为，以可复用火箭为代表的核心技术突破是商业航天提速的关键支撑。据统计，2025年底至2026年初，我国可复用火箭技术将进入密集首飞期，包括蓝箭航天“朱雀三号”、中科宇航“力箭二号”、星际荣耀“双曲线三号”和星河动力“智神星一号”在内的多款可复用火箭将迎来首飞。', '<p style=\"text-align: justify;\"> &nbsp; &nbsp; &nbsp; &nbsp;可搭载7名乘客穿越卡门线，体验约4分钟失重体验……记者从11月22日在京开幕的第四届中国空间科学大会上了解到我国太空旅游的最新进展。与会专家学者认为，随着产业链条不断完善、核心技术持续突破，我国商业航天已迈入稳步快跑的发展新阶段，曾经遥不可及的“太空旅游”正加速走进现实。</p><p style=\"text-align: justify;\">  记者在第四届中国空间科学大会同期举行的“航天新技术、新成果展”上看到，我国首型面向太空旅游的可重复使用飞行器力鸿二号的模型吸引了众多参观者。中科宇航展台工作人员告诉记者，力鸿二号将采用“箭船分离”的方式将乘客送上太空：飞到既定高度之后，载人舱与火箭分离，继续飞越100公里的卡门线，开始约4分钟的失重段，之后返回地面，以伞降的方式着陆，火箭也将垂直着陆回收。“我们的目标是让力鸿二号可重复使用超30次，这样就能把飞行成本降下来，让更多的人体验太空旅游。”</p><p style=\"text-align: justify;\">  我国商业航天的快速发展让太空旅游渐行渐近。业界普遍认为，以可复用火箭为代表的核心技术突破是商业航天提速的关键支撑。据统计，2025年底至2026年初，我国可复用火箭技术将进入密集首飞期，包括蓝箭航天“朱雀三号”、中科宇航“力箭二号”、星际荣耀“双曲线三号”和星河动力“智神星一号”在内的多款可复用火箭将迎来首飞。</p><p style=\"text-align: justify;\">  不仅火箭研制加速突破，卫星应用也在不断拓展。此次展会上，微纳星空等卫星企业也带来了最新的研发成果。微纳星空品牌总监刘晓光介绍，即将发射的“全天候卫士”MN200S-2（01B）星是公司自主研制的商业X波段相控阵雷达成像领域的技术标杆型卫星，可广泛应用于应急救灾、海洋维权、国土安全、生态监测、智慧城市建设等场景，并可实现多星高密度堆叠发射，为后续卫星规模化组网编队提供关键技术验证与工程实践依据。“随着国家低轨卫星互联网的能力建设牵引，微纳星空已经开启批量化、低成本的卫星制造。”</p><p style=\"text-align: justify;\">  业界认为，目前我国已形成覆盖火箭研制、卫星制造、发射服务、地面应用的完整商业航天产业链，产业集群效应逐步显现。在北京，“南箭北星”的产业格局已显露雏形：亦庄新城正在打造全国首个商业航天共性科研生产基地——火箭大街，海淀区作为“北星”的核心承载区，已集聚涵盖商业卫星制造、测运控、运营及数据应用的近200家相关企业。“在此基础上，海淀正全力推进卫星小镇‘两区一平台’的建设：先导区目前已有40余家商业航天企业聚集；紧邻航天城的卫星小镇核心区54万平方米空间预计2026年6月竣备，将重点引入卫星上下游企业；同时，卫星小镇拟建公共服务平台，提供卫星整星及组部件的力学、热真空、抗辐射等多种测试服务。”卫星小镇核心区对接人段叶叶介绍。</p><p style=\"text-align: justify;\">  “我国发展商业航天的优势是人多、力量大、竞争强，技术和产品能够快速迭代，紧跟国际趋势。”中国科学院微小卫星创新研究院副院长张永合在接受记者专访时表示，但目前我国商业航天企业和人才大多集中在制造领域，“还需要更多能创造任务的人，有非常前沿的想法，有改变当前航天模式的颠覆性路径。”</p><p style=\"text-align: justify;\">  张永合认为，商业航天关键是要创造需求，“比如太空旅游就是商业航天创造的需求，将人们日常生活中的旅游延伸到太空中去，在产业上就属于增量。”未来，低空经济、空间互联网等也将打开想象空间。“有了坚实的技术底座，新的产业形态就会自然而然生长出来。”</p><p style=\"text-align: justify;\">  不过，业内专家也指出，我国商业航天发展仍面临体制机制创新不足、部分核心技术有待突破等挑战。从政策层面来看，近年来国家持续加大对商业航天的支持力度，相关扶持政策和行业规范正在逐步完善，旨在优化市场环境、加大核心技术研发支持，为商业航天高质量发展营造良好生态，推动太空旅游等新业态逐步走向成熟。</p><p style=\"text-align: justify;\">  业内普遍认为，商业航天已成为航天强国建设的重要增长点。从运载火箭重复使用技术突破到卫星应用场景拓展，随着技术持续成熟、产业链不断完善和政策环境优化，未来“上太空”有望从专业探索逐步走向大众体验，中国商业航天也将在全球太空经济格局中占据重要地位。</p><p><br></p>', null, null, null, null, '1', '100', '1', '2', '', '2', '100', '1', '2024-06-02 22:56:47', '2026-01-10 11:13:47', null);
INSERT INTO `sa_article` VALUES ('3', '2', '以数字经济为引擎加快推进中国式现代化', '新华网', '12', '1', 'https://www.news.cn/tech/20251023/0cb8f0bcb7874992b8d431abdd7331a9/202510230cb8f0bcb7874992b8d431abdd7331a9_2025102332abb363b12744eb9f725ce395f16e4a.png', 'The Athletic报道，阿森纳理疗师乔丹-里斯即将加盟曼联，成为红魔的首席理疗师。曼联首席理疗师罗宾-萨德勒已于今年一月离开俱乐部', '<p style=\"text-align: justify;\"> &nbsp; &nbsp; &nbsp; &nbsp;随着中国式现代化不断向前推进，中国迎来了数字经济发展的新机遇。在数字经济快速发展的背景下，中国式现代化的内涵得以拓展，现代化动力得以重塑，现代化新动能得以培育，现代化新优势得以形成。数字技术创新、实体经济与数字经济融合、产业数字化、数字产业化成为推进中国式现代化的重要驱动力量。</p><p style=\"text-align: justify;\">  在数字经济推动下，现代化由工业经济时代的现代化向数字经济时代的现代化转变，在这一大背景下需要在理论上研究数字经济赋能中国式现代化的逻辑和机制，需要深入探讨中国式现代化如何紧紧抓住数字经济发展带来的新机遇，以数字化的知识和信息作为关键生产要素，以数字技术为核心驱动力，在数据要素和数字技术的双轮驱动下推动中国式现代化走上新征程。</p><p style=\"text-align: justify;\">  南京大学数字经济与管理学院任保平教授的专著《数字经济赋能中国式现代化》于2025年在江苏人民出版社出版，全书共17章，35.8万字。该书立足世界范围内数字化浪潮下的经济现代化背景，从理论与实践两个方面研究了数字经济发展对中国式现代化的赋能作用。</p><p style=\"text-align: justify;\">  在理论层面，该书研究了数字经济发展对中国式现代化的影响、数字经济与中国式现代化的有机衔接，数字经济背景下中国式现代化目标的重塑、数字经济与中国式现代化深度融合的逻辑机制，数字经济背景下中国式现代化的延伸和拓展。在实践层面，从中国式现代化的不同方面具体研究了数字经济的赋能作用，具体包括数字经济赋能中国式新型工业化、新型城镇化、科技现代化、农业农村现代化、产业现代化和科技现代化。</p><p style=\"text-align: justify;\">  该书的核心观点主要有以下方面。一是，中国式现代化战略在数字化转型背景下发生的一系列拓展。促进工业化与信息化的融合发展，以数字化带动工业化发展，加大数字技术研发力度，大力发展数字产业。以数字化带动农业现代化，补足中国式现代化短板。协同匹配数字经济时代的创新供求，提升产业技术创新能力。促进企业数字化转型，引领数字经济发展。协调产业数字化与数字产业化，推进产业基础现代化。加快新型基础设施建设，提升基础设施支撑能力。构建数字平台体系，打造现代化经济新形态。</p><p style=\"text-align: justify;\">  二是，以数字经济发展培育中国式现代化新优势。针对数字经济带来的现代化新变化，研究了数字经济对中国式现代化的引擎作用，认为目前中国式现代化正处于数字经济蓬勃发展带来无数新机遇的时代，我们要抓住数字经济发展带来的新机遇，以数字经济推动中国式现代化的新发展。</p><p style=\"text-align: justify;\">  三是，阐释数字经济赋能中国式现代化的逻辑。在理论上深刻阐释数字经济如何成为中国式现代化的新引擎，数字经济作为新引擎对中国式现代化赋能的驱动机制和路径，论证数字经济发展赋能中国式现代化在目标、路径和战略上的延伸和拓展，为数字经济赋能中国式现代化提供了一个理论框架。</p><p style=\"text-align: justify;\">  四是，研究数字经济全面赋能中国式现代化的机制。中国式经济现代化涉及多方面内容，包括科技现代化、工业现代化、农业现代化、服务业现代化、产业链现代化、城市现代化、区域现代化、城市现代化、生态现代化、企业现代化、人的现代化和治理现代化，数字经济应该从上述方面赋能中国式现代化。</p><p style=\"text-align: justify;\">  五是，提出了以数字经济培育中国式现代化新优势的路径。数字经济培育中国式现代化的新优势包括需求端的动力新优势、供给端的效率新优势等。需要从数字化转型的创新能力、基础设施的供给能力、数字化转型的战略支撑能力，数字化转型的保障能力等方面研究数字经济发展培育中国式现代化新优势的实现路径。而且，需要从效率变革机制、动力变革机制和质量变革机制等方面研究数字经济赋能中国式现代化新优势培育的机制，从数字产业化、产业数字化、产学研协同创新、劳动力质量和相关配套制度等方面实现数字经济培育中国式现代化的新优势，全面展示数字经济赋能中国式现代化中的应用场景。</p>', null, null, null, null, '2', '100', '1', '2', '', '2', '1', '1', '2024-06-02 22:58:41', '2026-01-10 11:13:01', null);
INSERT INTO `sa_article` VALUES ('4', '2', '2025腾讯全球数字生态大会在深圳举行', '新华网', '8', '2', 'https://www.news.cn/tech/20250918/a8a0f6e1a6d740188db7752e247518bb/20250918a8a0f6e1a6d740188db7752e247518bb_202509184f78f2904fa2456db9537d878cb89166.jpg', '5月26日晚上18：00，中超第14轮，深圳新鹏城主场迎战上海申花，上半场马莱莱补射斩获赛季第6球，半场战罢，申花暂1-0新鹏城', '<p><br></p><div data-w-e-type=\"video\" data-w-e-is-void>\n<video poster=\"\" controls=\"true\" width=\"auto\" height=\"auto\"><source src=\"https://vodpub6.v.news.cn/yqfbzx-original/20250918/20250918a8a0f6e1a6d740188db7752e247518bb_XxjfceC000090_20250917_CBVFN0A001.mp4\" type=\"video/mp4\"/></video>\n</div><p><span style=\"color: rgb(0, 0, 0);\"> &nbsp; &nbsp; &nbsp; &nbsp;9月16日，2025腾讯全球数字生态大会在深圳举行，会上公布多项AI技术和产品最新进展，并宣布全面开放腾讯AI落地能力及优势场景，助力“好用的AI”在千行百业中加速落地。</span></p><p><br></p>', null, null, null, null, '3', '100', '1', '2', '', '2', '1', '1', '2024-06-02 22:59:41', '2026-01-10 13:42:34', null);
INSERT INTO `sa_article` VALUES ('5', '3', '秀我中国丨中国小机器人“勇闯”美国CES', '新华网', '121', '1', 'https://www.news.cn/tech/20260109/b2c43e2b0d1e43a98840c33e37fbbc73/20260109896bd0b56c18435987243f0f5dc01d67_202601099d0953f9999949a9b55e9d212d7bf773.jpg', '2026年美国拉斯维加斯消费电子展（CES）6日至9日举行，首次亮相海外展会的中国小机器人“启元Q1”刚一登场就成为焦点，凭借其出色表现“圈粉”海外。', '<p><br></p><div data-w-e-type=\"video\" data-w-e-is-void>\n<video poster=\"https://vodpub6.v.news.cn/yqfbzx-original/20260109/image/2ff2c0d5-4060-400d-8640-b41a0da5af1f.jpg\" controls=\"true\" width=\"360\" height=\"640\"><source src=\"https://vodpub6.v.news.cn/yqfbzx-original/20260109/20260109896bd0b56c18435987243f0f5dc01d67_XxjfceC000165_20260109_CBVFN0A001.mp4\" type=\"video/mp4\"/></video>\n</div><p style=\"text-align: left;\"><span style=\"color: rgb(0, 0, 0);\"> &nbsp; &nbsp; &nbsp; &nbsp;2026年美国拉斯维加斯消费电子展（CES）6日至9日举行，首次亮相海外展会的中国小机器人“启元Q1”刚一登场就成为焦点，凭借其出色表现“圈粉”海外。</span></p>', null, null, null, null, '3', '100', '1', '2', '', '2', '1', '1', '2024-06-02 23:01:17', '2026-01-10 13:42:24', null);
INSERT INTO `sa_article` VALUES ('6', '3', 'AI助力药物虚拟筛选提速百万倍 开启后AlphaFold时代创新药', '新华网', '1', '1', 'https://www.news.cn/tech/20260109/2e0f65d6733a4e2588a97dfe96593a09/202601092e0f65d6733a4e2588a97dfe96593a09_202601090012b088f5604e22a77ae70f8656f466.jpg', '团队与清华大学闫创业教授团队合作，在去甲肾上腺素转运体（NET）的临床相关靶点上开展了系列生物实验验证。', '<p><span style=\"color: rgb(0, 0, 0);\"> &nbsp; &nbsp; &nbsp; &nbsp;1月9日，清华大学智能产业研究院（AIR）联合清华大学生命学院、清华大学化学系在《科学》杂志发表论文《深度对比学习实现基因组级别药物虚拟筛选》。该论文研发了一个AI驱动的超高通量药物虚拟筛选平台DrugCLIP, 筛选速度对比传统方法实现百万倍提升，同时在预测准确率上也取得显著突破。依托该平台，团队打通了从AlphaFold结构预测到药物发现的关键通道，首次完成了覆盖人类基因组规模的药物虚拟筛选，为后AlphaFold时代的创新药物发现带来新可能性。</span></p><p><img src=\"https://www.news.cn/tech/20260109/2e0f65d6733a4e2588a97dfe96593a09/202601092e0f65d6733a4e2588a97dfe96593a09_2026010932fb993ce4734583aa3e4e861e536cff.png\" alt=\"\" data-href=\"\" style=\"\"/></p><p style=\"text-align: justify;\"> &nbsp; &nbsp;长期以来，药物研发面临“高风险、高投入、低成功率”的难题，在靶点发现与先导化合物筛选阶段，受限于传统工具的计算能力，绝大多数潜在靶点和化合物仍未被充分探索。如何在广阔的生物与化学空间中精准高效地发现活性化合物，是当前创新药物研发面临的核心挑战。</p><p style=\"text-align: justify;\">  据了解，为突破虚拟筛选规模瓶颈，DrugCLIP创新性地构建了蛋白口袋与小分子的“向量化结合空间”，将传统基于物理对接的筛选流程转化为高效的向量检索问题。该模型结合对比学习、3D结构预训练与多模态编码技术，能在三维结构层面精准建模蛋白-配体间的相互作用。训练后的高潜力分子将自然聚集于目标蛋白口袋的向量邻域，能够有效支撑快速的大规模虚拟筛选。依托这一机制，DrugCLIP在128核CPU+8张GPU的计算节点上，能实现毫秒级打分与万亿级日吞吐能力，筛选100万个候选分子仅需0.02秒，日处理能力达31万亿次，对比传统方法实现了百万倍提升。</p><p style=\"text-align: justify;\"><img src=\"https://www.news.cn/tech/20260109/2e0f65d6733a4e2588a97dfe96593a09/202601092e0f65d6733a4e2588a97dfe96593a09_2026010902fd55e1493f4741a2f10b4480ee398e.png\" alt=\"\" data-href=\"\" style=\"\"></p><p style=\"text-align: justify;\"> &nbsp; &nbsp;团队与清华大学闫创业教授团队合作，在去甲肾上腺素转运体（NET）的临床相关靶点上开展了系列生物实验验证。团队使用DrugCLIP模型从160万个候选分子中筛选出约100个高评分分子，同位素配体转运实验检测显示，其中15%为有效抑制剂，其中12个分子结合能力优于现有抗抑郁药物安非他酮。相关复合物结构已通过冷冻电镜解析，进一步验证了DrugCLIP筛选结果的生物学可信度。</p><p style=\"text-align: justify;\">  值得关注的是，DrugCLIP支持对AlphaFold预测的蛋白结构和apo（无配体）状态下的蛋白口袋进行筛选，扩大了其在真实药物发现场景中的适用性。团队和清华大学刘磊教授团队合作，针对E3泛素连接酶TRIP12（thyroid hormone receptor interactor 12）进行了虚拟筛选与实验验证。过往研究发现，TRIP12是多种肿瘤、帕金森综合征的潜在靶点，但是TRIP12缺少已知的小分子配体和复合物结构。团队使用DrugCLIP模型，从160万个候选分子中高通量筛选出约50个高评分分子，SPR实验证实，其中10个分子与TRIP12有结合能力，两个亲和力较高的分子也对TRIP12的泛素连接酶活性有一定的抑制活性。</p><p style=\"text-align: justify;\">  此外，依托DrugCLIP，团队首次完成了人类基因组规模的虚拟筛选项目，覆盖约1万个蛋白靶点、2万个结合口袋，分析超过5亿个小分子，富集出200万余个高潜力活性分子，构建了目前已知最大规模的蛋白-配体筛选数据库。该数据库已面向全球科研社区开放，为基础研究与早期药物发现提供了强大数据支持。</p><p style=\"text-align: justify;\">  DrugCLIP平台现已免费开放，用户无需本地部署，通过网页上传蛋白结构即可启动筛选任务。平台集成口袋/分子编码、向量检索、可视化与结果分析等功能，支持多种分子库调用与自定义上传，广泛适用于科研机构与企业用户。</p><p style=\"text-align: justify;\">  未来，DrugCLIP将与科研产业生态合作伙伴深度合作，在抗癌、传染病、罕见病等方向加速新靶点与First-in-class药物的发现。团队将持续优化引擎性能、拓展支持模态，助力构建一个更智能、高效与普惠的全球药物创新生态。</p>', null, null, null, null, '4', '100', '1', '2', '', '2', '1', '1', '2024-06-02 23:02:40', '2026-01-10 13:38:51', null);
INSERT INTO `sa_article` VALUES ('7', '4', '高度重视低空经济为哪般', '新华网', '4', '1', 'https://www.news.cn/tech/20250312/c0453593a495424780c5424c054a1d4d/20250312c0453593a495424780c5424c054a1d4d_2025031215d8945b560d4d169997f7745d0ef56f.jpg', '当前，我国低空经济正处于市场培育初期，关键技术的实用性和商业价值仅得到初步验证，但已彰显出广阔的增长空间', '<p style=\"text-align: justify;\"> &nbsp; &nbsp; &nbsp; &nbsp;近年来，低空经济成为全球发达经济体角逐的重要方向。虽然世界范围内低空经济还处于培育初期阶段，但是美国、日本、欧盟等国家和地区已经重点围绕场景开发应用、交通管理能力、运行技术验证、系统标准体系等方面积极出台和完善相关政策，加快发展低空经济。</p><p style=\"text-align: justify;\">  低空经济是依托低空飞行活动牵引串联的一系列相互关联的产业经济活动，不仅包括上游生产制造飞行器所必需的材料、零部件及分系统的行业企业，还包括中下游低空飞行器组装集成制造和测试试飞、设施配套及低空服务等领域。低空经济产业链条长、产业关联性强、应用场景丰富，具有战略引领性、高增长潜力等显著特征，既可以推动现代农牧业、先进制造业、现代服务业深度融合发展，又能够扩大有效投资、提振消费需求、提升创新能力。世界主要国家高度重视低空经济发展，就是因为看好其发展前景。</p><p style=\"text-align: justify;\">  当前，我国低空经济正处于市场培育初期，关键技术的实用性和商业价值仅得到初步验证，但已彰显出广阔的增长空间。未来随着技术迭代升级和商业模式逐步成熟，低空经济的高增长潜力将会进一步释放，更容易实现相关产业企业的群体性爆发成长，有望成为拉动经济增长的新引擎。</p><p style=\"text-align: justify;\">  一方面，低空飞行器的产业规模体量加快增长、产业生态持续完善。目前，我国无人机制造国际竞争力逐步增强，消费级无人机世界领先优势突出。截至2023年底，我国民用无人机研制企业已超过2300家，量产的无人机产品超过1000款。2023年，我国民用无人机产业规模达到1174.3亿元，同比增长32%。同时，新一代信息技术、新材料、新能源加速与航空科学技术融合发展，推动低空飞行器动力装备及系统、传感器、飞控系统等相关技术加速迭代，绿色高效、安全低噪的飞行器设计、制造与验证技术也持续更新升级。</p><p style=\"text-align: justify;\">  另一方面，体量巨大、类型多样的应用场景持续涌现，牵引低空服务快速释放动能。运营航空器大幅增加，《2023—2024中国民用无人驾驶航空发展报告》显示，截至2024年8月底，我国无人机实名登记数达198.7万架，比2023年底增加72万架；共颁发无人机驾驶员执照22万本，比2023年底增加13.9%。随着影视航拍、航空运动、空中观光游览等低空文旅应用场景快速发展，低空经济能为满足人民群众美好生活需求提供新供给。2023年，横店“航空＋影视＋旅游”交旅融合案例入选第一批交通运输与旅游融合发展十佳案例；2024年，敦煌“飞天”通用航空项目等航空旅游产品案例入选第二批交通运输与旅游融合发展示范案例。低空旅游市场潜力开始显现。</p><p style=\"text-align: justify;\">  同时，低空经济在农业植保、现代物流等行业领域的发展应用不断深入。随着无人机应用技术不断成熟和应用场景持续丰富，“农林牧副渔”多场景作业不断拓展，农业无人机服务市场规模呈蓬勃发展态势。2024年，全国植保无人机的保有量达到25.1万架，作业面积更是高达26.7亿亩次，同比增长近25%。从全球看，上世纪80年代以来，美国农业植保无人机作业渗透率超过50％，日本60％的稻田采用无人机进行植保作业。相较而言，我国农业无人机作业渗透率还比较低，有很大发展空间。在低空物流领域，以无人机为载运工具的无人化配送成为优化城市物流的重要方向，这能有效解决传统物流配送模式面临的劳动力成本、运输成本大幅攀升以及物资配送流通效率低下等诸多问题。在“低空+”领域，低空经济赋能社会治理成效突出，促进巡检、应急救援、城市管理、森林防火、医疗救护等公共服务快速发展。实践中，北京延庆、湖北武汉等地已采用电力线路无人机智能巡检，有效降低了巡检成本，提升了巡检效率。</p><p style=\"text-align: justify;\">  但也要看到，我国低空经济发展还存在一些问题，如统筹发展和安全有短板、产业融合化发展不足、空域管理协同机制尚不健全、基础设施建设相对滞后等。对此，要从突出集群融合、强化科技创新、加强设施建设等方面综合施策，将低空经济的发展潜力充分释放出来。</p><p style=\"text-align: justify;\">  一是突出集群融合，加快培育壮大低空经济产业集群，以市场需求为牵引、以科技创新为驱动，积极完善产业生态、谋划应用场景，推进低空制造业集群化发展。二是强化科技创新，聚焦低空经济创新链薄弱环节，加大科技创新投入，加快提升低空技术支撑能力。三是加强设施建设，构建低空经济基础设施综合保障体系，坚持绿色发展、节约集约，统筹推进通用机场、电动垂直起降飞行器起降场、固定运营基地、飞行服务站等地面配套基础设施建设，推进低空飞行通信、导航、气象监测等信息基础设施建设，加速低空经济智联网络设施建设。此外，还要统筹发展和安全，加强低空飞行器监控防护，强化低空安全技术攻关，提升空域精细化管理能力。坚持包容审慎的安全风险管控理念，建设监管服务体系，建立灵活调配、动态高效的低空空域管理使用机制，增强管理的协同性与联动性。</p>', null, null, null, null, '11', '100', '1', '2', '', '2', '1', '1', '2024-06-02 23:04:23', '2026-01-10 13:43:44', null);
INSERT INTO `sa_article` VALUES ('8', '4', '国家发改委成立低空经济发展司', '新华网', '1', '1', 'https://www.news.cn/tech/20241231/3f5396024a9749ee863292c04c7119dc/202412313f5396024a9749ee863292c04c7119dc_2024123101c42d384b83467f835ffd286af095d4.jpg', '近日，低空经济发展司召开推动低空基础设施建设座谈会和推动低空智能网联系统建设专题座谈会..', '<p style=\"text-align: justify;\"> &nbsp; &nbsp; &nbsp; 记者从国家发展和改革委员会官方网站获悉，低空经济发展司已正式成立。</p><p style=\"text-align: justify;\">　　低空经济发展司的具体职责是拟订并组织实施低空经济发展战略、中长期发展规划，提出有关政策建议，协调有关重大问题等。</p><p style=\"text-align: justify;\">　　近日，低空经济发展司召开推动低空基础设施建设座谈会和推动低空智能网联系统建设专题座谈会。</p><p style=\"text-align: justify;\">　　在推动低空基础设施建设座谈会上，低空经济发展司负责同志同自然资源部、生态环境部等部委和有关中央企业进行座谈，了解相关领域低空经济典型场景应用和相关基础设施建设发展情况，并就推动低空基础设施有序规划建设进行交流。</p><p style=\"text-align: justify;\">　　在推动低空智能网联系统建设专题座谈会上，低空经济发展司负责同志与通信、导航方面有关专家进行座谈，就低空智能网联系统建设进行交流。</p>', null, null, null, null, '6', '100', '1', '2', '', '2', '1', '1', '2024-06-02 23:04:23', '2026-04-23 23:21:09', null);
INSERT INTO `sa_article` VALUES ('9', '1', '多租户系统架构与权限设计探讨', 'admin', '1', '2', 'http://127.0.0.1:8000/uploads/2026/03/28/69c7a3b2058589.44968839.webp', '多租户系统架构与权限设计探讨', '<p>多租户系统架构与权限设计探讨多租户系统架构与权限设计探讨</p><p>多租户系统架构与权限设计探讨</p><p>多租户系统架构与权限设计探讨</p>', null, null, null, null, '0', '100', '1', '2', '', '2', '1', '1', '2026-04-23 22:22:26', '2026-04-23 23:21:00', null);
INSERT INTO `sa_article` VALUES ('10', '2', '切尔西官宣41岁主帅下课！带队107天+英超遭5连败 解约金1200万镑', 'admin', '1', '2', 'http://127.0.0.1:8000/uploads/2026/03/28/69c7a3acd6b581.21163358.png', '切尔西官宣41岁主帅下课！带队107天+英超遭5连败 解约金1200万镑', '<p><br></p><p style=\"text-align: justify;\">北京时间4月23日，英超豪门切尔西俱乐部官方宣布，因近期比赛结果和球队表现未能达到应有标准，41岁的主帅罗塞尼尔正式下课。</p><p style=\"text-align: justify;\">切尔西官方向罗塞尼尔及其教练组，在俱乐部效力期间所付出的所有努力，表示衷心的感谢，并祝愿他在未来一切顺利。</p><p style=\"text-align: center;\"><img src=\"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2026%2F0423%2Fd77d2db1j00tdwmbr00p7d000qo00gcm.jpg&amp;thumbnail=660x2147483647&amp;quality=80&amp;type=jpg\" alt=\"\" data-href=\"\" style=\"\"><br><br></p><p style=\"text-align: justify;\">切尔西还同时宣布，助教卡勒姆·麦克法兰将担任一线队临时主教练，带领球队直至本赛季结束，并由俱乐部现有教练组成员协助。</p><p style=\"text-align: justify;\">切尔西官方还表示，俱乐部未来会在寻求新帅稳定人选的过程中，进行自我反思，以做出正确的长期任命。</p><p style=\"text-align: center;\"><img src=\"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2026%2F0423%2Fc5090293j00tdwmbr008dd000qo00g8m.jpg&amp;thumbnail=660x2147483647&amp;quality=80&amp;type=jpg\" alt=\"\" data-href=\"\" style=\"\"><br><br></p><p style=\"text-align: justify;\">今年1月8日，罗塞尼尔从清湖集团旗下的另一支球队斯特拉斯堡，“内部调遣”来到切尔西，双方签下了长达6年半的合同。</p><p style=\"text-align: justify;\">上任之初，他带领切尔西踢出了不错的成绩，前9场比赛球队只在英联杯两负阿森纳，赢下了剩余7场。</p><p style=\"text-align: center;\"><img src=\"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2026%2F0423%2F52e72206j00tdwmbq0017d000qo00hmm.jpg&amp;thumbnail=660x2147483647&amp;quality=80&amp;type=jpg\" alt=\"\" data-href=\"\" style=\"\"><br><br></p><p style=\"text-align: justify;\">但随后，切尔西的状况开始急转直下，最近8场比赛，切尔西1胜7负，唯一的一胜还是在足总杯赛场战胜第三级别联赛球队维尔港。</p><p style=\"text-align: justify;\">最近5场联赛，切尔西遭遇5连败且一球未进，目前切尔西在本轮先赛的情况下，已经落后欧冠区7分之多。</p><p style=\"text-align: justify;\">最终，罗塞尼尔仅执教切尔西107天后，便黯然下课。他带队打了23场比赛，战绩为11胜2平10负，胜率不到5成。</p><p style=\"text-align: center;\"><img src=\"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2026%2F0423%2F869822dfj00tdwmbr00bbd000e600hvm.jpg&amp;thumbnail=660x2147483647&amp;quality=80&amp;type=jpg\" alt=\"\" data-href=\"\" style=\"\"><br><br></p><p style=\"text-align: justify;\">而据多家媒体确认，罗塞尼尔在切尔西剩余未被支付的薪水高达2400万镑。而队报记者表示，切尔西不会支付所有剩余款项，将支付1000万-1200万镑解雇他。</p><p style=\"text-align: justify;\"><br></p>', null, null, null, null, '0', '100', '1', '2', '', '2', '1', '1', '2026-04-23 23:39:01', '2026-06-21 19:39:42', null);
INSERT INTO `sa_article` VALUES ('11', '2', 'Dromara Warm-Flow，国产的工作流引擎1', 'Dromara', '1', '1', 'http://127.0.0.1:8000/uploads/2026/03/28/69c7a3af23d945.66099869.webp', 'Dromara Warm-Flow，国产的工作流引擎，以其简洁轻量、五脏俱全、灵活扩展性强的特点，成为了众多开发者的首选。它不仅可以通过jar包快速集成设计器，同时原生支持经典和仿钉钉双模式，还具备以下显著优势：', '<blockquote style=\"text-align: start;\">Dromara Warm-Flow，国产的工作流引擎，以其简洁轻量、五脏俱全、灵活扩展性强的特点，成为了众多开发者的首选。它不仅可以通过jar包快速集成设计器，同时原生支持经典和仿钉钉双模式，还具备以下显著优势：</blockquote><ul><li style=\"text-align: start;\"><strong>简洁易用</strong>‌：仅包含7张表，代码量少，上手和集成速度快。</li><li style=\"text-align: start;\"><strong>审批功能全面</strong>‌：支持通过、退回、撤销、拿回、任意跳转、终止、转办、票签、委派和加减签、互斥、并行、自动审批、远程访问和脚本执行服务等多种审批操作，以及条件表达式、办理人表达和监听器等高级功能。</li><li style=\"text-align: start;\"><strong>流程设计器</strong>‌：通过jar包形式快速集成到项目，支持节点属性扩展，原生支持经典和仿钉钉双模式。</li><li style=\"text-align: start;\"><strong>流程图</strong>‌：自带流程图，通过jar包快速集，功能扩展，原生支持经典和仿钉钉双模式。</li><li style=\"text-align: start;\"><strong>条件表达式</strong>‌：内置常见的和spel条件表达式，支持自定义扩展。</li><li style=\"text-align: start;\"><strong>办理人变量表达式</strong>‌：内置${handler}和spel格式的表达式，满足不同场景需求，灵活可扩展。</li><li style=\"text-align: start;\"><strong>监听器</strong>‌：提供四种监听器，支持不同作用范围和spel表达式，参数传递灵活，支持动态权限。</li><li style=\"text-align: start;\"><strong>流程变量</strong>‌：在整个流程办理过程起到重要的角色，如办理人表达式中，传入变量进行动态指定办理人。</li><li style=\"text-align: start;\"><strong>ORM框架支持</strong>‌：支持MyBatis、Mybatis-Plus、Mybatis-Flex、Jpa、Easy-Query和BeetlSql，后续将扩展支持其他框架</li><li style=\"text-align: start;\"><strong>数据库支持</strong>‌：支持MySQL、Oracle、PostgreSQL和SQL Server，其他数据库只需要转换表结构即可支持。</li><li style=\"text-align: start;\"><strong>多租户与软删除</strong>‌：流程引擎自身维护多租户和软删除实现，也可使用对应ORM框架的实现方式。</li><li style=\"text-align: start;\"><strong>兼容性</strong>‌：同时支持Spring和Solon，兼容Java8、Java17、Java21。</li><li style=\"text-align: start;\"><strong>实战项目</strong>‌：官方提供基于Ruoyi-Vue封装的实战项目，极具参考价值。</li><li style=\"text-align: start;\"></li><li style=\"text-align: start;\"> <a href=\"https://www.warm-flow.com/master/introduction/introduction.html\" target=\"_blank\">https://www.warm-flow.com/master/introduction/introduction.html</a> </li><li style=\"text-align: start;\"> <a href=\"https://juejin.cn/post/7205873584339009596\" target=\"_blank\">https://juejin.cn/post/7205873584339009596</a> </li></ul>', null, null, null, null, '0', '100', '1', '2', '', '2', '1', '1', '2026-04-26 17:09:16', '2026-10-13 20:58:52', null);

-- ----------------------------
-- Table structure for `sa_article_banner`
-- ----------------------------
DROP TABLE IF EXISTS `sa_article_banner`;
CREATE TABLE `sa_article_banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `banner_type` int(11) DEFAULT NULL COMMENT '类型',
  `image` varchar(1000) DEFAULT NULL COMMENT '图片地址',
  `is_href` tinyint(1) DEFAULT '1' COMMENT '是否链接',
  `url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '描述',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='文章轮播图';

-- ----------------------------
-- Records of sa_article_banner
-- ----------------------------
INSERT INTO `sa_article_banner` VALUES ('1', '1', 'https://picsum.photos/id/490/640/360', '1', '/blog/1', '探索亚洲的烹饪奇迹', '1', '100', '有一系列名为“新加坡传统烹饪”的食谱，探索了新加坡的美食和文化。它包括新加坡华人、马来人、印度人、欧亚人和土生华人（海峡华人）的美食', '1', '1', '2024-06-02 23:06:37', '2026-01-09 21:51:50', null);
INSERT INTO `sa_article_banner` VALUES ('2', '1', 'https://picsum.photos/id/29/640/360', '1', '/blog/2', '探索雄伟的山峰', '1', '100', '攀登这座风景如画的山峰的最佳方式是乘坐御在所索道，乘坐15 分钟即可将游客带入空中，欣赏周围一览无余的景观', '1', '1', '2024-06-02 23:06:49', '2026-01-09 21:51:54', null);
INSERT INTO `sa_article_banner` VALUES ('3', '1', 'https://picsum.photos/id/903/640/360', '1', '/blog/3', '揭秘奇迹', '1', '100', '极光是地球磁场与太阳风相互作用的产物，当太阳风中的带电粒子与地球高层大气中的原子、分子碰撞时，会产生发光现象，形成美丽的极光', '1', '1', '2024-06-02 23:06:56', '2026-01-09 21:53:32', null);

-- ----------------------------
-- Table structure for `sa_article_category`
-- ----------------------------
DROP TABLE IF EXISTS `sa_article_category`;
CREATE TABLE `sa_article_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `category_name` varchar(255) NOT NULL COMMENT '分类标题',
  `describe` varchar(255) DEFAULT NULL COMMENT '分类简介',
  `image` varchar(255) DEFAULT NULL COMMENT '分类图片',
  `sort` int(10) unsigned DEFAULT '100' COMMENT '排序',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '状态',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='文章分类表';

-- ----------------------------
-- Records of sa_article_category
-- ----------------------------
INSERT INTO `sa_article_category` VALUES ('1', '0', '大国科技', '', null, '100', '1', '1', '1', '2024-06-02 22:50:51', '2026-01-06 18:03:07', null);
INSERT INTO `sa_article_category` VALUES ('2', '0', '数字经济', '', null, '100', '1', '1', '1', '2024-06-02 22:50:56', '2026-01-09 16:54:05', null);
INSERT INTO `sa_article_category` VALUES ('3', '0', '科技快讯', '', null, '100', '1', '1', '1', '2024-06-02 22:51:01', '2026-01-07 01:03:37', null);
INSERT INTO `sa_article_category` VALUES ('4', '0', '低空经济', '', null, '100', '1', '1', '1', '2024-06-02 22:51:16', '2026-01-06 18:03:14', null);

-- ----------------------------
-- Table structure for `sa_job`
-- ----------------------------
DROP TABLE IF EXISTS `sa_job`;
CREATE TABLE `sa_job` (
  `job_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT NULL COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_by` varchar(64) NOT NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) NOT NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='定时任务表';

-- ----------------------------
-- Records of sa_job
-- ----------------------------
INSERT INTO `sa_job` VALUES ('1', '系统默认（无参）', 'DEFAULT', 'task.noParams', '0 0 0 * * 1', '3', '1', '1', 'admin', '2025-02-28 16:52:10.000000', 'admin', '2026-06-19 00:32:16.000000', '', '0');
INSERT INTO `sa_job` VALUES ('2', '系统默认（有参）', 'DEFAULT', 'task.params(\'ry\')', '0 0 0 * * 1', '3', '1', '1', 'admin', '2025-02-28 16:52:10.000000', '', '2026-06-19 09:53:40.000000', '', '0');
INSERT INTO `sa_job` VALUES ('3', '系统默认（多参）', 'DEFAULT', 'task.multipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-02-28 16:52:10.000000', '', null, '', '0');
INSERT INTO `sa_job` VALUES ('4', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '0 1 1 * * *', '3', '0', '0', '', '2026-06-23 23:31:31.000000', '', '2026-06-23 23:31:31.000000', '', '0');

-- ----------------------------
-- Table structure for `sa_job_log`
-- ----------------------------
DROP TABLE IF EXISTS `sa_job_log`;
CREATE TABLE `sa_job_log` (
  `job_log_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COMMENT='任务调度日志表';

-- ----------------------------
-- Records of sa_job_log
-- ----------------------------
INSERT INTO `sa_job_log` VALUES ('2', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 2ms', '0', '', '2026-06-11 21:11:30.000000');
INSERT INTO `sa_job_log` VALUES ('3', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 2ms', '0', '', '2026-06-11 21:11:40.000000');
INSERT INTO `sa_job_log` VALUES ('4', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 2ms', '0', '', '2026-06-11 21:11:50.000000');
INSERT INTO `sa_job_log` VALUES ('5', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 2ms', '0', '', '2026-06-11 21:12:00.000000');
INSERT INTO `sa_job_log` VALUES ('6', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 1ms', '0', '', '2026-06-11 21:12:10.000000');
INSERT INTO `sa_job_log` VALUES ('7', '系统默认（有参）', 'DEFAULT', 'task.params(\'ry\')', '执行成功，耗时 14ms', '0', '', '2026-06-19 00:04:01.000000');
INSERT INTO `sa_job_log` VALUES ('8', '系统默认（多参）', 'DEFAULT', 'task.multipleParams(\'ry\', true, 2000L, 316.50D, 100)', '执行失败，耗时 8ms', '1', '任务 task.multipleParams 不存在', '2026-06-19 00:04:12.000000');
INSERT INTO `sa_job_log` VALUES ('9', '系统默认（有参）', 'DEFAULT', 'task.params(\'ry\')', '执行成功，耗时 0ms', '0', '', '2026-06-19 00:04:26.000000');
INSERT INTO `sa_job_log` VALUES ('10', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 0ms', '0', '', '2026-06-19 00:04:30.000000');
INSERT INTO `sa_job_log` VALUES ('11', '系统默认（多参）', 'DEFAULT', 'task.multipleParams(\'ry\', true, 2000L, 316.50D, 100)', '执行失败，耗时 3ms', '1', '任务 task.multipleParams 不存在', '2026-06-19 00:08:51.000000');
INSERT INTO `sa_job_log` VALUES ('12', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 0ms', '0', '', '2026-06-19 00:32:11.000000');
INSERT INTO `sa_job_log` VALUES ('13', '系统默认（有参）', 'DEFAULT', 'task.params(\'ry\')', '执行成功，耗时 0ms', '0', '', '2026-06-19 09:53:36.000000');
INSERT INTO `sa_job_log` VALUES ('14', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 0ms', '0', '', '2026-06-19 21:33:40.000000');
INSERT INTO `sa_job_log` VALUES ('15', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 1ms', '0', '', '2026-06-21 19:18:00.000000');
INSERT INTO `sa_job_log` VALUES ('16', '系统默认（无参）', 'DEFAULT', 'task.noParams', '执行成功，耗时 0ms', '0', '', '2026-06-23 23:31:06.000000');
INSERT INTO `sa_job_log` VALUES ('17', '系统默认（有参）', 'DEFAULT', 'task.params(\'ry\')', '执行成功，耗时 0ms', '0', '', '2026-06-23 23:31:11.000000');
INSERT INTO `sa_job_log` VALUES ('18', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 0ms', '0', '', '2026-06-23 23:31:35.000000');
INSERT INTO `sa_job_log` VALUES ('19', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 4ms', '0', '', '2026-06-25 01:01:00.000000');
INSERT INTO `sa_job_log` VALUES ('20', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 0ms', '0', '', '2026-06-28 01:01:00.000000');
INSERT INTO `sa_job_log` VALUES ('21', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 3ms', '0', '', '2026-06-29 01:01:00.000000');
INSERT INTO `sa_job_log` VALUES ('22', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 2ms', '0', '', '2026-09-25 01:01:00.000000');
INSERT INTO `sa_job_log` VALUES ('23', 'ceshi', 'DEFAULT', 'task.backupDatabase()', '执行成功，耗时 5ms', '0', '', '2026-09-25 09:55:08.000000');
INSERT INTO `sa_job_log` VALUES ('24', '系统默认（多参）', 'DEFAULT', 'task.multipleParams(\'ry\', true, 2000L, 316.50D, 100)', '执行失败，耗时 1ms', '1', '任务 task.multipleParams 不存在', '2026-09-25 09:58:00.000000');

-- ----------------------------
-- Table structure for `sa_system_attachment`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_attachment`;
CREATE TABLE `sa_system_attachment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` int(11) DEFAULT '0' COMMENT '文件分类',
  `storage_mode` smallint(6) DEFAULT '1' COMMENT '存储模式 (1 本地 2 阿里云 3 七牛云 4 腾讯云)',
  `origin_name` varchar(255) DEFAULT NULL COMMENT '原文件名',
  `object_name` varchar(255) NOT NULL COMMENT '存储对象名',
  `hash` varchar(64) DEFAULT NULL COMMENT '文件hash',
  `mime_type` varchar(255) DEFAULT NULL COMMENT '资源类型',
  `storage_path` varchar(512) NOT NULL COMMENT '存储路径',
  `suffix` varchar(10) DEFAULT NULL COMMENT '文件后缀',
  `size_byte` bigint(20) DEFAULT NULL COMMENT '字节数',
  `size_info` varchar(50) DEFAULT NULL COMMENT '文件大小',
  `url` varchar(1024) NOT NULL COMMENT '文件地址',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='文件上传记录';

-- ----------------------------
-- Records of sa_system_attachment
-- ----------------------------
INSERT INTO `sa_system_attachment` VALUES ('37', '0', '1', '6343299.jpg', '1781926045557_823e11c0a565406e.jpg', '4a5a5cae301074163209b84a5442659a', 'image/jpeg', '/profile/1781926045557_823e11c0a565406e.jpg', 'jpg', '8776', '8.57KB', 'https://nest.phpframe.org/profile/1781926045557_823e11c0a565406e.jpg', '', '1', '1', '2026-06-20 03:27:26', '2026-06-23 21:17:04', '2026-06-23 21:17:04');
INSERT INTO `sa_system_attachment` VALUES ('38', '0', '1', '2205be50f7884aa2ad8c9fb214460729_weixin_36343299.jpg', '1782043223796_c0df6bfd59164c15.jpg', null, 'image/jpeg', '1782043223796_c0df6bfd59164c15.jpg', 'jpg', '8776', '8.57KB', 'http://localhost:8181/profile/1782043223796_c0df6bfd59164c15.jpg', null, '1', '1', '2026-06-21 20:00:24', '2026-06-24 21:08:34', '2026-06-24 21:08:34');
INSERT INTO `sa_system_attachment` VALUES ('39', '0', '1', '4601.jpg_wh860.jpg', '1782044544271_c20cbc6568d54597.jpg', null, 'image/jpeg', '1782044544271_c20cbc6568d54597.jpg', 'jpg', '56958', '55.62KB', 'http://localhost:8181/profile/1782044544271_c20cbc6568d54597.jpg', null, '1', '1', '2026-06-21 20:22:24', '2026-06-24 21:08:34', '2026-06-24 21:08:34');
INSERT INTO `sa_system_attachment` VALUES ('40', '0', '1', 'mjc.88aab0a2.png', '1782220629962_33eba9649615455d.png', '9955a9a409100c212f218f6570ae5c5d', 'image/png', '1782220629962_33eba9649615455d.png', 'png', '6108', '5.96KB', 'http://localhost:8181/profile/1782220629962_33eba9649615455d.png', null, '1', '1', '2026-06-23 21:17:10', '2026-06-23 21:17:13', '2026-06-23 21:17:13');
INSERT INTO `sa_system_attachment` VALUES ('41', '0', '1', 'mjc.88aab0a2.png', '1782305905308_2a353fa1a1aa4c06.png', '9955a9a409100c212f218f6570ae5c5d', 'image/png', '1782305905308_2a353fa1a1aa4c06.png', 'png', '6108', '5.96KB', 'http://localhost:8181/profile/1782305905308_2a353fa1a1aa4c06.png', null, '1', '1', '2026-06-24 20:58:25', '2026-06-24 20:58:25', '2026-09-23 07:26:05');
INSERT INTO `sa_system_attachment` VALUES ('42', '1', '1', '2205be50f7884aa2ad8c9fb214460729_weixin_36343299.jpg', '1782306494028_8cc60b571a014820.jpg', '4a5a5cae301074163209b84a5442659a', 'image/jpeg', '1782306494028_8cc60b571a014820.jpg', 'jpg', '8776', '8.57KB', 'http://localhost:8181/profile/1782306494028_8cc60b571a014820.jpg', null, '1', '1', '2026-06-24 21:08:14', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('43', '0', '1', 'fssoa-net.sql', '1782306520028_d226724524344192.sql', '0364e2bac98a33e2d78dce8081ec14ed', 'application/octet-stream', '1782306520028_d226724524344192.sql', 'sql', '693294', '677.04KB', 'http://localhost:8181/profile/1782306520028_d226724524344192.sql', null, '1', '1', '2026-06-24 21:08:40', '2026-06-24 21:18:18', '2026-06-24 21:18:18');
INSERT INTO `sa_system_attachment` VALUES ('44', '0', '1', 'package(1).json', '1782306524654_ffcdc15950004198.json', 'd30260c88fc87c881f9bf69ccd4475d7', 'application/json', '1782306524654_ffcdc15950004198.json', 'json', '4617', '4.51KB', 'http://localhost:8181/profile/1782306524654_ffcdc15950004198.json', null, '1', '1', '2026-06-24 21:08:45', '2026-06-24 21:08:47', '2026-06-24 21:08:47');
INSERT INTO `sa_system_attachment` VALUES ('45', '0', '1', 'getmov.php', '1782306586070_e22c3ac68ed448ae.php', '19bb3474143a8977ee1750e43a34e921', 'application/octet-stream', '1782306586070_e22c3ac68ed448ae.php', 'php', '5400', '5.27KB', 'http://localhost:8181/profile/1782306586070_e22c3ac68ed448ae.php', null, '1', '1', '2026-06-24 21:09:46', '2026-06-24 21:18:18', '2026-06-24 21:18:18');
INSERT INTO `sa_system_attachment` VALUES ('46', '1', '1', '2205be50f7884aa2ad8c9fb214460729_weixin_36343299.jpg', '1784388368867_c75135d2ea8c49e0.jpg', '4a5a5cae301074163209b84a5442659a', 'image/jpeg', 'uploads/2026/07/18/1784388368867_c75135d2ea8c49e0.jpg', 'jpg', '8776', '8.6KB', '/uploads/2026/07/18/1784388368867_c75135d2ea8c49e0.jpg', null, '1', '1', '2026-07-18 23:26:09', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('47', '3', '1', 'mjc.88aab0a2.png', '1784390696210_44fcb67fc6044be9.png', '9955a9a409100c212f218f6570ae5c5d', 'image/png', 'uploads/2026/07/19/1784390696210_44fcb67fc6044be9.png', 'png', '6108', '6.0KB', '/uploads/2026/07/19/1784390696210_44fcb67fc6044be9.png', null, '1', '1', '2026-07-19 00:04:56', '2026-07-19 00:04:56', '2026-09-21 23:55:56');
INSERT INTO `sa_system_attachment` VALUES ('48', '1', '1', '2205be50f7884aa2ad8c9fb21446072936343299.jpg', '1790004203422_N67RXCuN.jpg', null, 'image/jpeg', 'uploads/2026/09/21/1790004203422_N67RXCuN.jpg', 'jpg', '8776', '8.6KB', '/uploads/2026/09/21/1790004203422_N67RXCuN.jpg', null, '1', '1', '2026-09-21 23:23:23', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('49', '1', '1', 'mjc.88aab0aaa2.png', '1790006152315_90ZBJS7S.png', null, 'image/png', 'uploads/2026/09/21/1790006152315_90ZBJS7S.png', 'png', '6108', '6.0KB', '/uploads/2026/09/21/1790006152315_90ZBJS7S.png', null, '1', '1', '2026-09-21 23:55:52', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('50', '0', '1', '2205be50f7884aa2ad8c9fb214460729_weixin_36343299.jpg', '1790301829191_28cb7d9883fb4564.jpg', '4a5a5cae301074163209b84a5442659a', 'image/jpeg', '1790301829191_28cb7d9883fb4564.jpg', 'jpg', '8776', '8.57KB', 'https://nest.phpframe.org/profile/1790301829191_28cb7d9883fb4564.jpg', null, '1', '1', '2026-09-25 10:03:49', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('51', '0', '1', 'mjc.88aab0a2.png', '1790301843929_59e62611c59d430f.png', '9955a9a409100c212f218f6570ae5c5d', 'image/png', '1790301843929_59e62611c59d430f.png', 'png', '6108', '5.96KB', 'https://nest.phpframe.org/profile/1790301843929_59e62611c59d430f.png', null, '1', '1', '2026-09-25 10:04:04', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('52', '0', '1', 'ScreenShot_2026-03-28_171541_015.png', '1790302080271_fa6a2dd9ad5240b3.png', 'b65216028a95a8503f997a62bf3ee969', 'image/png', '1790302080271_fa6a2dd9ad5240b3.png', 'png', '16427', '16.04KB', 'http://localhost:8181/profile/1790302080271_fa6a2dd9ad5240b3.png', null, '1', '1', '2026-09-25 10:08:00', '2026-09-25 10:08:05', '2026-09-25 10:08:05');
INSERT INTO `sa_system_attachment` VALUES ('53', '0', '1', 'mjc.88aab0a2.png', '1790302088642_52deb9c1afa94eee.png', '9955a9a409100c212f218f6570ae5c5d', 'image/png', '1790302088642_52deb9c1afa94eee.png', 'png', '6108', '5.96KB', 'http://localhost:8181/profile/1790302088642_52deb9c1afa94eee.png', null, '1', '1', '2026-09-25 10:08:09', '2026-09-25 10:08:09', null);
INSERT INTO `sa_system_attachment` VALUES ('54', '0', '1', 'wel_tips.5624828.png', '1790302137004_7ac5ed983c4a45e8.png', '5624828dcc8975b34dd8af3c5b6229d5', 'image/png', '1790302137004_7ac5ed983c4a45e8.png', 'png', '16937', '16.54KB', 'http://localhost:8181/profile/1790302137004_7ac5ed983c4a45e8.png', null, '1', '1', '2026-09-25 10:08:57', '2026-09-25 10:08:57', null);
INSERT INTO `sa_system_attachment` VALUES ('55', '1', '1', 'ScreenShot_2026-03-28_171606_033.png', '1790339881109_XvuDvfCM.png', null, 'image/png', 'uploads/2026/09/25/1790339881109_XvuDvfCM.png', 'png', '16632', '16.2KB', '/uploads/2026/09/25/1790339881109_XvuDvfCM.png', null, '1', null, '2026-09-25 20:38:01', '2026-09-25 20:38:01', null);

-- ----------------------------
-- Table structure for `sa_system_category`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_category`;
CREATE TABLE `sa_system_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父id',
  `level` varchar(255) DEFAULT NULL COMMENT '组集关系',
  `category_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pid` (`parent_id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='附件分类表';

-- ----------------------------
-- Records of sa_system_category
-- ----------------------------
INSERT INTO `sa_system_category` VALUES ('1', '0', '0,', '全部分类', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_category` VALUES ('2', '1', '0,1,', '图片分类', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-04-21 01:04:51', null);
INSERT INTO `sa_system_category` VALUES ('3', '1', '0,1,', '文件分类', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-23 21:54:20', null);
INSERT INTO `sa_system_category` VALUES ('4', '1', '0,1,', '系统图片', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_category` VALUES ('5', '1', '0,1,', '其他分类', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-28 23:51:54', null);
INSERT INTO `sa_system_category` VALUES ('6', '1', '0,1,', 'ces', '100', '1', '', '1', '1', '2026-03-23 21:52:33', '2026-03-23 21:52:35', null);
INSERT INTO `sa_system_category` VALUES ('7', '2', '0,1,2,', '测试', '100', '1', '', '1', '1', '2026-03-23 21:52:46', '2026-03-23 22:02:52', null);

-- ----------------------------
-- Table structure for `sa_system_config`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_config`;
CREATE TABLE `sa_system_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `group_id` int(11) DEFAULT NULL COMMENT '组id',
  `key` varchar(32) NOT NULL COMMENT '配置键名',
  `value` text COMMENT '配置值',
  `name` varchar(255) DEFAULT NULL COMMENT '配置名称',
  `input_type` varchar(32) DEFAULT NULL COMMENT '数据输入类型',
  `config_select_data` varchar(500) DEFAULT NULL COMMENT '配置选项数据',
  `sort` smallint(5) unsigned DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建人',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`,`key`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='参数配置表';

-- ----------------------------
-- Records of sa_system_config
-- ----------------------------
INSERT INTO `sa_system_config` VALUES ('1', '1', 'site_copyright', 'Copyright © 2026 FSSPHP Team', '版权信息', 'textarea', null, '96', '', '1', '1', '2026-01-01 00:00:00', '2026-10-13 00:35:09', null);
INSERT INTO `sa_system_config` VALUES ('2', '1', 'site_desc', '基于Vue3 + FSSPHP 的极速开发框架', '网站描述', 'textarea', null, '97', null, '1', '1', '2026-01-01 00:00:00', '2026-10-13 00:35:09', null);
INSERT INTO `sa_system_config` VALUES ('3', '1', 'site_keywords', 'FSSPHP, Workerman，symfony，Thinkphp，后台管理系统', '网站关键字', 'input', null, '98', null, '1', '1', '2026-01-01 00:00:00', '2026-10-13 00:35:09', null);
INSERT INTO `sa_system_config` VALUES ('4', '1', 'site_name', 'FssAdmin（go）版', '网站名称', 'input', null, '99', null, '1', '1', '2026-01-01 00:00:00', '2026-10-13 00:35:09', null);
INSERT INTO `sa_system_config` VALUES ('5', '1', 'site_record_number', '9527', '网站备案号', 'input', null, '95', null, '1', '1', '2026-01-01 00:00:00', '2026-10-13 00:35:09', null);
INSERT INTO `sa_system_config` VALUES ('6', '2', 'upload_allow_file', 'txt,doc,docx,xls,xlsx,ppt,pptx,rar,zip,7z,gz,pdf,wps,md,jpg,png,jpeg,mp4,pem,crt', '文件类型', 'input', null, '0', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('7', '2', 'upload_allow_image', 'jpg,jpeg,png,gif,svg,bmp', '图片类型', 'input', null, '0', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('8', '2', 'upload_mode', '1', '上传模式', 'select', '[{\"label\":\"本地上传\",\"value\":\"1\"},{\"label\":\"阿里云OSS\",\"value\":\"2\"},{\"label\":\"七牛云\",\"value\":\"3\"},{\"label\":\"腾讯云COS\",\"value\":\"4\"},{\"label\":\"亚马逊S3\",\"value\":\"5\"}]', '99', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('10', '2', 'upload_size', '52428800', '上传大小', 'input', null, '88', '单位Byte,1MB=1024*1024Byte', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('11', '2', 'local_root', 'public/storage/', '本地存储路径', 'input', null, '0', '本地存储文件路径', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('12', '2', 'local_domain', 'http://127.0.0.1:8000', '本地存储域名', 'input', null, '0', 'http://127.0.0.1:8787', '1', '1', '2026-01-01 00:00:00', '2026-03-22 20:07:02', null);
INSERT INTO `sa_system_config` VALUES ('13', '2', 'local_uri', '/storage/', '本地访问路径', 'input', null, '0', '访问是通过domain + uri', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('14', '2', 'qiniu_accessKey', '', '七牛key', 'input', null, '0', '七牛云存储secretId', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('15', '2', 'qiniu_secretKey', '', '七牛secret', 'input', null, '0', '七牛云存储secretKey', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('16', '2', 'qiniu_bucket', '', '七牛bucket', 'input', null, '0', '七牛云存储bucket', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('17', '2', 'qiniu_dirname', '', '七牛dirname', 'input', null, '0', '七牛云存储dirname', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('18', '2', 'qiniu_domain', '', '七牛domain', 'input', null, '0', '七牛云存储domain', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('19', '2', 'cos_secretId', '', '腾讯Id', 'input', null, '0', '腾讯云存储secretId', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('20', '2', 'cos_secretKey', '', '腾讯key', 'input', null, '0', '腾讯云secretKey', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('21', '2', 'cos_bucket', '', '腾讯bucket', 'input', null, '0', '腾讯云存储bucket', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('22', '2', 'cos_dirname', '', '腾讯dirname', 'input', null, '0', '腾讯云存储dirname', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('23', '2', 'cos_domain', '', '腾讯domain', 'input', null, '0', '腾讯云存储domain', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('24', '2', 'cos_region', '', '腾讯region', 'input', null, '0', '腾讯云存储region', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('25', '2', 'oss_accessKeyId', '', '阿里Id', 'input', null, '0', '阿里云存储accessKeyId', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('26', '2', 'oss_accessKeySecret', '', '阿里Secret', 'input', null, '0', '阿里云存储accessKeySecret', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('27', '2', 'oss_bucket', '', '阿里bucket', 'input', null, '0', '阿里云存储bucket', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('28', '2', 'oss_dirname', '', '阿里dirname', 'input', null, '0', '阿里云存储dirname', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('29', '2', 'oss_domain', '', '阿里domain', 'input', null, '0', '阿里云存储domain', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('30', '2', 'oss_endpoint', '', '阿里endpoint', 'input', null, '0', '阿里云存储endpoint', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('31', '3', 'Host', 'smtp.qq.com', 'SMTP服务器', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('32', '3', 'Port', '465', 'SMTP端口', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('33', '3', 'Username', '', 'SMTP用户名', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('34', '3', 'Password', '', 'SMTP密码', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('35', '3', 'SMTPSecure', 'ssl', 'SMTP验证方式', 'radio', '[\r\n    {\"label\":\"ssl\",\"value\":\"ssl\"},\r\n    {\"label\":\"tsl\",\"value\":\"tsl\"}\r\n]', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('36', '3', 'From', '', '默认发件人', 'input', '', '100', '默认发件的邮箱地址', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('37', '3', 'FromName', '账户注册', '默认发件名称', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('38', '3', 'CharSet', 'UTF-8', '编码', 'input', '', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('39', '3', 'SMTPDebug', '1', '调试模式', 'radio', '[\r\n    {\"label\":\"关闭\",\"value\":\"0\"},\r\n    {\"label\":\"client\",\"value\":\"1\"},\r\n    {\"label\":\"server\",\"value\":\"2\"}\r\n]', '100', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 17:56:52', null);
INSERT INTO `sa_system_config` VALUES ('40', '2', 's3_key', '', 'key', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('41', '2', 's3_secret', '', 'secret', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('42', '2', 's3_bucket', '', 'bucket', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('43', '2', 's3_dirname', '', 'dirname', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('44', '2', 's3_domain', '', 'domain', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('45', '2', 's3_region', '', 'region', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('46', '2', 's3_version', '', 'version', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('47', '2', 's3_use_path_style_endpoint', '', 'path_style_endpoint', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('48', '2', 's3_endpoint', '', 'endpoint', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('49', '2', 's3_acl', '', 'acl', 'input', '', '0', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config` VALUES ('50', '1', 'ggg', '', 'ggg', 'uploadImage', null, '100', '', '1', '1', '2026-03-22 20:11:57', '2026-03-22 20:36:34', '2026-03-22 20:36:34');
INSERT INTO `sa_system_config` VALUES ('52', '1', 'Logo', 'http://127.0.0.1:8000/uploads/2026/03/28/69c7a3acd6b581.21163358.png', 'Logo', 'uploadImage', null, '100', '', '1', '1', '2026-03-25 21:30:52', '2026-03-28 23:36:48', '2026-03-28 23:36:48');
INSERT INTO `sa_system_config` VALUES ('54', '1', 'file', '', 'file', 'uploadFile', '[]', '100', '', '1', '1', '2026-03-28 22:17:22', '2026-03-28 22:17:32', '2026-03-28 22:17:32');
INSERT INTO `sa_system_config` VALUES ('55', '1', 'file', '', 'file', 'uploadFile', '[]', '100', '', '1', '1', '2026-03-28 22:17:23', '2026-03-28 22:17:36', '2026-03-28 22:17:36');
INSERT INTO `sa_system_config` VALUES ('56', '1', 'file', '', 'file', 'uploadFile', '[]', '100', '', '1', '1', '2026-03-28 22:17:28', '2026-03-28 23:36:48', '2026-03-28 23:36:48');
INSERT INTO `sa_system_config` VALUES ('60', '10', 'ai_enabled', '1', '启用 AI 助手', 'select', '[{\"label\":\"关闭\",\"value\":\"0\"},{\"label\":\"开启\",\"value\":\"1\"}]', '100', '', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('61', '10', 'ai_max_history_rounds', '10', '默认携带历史轮数', 'input', null, '90', '构建上下文时最多取最近 N 轮；配合摘要可设 8-12', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('62', '10', 'ai_summary_enabled', '1', '启用长对话自动摘要', 'select', '[{\"label\":\"关闭\",\"value\":\"0\"},{\"label\":\"开启\",\"value\":\"1\"}]', '89', '超出触发轮数后压缩旧消息为摘要', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('63', '10', 'ai_summary_trigger_rounds', '12', '摘要触发轮数', 'input', null, '88', '对话超过 N 轮后开始摘要旧消息', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('64', '10', 'ai_summary_keep_rounds', '8', '摘要后保留原文轮数', 'input', null, '87', '最近 N 轮仍以完整消息发送', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('65', '10', 'ai_context_reserve_tokens', '1024', '上下文安全余量(tokens)', 'input', null, '86', '预留给输出与格式开销，防止超窗', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('66', '10', 'ai_summary_model_id', '', '摘要专用模型ID', 'input', null, '85', '留空则用会话当前模型；可填便宜模型 ID 省 token', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('67', '10', 'ai_ws_heartbeat_sec', '30', 'WebSocket 心跳间隔(秒)', 'input', null, '80', '', '1', '1', '2026-06-21 22:51:58', '2026-06-21 22:51:58', null);
INSERT INTO `sa_system_config` VALUES ('68', '10', 'ai_message_max_tokens', '1500', '单条历史消息上限(tokens)', 'input', null, '84', 'Reasonix 式 turn-end 截断，完整内容仍存 DB', '1', '1', '2026-06-21 23:03:39', '2026-06-21 23:03:39', null);
INSERT INTO `sa_system_config` VALUES ('69', '10', 'ai_context_compact_threshold', '80', '紧急压缩阈值(%)', 'input', null, '83', '上下文占比达此值触发摘要，对标 Reasonix 80%', '1', '1', '2026-06-21 23:03:39', '2026-06-21 23:03:39', null);
INSERT INTO `sa_system_config` VALUES ('70', '10', 'ai_context_compact_proactive', '40', '主动压缩阈值(%)', 'input', null, '82', '上下文占比达此值提前摘要，对标 Reasonix 40%', '1', '1', '2026-06-21 23:03:39', '2026-06-21 23:03:39', null);

-- ----------------------------
-- Table structure for `sa_system_config_group`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_config_group`;
CREATE TABLE `sa_system_config_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '字典名称',
  `code` varchar(100) DEFAULT NULL COMMENT '字典标示',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建人',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='参数配置分组表';

-- ----------------------------
-- Records of sa_system_config_group
-- ----------------------------
INSERT INTO `sa_system_config_group` VALUES ('1', '站点配置', 'site_config', '111', '1', '1', '2026-01-01 00:00:00', '2026-03-31 00:31:21', null);
INSERT INTO `sa_system_config_group` VALUES ('2', '上传配置', 'upload_config', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config_group` VALUES ('3', '邮件服务', 'email_config', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_config_group` VALUES ('10', 'AI 助手', 'ai', '大模型对话全局参数', '1', '1', '2026-06-21 21:59:30', '2026-06-21 21:59:30', null);

-- ----------------------------
-- Table structure for `sa_system_dept`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_dept`;
CREATE TABLE `sa_system_dept` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '父级ID，0为根节点',
  `name` varchar(64) NOT NULL COMMENT '部门名称',
  `code` varchar(64) DEFAULT NULL COMMENT '部门编码',
  `leader_id` bigint(20) unsigned DEFAULT NULL COMMENT '部门负责人ID',
  `level` varchar(255) DEFAULT '' COMMENT '祖级列表，格式: 0,1,5, (便于查询子孙节点)',
  `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '所属租户ID，0表示系统级',
  `sort` int(11) DEFAULT '0' COMMENT '排序，数字越小越靠前',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 1启用, 0禁用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='部门表';

-- ----------------------------
-- Records of sa_system_dept
-- ----------------------------
INSERT INTO `sa_system_dept` VALUES ('1', '0', '腾讯集团', 'GROUP', '100', '0,', '1', '0', '1', '0011', '1', '1', '2026-01-01 00:00:00', '2026-09-28 22:19:10', null);
INSERT INTO `sa_system_dept` VALUES ('2', '0', '总办', 'GMO', '0', '0,1,', '1', '1', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 11:20:13', null);
INSERT INTO `sa_system_dept` VALUES ('5', '0', '技术部A', null, null, '', '1', '0', '1', null, null, null, '2026-04-24 12:34:04', '2026-04-24 12:34:04', null);
INSERT INTO `sa_system_dept` VALUES ('8', '0', '销售部B', null, null, '', '2', '0', '1', null, null, null, '2026-04-24 12:34:04', '2026-04-24 12:34:04', null);
INSERT INTO `sa_system_dept` VALUES ('10', '0', '微信事业群', 'WXG', '0', '0,1,', '1', '1', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 11:38:29', null);
INSERT INTO `sa_system_dept` VALUES ('11', '0', '互动娱乐事业群', 'IEG', '0', '0,1,', '1', '1', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 11:39:34', null);
INSERT INTO `sa_system_dept` VALUES ('12', '1', '云与智慧产业事业群', 'CSIG', '10', '0,1,', '1', '400', '1', '122', '1', '1', '2026-01-01 00:00:00', '2026-06-23 18:41:24', null);
INSERT INTO `sa_system_dept` VALUES ('100', '0', '测试部门', null, null, '', '10', '0', '1', null, null, null, '2026-04-24 12:40:17', '2026-04-24 12:40:17', null);
INSERT INTO `sa_system_dept` VALUES ('101', '10', '微信基础产品部', 'WX_BASE', null, '0,1,10,', '1', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dept` VALUES ('102', '10', '微信支付线', 'WX_PAY', null, '0,1,10,', '1', '200', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 11:37:14', null);
INSERT INTO `sa_system_dept` VALUES ('110', '0', '父部门', null, null, '', '10', '0', '1', null, null, null, '2026-04-24 12:40:19', '2026-04-24 12:40:19', null);
INSERT INTO `sa_system_dept` VALUES ('111', '11', '天美工作室群', 'TIMI', null, '0,1,11,', '1', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dept` VALUES ('112', '11', '光子工作室群', 'LIGHT', null, '0,1,11,', '1', '200', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 22:00:41', null);
INSERT INTO `sa_system_dept` VALUES ('120', '0', '权限测试部门', null, null, '', '10', '0', '1', null, null, null, '2026-04-24 12:40:19', '2026-04-24 12:40:19', null);
INSERT INTO `sa_system_dept` VALUES ('121', '12', '腾讯云事业部1', 'CLOUD', '122', '0,1,12,', '1', '100', '1', '111', '1', '1', '2026-01-01 00:00:00', '2026-09-21 23:30:40', null);
INSERT INTO `sa_system_dept` VALUES ('122', '111', '王者荣耀项目组', 'HOK', '101', '0,1,11,111,', '1', '100', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-03-22 13:01:35', null);
INSERT INTO `sa_system_dept` VALUES ('123', '111', 'QQ飞车项目组', 'QQ_SPEED', '5', '0,1,11,111,', '0', '200', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dept` VALUES ('127', '0', '111233', '11111', '100', '0,', '1', '100', '1', '11', '1', '1', '2026-03-22 12:06:27', '2026-03-31 19:30:50', '2026-03-31 19:30:50');
INSERT INTO `sa_system_dept` VALUES ('128', '0', '11', '111', '123', '0,', '0', '100', '1', '', '1', '1', '2026-03-22 12:27:44', '2026-09-21 23:30:25', null);
INSERT INTO `sa_system_dept` VALUES ('129', '0', '5555', 'aa', null, '0,', '2', '100', '1', '', '100', '1', '2026-04-19 00:30:03', '2026-09-21 23:30:19', null);
INSERT INTO `sa_system_dept` VALUES ('130', '1', '', null, null, '0,1,', '1', '1', '1', null, '1', '1', '2026-06-21 21:33:14', '2026-06-23 17:54:34', '2026-06-23 17:54:34');
INSERT INTO `sa_system_dept` VALUES ('131', '0', 'aaa11', 'aa1', '123', '', '1', '101', '1', '111', '1', '1', '2026-09-21 23:30:55', '2026-09-21 23:31:30', '2026-10-13 20:57:45');

-- ----------------------------
-- Table structure for `sa_system_dict_data`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_dict_data`;
CREATE TABLE `sa_system_dict_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` int(11) unsigned DEFAULT NULL COMMENT '字典类型ID',
  `label` varchar(50) DEFAULT NULL COMMENT '字典标签',
  `value` varchar(100) DEFAULT NULL COMMENT '字典值',
  `color` varchar(50) DEFAULT NULL COMMENT '字典颜色',
  `code` varchar(100) DEFAULT NULL COMMENT '字典标示',
  `sort` smallint(5) unsigned DEFAULT '0' COMMENT '排序',
  `status` smallint(6) DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of sa_system_dict_data
-- ----------------------------
INSERT INTO `sa_system_dict_data` VALUES ('2', '2', '本地存储', '1', '#60c041', 'upload_mode', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-29 00:01:30', null);
INSERT INTO `sa_system_dict_data` VALUES ('3', '2', '阿里云OSS', '2', '#f9901f', 'upload_mode', '98', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-29 00:01:30', null);
INSERT INTO `sa_system_dict_data` VALUES ('4', '2', '七牛云', '3', '#00ced1', 'upload_mode', '97', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-29 00:01:30', null);
INSERT INTO `sa_system_dict_data` VALUES ('5', '2', '腾讯云COS', '4', '#1d84ff', 'upload_mode', '96', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-29 00:01:30', null);
INSERT INTO `sa_system_dict_data` VALUES ('6', '2', '亚马逊S3', '5', '#b48df3', 'upload_mode', '95', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-29 00:01:30', null);
INSERT INTO `sa_system_dict_data` VALUES ('7', '3', '正常', '1', '#60c041', 'data_status', '0', '1', '1为正常', '1', '1', '2026-01-01 00:00:00', '2026-03-24 23:16:13', null);
INSERT INTO `sa_system_dict_data` VALUES ('8', '3', '停用', '0', '#ff4d4f', 'data_status', '0', '1', '0为停用1', '1', '1', '2026-01-01 00:00:00', '2026-03-28 17:53:02', null);
INSERT INTO `sa_system_dict_data` VALUES ('9', '4', '统计页面', 'statistics', '#00ced1', 'dashboard', '100', '1', '管理员用', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('10', '4', '工作台', 'work', '#ff8c00', 'dashboard', '50', '1', '员工使用', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('11', '5', '男', '1', '#5d87ff', 'gender', '0', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('12', '5', '女', '2', '#ff4500', 'gender', '0', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('13', '5', '未知', '3', '#b48df3', 'gender', '0', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('16', '12', '图片', 'image', '#60c041', 'attachment_type', '10', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('17', '12', '文档', 'text', '#1d84ff', 'attachment_type', '9', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('18', '12', '音频', 'audio', '#00ced1', 'attachment_type', '8', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('19', '12', '视频', 'video', '#ff4500', 'attachment_type', '7', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('20', '12', '应用程序', 'application', '#ff8c00', 'attachment_type', '6', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('21', '13', '目录', '1', '#909399', 'menu_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('22', '13', '菜单', '2', '#1e90ff', 'menu_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('23', '13', '按钮', '3', '#ff4500', 'menu_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('24', '13', '外链', '4', '#00ced1', 'menu_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('25', '14', '是', '1', '#60c041', 'yes_or_no', '101', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-21 23:55:46', null);
INSERT INTO `sa_system_dict_data` VALUES ('26', '14', '否', '0', '#ff4500', 'yes_or_no', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-03-23 21:16:53', null);
INSERT INTO `sa_system_dict_data` VALUES ('47', '20', 'URL任务GET', '1', '#5d87ff', 'crontab_task_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('48', '20', 'URL任务POST', '2', '#00ced1', 'crontab_task_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-03-28 23:11:23', null);
INSERT INTO `sa_system_dict_data` VALUES ('49', '20', '类任务', '3', '#ff8c00', 'crontab_task_type', '100', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_data` VALUES ('50', '5', 'renn', '4', '#5d87ff', null, '100', '1', '', '1', '1', '2026-03-23 21:20:40', '2026-03-23 21:20:44', '2026-03-23 21:20:44');
INSERT INTO `sa_system_dict_data` VALUES ('51', '5', '11', '111', '#5d87ff', null, '100', '0', '', '1', '1', '2026-03-23 21:20:49', '2026-03-23 21:24:19', '2026-03-23 21:24:19');
INSERT INTO `sa_system_dict_data` VALUES ('52', '5', '11', '123', '#5d87ff', null, '100', '1', '', '1', '1', '2026-03-23 21:24:27', '2026-03-23 21:24:30', '2026-03-23 21:24:30');

-- ----------------------------
-- Table structure for `sa_system_dict_type`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_dict_type`;
CREATE TABLE `sa_system_dict_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '字典名称',
  `code` varchar(100) DEFAULT NULL COMMENT '字典标示',
  `status` smallint(6) DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of sa_system_dict_type
-- ----------------------------
INSERT INTO `sa_system_dict_type` VALUES ('2', '存储模式', 'upload_mode', '1', '上传文件存储模式111', '1', '1', '2026-01-01 00:00:00', '2026-06-19 10:50:00', null);
INSERT INTO `sa_system_dict_type` VALUES ('3', '数据状态', 'data_status', '1', '通用数据状态', '1', '1', '2026-01-01 00:00:00', '2026-06-23 18:43:44', null);
INSERT INTO `sa_system_dict_type` VALUES ('4', '后台首页', 'dashboard', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 18:43:47', null);
INSERT INTO `sa_system_dict_type` VALUES ('5', '性别', 'gender', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-03-23 21:24:56', null);
INSERT INTO `sa_system_dict_type` VALUES ('12', '附件类型', 'attachment_type', '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_type` VALUES ('13', '菜单类型', 'menu_type', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_dict_type` VALUES ('14', '是否', 'yes_or_no', '1', '11', '1', '1', '2026-01-01 00:00:00', '2026-07-18 19:12:28', null);
INSERT INTO `sa_system_dict_type` VALUES ('20', '定时任务类型', 'crontab_task_type', '1', '2', '1', '1', '2026-01-01 00:00:00', '2026-09-22 23:35:58', null);
INSERT INTO `sa_system_dict_type` VALUES ('21', '111', '111', '1', '', '1', '1', '2026-03-23 21:25:10', '2026-03-23 22:48:47', '2026-03-23 22:48:47');

-- ----------------------------
-- Table structure for `sa_system_login_log`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_login_log`;
CREATE TABLE `sa_system_login_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(20) DEFAULT NULL COMMENT '用户名',
  `ip` varchar(45) DEFAULT NULL COMMENT '登录IP地址',
  `ip_location` varchar(255) DEFAULT NULL COMMENT 'IP所属地',
  `os` varchar(50) DEFAULT NULL COMMENT '操作系统',
  `browser` varchar(50) DEFAULT NULL COMMENT '浏览器',
  `status` smallint(6) DEFAULT '1' COMMENT '登录状态 (1成功 2失败)',
  `message` varchar(50) DEFAULT NULL COMMENT '提示消息',
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '登录时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';

-- ----------------------------
-- Records of sa_system_login_log
-- ----------------------------
INSERT INTO `sa_system_login_log` VALUES ('1', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 19:11:16', null, null, null, '2026-07-18 19:11:16', '2026-07-18 19:11:16', null);
INSERT INTO `sa_system_login_log` VALUES ('2', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 19:13:08', null, null, null, '2026-07-18 19:13:08', '2026-07-18 19:13:08', null);
INSERT INTO `sa_system_login_log` VALUES ('3', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 21:15:59', null, null, null, '2026-07-18 21:15:59', '2026-07-18 21:15:59', null);
INSERT INTO `sa_system_login_log` VALUES ('4', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 21:19:58', null, null, null, '2026-07-18 21:19:58', '2026-07-18 21:19:58', null);
INSERT INTO `sa_system_login_log` VALUES ('5', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 21:21:24', null, null, null, '2026-07-18 21:21:24', '2026-07-18 21:21:24', null);
INSERT INTO `sa_system_login_log` VALUES ('6', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-18 22:09:34', null, null, null, '2026-07-18 22:09:34', '2026-07-18 22:09:34', null);
INSERT INTO `sa_system_login_log` VALUES ('7', 'admin', '::1', '', '', '', '1', '登录成功', '2026-07-18 23:56:00', null, null, null, '2026-07-18 23:56:00', '2026-07-18 23:56:00', null);
INSERT INTO `sa_system_login_log` VALUES ('8', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-19 00:03:34', null, null, null, '2026-07-19 00:03:34', '2026-07-19 00:03:34', null);
INSERT INTO `sa_system_login_log` VALUES ('9', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-19 10:43:19', null, null, null, '2026-07-19 10:43:19', '2026-07-19 10:43:19', null);
INSERT INTO `sa_system_login_log` VALUES ('10', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-07-19 22:12:17', null, null, null, '2026-07-19 22:12:17', '2026-07-19 22:12:17', null);
INSERT INTO `sa_system_login_log` VALUES ('11', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 151.0.0', '1', '退出成功', '2026-08-24 22:38:47', null, null, null, '2026-08-24 22:38:47', '2026-08-24 22:38:47', null);
INSERT INTO `sa_system_login_log` VALUES ('12', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-24 22:38:56', null, null, null, '2026-08-24 22:38:56', '2026-08-24 22:38:56', null);
INSERT INTO `sa_system_login_log` VALUES ('13', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 151.0.0', '1', '退出成功', '2026-08-24 22:40:08', null, null, null, '2026-08-24 22:40:08', '2026-08-24 22:40:08', null);
INSERT INTO `sa_system_login_log` VALUES ('14', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-24 22:43:04', null, null, null, '2026-08-24 22:43:04', '2026-08-24 22:43:04', null);
INSERT INTO `sa_system_login_log` VALUES ('15', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-24 23:11:40', null, null, null, '2026-08-24 23:11:40', '2026-08-24 23:11:40', null);
INSERT INTO `sa_system_login_log` VALUES ('16', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-24 23:39:02', null, null, null, '2026-08-24 23:39:02', '2026-08-24 23:39:02', null);
INSERT INTO `sa_system_login_log` VALUES ('17', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-26 22:29:07', null, null, null, '2026-08-26 22:29:07', '2026-08-26 22:29:07', null);
INSERT INTO `sa_system_login_log` VALUES ('18', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-26 23:08:15', null, null, null, '2026-08-26 23:08:15', '2026-08-26 23:08:15', null);
INSERT INTO `sa_system_login_log` VALUES ('19', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-27 21:22:31', null, null, null, '2026-08-27 21:22:31', '2026-08-27 21:22:31', null);
INSERT INTO `sa_system_login_log` VALUES ('20', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-27 21:22:52', null, null, null, '2026-08-27 21:22:52', '2026-08-27 21:22:52', null);
INSERT INTO `sa_system_login_log` VALUES ('21', 'admin', '127.0.0.1', '', '', '', '1', '登录成功', '2026-08-28 20:55:32', null, null, null, '2026-08-28 20:55:32', '2026-08-28 20:55:32', null);
INSERT INTO `sa_system_login_log` VALUES ('22', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:11:17', null, null, null, '2026-08-28 21:11:17', '2026-08-28 21:11:17', null);
INSERT INTO `sa_system_login_log` VALUES ('23', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:28:45', null, null, null, '2026-08-28 21:28:45', '2026-08-28 21:28:45', null);
INSERT INTO `sa_system_login_log` VALUES ('24', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:29:07', null, null, null, '2026-08-28 21:29:07', '2026-08-28 21:29:07', null);
INSERT INTO `sa_system_login_log` VALUES ('25', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:30:38', null, null, null, '2026-08-28 21:30:38', '2026-08-28 21:30:38', null);
INSERT INTO `sa_system_login_log` VALUES ('26', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:31:08', null, null, null, '2026-08-28 21:31:08', '2026-08-28 21:31:08', null);
INSERT INTO `sa_system_login_log` VALUES ('27', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:38:40', null, null, null, '2026-08-28 21:38:40', '2026-08-28 21:38:40', null);
INSERT INTO `sa_system_login_log` VALUES ('28', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:40:10', null, null, null, '2026-08-28 21:40:10', '2026-08-28 21:40:10', null);
INSERT INTO `sa_system_login_log` VALUES ('29', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:43:52', null, null, null, '2026-08-28 21:43:52', '2026-08-28 21:43:52', null);
INSERT INTO `sa_system_login_log` VALUES ('30', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:49:26', null, null, null, '2026-08-28 21:49:26', '2026-08-28 21:49:26', null);
INSERT INTO `sa_system_login_log` VALUES ('31', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-28 21:56:14', null, null, null, '2026-08-28 21:56:14', '2026-08-28 21:56:14', null);
INSERT INTO `sa_system_login_log` VALUES ('32', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 151.0.0', '1', '登录成功', '2026-08-30 04:53:03', null, null, null, '2026-08-30 11:53:03', '2026-08-30 11:53:03', null);
INSERT INTO `sa_system_login_log` VALUES ('33', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 125.0.0', '1', '登录成功', '2026-08-30 05:21:42', null, null, null, '2026-08-30 12:21:42', '2026-08-30 12:21:42', null);
INSERT INTO `sa_system_login_log` VALUES ('34', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 125.0.0', '1', '登录成功', '2026-08-30 07:30:13', null, null, null, '2026-08-30 14:30:13', '2026-08-30 14:30:13', null);
INSERT INTO `sa_system_login_log` VALUES ('35', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 125.0.0', '1', '登录成功', '2026-08-30 11:58:12', null, null, null, '2026-08-30 18:58:12', '2026-08-30 18:58:12', null);
INSERT INTO `sa_system_login_log` VALUES ('36', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-21 14:58:28', null, null, null, '2026-09-21 21:58:28', '2026-09-21 21:58:28', null);
INSERT INTO `sa_system_login_log` VALUES ('37', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '2', '用户名或密码错误', '2026-09-21 23:21:26', null, null, null, '2026-09-21 23:21:26', null, null);
INSERT INTO `sa_system_login_log` VALUES ('38', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-21 23:21:42', null, null, null, '2026-09-21 23:21:42', null, null);
INSERT INTO `sa_system_login_log` VALUES ('39', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-21 23:21:54', null, null, null, '2026-09-21 23:21:54', null, null);
INSERT INTO `sa_system_login_log` VALUES ('40', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-21 23:22:09', null, null, null, '2026-09-21 23:22:09', null, null);
INSERT INTO `sa_system_login_log` VALUES ('41', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-21 23:49:56', null, null, null, '2026-09-21 23:49:56', null, null);
INSERT INTO `sa_system_login_log` VALUES ('42', 'admin', '127.0.0.1', '', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-21 23:50:18', null, null, null, '2026-09-21 23:50:18', null, null);
INSERT INTO `sa_system_login_log` VALUES ('43', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-21 23:54:05', null, null, null, '2026-09-21 23:54:05', null, null);
INSERT INTO `sa_system_login_log` VALUES ('44', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-21 23:56:32', null, null, null, '2026-09-21 23:56:32', null, null);
INSERT INTO `sa_system_login_log` VALUES ('45', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 22:54:42', null, null, null, '2026-09-22 22:54:42', null, null);
INSERT INTO `sa_system_login_log` VALUES ('46', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 23:21:53', null, null, null, '2026-09-22 23:21:53', null, null);
INSERT INTO `sa_system_login_log` VALUES ('47', 'devwang', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 23:25:07', null, null, null, '2026-09-22 23:25:07', null, null);
INSERT INTO `sa_system_login_log` VALUES ('48', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 23:25:26', null, null, null, '2026-09-22 23:25:26', null, null);
INSERT INTO `sa_system_login_log` VALUES ('49', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 23:26:52', null, null, null, '2026-09-22 23:26:52', null, null);
INSERT INTO `sa_system_login_log` VALUES ('50', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-22 23:42:28', null, null, null, '2026-09-22 23:42:28', null, null);
INSERT INTO `sa_system_login_log` VALUES ('51', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:22:44', null, null, null, '2026-09-23 07:12:33', null, '2026-09-23 07:22:45');
INSERT INTO `sa_system_login_log` VALUES ('52', 'devwang', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:38:54', null, null, null, '2026-09-23 07:38:54', null, null);
INSERT INTO `sa_system_login_log` VALUES ('53', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:39:13', null, null, null, '2026-09-23 07:39:13', null, null);
INSERT INTO `sa_system_login_log` VALUES ('54', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:46:50', null, null, null, '2026-09-23 07:46:50', null, null);
INSERT INTO `sa_system_login_log` VALUES ('55', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:47:57', null, null, null, '2026-09-23 07:47:57', null, null);
INSERT INTO `sa_system_login_log` VALUES ('56', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:51:50', null, null, null, '2026-09-23 07:51:50', null, null);
INSERT INTO `sa_system_login_log` VALUES ('57', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:53:45', null, null, null, '2026-09-23 07:53:45', null, null);
INSERT INTO `sa_system_login_log` VALUES ('58', 'devwang', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 07:54:02', null, null, null, '2026-09-23 07:54:02', null, null);
INSERT INTO `sa_system_login_log` VALUES ('59', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-23 08:01:38', null, null, null, '2026-09-23 08:01:38', null, null);
INSERT INTO `sa_system_login_log` VALUES ('60', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-24 21:55:17', null, null, null, '2026-09-24 21:55:17', null, null);
INSERT INTO `sa_system_login_log` VALUES ('61', 'admin', '::1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-24 22:25:35', null, null, null, '2026-09-24 22:25:35', null, null);
INSERT INTO `sa_system_login_log` VALUES ('62', 'admin', '127.0.0.1', '', 'Windows', 'Unknown', '1', '登录成功', '2026-09-24 23:00:29', null, null, null, '2026-09-24 23:00:29', null, null);
INSERT INTO `sa_system_login_log` VALUES ('63', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-24 23:23:56', null, null, null, '2026-09-24 23:23:56', null, null);
INSERT INTO `sa_system_login_log` VALUES ('64', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-24 23:26:30', null, null, null, '2026-09-24 23:26:30', null, null);
INSERT INTO `sa_system_login_log` VALUES ('65', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 00:08:21', null, null, null, '2026-09-25 00:08:21', '2026-09-25 00:08:21', null);
INSERT INTO `sa_system_login_log` VALUES ('66', null, '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 00:08:29', null, null, null, '2026-09-25 00:08:29', '2026-09-25 00:08:29', null);
INSERT INTO `sa_system_login_log` VALUES ('67', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 00:08:36', null, null, null, '2026-09-25 00:08:36', '2026-09-25 00:08:36', null);
INSERT INTO `sa_system_login_log` VALUES ('68', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 00:34:12', null, null, null, '2026-09-25 00:34:12', '2026-09-25 00:34:12', null);
INSERT INTO `sa_system_login_log` VALUES ('69', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 00:34:19', null, null, null, '2026-09-25 00:34:19', '2026-09-25 00:34:19', null);
INSERT INTO `sa_system_login_log` VALUES ('70', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 00:48:46', null, null, null, '2026-09-25 00:48:46', '2026-09-25 00:48:46', null);
INSERT INTO `sa_system_login_log` VALUES ('71', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 00:48:53', null, null, null, '2026-09-25 00:48:53', '2026-09-25 00:48:53', null);
INSERT INTO `sa_system_login_log` VALUES ('72', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 09:42:08', null, null, null, '2026-09-25 09:42:08', '2026-09-25 09:42:08', null);
INSERT INTO `sa_system_login_log` VALUES ('73', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 09:42:30', null, null, null, '2026-09-25 09:42:30', '2026-09-25 09:42:30', null);
INSERT INTO `sa_system_login_log` VALUES ('74', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 10:07:23', null, null, null, '2026-09-25 10:07:23', '2026-09-25 10:07:23', null);
INSERT INTO `sa_system_login_log` VALUES ('75', 'admin', '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 10:07:29', null, null, null, '2026-09-25 10:07:29', '2026-09-25 10:07:29', null);
INSERT INTO `sa_system_login_log` VALUES ('76', null, '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 14:20:19', null, null, null, '2026-09-25 14:20:19', '2026-09-25 14:20:19', null);
INSERT INTO `sa_system_login_log` VALUES ('77', null, '127.0.0.1', '内网地址', 'Windows', 'Chrome 153.0.0', '1', '退出成功', '2026-09-25 14:20:26', null, null, null, '2026-09-25 14:20:26', '2026-09-25 14:20:26', null);
INSERT INTO `sa_system_login_log` VALUES ('78', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 11:27:15', null, null, null, '2026-09-25 18:27:15', '2026-09-25 18:27:15', null);
INSERT INTO `sa_system_login_log` VALUES ('79', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 11:30:10', null, null, null, '2026-09-25 18:30:10', '2026-09-25 18:30:10', null);
INSERT INTO `sa_system_login_log` VALUES ('80', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-25 11:32:44', null, null, null, '2026-09-25 18:32:44', '2026-09-25 18:32:44', null);
INSERT INTO `sa_system_login_log` VALUES ('81', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 20:37:51', null, null, null, '2026-09-25 20:37:51', null, null);
INSERT INTO `sa_system_login_log` VALUES ('82', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 20:39:49', null, null, null, '2026-09-25 20:39:49', null, null);
INSERT INTO `sa_system_login_log` VALUES ('83', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 20:40:34', null, null, null, '2026-09-25 20:40:34', null, null);
INSERT INTO `sa_system_login_log` VALUES ('84', 'admin', '127.0.0.1', '', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 22:27:58', null, null, null, '2026-09-25 22:27:58', null, null);
INSERT INTO `sa_system_login_log` VALUES ('85', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 22:35:46', null, null, null, '2026-09-25 22:35:46', null, null);
INSERT INTO `sa_system_login_log` VALUES ('86', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-25 22:36:20', null, null, null, '2026-09-25 22:36:20', null, null);
INSERT INTO `sa_system_login_log` VALUES ('87', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-28 22:05:49', null, null, null, '2026-09-28 22:05:49', null, null);
INSERT INTO `sa_system_login_log` VALUES ('88', 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-28 23:29:22', null, null, null, '2026-09-28 23:29:22', null, null);
INSERT INTO `sa_system_login_log` VALUES ('89', 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '登录成功', '2026-09-28 23:29:34', null, null, null, '2026-09-28 23:29:34', null, null);
INSERT INTO `sa_system_login_log` VALUES ('90', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-28 23:30:18', null, null, null, '2026-09-28 23:30:18', null, null);
INSERT INTO `sa_system_login_log` VALUES ('91', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-28 23:41:38', null, null, null, '2026-09-28 23:41:38', null, null);
INSERT INTO `sa_system_login_log` VALUES ('92', 'devwang', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-28 23:42:13', null, null, null, '2026-09-28 23:42:13', null, null);
INSERT INTO `sa_system_login_log` VALUES ('93', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome 153.0.0', '1', '登录成功', '2026-09-28 16:44:25', null, null, null, '2026-09-28 23:44:25', '2026-09-28 23:44:25', null);
INSERT INTO `sa_system_login_log` VALUES ('94', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-09-29 00:27:09', null, null, null, '2026-09-29 00:27:09', null, null);
INSERT INTO `sa_system_login_log` VALUES ('95', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 00:29:09', null, null, null, '2026-10-13 00:29:09', null, null);
INSERT INTO `sa_system_login_log` VALUES ('96', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 00:34:43', null, null, null, '2026-10-13 00:34:43', null, null);
INSERT INTO `sa_system_login_log` VALUES ('97', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 00:35:41', null, null, null, '2026-10-13 00:35:41', null, null);
INSERT INTO `sa_system_login_log` VALUES ('98', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 19:51:19', null, null, null, '2026-10-13 19:51:19', null, null);
INSERT INTO `sa_system_login_log` VALUES ('99', 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '登录成功', '2026-10-13 20:34:36', null, null, null, '2026-10-13 20:34:36', null, null);
INSERT INTO `sa_system_login_log` VALUES ('100', 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '登录成功', '2026-10-13 20:35:36', null, null, null, '2026-10-13 20:35:36', null, null);
INSERT INTO `sa_system_login_log` VALUES ('101', 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '登录成功', '2026-10-13 20:36:21', null, null, null, '2026-10-13 20:36:21', null, null);
INSERT INTO `sa_system_login_log` VALUES ('102', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:15:47', null, null, null, '2026-10-13 21:15:47', null, null);
INSERT INTO `sa_system_login_log` VALUES ('103', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:16:58', null, null, null, '2026-10-13 21:16:58', null, null);
INSERT INTO `sa_system_login_log` VALUES ('104', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:17:31', null, null, null, '2026-10-13 21:17:19', null, '2026-10-13 21:17:32');
INSERT INTO `sa_system_login_log` VALUES ('105', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:21:47', null, null, null, '2026-10-13 21:21:47', null, null);
INSERT INTO `sa_system_login_log` VALUES ('106', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:24:37', null, null, null, '2026-10-13 21:24:37', null, null);
INSERT INTO `sa_system_login_log` VALUES ('107', 'admin', '127.0.0.1', '内网IP', 'Windows', 'Chrome', '1', '登录成功', '2026-10-13 21:25:27', null, null, null, '2026-10-13 21:25:27', null, null);

-- ----------------------------
-- Table structure for `sa_system_mail`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_mail`;
CREATE TABLE `sa_system_mail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `gateway` varchar(50) DEFAULT NULL COMMENT '网关',
  `from` varchar(50) DEFAULT NULL COMMENT '发送人',
  `email` varchar(50) DEFAULT NULL COMMENT '接收人',
  `code` varchar(20) DEFAULT NULL COMMENT '验证码',
  `content` varchar(500) DEFAULT NULL COMMENT '邮箱内容',
  `status` varchar(20) DEFAULT NULL COMMENT '发送状态',
  `response` varchar(500) DEFAULT NULL COMMENT '返回结果',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='邮件记录';

-- ----------------------------
-- Records of sa_system_mail
-- ----------------------------
INSERT INTO `sa_system_mail` VALUES ('1', 'mail.163.com', 'test@qq.com', 'admin@qq.com', '869', 'hello', 'success', 'data', '2026-03-23 19:53:53', null, null);
INSERT INTO `sa_system_mail` VALUES ('2', 'mail.qq.com', 'admin@test.com', 'admin@qq.com', '456', 'test', 'failure', 'data', '2026-03-23 19:52:49', '2026-03-28 18:41:38', null);

-- ----------------------------
-- Table structure for `sa_system_menu`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_menu`;
CREATE TABLE `sa_system_menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '父级ID',
  `name` varchar(64) NOT NULL COMMENT '菜单名称',
  `code` varchar(64) DEFAULT NULL COMMENT '组件名称',
  `slug` varchar(100) DEFAULT NULL COMMENT '权限标识，如 user:list, user:add',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型: 1目录, 2菜单, 3按钮/API',
  `path` varchar(255) DEFAULT NULL COMMENT '路由地址(前端)或API路径(后端)',
  `component` varchar(255) DEFAULT NULL COMMENT '前端组件路径，如 layout/User',
  `method` varchar(10) DEFAULT NULL COMMENT '请求方式',
  `icon` varchar(64) DEFAULT NULL COMMENT '图标',
  `sort` int(11) DEFAULT '100' COMMENT '排序',
  `link_url` varchar(255) DEFAULT NULL COMMENT '外部链接',
  `is_iframe` tinyint(1) DEFAULT '2' COMMENT '是否iframe',
  `is_keep_alive` tinyint(1) DEFAULT '2' COMMENT '是否缓存',
  `is_hidden` tinyint(1) DEFAULT '2' COMMENT '是否隐藏',
  `is_fixed_tab` tinyint(1) DEFAULT '2' COMMENT '是否固定标签页',
  `is_full_page` tinyint(1) DEFAULT '2' COMMENT '是否全屏',
  `generate_id` int(11) DEFAULT '0' COMMENT '生成id',
  `generate_key` varchar(255) DEFAULT NULL COMMENT '生成key',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=431 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';

-- ----------------------------
-- Records of sa_system_menu
-- ----------------------------
INSERT INTO `sa_system_menu` VALUES ('1', '0', '仪表盘', 'Dashboard', '', '1', 'dashboard', '', null, 'ri:pie-chart-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-06-18 23:26:56', null);
INSERT INTO `sa_system_menu` VALUES ('2', '1', '工作台', 'Console', '', '2', 'console', '/dashboard/console', null, 'ri:home-smile-2-line', '100', '', '2', '2', '2', '1', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-03-24 22:06:42', null);
INSERT INTO `sa_system_menu` VALUES ('3', '0', '系统管理', 'System', null, '1', '/system', '', null, 'ri:user-3-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('4', '3', '用户管理', 'User', null, '2', 'user', '/system/user', null, 'ri:user-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('5', '3', '部门管理', 'Dept', null, '2', 'dept', '/system/dept', null, 'ri:node-tree', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('6', '3', '角色管理', 'Role', null, '2', 'role', '/system/role', null, 'ri:admin-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('7', '3', '岗位管理', 'Post', '', '2', 'post', '/system/post', null, 'ri:signpost-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('8', '3', '菜单管理', 'Menu', null, '2', 'menu', '/system/menu', null, 'ri:menu-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('10', '0', '运维管理', 'Safeguard', null, '1', '/safeguard', '', null, 'ri:shield-check-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('11', '10', '缓存管理', 'Cache', '', '2', 'cache', '/safeguard/cache', null, 'ri:keyboard-box-line', '80', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('12', '10', '数据字典', 'Dict', null, '2', 'dict', '/safeguard/dict', null, 'ri:database-2-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('13', '10', '附件管理', 'Attachment', '', '2', 'attachment', '/safeguard/attachment', null, 'ri:file-cloud-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('14', '10', '数据表维护', 'Database', '', '2', 'database', '/safeguard/database', null, 'ri:database-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('15', '10', '登录日志', 'LoginLog', '', '2', 'login-log', '/safeguard/login-log', null, 'ri:login-circle-line', '50', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('16', '10', '操作日志', 'OperLog', '', '2', 'oper-log', '/safeguard/oper-log', null, 'ri:shield-keyhole-line', '50', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('17', '10', '邮件日志', 'EmailLog', '', '2', 'email-log', '/safeguard/email-log', null, 'ri:mail-line', '50', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('18', '3', '系统设置', 'Config', null, '2', 'config', '/system/config', null, 'ri:settings-4-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('19', '0', '官方文档', 'Document', '', '4', '', '', null, 'ri:file-copy-2-fill', '102', 'https://v3.phpframe.org', '1', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-10-13 21:15:32', null);
INSERT INTO `sa_system_menu` VALUES ('20', '4', '数据列表', '', 'core:user:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('21', '1', '个人中心', 'UserCenter', '', '2', 'user-center', '/dashboard/user-center/index', null, 'ri:user-2-line', '100', '', '2', '2', '1', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-09-28 22:19:42', null);
INSERT INTO `sa_system_menu` VALUES ('22', '4', '添加', '', 'core:user:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('23', '4', '修改', '', 'core:user:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('24', '4', '读取', '', 'core:user:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('25', '4', '删除', '', 'core:user:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('26', '4', '重置密码', '', 'core:user:password', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('27', '4', '清理缓存', '', 'core:user:cache', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('28', '4', '设置工作台', '', 'core:user:home', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('29', '5', '数据列表', '', 'core:dept:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('30', '5', '添加', '', 'core:dept:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('31', '5', '修改', '', 'core:dept:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('32', '5', '读取', '', 'core:dept:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('33', '5', '删除', '', 'core:dept:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('34', '6', '添加', '', 'core:role:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('35', '6', '数据列表', '', 'core:role:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('36', '6', '修改', '', 'core:role:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('37', '6', '读取', '', 'core:role:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('38', '6', '删除', '', 'core:role:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('39', '6', '菜单权限', '', 'core:role:menu', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('41', '7', '数据列表', '', 'core:post:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('42', '7', '添加', '', 'core:post:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('43', '7', '修改', '', 'core:post:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('44', '7', '读取', '', 'core:post:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('45', '7', '删除', '', 'core:post:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('46', '7', '导入', '', 'core:post:import', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('47', '7', '导出', '', 'core:post:export', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('48', '8', '数据列表', '', 'core:menu:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('49', '8', '读取', '', 'core:menu:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('50', '8', '添加', '', 'core:menu:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('51', '8', '修改', '', 'core:menu:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('52', '8', '删除', '', 'core:menu:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('53', '18', '数据列表', '', 'core:config:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('54', '18', '管理', '', 'core:config:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('55', '18', '修改', '', 'core:config:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('56', '12', '数据列表', '', 'core:dict:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('57', '12', '管理', '', 'core:dict:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('58', '13', '数据列表', '', 'core:attachment:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('59', '13', '管理', '', 'core:attachment:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('60', '14', '数据表列表', '', 'core:database:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('61', '14', '数据表维护', '', 'core:database:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('62', '14', '回收站数据', '', 'core:recycle:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('63', '14', '回收站管理', '', 'core:recycle:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('64', '15', '数据列表', '', 'core:logs:login', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('65', '15', '删除', '', 'core:logs:deleteLogin', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('66', '16', '数据列表', '', 'core:logs:Oper', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('67', '16', '删除', '', 'core:logs:deleteOper', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('68', '17', '数据列表', '', 'core:email:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('69', '17', '删除', '', 'core:email:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('70', '10', '服务监控', 'Server', '', '2', 'server', '/safeguard/server', null, 'ri:server-line', '90', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('71', '70', '数据列表', '', 'core:server:monitor', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('72', '11', '数据列表', '', 'core:server:cache', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('73', '11', '缓存清理', '', 'core:server:clear', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('74', '2', '登录数据统计', '', 'core:console:list', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('75', '0', '附加权限', 'Permission', '', '1', 'permission', '', null, 'ri:apps-2-ai-line', '100', '', '2', '2', '1', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('76', '75', '上传图片', '', 'core:system:uploadImage', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('77', '75', '上传文件', '', 'core:system:uploadFile', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('78', '75', '附件列表', '', 'core:system:resource', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('79', '75', '用户列表', '', 'core:system:user', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('80', '0', '开发工具', 'Tool', '', '1', '/tool', '', null, 'ri:tools-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-03-23 23:03:00', null);
INSERT INTO `sa_system_menu` VALUES ('81', '80', '代码生成', 'Code', '', '2', 'code', '/tool/code', null, 'ri:code-s-slash-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-04-26 17:08:04', null);
INSERT INTO `sa_system_menu` VALUES ('82', '80', '定时任务', 'Crontab', '', '2', 'crontab', '/tool/crontab', null, 'ri:time-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('83', '82', '数据列表', '', 'tool:crontab:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('84', '82', '管理', '', 'tool:crontab:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('85', '82', '运行任务', '', 'tool:crontab:run', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('86', '81', '数据列表', '', 'tool:code:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('87', '81', '管理', '', 'tool:code:edit', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_menu` VALUES ('88', '10', '在线用户', 'Plugin', '', '2', 'online', '/safeguard/online/index', null, 'ri:speak-ai-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-01-01 00:00:00', '2026-06-19 11:23:04', null);
INSERT INTO `sa_system_menu` VALUES ('92', '4', '分配菜单', '', 'core:user:menu', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '0', '', '1', '1', '2026-03-24 22:56:49', '2026-03-24 22:56:49', null);
INSERT INTO `sa_system_menu` VALUES ('93', '1', '分析页', 'Analysis', '', '2', 'analysis', '/dashboard/analysis', null, 'ri:file-music-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-03-25 20:28:34', '2026-03-29 14:28:06', null);
INSERT INTO `sa_system_menu` VALUES ('94', '1', '电子商务', 'Ecommerce', '', '2', 'ecommerce', '/dashboard/ecommerce', null, 'ri:bootstrap-fill', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-03-25 20:42:29', '2026-03-29 14:39:56', null);
INSERT INTO `sa_system_menu` VALUES ('95', '80', '表单示例', 'Form', '', '2', 'form', '/tool/form', null, 'ri:article-line', '100', '', '2', '2', '2', '2', '2', '0', null, '0', '', '1', '1', '2026-03-25 20:47:03', '2026-03-25 20:47:44', null);
INSERT INTO `sa_system_menu` VALUES ('96', '88', '111', null, 'chajian:market:add', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-03-28 19:41:47', '2026-03-28 20:05:26', '2026-03-28 20:05:26');
INSERT INTO `sa_system_menu` VALUES ('97', '5', '菜单树', null, 'core:dept:tree', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-03-29 18:03:52', '2026-03-29 18:03:52', null);
INSERT INTO `sa_system_menu` VALUES ('98', '3', '租户管理', 'Tenant', '', '2', 'tenant', '/system/tenant', null, 'ri:dashboard-horizontal-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 21:24:21', '2026-04-06 21:36:53', null);
INSERT INTO `sa_system_menu` VALUES ('99', '98', '数据列表', null, 'core:tenant:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 21:30:15', '2026-04-06 21:30:15', null);
INSERT INTO `sa_system_menu` VALUES ('100', '98', '读取', '', 'core:tenant:read', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 22:00:15', '2026-04-06 22:00:15', null);
INSERT INTO `sa_system_menu` VALUES ('101', '98', '添加', '', 'core:tenant:save', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 22:01:03', '2026-04-06 22:01:03', null);
INSERT INTO `sa_system_menu` VALUES ('102', '98', '修改', '', 'core:tenant:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 22:01:24', '2026-04-06 22:01:24', null);
INSERT INTO `sa_system_menu` VALUES ('103', '98', '删除', '', 'core:tenant:destroy', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-06 22:01:53', '2026-04-06 22:01:53', null);
INSERT INTO `sa_system_menu` VALUES ('104', '10', 'Redis监控', 'Redis', 'core:server:redis', '2', 'redis', '/safeguard/redis', null, 'ri:exchange-cny-fill', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-20 22:44:29', '2026-04-21 00:33:07', null);
INSERT INTO `sa_system_menu` VALUES ('105', '0', '文章管理', 'Article', '', '1', '/article', '', null, 'ri:book-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-23 22:18:18', '2026-08-28 21:36:33', null);
INSERT INTO `sa_system_menu` VALUES ('106', '105', '文章列表', 'ArticleList', '', '2', '/article/index', '/article', null, 'ri:code-block', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-04-23 22:19:39', '2026-04-26 17:08:18', null);
INSERT INTO `sa_system_menu` VALUES ('173', '1', 'HRM看板', 'Hrm', '', '2', 'hrm', '/dashboard/hrm', null, 'ri:team-line', '100', null, '2', '2', '2', '2', '2', '0', null, '1', '人力资源看板', '1', '1', '2026-05-06 23:15:10', '2026-05-06 23:15:10', null);
INSERT INTO `sa_system_menu` VALUES ('183', '1', '赞助支持', 'DashboardSponsor', '', '2', 'sponsor', '/dashboard/sponsor', null, 'ri:hand-heart-line', '110', null, '2', '2', '2', '2', '2', '0', null, '1', '项目赞助说明页', '1', '1', '2026-05-16 21:08:42', '2026-05-16 21:08:42', null);
INSERT INTO `sa_system_menu` VALUES ('400', '0', '任务管理', 'Task', '', '1', '/task', '', null, 'ri:tools-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', 'APScheduler 任务管理', '1', '1', '2026-07-18 22:09:16', '2026-07-18 23:04:10', null);
INSERT INTO `sa_system_menu` VALUES ('401', '400', '定时任务', 'Cronjob', null, '1', 'cronjob', '', null, 'ri:timer-line', '1', null, '2', '1', '2', '2', '2', '0', null, '1', 'APScheduler 调度器与任务节点', '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('402', '401', '调度器监控', 'Job', 'module_task:cronjob:job:query', '2', 'job', '/tool/task/cronjob/job', null, 'ri:line-chart-line', '1', null, '2', '1', '2', '2', '2', '0', null, '1', '调度器监控', '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('403', '402', '查询调度器', null, 'module_task:cronjob:job:query', '3', '', '', null, '', '1', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('404', '402', '控制调度器', null, 'module_task:cronjob:job:scheduler', '3', '', '', null, '', '2', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('405', '402', '操作任务', null, 'module_task:cronjob:job:task', '3', '', '', null, '', '3', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('406', '402', '删除执行日志', null, 'module_task:cronjob:job:delete', '3', '', '', null, '', '4', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('407', '402', '日志详情', null, 'module_task:cronjob:job:detail', '3', '', '', null, '', '5', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('408', '402', '更新/同步任务', null, 'module_task:cronjob:job:update', '3', '', '', null, '', '6', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('410', '401', '节点管理', 'Node', 'module_task:cronjob:node:query', '2', 'node', '/tool/task/cronjob/node', null, 'ri:mail-send-line', '2', null, '2', '1', '2', '2', '2', '0', null, '1', '节点管理', '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('411', '410', '创建节点', null, 'module_task:cronjob:node:create', '3', '', '', null, '', '1', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('412', '410', '调试节点', null, 'module_task:cronjob:node:execute', '3', '', '', null, '', '2', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('413', '410', '修改节点', null, 'module_task:cronjob:node:update', '3', '', '', null, '', '3', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('414', '410', '删除节点', null, 'module_task:cronjob:node:delete', '3', '', '', null, '', '4', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('415', '410', '节点详情', null, 'module_task:cronjob:node:detail', '3', '', '', null, '', '5', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('416', '410', '查询节点', null, 'module_task:cronjob:node:query', '3', '', '', null, '', '6', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-18 22:09:16', '2026-07-18 22:09:16', null);
INSERT INTO `sa_system_menu` VALUES ('420', '0', '视频下载', 'Video', '', '1', '/video', '', null, 'ri:video-download-line', '100', '', '2', '2', '2', '2', '2', '0', null, '1', 'yt-dlp 视频下载管理', '1', '1', '2026-07-19 11:24:09', '2026-07-19 22:36:33', null);
INSERT INTO `sa_system_menu` VALUES ('421', '420', '视频列表', 'VideoList', 'module_platform:video:query', '2', 'list', '/video/index', null, 'ri:film-line', '1', null, '2', '1', '2', '2', '2', '0', null, '1', '视频链接与下载队列', '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('422', '421', '查询', null, 'module_platform:video:query', '3', '', '', null, '', '1', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('423', '421', '新建', null, 'module_platform:video:create', '3', '', '', null, '', '2', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('424', '421', '编辑', null, 'module_platform:video:update', '3', '', '', null, '', '3', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('425', '421', '删除', null, 'module_platform:video:delete', '3', '', '', null, '', '4', null, '2', '2', '2', '2', '2', '0', null, '1', null, '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('426', '421', '下载控制', null, 'module_platform:video:download', '3', '', '', null, '', '5', null, '2', '2', '2', '2', '2', '0', null, '1', '入队/暂停/继续/停止', '1', '1', '2026-07-19 11:24:09', '2026-07-19 11:24:09', null);
INSERT INTO `sa_system_menu` VALUES ('427', '106', '列表', '', 'module_platform:article:index', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-08-28 21:37:48', '2026-08-28 21:37:48', null);
INSERT INTO `sa_system_menu` VALUES ('428', '106', '新增', '', 'module_platform:article:create', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-08-28 21:49:59', '2026-08-28 21:49:59', null);
INSERT INTO `sa_system_menu` VALUES ('429', '106', '修改', '', 'module_platform:article:update', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-08-28 21:50:28', '2026-08-28 21:50:28', null);
INSERT INTO `sa_system_menu` VALUES ('430', '106', '删除', '', 'module_platform:article:delete', '3', '', '', null, '', '100', '', '2', '2', '2', '2', '2', '0', null, '1', '', '1', '1', '2026-08-28 21:50:47', '2026-08-28 21:50:47', null);

-- ----------------------------
-- Table structure for `sa_system_notice`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_notice`;
CREATE TABLE `sa_system_notice` (
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `delete_time` datetime(6) DEFAULT NULL COMMENT '删除时间',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '公告标题',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '公告类型（1通知 2公告）',
  `content` longtext COMMENT '公告内容',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态（1启用 0禁用）',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知公告表';

-- ----------------------------
-- Records of sa_system_notice
-- ----------------------------

-- ----------------------------
-- Table structure for `sa_system_oper_log`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_oper_log`;
CREATE TABLE `sa_system_oper_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(20) DEFAULT NULL COMMENT '用户名',
  `app` varchar(50) DEFAULT NULL COMMENT '应用名称',
  `method` varchar(20) DEFAULT NULL COMMENT '请求方式',
  `router` varchar(500) DEFAULT NULL COMMENT '请求路由',
  `service_name` varchar(30) DEFAULT NULL COMMENT '业务名称',
  `ip` varchar(45) DEFAULT NULL COMMENT '请求IP地址',
  `ip_location` varchar(255) DEFAULT NULL COMMENT 'IP所属地',
  `request_data` text COMMENT '请求数据',
  `duration` varchar(20) DEFAULT NULL COMMENT '耗时',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=476 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';

-- ----------------------------
-- Records of sa_system_oper_log
-- ----------------------------
INSERT INTO `sa_system_oper_log` VALUES ('1', 'admin', 'system', 'DELETE', '/api/core/server/redis/browser/delete', 'delete', '127.0.0.1', '', '{\"key\": \"apscheduler.run_times\"}', '4.68', null, '1', null, '2026-07-18 19:12:16', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('2', 'admin', 'system', 'PUT', '/api/system/dict/type/update/14', 'update', '127.0.0.1', '', '{\"id\": 14, \"name\": \"是否\", \"code\": \"yes_or_no\", \"remark\": \"11\", \"status\": 1}', '34.56', null, '1', null, '2026-07-18 19:12:28', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('3', 'admin', 'system', 'DELETE', '/api/monitor/online/2e1c5e34071442c285d5f3614f45a37c', '2e1c5e34071442c285d5f3614f45a3', '127.0.0.1', '', '{}', '5.45', null, '1', null, '2026-07-18 19:12:52', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('4', 'admin', 'system', 'DELETE', '/api/monitor/online/0e20345ab4ee4ca99412794041cf8773', '0e20345ab4ee4ca99412794041cf87', '127.0.0.1', '', '{}', '5.2', null, '1', null, '2026-07-18 19:12:57', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('5', 'admin', 'system', 'DELETE', '/api/monitor/online/eb541821f4b14f55a6277b045cd0eafc', 'eb541821f4b14f55a6277b045cd0ea', '127.0.0.1', '', '{}', '6.25', null, '1', null, '2026-07-18 19:13:02', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('6', 'admin', 'system', 'POST', '/api/core/database/table/optimize', 'optimize', '127.0.0.1', '', '{\"tables\": [\"casbin_rule\"]}', '971.95', null, '1', null, '2026-07-18 20:09:43', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('7', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '6.05', null, '1', null, '2026-07-18 22:17:33', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('8', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '6.29', null, '1', null, '2026-07-18 22:17:34', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('9', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '6.42', null, '1', null, '2026-07-18 22:17:35', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('10', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '5.36', null, '1', null, '2026-07-18 22:18:24', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('11', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '5.45', null, '1', null, '2026-07-18 22:18:25', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('12', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/shutdown', 'shutdown', '127.0.0.1', '', '{}', '16.21', null, '1', null, '2026-07-18 22:20:38', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('13', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/start', 'start', '127.0.0.1', '', '{}', '2044.61', null, '1', null, '2026-07-18 22:20:46', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('14', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '7.1', null, '1', null, '2026-07-18 22:28:18', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('15', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/3', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '11.65', null, '1', null, '2026-07-18 22:34:11', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('16', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/1', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '9.81', null, '1', null, '2026-07-18 22:34:37', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('17', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/4', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '30.81', null, '1', null, '2026-07-18 22:36:31', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('18', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_clean_expired', 'system_clean_expired', '127.0.0.1', '', '{}', '24.85', null, '1', null, '2026-07-18 22:41:12', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('19', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_clean_expired', 'system_clean_expired', '127.0.0.1', '', '{}', '44.26', null, '1', null, '2026-07-18 22:41:12', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('20', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cleanup_operation_log', 'system_cleanup_operation_log', '127.0.0.1', '', '{}', '4081.51', null, '1', null, '2026-07-18 22:42:31', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('21', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/1', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '14.46', null, '1', null, '2026-07-18 22:42:36', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('22', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/4', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '19.14', null, '1', null, '2026-07-18 22:47:43', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('23', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '8.4', null, '1', null, '2026-07-18 22:47:56', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('24', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/pause/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '8.21', null, '1', null, '2026-07-18 22:47:57', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('25', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/resume/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '8.82', null, '1', null, '2026-07-18 22:48:04', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('26', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/1', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '11.06', null, '1', null, '2026-07-18 22:48:30', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('27', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/1', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '11.26', null, '1', null, '2026-07-18 22:50:10', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('28', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_grace_reminder', 'system_grace_reminder', '127.0.0.1', '', '{}', '10.16', null, '1', null, '2026-07-18 22:50:28', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('29', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '14.19', null, '1', null, '2026-07-18 22:53:26', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('30', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/pause/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '30.61', null, '1', null, '2026-07-18 22:55:30', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('31', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_tenant_expiry_check', 'system_tenant_expiry_check', '127.0.0.1', '', '{}', '8.81', null, '1', null, '2026-07-18 22:56:06', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('32', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_tenant_expiry_check', 'system_tenant_expiry_check', '127.0.0.1', '', '{}', '8.51', null, '1', null, '2026-07-18 22:56:10', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('33', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cleanup_operation_log', 'system_cleanup_operation_log', '127.0.0.1', '', '{}', '8.7', null, '1', null, '2026-07-18 23:03:38', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('34', 'admin', 'system', 'PUT', '/api/system/menu/update/400', 'update', '127.0.0.1', '', '{\"id\": 400, \"parent_id\": 0, \"type\": 1, \"component\": \"\", \"name\": \"任务管理\", \"slug\": \"\", \"path\": \"/task\", \"icon\": \"ri:tools-line\", \"code\": \"Task\", \"remark\": \"APScheduler 任务管理\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '39.55', null, '1', null, '2026-07-18 23:04:10', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('35', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_tenant_expiry_check', 'system_tenant_expiry_check', '127.0.0.1', '', '{}', '8.41', null, '1', null, '2026-07-18 23:09:05', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('36', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cancel_expired_orders', 'system_cancel_expired_orders', '127.0.0.1', '', '{}', '12.03', null, '1', null, '2026-07-18 23:12:34', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('37', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/1', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '15.82', null, '1', null, '2026-07-18 23:14:22', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('38', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '12.18', null, '1', null, '2026-07-18 23:19:21', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('39', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '10.42', null, '1', null, '2026-07-18 23:19:22', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('40', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '11.52', null, '1', null, '2026-07-18 23:19:23', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('41', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '11.26', null, '1', null, '2026-07-18 23:19:24', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('42', 'admin', 'system', 'DELETE', '/api/task/cronjob/job/task/remove/system_clean_expired', 'system_clean_expired', '127.0.0.1', '', '{}', '6.71', null, '1', null, '2026-07-18 23:19:27', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('43', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.57', null, '1', null, '2026-07-18 23:19:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('44', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.46', null, '1', null, '2026-07-18 23:19:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('45', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '10.58', null, '1', null, '2026-07-18 23:20:03', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('46', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.59', null, '1', null, '2026-07-18 23:20:04', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('47', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '10.46', null, '1', null, '2026-07-18 23:20:42', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('48', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '10.14', null, '1', null, '2026-07-18 23:20:44', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('49', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.08', null, '1', null, '2026-07-18 23:20:51', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('50', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/pause', 'pause', '127.0.0.1', '', '{}', '62.96', null, '1', null, '2026-07-18 23:21:49', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('51', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/resume', 'resume', '127.0.0.1', '', '{}', '45.79', null, '1', null, '2026-07-18 23:21:53', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('52', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.11', null, '1', null, '2026-07-18 23:22:46', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('53', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/shutdown', 'shutdown', '127.0.0.1', '', '{}', '7.55', null, '1', null, '2026-07-18 23:22:50', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('54', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/start', 'start', '127.0.0.1', '', '{}', '2184.76', null, '1', null, '2026-07-18 23:22:55', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('55', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/shutdown', 'shutdown', '127.0.0.1', '', '{}', '5.6', null, '1', null, '2026-07-18 23:23:10', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('56', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/start', 'start', '127.0.0.1', '', '{}', '2081.38', null, '1', null, '2026-07-18 23:23:16', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('57', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/sync', 'sync', '127.0.0.1', '', '{}', '9.81', null, '1', null, '2026-07-18 23:23:22', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('58', 'admin', 'system', 'PUT', '/api/system/tenant/update/3', 'update', '127.0.0.1', '', '{\"id\": 3, \"tenant_name\": \"租户3\", \"tenant_code\": \"8888\", \"contact_name\": \"\", \"contact_phone\": \"\", \"contact_email\": \"\", \"address\": \"\", \"logo_url\": \"\", \"status\": 1, \"expire_time\": null, \"max_users\": 0, \"max_depts\": 0, \"max_roles\": 0, \"remark\": \"\"}', '32.36', null, '1', null, '2026-07-18 23:25:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('59', 'admin', 'system', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '', '{\"_multipart\": true}', '37.62', null, '1', null, '2026-07-18 23:26:09', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('60', 'admin', 'system', 'PUT', '/api/system/role/update/6', 'update', '::1', '', '{\"id\": 6, \"level\": 10, \"name\": \"普通员工\", \"code\": \"staff\", \"remark\": \"自定义部门权限\", \"sort\": 100, \"status\": 1, \"data_scope\": 6, \"dept_ids\": [10, 2]}', '73.43', null, '1', null, '2026-07-18 23:52:01', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('61', 'admin', 'system', 'PUT', '/api/system/role/update/8', 'update', '::1', '', '{\"id\": 8, \"level\": 1, \"name\": \"ad\", \"code\": \"dddd\", \"remark\": \"啊大大、\", \"sort\": 100, \"status\": 1, \"data_scope\": 6, \"dept_ids\": [2, 5]}', '55.83', null, '1', null, '2026-07-18 23:52:17', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('62', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cleanup_operation_log', 'system_cleanup_operation_log', '127.0.0.1', '', '{}', '20.85', null, '1', null, '2026-07-19 00:03:01', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('63', 'admin', 'system', 'POST', '/api/core/system/uploadImage', 'uploadImage', '127.0.0.1', '', '{\"_multipart\": true}', '39.1', null, '1', null, '2026-07-19 00:04:56', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('64', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/shutdown', 'shutdown', '127.0.0.1', '', '{}', '6.49', null, '1', null, '2026-07-19 00:06:25', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('65', 'admin', 'system', 'POST', '/api/task/cronjob/job/scheduler/start', 'start', '127.0.0.1', '', '{}', '2071.87', null, '1', null, '2026-07-19 00:06:31', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('66', '', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1JXNk6vEqW/?spm_id_from=333.1007.tianma.1-2-2.click\"], \"enqueue\": false}', '2818.79', null, '1', null, '2026-07-19 11:24:59', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('67', 'admin', 'system', 'POST', '/api/platform/video/download/1', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '28.03', null, '1', null, '2026-07-19 11:27:15', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('68', 'admin', 'system', 'POST', '/api/platform/video/download/1', 'download', '127.0.0.1', '', '{\"mode\": \"audio\", \"audio_format\": \"mp3\"}', '19.89', null, '1', null, '2026-07-19 11:28:28', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('69', '', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=GoGHOe-MWMY\"], \"enqueue\": false}', '3915.13', null, '1', null, '2026-07-19 11:29:37', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('70', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=GoGHOe-MWMY\"], \"enqueue\": false}', '3337.99', null, '1', null, '2026-07-19 11:30:33', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('71', 'admin', 'system', 'DELETE', '/api/platform/video/delete/2', 'delete', '127.0.0.1', '', '{}', '22.65', null, '1', null, '2026-07-19 11:30:39', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('72', 'admin', 'system', 'POST', '/api/platform/video/download/3', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '25.85', null, '1', null, '2026-07-19 11:30:54', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('73', 'admin', 'system', 'POST', '/api/platform/video/download/3', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '19.24', null, '1', null, '2026-07-19 11:32:16', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('74', 'admin', 'system', 'POST', '/api/platform/video/download/3', 'download', '127.0.0.1', '', '{\"mode\": \"audio\", \"audio_format\": \"mp3\"}', '22.21', null, '1', null, '2026-07-19 11:32:27', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('75', 'admin', 'system', 'POST', '/api/platform/video/download/1', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '24.21', null, '1', null, '2026-07-19 11:36:38', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('76', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=HoAFUuLAqlw\"], \"enqueue\": false}', '2909.8', null, '1', null, '2026-07-19 11:38:17', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('77', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=OEOdBg0A5MQ\", \"https://www.bilibili.com/video/BV1oVKG6CEMZ?spm_id_from=333.1007.tianma.1-3-3.click\"], \"enqueue\": false}', '22.16', null, '1', null, '2026-07-19 11:43:19', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('78', 'admin', 'system', 'POST', '/api/platform/video/refresh/6', 'refresh', '127.0.0.1', '', '{}', '28.97', null, '1', null, '2026-07-19 11:47:34', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('79', 'admin', 'system', 'POST', '/api/platform/video/download/6', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '28.9', null, '1', null, '2026-07-19 11:48:20', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('80', 'admin', 'system', 'POST', '/api/platform/video/download/5', 'download', '127.0.0.1', '', '{\"mode\": \"custom\", \"format_id\": \"248\", \"audio_format\": \"249\", \"height\": 1080}', '29.21', null, '1', null, '2026-07-19 11:53:27', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('81', 'admin', 'system', 'POST', '/api/platform/video/download/5', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '144.18', null, '1', null, '2026-07-19 11:55:20', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('82', 'admin', 'system', 'POST', '/api/platform/video/refresh/5', 'refresh', '127.0.0.1', '', '{}', '23.79', null, '1', null, '2026-07-19 12:01:42', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('83', 'admin', 'system', 'POST', '/api/platform/video/download/5', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '26.72', null, '1', null, '2026-07-19 12:02:42', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('84', 'admin', 'system', 'POST', '/api/platform/video/download/6', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '27.73', null, '1', null, '2026-07-19 12:03:28', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('85', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1BrNo6uExY?spm_id_from=333.1007.tianma.2-3-6.click\"], \"enqueue\": false}', '27.32', null, '1', null, '2026-07-19 12:10:09', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('86', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1s6KA6NEWA?spm_id_from=333.1007.tianma.3-4-10.click\"], \"enqueue\": false}', '18.76', null, '1', null, '2026-07-19 12:10:41', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('87', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1EuTE6vEVD?spm_id_from=333.1007.tianma.4-2-12.click\"], \"enqueue\": false}', '17.35', null, '1', null, '2026-07-19 12:24:58', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('88', 'admin', 'system', 'POST', '/api/platform/video/download/9', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '29.97', null, '1', null, '2026-07-19 12:25:09', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('89', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=D6mEQrcSW10&list=PLlD7SeKBB31fIxaj0SxipLhCOhes17hup&index=4\"], \"enqueue\": false}', '23.62', null, '1', null, '2026-07-19 12:27:26', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('90', 'admin', 'system', 'POST', '/api/platform/video/download/10', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '52.63', null, '1', null, '2026-07-19 12:29:14', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('91', 'admin', 'system', 'POST', '/api/platform/video/download/queue/pause-all', 'pause-all', '127.0.0.1', '', '{}', '11.38', null, '1', null, '2026-07-19 12:33:02', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('92', 'admin', 'system', 'DELETE', '/api/platform/video/delete/10', 'delete', '127.0.0.1', '', '{}', '136.6', null, '1', null, '2026-07-19 12:36:09', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('93', 'admin', 'system', 'POST', '/api/platform/video/download/1', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '23.18', null, '1', null, '2026-07-19 12:36:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('94', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1GrzxBZE9X?spm_id_from=333.1007.tianma.5-2-16.click\"], \"enqueue\": false}', '20.22', null, '1', null, '2026-07-19 12:51:38', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('95', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1vBKw62EbY?spm_id_from=333.1007.tianma.5-1-15.click\"], \"enqueue\": false}', '21.56', null, '1', null, '2026-07-19 12:56:00', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('96', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.youtube.com/watch?v=OTigkbqe3wU&list=PLlD7SeKBB31fIxaj0SxipLhCOhes17hup\"], \"enqueue\": false}', '6497.7', null, '1', null, '2026-07-19 13:10:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('97', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/Jan812314/status/2078536885119459812\"], \"enqueue\": false}', '22.34', null, '1', null, '2026-07-19 13:15:24', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('98', 'admin', 'system', 'POST', '/api/platform/video/download/24', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '27.53', null, '1', null, '2026-07-19 13:16:18', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('99', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1AxsmeZEem?spm_id_from=333.788.videopod.episodes&vd_source=d8733470c6b5daf3bd9d0c6fb87342ce\"], \"enqueue\": false}', '22.61', null, '1', null, '2026-07-19 13:23:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('100', 'admin', 'system', 'DELETE', '/api/platform/video/delete/25', 'delete', '127.0.0.1', '', '{}', '41.55', null, '1', null, '2026-07-19 13:27:00', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('101', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1AxsmeZEem?spm_id_from=333.788.videopod.episodes&vd_source=d8733470c6b5daf3bd9d0c6fb87342ce\"], \"enqueue\": false}', '1887.35', null, '1', null, '2026-07-19 13:27:59', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('102', 'admin', 'system', 'POST', '/api/platform/video/download/38', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '40.58', null, '1', null, '2026-07-19 13:29:51', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('103', 'admin', 'system', 'POST', '/api/platform/video/download/queue/pause-all', 'pause-all', '127.0.0.1', '', '{}', '33.05', null, '1', null, '2026-07-19 14:04:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('104', 'admin', 'system', 'POST', '/api/platform/video/download/queue/resume-all', 'resume-all', '127.0.0.1', '', '{}', '25.92', null, '1', null, '2026-07-19 14:04:43', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('105', 'admin', 'system', 'POST', '/api/platform/video/download/37', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '31.94', null, '1', null, '2026-07-19 14:08:36', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('106', 'admin', 'system', 'POST', '/api/platform/video/download/36', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '15.91', null, '1', null, '2026-07-19 14:08:37', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('107', 'admin', 'system', 'POST', '/api/platform/video/download/23', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '34.3', null, '1', null, '2026-07-19 14:10:05', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('108', 'admin', 'system', 'POST', '/api/platform/video/download/queue/pause-all', 'pause-all', '127.0.0.1', '', '{}', '15.3', null, '1', null, '2026-07-19 14:10:26', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('109', 'admin', 'system', 'POST', '/api/platform/video/download/queue/resume-all', 'resume-all', '127.0.0.1', '', '{}', '18.77', null, '1', null, '2026-07-19 14:10:43', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('110', 'admin', 'system', 'POST', '/api/platform/video/download/23', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '37.7', null, '1', null, '2026-07-19 14:15:00', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('111', 'admin', 'system', 'POST', '/api/platform/video/download/queue/resume-all', 'resume-all', '127.0.0.1', '', '{}', '28.7', null, '1', null, '2026-07-19 14:16:05', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('112', 'admin', 'system', 'POST', '/api/platform/video/download/26', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '53.9', null, '1', null, '2026-07-19 14:21:41', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('113', 'admin', 'system', 'POST', '/api/platform/video/download/queue/pause-all', 'pause-all', '127.0.0.1', '', '{}', '9.81', null, '1', null, '2026-07-19 14:22:33', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('114', 'admin', 'system', 'POST', '/api/platform/video/download/queue/resume-all', 'resume-all', '127.0.0.1', '', '{}', '13.79', null, '1', null, '2026-07-19 14:22:37', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('115', 'admin', 'system', 'POST', '/api/platform/video/download/queue/resume-all', 'resume-all', '127.0.0.1', '', '{}', '21.91', null, '1', null, '2026-07-19 14:22:41', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('116', 'admin', 'system', 'POST', '/api/platform/video/download/35', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '46.94', null, '1', null, '2026-07-19 14:26:11', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('117', 'admin', 'system', 'POST', '/api/platform/video/download/queue/pause-all', 'pause-all', '127.0.0.1', '', '{}', '15.5', null, '1', null, '2026-07-19 14:26:16', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('118', 'admin', 'system', 'POST', '/api/platform/video/download/job/22/resume', 'resume', '127.0.0.1', '', '{}', '32.62', null, '1', null, '2026-07-19 14:27:30', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('119', 'admin', 'system', 'POST', '/api/platform/video/download/37', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '25.15', null, '1', null, '2026-07-19 14:28:46', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('120', 'admin', 'system', 'POST', '/api/platform/video/refresh/34', 'refresh', '127.0.0.1', '', '{}', '33.73', null, '1', null, '2026-07-19 14:31:31', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('121', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/iroha_ni_AI/status/2076233099977855164\"], \"enqueue\": false}', '4757.93', null, '1', null, '2026-07-19 14:34:57', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('122', 'admin', 'system', 'POST', '/api/platform/video/download/39', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '38.32', null, '1', null, '2026-07-19 14:35:22', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('123', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.xiaohongshu.com/discovery/item/64cb0107000000001201f8a3?source=webshare&xhsshare=pc_web&xsec_token=ABlljp1-jvCeOLK5LrE0Pn06NCDNW5UpgF0PrINx9Y4jA=&xsec_source=pc_share\"], \"enqueue\": false}', '943.64', null, '1', null, '2026-07-19 14:48:03', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('124', 'admin', 'system', 'POST', '/api/platform/video/download/40', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '46.7', null, '1', null, '2026-07-19 14:48:36', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('125', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/i/status/2078448617468355069\"], \"enqueue\": false}', '21611.66', null, '1', null, '2026-07-19 22:13:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('126', '', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/i/status/2078448617468355069\"], \"enqueue\": false}', '1210.93', null, '1', null, '2026-07-19 22:13:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('127', 'admin', 'system', 'POST', '/api/platform/video/refresh/41', 'refresh', '127.0.0.1', '', '{}', '29.06', null, '1', null, '2026-07-19 22:14:00', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('128', '', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/i/status/2078448617468355069\"], \"enqueue\": false}', '38.06', null, '1', null, '2026-07-19 22:16:46', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('129', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1S8K566EX9?spm_id_from=333.1007.tianma.1-2-2.click\"], \"enqueue\": false}', '2164.58', null, '1', null, '2026-07-19 22:17:47', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('130', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://v.youku.com/v_show/id_XNjQ5NTgyMTcwOA==.html?spm=a2hkl.14919748_WEBHOME_HOME.scg_scroll_3.d_2_play&s=36ac99b3075d43e1b06e&scm=20140719.rcmd.feed.show_36ac99b3075d43e1b06e&alginfo=-1sceneId-246595-1seqId-2158MK0o0CkJRLGnN-1abId-2497220-1reqId-244804c5f.15a8.4ee2.9215.b36f7dbd055f_1784470727024&scg_id=22896509\"], \"enqueue\": false}', '1179.5', null, '1', null, '2026-07-19 22:19:16', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('131', 'admin', 'system', 'POST', '/api/platform/video/download/43', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '39.07', null, '1', null, '2026-07-19 22:19:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('132', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://v.youku.com/v_show/id_XNjQ5OTMzNTIwOA==.html?s=36ac99b3075d43e1b06e&scm=20140719.apircmd.298671.video_XNjQ5OTMzNTIwOA==&spm=a2hkt.13141534.298671.d_3_2\"], \"enqueue\": false}', '561.56', null, '1', null, '2026-07-19 22:21:29', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('133', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://v.cctv.com/2026/07/19/VIDErXAyEWBZMQkMMJDEu1KG260719.shtml?spm=C90324.PE6LRxWJhH5P.S23920.10\"], \"enqueue\": false}', '807.57', null, '1', null, '2026-07-19 22:22:56', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('134', 'admin', 'system', 'POST', '/api/platform/video/download/45', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '21.2', null, '1', null, '2026-07-19 22:23:22', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('135', 'admin', 'system', 'POST', '/api/platform/video/download/45', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '32.25', null, '1', null, '2026-07-19 22:24:05', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('136', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.kuaishou.com/short-video/3xb5reghmxyxiwa?authorId=3xh23wiwvihjbk9&streamSource=find&area=homexxbrilliant\"], \"enqueue\": false}', '14019.63', null, '1', null, '2026-07-19 22:29:07', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('137', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.kuaishou.com/short-video/3xpwwavi584biei?authorId=3xh23wiwvihjbk9&streamSource=find&area=homexxbrilliant\"], \"enqueue\": false}', '1024.89', null, '1', null, '2026-07-19 22:30:02', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('138', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.kuaishou.com/short-video/3xpwwavi584biei?authorId=3xh23wiwvihjbk9&streamSource=find&area=homexxbrilliant\"], \"enqueue\": false}', '23.93', null, '1', null, '2026-07-19 22:30:38', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('139', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://v.qq.com/x/page/l3202o6lgu1.html\"], \"enqueue\": false}', '949.04', null, '1', null, '2026-07-19 22:30:59', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('140', 'admin', 'system', 'POST', '/api/platform/video/download/48', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '29.89', null, '1', null, '2026-07-19 22:31:14', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('141', 'admin', 'system', 'POST', '/api/platform/video/download/48', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '32.67', null, '1', null, '2026-07-19 22:33:40', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('142', 'admin', 'system', 'POST', '/api/platform/video/download/48', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '27.48', null, '1', null, '2026-07-19 22:35:49', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('143', 'admin', 'system', 'PUT', '/api/system/menu/update/420', 'update', '127.0.0.1', '', '{\"id\": 420, \"parent_id\": 0, \"type\": 1, \"component\": \"\", \"name\": \"视频下载\", \"slug\": \"\", \"path\": \"/video\", \"icon\": \"ri:video-download-line\", \"code\": \"Video\", \"remark\": \"yt-dlp 视频下载管理\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '54.01', null, '1', null, '2026-07-19 22:36:33', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('144', 'admin', 'system', 'PUT', '/api/system/menu/update/300', 'update', '127.0.0.1', '', '{\"id\": 300, \"parent_id\": 0, \"type\": 1, \"component\": \"\", \"name\": \"RAG智能系统\", \"slug\": \"\", \"path\": \"/ragsystem\", \"icon\": \"ri:brain-line\", \"code\": \"RAGSystem\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 101, \"status\": 0}', '56.77', null, '1', null, '2026-07-19 22:36:41', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('145', 'admin', 'system', 'PUT', '/api/system/menu/update/200', 'update', '127.0.0.1', '', '{\"id\": 200, \"parent_id\": 0, \"type\": 1, \"component\": \"\", \"name\": \"AI 助手\", \"slug\": \"\", \"path\": \"ai\", \"icon\": \"ri:robot-2-line\", \"code\": \"Ai\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 0}', '50.2', null, '1', null, '2026-07-19 22:36:49', '2026-08-26 22:48:00', '2026-08-26 22:48:00');
INSERT INTO `sa_system_oper_log` VALUES ('146', '', '刷新Token', 'POST', '/api/core/refresh', 'refreshToken', '127.0.0.1', '内网地址', '{\"refreshToken\":\"729fcaee272e019177ca18d7c67cb7893a11a5de7e943e2dedb6c783f8c54073288df4f3ec5d5ba5db5384e9a9a685a891edb69dbe7b777c140560ade4b5e053\"}', '6ms', '刷新令牌已过期，请重新登录', null, null, '2026-08-24 22:38:46', '2026-08-24 22:38:46', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('147', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '5ms', '', null, null, '2026-08-24 22:38:47', '2026-08-24 22:38:47', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('148', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"8691\",\"uuid\":\"693c65b9a80d42e2bd93d387695a3372\",\"tenant_id\":\"1\"}', '333ms', '', null, null, '2026-08-24 22:38:56', '2026-08-24 22:38:56', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('149', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '0ms', '', null, null, '2026-08-24 22:40:08', '2026-08-24 22:40:08', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('150', 'admin', 'system', 'POST', '/api/task/cronjob/node/execute/2', 'execute', '127.0.0.1', '', '{\"trigger\": \"now\"}', '60.62', null, '1', null, '2026-08-24 22:45:32', '2026-08-24 22:45:32', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('151', 'admin', 'system', 'DELETE', '/api/platform/video/delete/47', 'delete', '127.0.0.1', '', '{}', '138.97', null, '1', null, '2026-08-24 23:13:59', '2026-08-24 23:13:59', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('152', 'admin', 'system', 'DELETE', '/api/platform/video/delete/46', 'delete', '127.0.0.1', '', '{}', '74.16', null, '1', null, '2026-08-24 23:14:02', '2026-08-24 23:14:02', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('153', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1ieuu65Ega?spm_id_from=333.1007.tianma.1-1-1.click\"], \"enqueue\": true}', '3698.37', null, '1', null, '2026-08-24 23:15:12', '2026-08-24 23:15:12', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('154', 'admin', 'system', 'DELETE', '/api/platform/video/delete/48', 'delete', '127.0.0.1', '', '{}', '78.78', null, '1', null, '2026-08-24 23:21:46', '2026-08-24 23:21:46', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('155', 'admin', 'system', 'DELETE', '/api/platform/video/delete/44', 'delete', '127.0.0.1', '', '{}', '37.34', null, '1', null, '2026-08-24 23:21:49', '2026-08-24 23:21:49', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('156', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1aw8E6SE4F?spm_id_from=333.1007.tianma.1-2-2.click\"], \"enqueue\": false}', '4974.8', null, '1', null, '2026-08-25 21:31:18', '2026-08-25 21:31:18', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('157', 'admin', 'system', 'POST', '/api/platform/video/download/50', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '15.44', null, '1', null, '2026-08-25 21:31:33', '2026-08-25 21:31:33', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('158', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://www.bilibili.com/video/BV1Ab8F6EEmG?spm_id_from=333.1007.tianma.8-4-30.click\"], \"enqueue\": false}', '1837.06', null, '1', null, '2026-08-25 21:33:34', '2026-08-25 21:33:34', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('159', 'admin', 'system', 'POST', '/api/platform/video/download/51', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '12.73', null, '1', null, '2026-08-25 21:37:56', '2026-08-25 21:37:56', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('160', 'admin', 'system', 'POST', '/api/platform/video/refresh/51', 'refresh', '127.0.0.1', '', '{}', '9.67', null, '1', null, '2026-08-25 21:38:17', '2026-08-25 21:38:17', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('161', 'admin', 'system', 'PUT', '/api/platform/video/update/51', 'update', '127.0.0.1', '', '{\"url\": \"https://www.bilibili.com/video/BV1Ab8F6EEmG?spm_id_from=333.1007.tianma.8-4-30.click\"}', '11.63', null, '1', null, '2026-08-25 21:38:19', '2026-08-25 21:38:19', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('162', 'admin', 'system', 'POST', '/api/platform/video/refresh/50', 'refresh', '127.0.0.1', '', '{}', '10.02', null, '1', null, '2026-08-25 21:38:22', '2026-08-25 21:38:22', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('163', 'admin', 'system', 'PUT', '/api/platform/video/update/50', 'update', '127.0.0.1', '', '{\"url\": \"https://www.bilibili.com/video/BV1aw8E6SE4F?spm_id_from=333.1007.tianma.1-2-2.click\"}', '9.98', null, '1', null, '2026-08-25 21:38:23', '2026-08-25 21:38:23', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('164', 'admin', 'system', 'DELETE', '/api/core/logs/deleteLoginLog', 'deleteLoginLog', '127.0.0.1', '', '{\"ids\": \"18\"}', '29.63', null, '1', null, '2026-08-25 21:40:39', '2026-08-25 21:40:39', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('165', 'admin', 'system', 'DELETE', '/api/core/logs/deleteLoginLog', 'deleteLoginLog', '127.0.0.1', '', '{\"ids\": \"17\"}', '100.28', null, '1', null, '2026-08-25 21:40:42', '2026-08-25 21:40:42', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('166', 'admin', 'system', 'PUT', '/api/system/dict/type/update/20', 'update', '127.0.0.1', '', '{\"id\": 20, \"name\": \"定时任务类型\", \"code\": \"crontab_task_type\", \"remark\": \"2\", \"status\": 1}', '55.83', null, '1', null, '2026-08-25 21:41:02', '2026-08-25 21:41:02', '2026-09-25 21:40:22');
INSERT INTO `sa_system_oper_log` VALUES ('167', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_database_backup', 'system_database_backup', '127.0.0.1', '', '{}', '29.51', null, '1', null, '2026-08-26 22:47:46', '2026-08-26 22:47:46', null);
INSERT INTO `sa_system_oper_log` VALUES ('168', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/pause/system_database_backup', 'system_database_backup', '127.0.0.1', '', '{}', '10.26', null, '1', null, '2026-08-26 22:47:51', '2026-08-26 22:47:51', null);
INSERT INTO `sa_system_oper_log` VALUES ('169', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/resume/system_database_backup', 'system_database_backup', '127.0.0.1', '', '{}', '12.33', null, '1', null, '2026-08-26 22:47:56', '2026-08-26 22:47:56', null);
INSERT INTO `sa_system_oper_log` VALUES ('170', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_cleanup_operation_log', 'system_cleanup_operation_log', '127.0.0.1', '', '{}', '11.16', null, '1', null, '2026-08-26 22:48:00', '2026-08-26 22:48:00', null);
INSERT INTO `sa_system_oper_log` VALUES ('171', 'admin', 'system', 'POST', '/api/task/cronjob/job/task/run/system_database_backup', 'system_database_backup', '127.0.0.1', '', '{}', '9.29', null, '1', null, '2026-08-26 22:48:08', '2026-08-26 22:48:08', null);
INSERT INTO `sa_system_oper_log` VALUES ('172', 'admin', 'system', 'POST', '/api/core/switch-tenant', 'switch-tenant', '127.0.0.1', '', '{\"tenant_id\": 1}', '53.2', null, '1', null, '2026-08-26 23:08:19', '2026-08-26 23:08:19', null);
INSERT INTO `sa_system_oper_log` VALUES ('173', 'admin', 'system', 'POST', '/api/platform/video/refresh/41', 'refresh', '127.0.0.1', '', '{}', '106.85', null, '1', null, '2026-08-28 21:02:31', '2026-08-28 21:02:31', null);
INSERT INTO `sa_system_oper_log` VALUES ('174', 'admin', 'system', 'PUT', '/api/platform/video/update/41', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/i/status/2078448617468355069\"}', '7.84', null, '1', null, '2026-08-28 21:02:34', '2026-08-28 21:02:34', null);
INSERT INTO `sa_system_oper_log` VALUES ('175', 'admin', 'system', 'POST', '/api/platform/video/refresh/41', 'refresh', '127.0.0.1', '', '{}', '7.61', null, '1', null, '2026-08-28 21:02:50', '2026-08-28 21:02:50', null);
INSERT INTO `sa_system_oper_log` VALUES ('176', 'admin', 'system', 'PUT', '/api/platform/video/update/41', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/i/status/2078448617468355069\"}', '7.35', null, '1', null, '2026-08-28 21:02:56', '2026-08-28 21:02:56', null);
INSERT INTO `sa_system_oper_log` VALUES ('177', 'admin', 'system', 'PUT', '/api/article/update/11', 'update', '127.0.0.1', '', '{\"_raw\": \"{\\\"id\\\":11,\\\"title\\\":\\\"Dromara Warm-Flow，国产的工作流引擎1\\\",\\\"category_id\\\":2,\\\"author\\\":\\\"Dromara\\\",\\\"image\\\":\\\"http://127.0.0.1:8000/uploads/2026/03/28/69c7a3af23d945.66099869.webp\\\",\\\"describe\\\":\\\"Dromara Warm-Flow，国产的工作流引擎，以其简洁轻量、五脏俱全、灵活扩展性强的特点，成为了众多开发者的首选。它不仅可以通过jar包快速集成设计器，同时原生支持经典和仿钉钉双模式，还具备以下显著优势：\\\",\\\"content\\\":\\\"<blockquote style=\\\\\\\"text-align: start;\\\\\\\">Dromara Warm-Flow，国产的工作流引擎，以其简洁轻量、五脏俱全、灵活扩展性强的特点，成为了众多开发者的首选。它不仅可以通过jar包快速集成设计器，同时原生支持经典和仿钉钉双模式，还具备以下显著优势：</blockquote><ul><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>简洁易用</strong>‌：仅包含7张表，代码量少，上手和集成速度快。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>审批功能全面</strong>‌：支持通过、退回、撤销、拿回、任意跳转、终止、转办、票签、委派和加减签、互斥、并行、自动审批、远程访问和脚本执行服务等多种审批操作，以及条件表达式、办理人表达和监听器等高级功能。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>流程设计器</strong>‌：通过jar包形式快速集成到项目，支持节点属性扩展，原生支持经典和仿钉钉双模式。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>流程图</strong>‌：自带流程图，通过jar包快速集，功能扩展，原生支持经典和仿钉钉双模式。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>条件表达式</strong>‌：内置常见的和spel条件表达式，支持自定义扩展。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>办理人变量表达式</strong>‌：内置${handler}和spel格式的表达式，满足不同场景需求，灵活可扩展。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>监听器</strong>‌：提供四种监听器，支持不同作用范围和spel表达式，参数传递灵活，支持动态权限。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>流程变量</strong>‌：在整个流程办理过程起到重要的角色，如办理人表达式中，传入变量进行动态指定办理人。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>ORM框架支持</strong>‌：支持MyBatis、Mybatis-Plus、Mybatis-Flex、Jpa、Easy-Query和BeetlSql，后续将扩展支持其他框架</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>数据库支持</strong>‌：支持MySQL、Oracle、PostgreSQL和SQL Server，其他数据库只需要转换表结构即可支持。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>多租户与软删除</strong>‌：流程引擎自身维护多租户和软删除实现，也可使用对应ORM框架的实现方式。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>兼容性</strong>‌：同时支持Spring和Solon，兼容Java8、Java17、Java21。</li><li style=\\\\\\\"text-align: start;\\\\\\\"><strong>实战项目</strong>‌：官方提供基于Ruoyi-Vue封装的实战项目，极具参考价值。</li><li style=\\\\\\\"text-align: start;\\\\\\\"></li><li style=\\\\\\\"text-align: start;\\\\\\\"> <a href=\\\\\\\"ht', '71.15', null, '1', null, '2026-08-28 21:28:31', '2026-08-28 21:28:31', null);
INSERT INTO `sa_system_oper_log` VALUES ('178', 'admin', 'system', 'PUT', '/api/system/user/menus/100', 'menus', '127.0.0.1', '', '{\"menu_ids\": [105, 106]}', '81.7', null, '1', null, '2026-08-28 21:29:40', '2026-08-28 21:29:40', null);
INSERT INTO `sa_system_oper_log` VALUES ('179', 'admin', 'system', 'PUT', '/api/system/role/menu-permission/2', 'menu-permission', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183, 105, 106, 420, 421, 422, 423, 424, 425, 426]}', '79.31', null, '1', null, '2026-08-28 21:30:19', '2026-08-28 21:30:19', null);
INSERT INTO `sa_system_oper_log` VALUES ('180', 'admin', 'system', 'DELETE', '/api/system/menu/delete/300', 'delete', '127.0.0.1', '', '{}', '42.61', null, '1', null, '2026-08-28 21:34:43', '2026-08-28 21:34:43', null);
INSERT INTO `sa_system_oper_log` VALUES ('181', 'admin', 'system', 'PUT', '/api/system/menu/update/105', 'update', '127.0.0.1', '', '{\"id\": 105, \"parent_id\": 0, \"type\": 1, \"component\": \"\", \"name\": \"文章管理\", \"slug\": \"\", \"path\": \"/article\", \"icon\": \"ri:book-line\", \"code\": \"Article\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '37.3', null, '1', null, '2026-08-28 21:36:33', '2026-08-28 21:36:33', null);
INSERT INTO `sa_system_oper_log` VALUES ('182', 'admin', 'system', 'POST', '/api/system/menu/create', 'create', '127.0.0.1', '', '{\"id\": null, \"parent_id\": 106, \"type\": 3, \"component\": \"\", \"name\": \"列表\", \"slug\": \"module_platform:article:query\", \"path\": \"\", \"icon\": \"\", \"code\": \"\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '56.24', null, '1', null, '2026-08-28 21:37:48', '2026-08-28 21:37:48', null);
INSERT INTO `sa_system_oper_log` VALUES ('183', 'admin', 'system', 'PUT', '/api/system/user/menus/100', 'menus', '127.0.0.1', '', '{\"menu_ids\": [105, 106, 427]}', '85.86', null, '1', null, '2026-08-28 21:38:17', '2026-08-28 21:38:17', null);
INSERT INTO `sa_system_oper_log` VALUES ('184', 'admin', 'system', 'POST', '/api/system/menu/create', 'create', '127.0.0.1', '', '{\"id\": null, \"parent_id\": 106, \"type\": 3, \"component\": \"\", \"name\": \"新增\", \"slug\": \"module_platform:article:create\", \"path\": \"\", \"icon\": \"\", \"code\": \"\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '44.56', null, '1', null, '2026-08-28 21:49:59', '2026-08-28 21:49:59', null);
INSERT INTO `sa_system_oper_log` VALUES ('185', 'admin', 'system', 'POST', '/api/system/menu/create', 'create', '127.0.0.1', '', '{\"id\": null, \"parent_id\": 106, \"type\": 3, \"component\": \"\", \"name\": \"修改\", \"slug\": \"module_platform:article:update\", \"path\": \"\", \"icon\": \"\", \"code\": \"\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '62.4', null, '1', null, '2026-08-28 21:50:28', '2026-08-28 21:50:28', null);
INSERT INTO `sa_system_oper_log` VALUES ('186', 'admin', 'system', 'POST', '/api/system/menu/create', 'create', '127.0.0.1', '', '{\"id\": null, \"parent_id\": 106, \"type\": 3, \"component\": \"\", \"name\": \"删除\", \"slug\": \"module_platform:article:delete\", \"path\": \"\", \"icon\": \"\", \"code\": \"\", \"remark\": \"\", \"link_url\": \"\", \"is_iframe\": 2, \"is_keep_alive\": 2, \"is_hidden\": 2, \"is_fixed_tab\": 2, \"is_full_page\": 2, \"sort\": 100, \"status\": 1}', '33.84', null, '1', null, '2026-08-28 21:50:47', '2026-08-28 21:50:47', null);
INSERT INTO `sa_system_oper_log` VALUES ('187', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"\", \"email\": \"888@qq.com\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '137.74', null, '1', null, '2026-08-28 21:56:32', '2026-08-28 21:56:32', null);
INSERT INTO `sa_system_oper_log` VALUES ('188', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"\", \"email\": \"888@q\\\\q11.cossm\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '5.46', null, '1', null, '2026-08-28 21:56:43', '2026-08-28 21:56:43', null);
INSERT INTO `sa_system_oper_log` VALUES ('189', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"\", \"email\": \"888@q\\\\q11.cossm\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '4.91', null, '1', null, '2026-08-28 21:57:21', '2026-08-28 21:57:21', null);
INSERT INTO `sa_system_oper_log` VALUES ('190', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '45.7', null, '1', null, '2026-08-28 21:58:20', '2026-08-28 21:58:20', null);
INSERT INTO `sa_system_oper_log` VALUES ('191', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"13dd\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '5.05', null, '1', null, '2026-08-28 22:12:09', '2026-08-28 22:12:09', null);
INSERT INTO `sa_system_oper_log` VALUES ('192', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"***\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '54.3', null, '1', null, '2026-08-28 22:12:22', '2026-08-28 22:12:22', null);
INSERT INTO `sa_system_oper_log` VALUES ('193', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"***\", \"realname\": \"***\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '5.22', null, '1', null, '2026-08-28 22:12:28', '2026-08-28 22:12:28', null);
INSERT INTO `sa_system_oper_log` VALUES ('194', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [2], \"post_ids\": [], \"status\": 1, \"gender\": \"1\", \"remark\": \"\"}', '39.4', null, '1', null, '2026-08-28 22:12:38', '2026-08-28 22:12:38', null);
INSERT INTO `sa_system_oper_log` VALUES ('195', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://v.youku.com/v_show/id_XNjQ4MTI2MTI4NA==.html\"], \"enqueue\": true}', '2220.17', null, '1', null, '2026-08-30 11:55:38', '2026-08-30 11:55:38', null);
INSERT INTO `sa_system_oper_log` VALUES ('196', 'admin', 'system', 'POST', '/api/platform/video/refresh/52', 'refresh', '127.0.0.1', '', '{}', '8.98', null, '1', null, '2026-08-30 11:55:46', '2026-08-30 11:55:46', null);
INSERT INTO `sa_system_oper_log` VALUES ('197', 'admin', 'system', 'PUT', '/api/platform/video/update/52', 'update', '127.0.0.1', '', '{\"url\": \"https://v.youku.com/v_show/id_XNTIwMzQ5MDQ5Ng==.html?spm=a2hkl.14919748_WEBHOME_HOME.scg_scroll_2.d_4_play&s=dafe29f1b86e45d7af46&scm=20140719.rcmd.feed.show_dafe29f1b86e45d7af46&alginfo=-1abId-2497216-1seqId-2193PO4v0C0ZR7H0Z-1sceneId-246595-1reqId-2233ecfb6.7963.477b.9626.fb93421d980e_1788062107287&scg_id=22896462\"}', '9.51', null, '1', null, '2026-08-30 11:56:11', '2026-08-30 11:56:11', null);
INSERT INTO `sa_system_oper_log` VALUES ('198', 'admin', 'system', 'POST', '/api/platform/video/refresh/52', 'refresh', '127.0.0.1', '', '{}', '9.17', null, '1', null, '2026-08-30 11:56:13', '2026-08-30 11:56:13', null);
INSERT INTO `sa_system_oper_log` VALUES ('199', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/Shennaziah/status/2093763705335115864\"], \"enqueue\": false}', '21247.35', null, '1', null, '2026-08-30 11:59:16', '2026-08-30 11:59:16', null);
INSERT INTO `sa_system_oper_log` VALUES ('200', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/Shennaziah/status/2093763705335115864\"], \"enqueue\": false}', '7.16', null, '1', null, '2026-08-30 11:59:17', '2026-08-30 11:59:17', null);
INSERT INTO `sa_system_oper_log` VALUES ('201', 'admin', 'system', 'POST', '/api/platform/video/refresh/53', 'refresh', '127.0.0.1', '', '{}', '8.68', null, '1', null, '2026-08-30 11:59:24', '2026-08-30 11:59:24', null);
INSERT INTO `sa_system_oper_log` VALUES ('202', 'admin', 'system', 'POST', '/api/platform/video/refresh/53', 'refresh', '127.0.0.1', '', '{}', '8.96', null, '1', null, '2026-08-30 11:59:26', '2026-08-30 11:59:26', null);
INSERT INTO `sa_system_oper_log` VALUES ('203', 'admin', 'system', 'PUT', '/api/platform/video/update/53', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/Shennaziah/status/2093763705335115864\"}', '9.16', null, '1', null, '2026-08-30 11:59:28', '2026-08-30 11:59:28', null);
INSERT INTO `sa_system_oper_log` VALUES ('204', 'admin', 'system', 'PUT', '/api/platform/video/update/53', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/Shennaziah/status/2093763705335115864\"}', '18.15', null, '1', null, '2026-08-30 12:09:00', '2026-08-30 12:09:00', null);
INSERT INTO `sa_system_oper_log` VALUES ('205', 'admin', 'system', 'POST', '/api/platform/video/refresh/53', 'refresh', '127.0.0.1', '', '{}', '8.8', null, '1', null, '2026-08-30 12:09:06', '2026-08-30 12:09:06', null);
INSERT INTO `sa_system_oper_log` VALUES ('206', 'admin', 'system', 'PUT', '/api/platform/video/update/53', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/heygidimurat/status/2093567030536376773/video/1\"}', '10.31', null, '1', null, '2026-08-30 12:11:21', '2026-08-30 12:11:21', null);
INSERT INTO `sa_system_oper_log` VALUES ('207', 'admin', 'system', 'POST', '/api/platform/video/refresh/53', 'refresh', '127.0.0.1', '', '{}', '9.83', null, '1', null, '2026-08-30 12:11:25', '2026-08-30 12:11:25', null);
INSERT INTO `sa_system_oper_log` VALUES ('208', 'admin', 'system', 'POST', '/api/platform/video/download/53', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '46.86', null, '1', null, '2026-08-30 12:11:45', '2026-08-30 12:11:45', null);
INSERT INTO `sa_system_oper_log` VALUES ('209', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/tiiillyiniuijg/status/2093713442276577365/video/1\"], \"enqueue\": false}', '2420.57', null, '1', null, '2026-08-30 12:15:54', '2026-08-30 12:15:54', null);
INSERT INTO `sa_system_oper_log` VALUES ('210', 'admin', 'system', 'POST', '/api/platform/video/refresh/54', 'refresh', '127.0.0.1', '', '{}', '9.03', null, '1', null, '2026-08-30 12:15:57', '2026-08-30 12:15:57', null);
INSERT INTO `sa_system_oper_log` VALUES ('211', 'admin', 'system', 'POST', '/api/platform/video/refresh/54', 'refresh', '127.0.0.1', '', '{}', '7.59', null, '1', null, '2026-08-30 12:16:00', '2026-08-30 12:16:00', null);
INSERT INTO `sa_system_oper_log` VALUES ('212', 'admin', 'system', 'POST', '/api/platform/video/refresh/54', 'refresh', '127.0.0.1', '', '{}', '17.26', null, '1', null, '2026-08-30 12:16:26', '2026-08-30 12:16:26', null);
INSERT INTO `sa_system_oper_log` VALUES ('213', 'admin', 'system', 'POST', '/api/platform/video/refresh/54', 'refresh', '127.0.0.1', '', '{}', '16.83', null, '1', null, '2026-08-30 12:18:01', '2026-08-30 12:18:01', null);
INSERT INTO `sa_system_oper_log` VALUES ('214', 'admin', 'system', 'PUT', '/api/platform/video/update/54', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/tiiillyiniuijg/status/2093713442276577365/video/1\"}', '8.88', null, '1', null, '2026-08-30 12:18:05', '2026-08-30 12:18:05', null);
INSERT INTO `sa_system_oper_log` VALUES ('215', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/FUNF0RDREAM/status/2093634274884989092/video/1\"], \"enqueue\": false}', '910.82', null, '1', null, '2026-08-30 12:18:21', '2026-08-30 12:18:21', null);
INSERT INTO `sa_system_oper_log` VALUES ('216', 'admin', 'system', 'POST', '/api/platform/video/refresh/55', 'refresh', '127.0.0.1', '', '{}', '8.01', null, '1', null, '2026-08-30 12:18:27', '2026-08-30 12:18:27', null);
INSERT INTO `sa_system_oper_log` VALUES ('217', 'admin', 'system', 'POST', '/api/platform/video/refresh/55', 'refresh', '127.0.0.1', '', '{}', '8.7', null, '1', null, '2026-08-30 12:21:59', '2026-08-30 12:21:59', null);
INSERT INTO `sa_system_oper_log` VALUES ('218', 'admin', 'system', 'POST', '/api/platform/video/download/55', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '16.09', null, '1', null, '2026-08-30 12:23:22', '2026-08-30 12:23:22', null);
INSERT INTO `sa_system_oper_log` VALUES ('219', 'admin', 'system', 'POST', '/api/platform/video/refresh/54', 'refresh', '127.0.0.1', '', '{}', '9.11', null, '1', null, '2026-08-30 13:05:12', '2026-08-30 13:05:12', null);
INSERT INTO `sa_system_oper_log` VALUES ('220', 'admin', 'system', 'PUT', '/api/platform/video/update/54', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/tiiillyiniuijg/status/2093713442276577365/video/1\"}', '11.23', null, '1', null, '2026-08-30 13:05:16', '2026-08-30 13:05:16', null);
INSERT INTO `sa_system_oper_log` VALUES ('221', 'admin', 'system', 'POST', '/api/platform/video/download/54', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '14.27', null, '1', null, '2026-08-30 13:05:55', '2026-08-30 13:05:55', null);
INSERT INTO `sa_system_oper_log` VALUES ('222', 'admin', 'system', 'POST', '/api/platform/video/create', 'create', '127.0.0.1', '', '{\"urls\": [\"https://x.com/wivvhwb/status/2093885451971236088/video/1\"], \"enqueue\": false}', '2558.87', null, '1', null, '2026-08-30 14:50:10', '2026-08-30 14:50:10', null);
INSERT INTO `sa_system_oper_log` VALUES ('223', 'admin', 'system', 'POST', '/api/platform/video/refresh/56', 'refresh', '127.0.0.1', '', '{}', '10.71', null, '1', null, '2026-08-30 14:50:20', '2026-08-30 14:50:20', null);
INSERT INTO `sa_system_oper_log` VALUES ('224', 'admin', 'system', 'POST', '/api/platform/video/refresh/56', 'refresh', '127.0.0.1', '', '{}', '7.54', null, '1', null, '2026-08-30 14:50:30', '2026-08-30 14:50:30', null);
INSERT INTO `sa_system_oper_log` VALUES ('225', 'admin', 'system', 'PUT', '/api/platform/video/update/56', 'update', '127.0.0.1', '', '{\"url\": \"https://x.com/wivvhwb/status/2093885451971236088/video/1\"}', '10.35', null, '1', null, '2026-08-30 14:50:36', '2026-08-30 14:50:36', null);
INSERT INTO `sa_system_oper_log` VALUES ('226', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{username:admin,tenant_id:1,uuid:avgnsamgppd-j07lkhcrlg,code:aaaa,password:admin123}', '0', null, null, null, '2026-09-21 23:21:13', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('227', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\":\"admin\",\"password\":\"admin123\",\"tenant_id\":1,\"uuid\":\"1aw4eo_zrmjr0mne0mt2na\",\"code\":\"aaaa\"}', '132', null, null, null, '2026-09-21 23:21:26', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('228', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"tenant_id\":1,\"uuid\":\"uiis-u9v6sovsktrekx4ow\",\"code\":\"aaaa\"}', '202', null, null, null, '2026-09-21 23:21:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('229', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"tenant_id\":1,\"uuid\":\"elqluynmtglhxvacc1zemg\",\"code\":\"aaaa\"}', '153', null, null, null, '2026-09-21 23:21:54', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('230', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\": \"admin\", \"password\": \"123456\", \"tenant_id\": 1, \"uuid\": \"adzj2vp1ggwb3ww0gmvpmg\", \"code\": \"aaaa\"}', '125', null, null, null, '2026-09-21 23:22:09', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('231', 'admin', 'system', 'POST', '/core/system/uploadImage', '/api/core/system/uploadImage', '::1', null, '', '31', null, null, null, '2026-09-21 23:23:23', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('232', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '::1', null, '{\"id\":123,\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"username\":\"guojing\",\"password\":\"\",\"realname\":\"郭靖\",\"dept_id\":5,\"phone\":\"18587\",\"email\":\"\",\"role_ids\":[2],\"post_ids\":[],\"status\":1,\"gender\":\"1\",\"remark\":\"\"}', '116', null, null, null, '2026-09-21 23:23:32', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('233', 'admin', 'system', 'POST', '/platform/video/create', '/api/platform/video/create', '::1', null, '{\"urls\":[\"https://www.bilibili.com/video/BV1NCev68Ead?trackid=web_pegasus_0.router-web-pegasus-2479516-sm4rx.1790004273784.342&spm_id_from=333.1007.tianma.2-2-5.click\"],\"enqueue\":false}', '1', null, null, null, '2026-09-21 23:24:48', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('234', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '::1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183]}', '353', null, null, null, '2026-09-21 23:29:24', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('235', 'admin', 'system', 'PUT', '/system/dept/update/129', '/api/system/dept/update/:id', '::1', null, '{\"id\":129,\"parent_id\":0,\"level\":\"0,\",\"name\":\"5555\",\"code\":\"aa\",\"leader_id\":null,\"remark\":\"\",\"sort\":100,\"status\":1}', '40', null, null, null, '2026-09-21 23:30:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('236', 'admin', 'system', 'PUT', '/system/dept/update/128', '/api/system/dept/update/:id', '::1', null, '{\"id\":128,\"parent_id\":0,\"level\":\"0,\",\"name\":\"11\",\"code\":\"111\",\"leader_id\":123,\"remark\":\"\",\"sort\":100,\"status\":1}', '31', null, null, null, '2026-09-21 23:30:25', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('237', 'admin', 'system', 'PUT', '/system/dept/update/121', '/api/system/dept/update/:id', '::1', null, '{\"id\":121,\"parent_id\":12,\"level\":\"0,1,12,\",\"name\":\"腾讯云事业部1\",\"code\":\"CLOUD\",\"leader_id\":122,\"remark\":\"111\",\"sort\":100,\"status\":1}', '32', null, null, null, '2026-09-21 23:30:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('238', 'admin', 'system', 'POST', '/system/dept/create', '/api/system/dept/create', '::1', null, '{\"id\":null,\"parent_id\":0,\"level\":\"\",\"name\":\"aaa11\",\"code\":\"aa1\",\"leader_id\":123,\"remark\":\"\",\"sort\":100,\"status\":1}', '32', null, null, null, '2026-09-21 23:30:56', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('239', 'admin', 'system', 'PUT', '/system/dept/update/131', '/api/system/dept/update/:id', '::1', null, '{\"id\":131,\"parent_id\":0,\"level\":\"\",\"name\":\"aaa11\",\"code\":\"aa1\",\"leader_id\":123,\"remark\":\"111\",\"sort\":101,\"status\":1}', '27', null, null, null, '2026-09-21 23:31:30', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('240', 'admin', 'system', 'PUT', '/system/role/update/2', '/api/system/role/update/:id', '::1', null, '{\"id\":2,\"level\":1,\"name\":\"集团总裁\",\"code\":\"ceo\",\"remark\":\"查看全集团数据1111\",\"sort\":100,\"status\":1,\"data_scope\":5,\"dept_ids\":[]}', '26', null, null, null, '2026-09-21 23:31:50', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('241', 'admin', 'system', 'PUT', '/system/post/update/1', '/api/system/post/update/:id', '::1', null, '{\"id\":1,\"name\":\"司机岗\",\"code\":\"driver\",\"remark\":\"1\",\"sort\":100,\"status\":1}', '59', null, null, null, '2026-09-21 23:32:12', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('242', 'admin', 'system', 'PUT', '/system/menu/update/19', '/api/system/menu/update/:id', '::1', null, '{\"id\":19,\"parent_id\":0,\"type\":4,\"component\":\"\",\"name\":\"官方文档\",\"slug\":\"\",\"path\":\"\",\"icon\":\"ri:file-copy-2-fill\",\"code\":\"Document\",\"remark\":\"\",\"link_url\":\"https://v3.phpframe.org\",\"is_iframe\":1,\"is_keep_alive\":2,\"is_hidden\":2,\"is_fixed_tab\":2,\"is_full_page\":2,\"sort\":102,\"status\":1}', '28', null, null, null, '2026-09-21 23:32:29', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('243', 'admin', 'system', 'PUT', '/system/menu/update/19', '/api/system/menu/update/:id', '::1', null, '{\"id\":19,\"parent_id\":0,\"type\":4,\"component\":\"\",\"name\":\"官方文档\",\"slug\":\"\",\"path\":\"\",\"icon\":\"ri:file-copy-2-fill\",\"code\":\"Document\",\"remark\":\"\",\"link_url\":\"https://v3.phpframe.org\",\"is_iframe\":1,\"is_keep_alive\":2,\"is_hidden\":2,\"is_fixed_tab\":2,\"is_full_page\":2,\"sort\":102,\"status\":0}', '27', null, null, null, '2026-09-21 23:32:33', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('244', 'admin', 'system', 'PUT', '/system/tenant/update/1', '/api/system/tenant/update/:id', '::1', null, '{\"id\":1,\"tenant_name\":\"租户1\",\"tenant_code\":\"Tenant1\",\"contact_name\":\"张三丰\",\"contact_phone\":\"88888888\",\"contact_email\":\"admin@qq.com\",\"address\":\"测试地址\",\"logo_url\":\"\",\"status\":0,\"expire_time\":null,\"max_users\":0,\"max_depts\":0,\"max_roles\":0,\"remark\":\"\"}', '32', null, null, null, '2026-09-21 23:34:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('245', 'admin', 'system', 'PUT', '/system/tenant/update/1', '/api/system/tenant/update/:id', '::1', null, '{\"id\":1,\"tenant_name\":\"租户1\",\"tenant_code\":\"Tenant1\",\"contact_name\":\"张三丰\",\"contact_phone\":\"88888888\",\"contact_email\":\"admin@qq.com\",\"address\":\"测试地址\",\"logo_url\":\"\",\"status\":1,\"expire_time\":null,\"max_users\":0,\"max_depts\":0,\"max_roles\":0,\"remark\":\"\"}', '35', null, null, null, '2026-09-21 23:34:23', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('246', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"33\",\"uuid\":\"c24bwpiztuow4zq7exeesg\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:36:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('247', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"33\",\"uuid\":\"1vpfhy179p8dxxmugeir-w\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:36:41', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('248', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"33555\",\"uuid\":\"giebufrph2klvolassbg4w\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:36:44', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('249', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"3355\",\"uuid\":\"vz3myjh03xkxaswgi2fvrw\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:36:46', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('250', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"2343\",\"uuid\":\"sw0j888fip8b59uvuxebaw\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:37:06', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('251', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"555\",\"uuid\":\"p4qsi2zjefwrir-rgnaoxq\",\"tenant_id\":1}', '0', null, null, null, '2026-09-21 23:48:58', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('252', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\": \"admin\", \"password\": \"123456\", \"tenant_id\": 1, \"uuid\": \"3wlgmeg8mepku-zcwrpirg\", \"code\": \"1234\"}', '177', null, null, null, '2026-09-21 23:49:56', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('253', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"username\": \"admin\", \"password\": \"123456\", \"tenant_id\": 1, \"uuid\": \"gji91jo9ntmxgvurys1qpq\", \"code\": \"1234\"}', '129', null, null, null, '2026-09-21 23:50:18', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('254', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"xb5v\",\"uuid\":\"lr5x6lnlnalvsmzpsngkrq\",\"tenant_id\":1}', '134', null, null, null, '2026-09-21 23:54:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('255', 'admin', 'system', 'POST', '/system/attachment/upload', '/api/system/attachment/upload', '::1', null, '', '33', null, null, null, '2026-09-21 23:55:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('256', 'admin', 'system', 'DELETE', '/monitor/online/g40nwlau_pfsays1mxvssw', '/api/monitor/online/:token', '::1', null, '', '0', null, null, null, '2026-09-21 23:56:12', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('257', 'admin', 'system', 'DELETE', '/monitor/online/af6c44f6fe814d0783277d1c68974f8a', '/api/monitor/online/:token', '::1', null, '', '0', null, null, null, '2026-09-21 23:56:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('258', 'admin', 'system', 'DELETE', '/monitor/online/ochier_pohx-axqfsokhmq', '/api/monitor/online/:token', '::1', null, '', '0', null, null, null, '2026-09-21 23:56:24', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('259', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"w34c\",\"uuid\":\"kn6l8jfjdfc7bnmiqmpufq\",\"tenant_id\":1}', '128', null, null, null, '2026-09-21 23:56:32', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('260', 'admin', 'system', 'POST', '/platform/video/create', '/api/platform/video/create', '::1', null, '{\"urls\":[\"https://www.bilibili.com/video/BV1Zben6kEQ4?trackid=web_pegasus_0.router-web-pegasus-2479516-gfll4.1790006268219.529&spm_id_from=333.1007.tianma.7-4-26.click\"],\"enqueue\":false}', '0', null, null, null, '2026-09-21 23:58:07', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('261', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{username:admin,password:x,captcha:AAAA,uuid:nope}', '0', null, null, null, '2026-09-22 00:33:04', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('262', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '::1', null, '{\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"dept_id\":5,\"email\":\"\",\"gender\":\"1\",\"id\":123,\"password\":\"\",\"phone\":\"18587\",\"post_ids\":[],\"realname\":\"郭靖\",\"remark\":\"\",\"role_ids\":[2],\"status\":1,\"username\":\"guojing\"}', '100', null, null, null, '2026-09-22 00:37:02', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('263', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"4444\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"fcs8caadhh0moylybcfevw\"}', '0', null, null, null, '2026-09-22 22:53:43', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('264', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"4444\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"gf3y4yu3f7t2g9aijjia2a\"}', '0', null, null, null, '2026-09-22 22:53:45', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('265', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"ljrm\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"e0wnmltvewbffgyaqv_a4g\"}', '216', null, null, null, '2026-09-22 22:54:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('266', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"chdh\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"cdzqkw7owgyy-wix3aia_w\"}', '133', null, null, null, '2026-09-22 23:21:53', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('267', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"7cz9\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"devwang\",\"uuid\":\"11wkuhqzyx7nmuuioiwwyw\"}', '122', null, null, null, '2026-09-22 23:25:07', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('268', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"cdv9\",\"password\":\"123456\",\"tenant_id\":2,\"username\":\"admin\",\"uuid\":\"idqoghbktinlb7z-udadea\"}', '116', null, null, null, '2026-09-22 23:25:26', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('269', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"9bvz\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"rw4arwpyjexhrza49xm-fw\"}', '121', null, null, null, '2026-09-22 23:26:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('270', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"C43H\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"fmk07yik1e0gskom85vt1q\"}', '0', null, null, null, '2026-09-22 23:42:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('271', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"de3e\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"mhbzdshsohzir_vazmhfqq\"}', '122', null, null, null, '2026-09-22 23:42:28', null, '2026-09-23 07:22:36');
INSERT INTO `sa_system_oper_log` VALUES ('272', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"6F7F\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"mfhbk0e6rh2jkf5wkmup0w\"}', '257', null, null, null, '2026-09-23 07:12:33', null, '2026-09-23 07:22:34');
INSERT INTO `sa_system_oper_log` VALUES ('273', 'admin', 'system', 'DELETE', '/core/logs/deleteOperLog', '/api/core/logs/deleteOperLog', '::1', null, '', '26', null, null, null, '2026-09-23 07:22:34', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('274', 'admin', 'system', 'DELETE', '/core/logs/deleteOperLog', '/api/core/logs/deleteOperLog', '::1', null, '', '25', null, null, null, '2026-09-23 07:22:36', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('275', 'admin', 'system', 'DELETE', '/core/logs/deleteLoginLog', '/api/core/logs/deleteLoginLog', '::1', null, '', '25', null, null, null, '2026-09-23 07:22:45', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('276', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '99', null, null, null, '2026-09-23 07:33:17', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('277', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '66', null, null, null, '2026-09-23 07:38:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('278', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"6TRZ\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"devwang\",\"uuid\":\"ccb3m1hkuqr0kl5fxocnsa\"}', '126', null, null, null, '2026-09-23 07:38:54', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('279', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"T737\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"nfzoyns_hvqvjbgpv_zlhg\"}', '146', null, null, null, '2026-09-23 07:39:13', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('280', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '49', null, null, null, '2026-09-23 07:39:24', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('281', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '62', null, null, null, '2026-09-23 07:45:56', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('282', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '54', null, null, null, '2026-09-23 07:46:02', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('283', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"2mgs\",\"password\":\"123456\",\"tenant_id\":2,\"username\":\"admin\",\"uuid\":\"vejpbyahshje6bxiq6bx3a\"}', '123', null, null, null, '2026-09-23 07:46:50', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('284', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '57', null, null, null, '2026-09-23 07:46:59', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('285', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"738f\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"3prjdeao4dnkuhv-rrcxcq\"}', '119', null, null, null, '2026-09-23 07:47:57', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('286', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '53', null, null, null, '2026-09-23 07:48:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('287', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '69', null, null, null, '2026-09-23 07:48:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('288', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '54', null, null, null, '2026-09-23 07:49:09', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('289', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '63', null, null, null, '2026-09-23 07:51:26', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('290', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"mj5c\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"nexrhwalaz_stwromgvqzg\"}', '116', null, null, null, '2026-09-23 07:51:50', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('291', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '56', null, null, null, '2026-09-23 07:52:03', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('292', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '63', null, null, null, '2026-09-23 07:52:32', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('293', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"v577\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"pq_qmgwqrlmd3iwz8o7i2g\"}', '150', null, null, null, '2026-09-23 07:53:45', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('294', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"8qgy\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"devwang\",\"uuid\":\"uiy5key17zgbbfndi0l6cq\"}', '122', null, null, null, '2026-09-23 07:54:02', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('295', 'devwang', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '76', null, null, null, '2026-09-23 08:01:21', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('296', 'devwang', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '82', null, null, null, '2026-09-23 08:01:25', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('297', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"WET7\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"sijnupmidriucptdvu4gxq\"}', '117', null, null, null, '2026-09-23 08:01:38', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('298', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '66', null, null, null, '2026-09-23 08:01:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('299', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"wpj3\",\"password\":\"123456\",\"tenant_id\":2,\"username\":\"admin\",\"uuid\":\"0iefyz12kkuh5rowaufcnq\"}', '235', null, null, null, '2026-09-24 21:55:17', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('300', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '65', null, null, null, '2026-09-24 22:07:20', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('301', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '60', null, null, null, '2026-09-24 22:24:25', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('302', '', 'system', 'POST', '/core/login', '/api/core/login', '::1', null, '{\"code\":\"gpb6\",\"password\":\"123456\",\"tenant_id\":2,\"username\":\"admin\",\"uuid\":\"tn-jwtlapq30giwalbsgpq\"}', '140', null, null, null, '2026-09-24 22:25:35', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('303', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '73', null, null, null, '2026-09-24 22:25:39', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('304', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '64', null, null, null, '2026-09-24 22:36:38', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('305', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '56', null, null, null, '2026-09-24 22:49:11', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('306', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:57:27', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('307', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"code\":\"1\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ishxmxej09cqdhrfxhlxta\"}', '0', null, null, null, '2026-09-24 22:57:35', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('308', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"code\":\"1\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"m6vcqjtear9od5vfc7foya\"}', '0', null, null, null, '2026-09-24 22:57:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('309', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:57:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('310', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:57:56', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('311', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:58:10', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('312', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:58:26', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('313', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:58:58', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('314', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"code\":\"1\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"zvsgoxqp9l6b36tcih9wrg\"}', '0', null, null, null, '2026-09-24 22:59:07', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('315', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 22:59:30', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('316', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '0', null, null, null, '2026-09-24 23:00:06', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('317', '', 'system', 'POST', '/core/login', '/core/login', '127.0.0.1', null, '{\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\"}', '115', null, null, null, '2026-09-24 23:00:29', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('318', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":2}', '55', null, null, null, '2026-09-24 23:05:12', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('319', 'admin', 'system', 'POST', '/core/switch-tenant', '/api/core/switch-tenant', '::1', null, '{\"tenant_id\":1}', '59', null, null, null, '2026-09-24 23:08:15', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('320', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"2p2g\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"1_8bgteewdcibeexxoekbq\"}', '116', null, null, null, '2026-09-24 23:23:56', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('321', 'admin', 'system', 'PUT', '/system/dept/update/1', '/api/system/dept/update/:id', '127.0.0.1', null, '{\"code\":\"GROUP\",\"id\":1,\"leader_id\":100,\"level\":\"0,\",\"name\":\"腾讯集团\",\"parent_id\":0,\"remark\":\"00\",\"sort\":0,\"status\":1}', '55', null, null, null, '2026-09-24 23:24:09', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('322', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"x48a\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"bx86glxg7wwtvmwxmtmvoq\"}', '118', null, null, null, '2026-09-24 23:26:30', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('323', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '10ms', '', null, null, '2026-09-25 00:08:21', '2026-09-25 00:08:21', null);
INSERT INTO `sa_system_oper_log` VALUES ('324', '', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{}', '2ms', '', null, null, '2026-09-25 00:08:29', '2026-09-25 00:08:29', null);
INSERT INTO `sa_system_oper_log` VALUES ('325', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"4924\",\"uuid\":\"9110061f00534ba98001f68e89e3b1b0\",\"tenant_id\":\"1\"}', '154ms', '', null, null, '2026-09-25 00:08:36', '2026-09-25 00:08:36', null);
INSERT INTO `sa_system_oper_log` VALUES ('326', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '9ms', '', null, null, '2026-09-25 00:34:12', '2026-09-25 00:34:12', null);
INSERT INTO `sa_system_oper_log` VALUES ('327', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"3223\",\"uuid\":\"cd177efe0e9941e4ab07b9b2c5147dfe\",\"tenant_id\":\"1\"}', '142ms', '', null, null, '2026-09-25 00:34:19', '2026-09-25 00:34:19', null);
INSERT INTO `sa_system_oper_log` VALUES ('328', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '7ms', '', null, null, '2026-09-25 00:48:46', '2026-09-25 00:48:46', null);
INSERT INTO `sa_system_oper_log` VALUES ('329', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"1463\",\"uuid\":\"c4b489ff52a94d9cbba68263a7e39465\",\"tenant_id\":\"1\"}', '140ms', '', null, null, '2026-09-25 00:48:53', '2026-09-25 00:48:53', null);
INSERT INTO `sa_system_oper_log` VALUES ('330', '', '刷新Token', 'POST', '/api/core/refresh', 'refreshToken', '127.0.0.1', '内网地址', '{\"refreshToken\":\"78cd586f0fe223687f33206ba3f4d26fa150036b9d27497831f742b9c09456fe33587f78a0914878ac10377ff9e78e87e2162211c39219ae50075b56ccb0f3a9\"}', '6ms', '刷新令牌已过期，请重新登录', null, null, '2026-09-25 09:42:07', '2026-09-25 09:42:07', null);
INSERT INTO `sa_system_oper_log` VALUES ('331', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '9ms', '', null, null, '2026-09-25 09:42:08', '2026-09-25 09:42:08', null);
INSERT INTO `sa_system_oper_log` VALUES ('332', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"3678\",\"uuid\":\"0acd26f471604a019357f88175b7381c\",\"tenant_id\":\"1\"}', '430ms', '', null, null, '2026-09-25 09:42:30', '2026-09-25 09:42:30', null);
INSERT INTO `sa_system_oper_log` VALUES ('333', 'admin', '立即执行一次', 'POST', '/api/tool/crontab/run/4', 'run', '127.0.0.1', '内网地址', '{}', '43ms', '', '1', '1', '2026-09-25 09:55:09', '2026-09-25 09:55:09', null);
INSERT INTO `sa_system_oper_log` VALUES ('334', 'admin', '立即执行一次', 'POST', '/api/tool/crontab/run/3', 'run', '127.0.0.1', '内网地址', '{}', '47ms', '', '1', '1', '2026-09-25 09:58:01', '2026-09-25 09:58:01', null);
INSERT INTO `sa_system_oper_log` VALUES ('335', 'admin', '上传附件', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '内网地址', '{}', '248ms', '', '1', '1', '2026-09-25 10:03:49', '2026-09-25 10:03:49', null);
INSERT INTO `sa_system_oper_log` VALUES ('336', 'admin', '上传附件', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '内网地址', '{}', '59ms', '', '1', '1', '2026-09-25 10:04:04', '2026-09-25 10:04:04', null);
INSERT INTO `sa_system_oper_log` VALUES ('337', 'admin', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{\"username\":\"admin\"}', '7ms', '', null, null, '2026-09-25 10:07:23', '2026-09-25 10:07:23', null);
INSERT INTO `sa_system_oper_log` VALUES ('338', 'admin', '登录', 'POST', '/api/core/login', 'login', '127.0.0.1', '内网地址', '{\"username\":\"admin\",\"password\":\"123456\",\"code\":\"2385\",\"uuid\":\"7834f4c53cd04595a1201c5d087172d5\",\"tenant_id\":\"1\"}', '155ms', '', null, null, '2026-09-25 10:07:29', '2026-09-25 10:07:29', null);
INSERT INTO `sa_system_oper_log` VALUES ('339', 'admin', '上传附件', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '内网地址', '{}', '138ms', '', '1', '1', '2026-09-25 10:08:00', '2026-09-25 10:08:00', null);
INSERT INTO `sa_system_oper_log` VALUES ('340', 'admin', '批量删除附件', 'DELETE', '/api/system/attachment/batchDelete', 'batchDelete', '127.0.0.1', '内网地址', '{\"ids\":[52,51,50,49,48,46,42]}', '47ms', '', '1', '1', '2026-09-25 10:08:06', '2026-09-25 10:08:06', null);
INSERT INTO `sa_system_oper_log` VALUES ('341', 'admin', '上传附件', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '内网地址', '{}', '72ms', '', '1', '1', '2026-09-25 10:08:09', '2026-09-25 10:08:09', null);
INSERT INTO `sa_system_oper_log` VALUES ('342', 'admin', '上传附件', 'POST', '/api/system/attachment/upload', 'upload', '127.0.0.1', '内网地址', '{}', '72ms', '', '1', '1', '2026-09-25 10:08:57', '2026-09-25 10:08:57', null);
INSERT INTO `sa_system_oper_log` VALUES ('343', '', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{}', '8ms', '', null, null, '2026-09-25 14:20:19', '2026-09-25 14:20:19', null);
INSERT INTO `sa_system_oper_log` VALUES ('344', '', '退出登录', 'POST', '/api/core/logout', 'logout', '127.0.0.1', '内网地址', '{}', '1ms', '', null, null, '2026-09-25 14:20:26', '2026-09-25 14:20:26', null);
INSERT INTO `sa_system_oper_log` VALUES ('345', 'admin', 'system', 'POST', '/api/platform/video/download/58', 'download', '127.0.0.1', '', '{\"mode\": \"best\"}', '32.54', null, '1', null, '2026-09-25 18:30:50', '2026-09-25 18:30:50', null);
INSERT INTO `sa_system_oper_log` VALUES ('346', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"4bn8\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ghmj5ufzjs0o4wx-kq62tg\"}', '114', null, null, null, '2026-09-25 20:37:51', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('347', 'admin', 'system', 'POST', '/system/attachment/upload', '/api/system/attachment/upload', '127.0.0.1', null, '', '99', null, null, null, '2026-09-25 20:38:01', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('348', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"pv6z\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ujwjzarravilf3dabmoupq\"}', '117', null, null, null, '2026-09-25 20:39:49', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('349', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"u79y\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"dcytrakppkfsmubdlhu1bw\"}', '116', null, null, null, '2026-09-25 20:40:34', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('350', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"args\":\"\",\"coalesce\":false,\"code\":\"e2e_node_test\",\"description\":\"temporary e2e node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"max_instances\":1,\"name\":\"E2E test node\",\"status\":0,\"trigger\":\"\",\"trigger_args\":\"\"}', '40', null, null, null, '2026-09-25 21:23:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('351', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"args\":\"\",\"coalesce\":false,\"code\":\"e2e_node_test\",\"description\":\"temporary e2e node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"max_instances\":1,\"name\":\"E2E test node\",\"status\":0,\"trigger\":\"\",\"trigger_args\":\"\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('352', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"now\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('353', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"cron\",\"trigger_args\":\"0 0 3 * * *\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('354', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"interval\",\"trigger_args\":\"0 0 1 0 0\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('355', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2020-01-01 08:00:00\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('356', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2026-09-25 23:24:30\"}', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('357', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[]', '0', null, null, null, '2026-09-25 21:24:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('358', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[6]', '0', null, null, null, '2026-09-25 21:25:39', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('359', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"args\":\"\",\"coalesce\":false,\"code\":\"e2e_node_test\",\"description\":\"temporary e2e node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"max_instances\":1,\"name\":\"E2E test node\",\"status\":0,\"trigger\":\"\",\"trigger_args\":\"\"}', '0', null, null, null, '2026-09-25 21:25:39', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('360', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"now\"}', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('361', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"cron\",\"trigger_args\":\"0 0 3 * * *\"}', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('362', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"interval\",\"trigger_args\":\"0 0 1 0 0\"}', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('363', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2020-01-01 08:00:00\"}', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('364', 'admin', 'system', 'POST', '/task/cronjob/node/execute', '/*', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2026-09-25 23:25:39\"}', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('365', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[]', '0', null, null, null, '2026-09-25 21:25:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('366', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[6]', '0', null, null, null, '2026-09-25 21:25:53', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('367', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[6]', '0', null, null, null, '2026-09-25 21:26:01', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('368', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '', '23', null, null, null, '2026-09-25 21:26:01', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('369', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"args\":\"\",\"coalesce\":false,\"code\":\"e2e_node_test\",\"description\":\"temporary e2e node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"max_instances\":1,\"name\":\"E2E test node\",\"status\":0,\"trigger\":\"\",\"trigger_args\":\"\"}', '52', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('370', 'admin', 'system', 'POST', '/task/cronjob/node/execute/7', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"now\"}', '52', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('371', 'admin', 'system', 'POST', '/task/cronjob/node/execute/7', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"cron\",\"trigger_args\":\"0 0 3 * * *\"}', '24', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('372', 'admin', 'system', 'POST', '/task/cronjob/node/execute/7', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"interval\",\"trigger_args\":\"0 0 1 0 0\"}', '25', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('373', 'admin', 'system', 'POST', '/task/cronjob/node/execute/7', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2020-01-01 08:00:00\"}', '0', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('374', 'admin', 'system', 'POST', '/task/cronjob/node/execute/7', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2026-09-25 23:28:14\"}', '28', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('375', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[7]', '29', null, null, null, '2026-09-25 21:28:14', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('376', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"code\":\"e2e_probe_node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"name\":\"probe node\",\"status\":0,\"trigger\":\"\"}', '63', null, null, null, '2026-09-25 21:29:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('377', 'admin', 'system', 'POST', '/task/cronjob/node/execute/8', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"now\"}', '56', null, null, null, '2026-09-25 21:29:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('378', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[8]', '27', null, null, null, '2026-09-25 21:29:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('379', 'admin', 'system', 'POST', '/task/cronjob/node/create', '/task/cronjob/node/create', '127.0.0.1', null, '{\"args\":\"\",\"coalesce\":false,\"code\":\"e2e_node_test\",\"description\":\"temporary e2e node\",\"func\":\"http_request\",\"kwargs\":\"{\\\"url\\\":\\\"http://127.0.0.1:8182/health\\\",\\\"expect_status\\\":200}\",\"max_instances\":1,\"name\":\"E2E test node\",\"status\":0,\"trigger\":\"\",\"trigger_args\":\"\"}', '28', null, null, null, '2026-09-25 21:30:04', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('380', 'admin', 'system', 'POST', '/task/cronjob/node/execute/9', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"now\"}', '53', null, null, null, '2026-09-25 21:30:04', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('381', 'admin', 'system', 'POST', '/task/cronjob/node/execute/9', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"cron\",\"trigger_args\":\"0 0 3 * * *\"}', '43', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('382', 'admin', 'system', 'POST', '/task/cronjob/node/execute/9', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"interval\",\"trigger_args\":\"0 0 1 0 0\"}', '34', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('383', 'admin', 'system', 'POST', '/task/cronjob/node/execute/9', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2020-01-01 08:00:00\"}', '0', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('384', 'admin', 'system', 'POST', '/task/cronjob/node/execute/9', '/task/cronjob/node/execute/:id', '127.0.0.1', null, '{\"trigger\":\"date\",\"trigger_args\":\"2026-09-25 23:30:04\"}', '29', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('385', 'admin', 'system', 'DELETE', '/task/cronjob/node/delete', '/task/cronjob/node/delete', '127.0.0.1', null, '[9]', '25', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('386', 'admin', 'system', 'DELETE', '/task/cronjob/job/log/delete', '/task/cronjob/job/log/delete', '127.0.0.1', null, '[1039]', '27', null, null, null, '2026-09-25 21:30:05', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('387', 'admin', 'system', 'DELETE', '/monitor/online/k6n_viyz69wj9n5i7h3-og', '/api/monitor/online/:token', '127.0.0.1', null, '', '0', null, null, null, '2026-09-25 22:27:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('388', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"dc5h\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"xsazpzai8kv98fmxuuy8mw\"}', '134', null, null, null, '2026-09-25 22:27:58', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('389', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"3h32\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"r_xz2yl1zmwap20rlw8ozq\"}', '187', null, null, null, '2026-09-25 22:35:46', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('390', 'admin', 'system', 'DELETE', '/monitor/online/ucho-o_kyns6tyzpwac8ua', '/api/monitor/online/:token', '127.0.0.1', null, '', '0', null, null, null, '2026-09-25 22:36:12', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('391', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"tkdu\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"yusoy1ufoa3m2cgblhoobq\"}', '109', null, null, null, '2026-09-25 22:36:20', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('392', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"ce6m\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"pfugerjyw87zeqqlkilfdw\"}', '0', null, null, null, '2026-09-28 22:05:34', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('393', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"oxv9\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"_ci10c_8q_83cnudfwfmja\"}', '0', null, null, null, '2026-09-28 22:05:40', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('394', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"2040\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"6zuc76duoysce_dbxjtrcg\"}', '0', null, null, null, '2026-09-28 22:05:43', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('395', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"w6l4\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"wuprwv1ata5olbwggtxxgg\"}', '136', null, null, null, '2026-09-28 22:05:49', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('396', 'admin', 'system', 'PUT', '/system/role/update/2', '/api/system/role/update/:id', '127.0.0.1', null, '{\"code\":\"ceo\",\"data_scope\":1,\"dept_ids\":[],\"id\":2,\"level\":1,\"name\":\"集团总裁\",\"remark\":\"查看全集团数据1111\",\"sort\":100,\"status\":1}', '34', null, null, null, '2026-09-28 22:18:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('397', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,173,1]}', '272', null, null, null, '2026-09-28 22:18:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('398', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,173,1]}', '233', null, null, null, '2026-09-28 22:18:36', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('399', 'admin', 'system', 'PUT', '/system/dept/update/1', '/api/system/dept/update/:id', '127.0.0.1', null, '{\"code\":\"GROUP\",\"id\":1,\"leader_id\":100,\"level\":\"0,\",\"name\":\"腾讯集团\",\"parent_id\":0,\"remark\":\"0011\",\"sort\":0,\"status\":1}', '36', null, null, null, '2026-09-28 22:19:10', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('400', 'admin', 'system', 'PUT', '/system/menu/update/21', '/api/system/menu/update/:id', '127.0.0.1', null, '{\"code\":\"UserCenter\",\"component\":\"/dashboard/user-center/index\",\"icon\":\"ri:user-2-line\",\"id\":21,\"is_fixed_tab\":2,\"is_full_page\":2,\"is_hidden\":1,\"is_iframe\":2,\"is_keep_alive\":2,\"link_url\":\"\",\"name\":\"个人中心\",\"parent_id\":1,\"path\":\"user-center\",\"remark\":\"\",\"slug\":\"\",\"sort\":100,\"status\":1,\"type\":2}', '36', null, null, null, '2026-09-28 22:19:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('401', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '127.0.0.1', null, '{\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"dept_id\":5,\"email\":\"\",\"gender\":\"1\",\"id\":123,\"password\":\"\",\"phone\":\"18587\",\"post_ids\":[],\"realname\":\"郭靖\",\"remark\":\"111\",\"role_ids\":[2],\"status\":1,\"username\":\"guojing111\"}', '79', null, null, null, '2026-09-28 23:05:41', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('402', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '127.0.0.1', null, '{\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"dept_id\":5,\"email\":\"\",\"gender\":\"1\",\"id\":123,\"password\":\"\",\"phone\":\"18587\",\"post_ids\":[1],\"realname\":\"郭靖\",\"remark\":\"111\",\"role_ids\":[2],\"status\":1,\"username\":\"guojing\"}', '104', null, null, null, '2026-09-28 23:07:15', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('403', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '127.0.0.1', null, '{\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"dept_id\":5,\"email\":\"\",\"gender\":\"1\",\"id\":123,\"password\":\"\",\"phone\":\"18587\",\"post_ids\":[1],\"realname\":\"郭靖\",\"remark\":\"111\",\"role_ids\":[2],\"status\":1,\"username\":\"guojing1\"}', '132', null, null, null, '2026-09-28 23:13:48', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('404', 'admin', 'system', 'PUT', '/system/user/update/123', '/api/system/user/update/:id', '127.0.0.1', null, '{\"avatar\":\"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\",\"dept_id\":5,\"email\":\"\",\"gender\":\"1\",\"id\":123,\"password\":\"\",\"phone\":\"18587\",\"post_ids\":[1],\"realname\":\"郭靖\",\"remark\":\"111\",\"role_ids\":[3],\"status\":1,\"username\":\"guojing1\"}', '182', null, null, null, '2026-09-28 23:13:55', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('405', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,173,1]}', '251', null, null, null, '2026-09-28 23:14:03', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('406', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183,4,20,22,23,24,25,26,27,28,3]}', '524', null, null, null, '2026-09-28 23:14:32', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('407', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,3,4,20,22,23,24,25,26,27,28,5,29,30,31,32,33,97,6,34,35,36,37,38,39,7,41,42,43,44,45,46,47,8,48,49,50,51,52,18,53,54,55,98,99,100,101,102,103,1]}', '1373', null, null, null, '2026-09-28 23:14:41', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('408', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183]}', '217', null, null, null, '2026-09-28 23:14:48', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('409', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,173,183,1]}', '172', null, null, null, '2026-09-28 23:14:55', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('410', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,173,1]}', '262', null, null, null, '2026-09-28 23:16:17', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('411', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183,3,4,20,22,23,24,25,26,27,28,5,29,30,31,32,33,97,6,34,35,36,37,38,39,7,41,42,43,44,45,46,47,8,48,49,50,51,52,18,53,54,55,98,99,100,101,102,103]}', '1439', null, null, null, '2026-09-28 23:16:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('412', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183]}', '265', null, null, null, '2026-09-28 23:16:39', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('413', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94,173]}', '254', null, null, null, '2026-09-28 23:20:25', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('414', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183,3,4,20,22,23,24,25,26,27,28,5,29,30,31,32,33,97,6,34,35,36,37,38,39,7,41,42,43,44,45,46,47,8,48,49,50,51,52,18,53,54,55,98,99,100,101,102,103]}', '1429', null, null, null, '2026-09-28 23:20:34', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('415', 'admin', 'system', 'PUT', '/system/user/menus/123', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[2,74,21,93,94]}', '149', null, null, null, '2026-09-28 23:20:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('416', 'admin', 'system', 'PUT', '/system/user/menus/100', '/api/system/user/menus/:id', '127.0.0.1', null, '{\"menu_ids\":[1,2,74,21,93,94,173,183,105,106,427,428,429,430]}', '474', null, null, null, '2026-09-28 23:26:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('417', 'admin', 'system', 'PUT', '/system/user/update/100', '/api/system/user/update/:id', '127.0.0.1', null, '{\"avatar\":\"\",\"dept_id\":12,\"email\":\"888888@qq.com\",\"gender\":\"1\",\"id\":100,\"password\":\"\",\"phone\":\"15888888888\",\"post_ids\":[1],\"realname\":\"王程序员\",\"remark\":\"1\",\"role_ids\":[2],\"status\":1,\"username\":\"devwang\"}', '146', null, null, null, '2026-09-28 23:26:42', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('418', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"59jf\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"qw8idsj0xct_gzuqmbevkg\"}', '116', null, null, null, '2026-09-28 23:29:22', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('419', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"lwf5\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ey7pshkm4xifloh8tfga5a\"}', '136', null, null, null, '2026-09-28 23:29:34', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('420', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"lyu7\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"iwjnirmr7cmrgsogxqkora\"}', '115', null, null, null, '2026-09-28 23:30:18', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('421', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"x4av\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"devwang\",\"uuid\":\"ewbo6etwekepyf3xmhgobq\"}', '136', null, null, null, '2026-09-28 23:41:38', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('422', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"k69w\",\"password\":\"123456\",\"tenant_id\":2,\"username\":\"devwang\",\"uuid\":\"pi_dvnzduvmzc4irvr74eq\"}', '120', null, null, null, '2026-09-28 23:42:13', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('423', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94, 173]}', '20.29', null, '1', null, '2026-09-28 23:44:41', '2026-09-28 23:44:41', null);
INSERT INTO `sa_system_oper_log` VALUES ('424', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94, 173]}', '13.28', null, '1', null, '2026-09-28 23:44:47', '2026-09-28 23:44:47', null);
INSERT INTO `sa_system_oper_log` VALUES ('425', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"111\"}', '19.42', null, '1', null, '2026-09-28 23:45:09', '2026-09-28 23:45:09', null);
INSERT INTO `sa_system_oper_log` VALUES ('426', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing1\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3, 2], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"111\"}', '12.95', null, '1', null, '2026-09-28 23:46:08', '2026-09-28 23:46:08', null);
INSERT INTO `sa_system_oper_log` VALUES ('427', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing1\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3, 2], \"post_ids\": [1, 2], \"status\": 1, \"gender\": \"1\", \"remark\": \"111\"}', '14.42', null, '1', null, '2026-09-28 23:46:12', '2026-09-28 23:46:12', null);
INSERT INTO `sa_system_oper_log` VALUES ('428', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing1\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"111\"}', '13.24', null, '1', null, '2026-09-28 23:46:18', '2026-09-28 23:46:18', null);
INSERT INTO `sa_system_oper_log` VALUES ('429', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing2\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"111\"}', '11.95', null, '1', null, '2026-09-28 23:46:24', '2026-09-28 23:46:24', null);
INSERT INTO `sa_system_oper_log` VALUES ('430', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing1\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"11111\"}', '20.82', null, '1', null, '2026-09-28 23:46:31', '2026-09-28 23:46:31', null);
INSERT INTO `sa_system_oper_log` VALUES ('431', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing1\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"11111444\"}', '12.99', null, '1', null, '2026-09-28 23:46:35', '2026-09-28 23:46:35', null);
INSERT INTO `sa_system_oper_log` VALUES ('432', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94, 173, 20]}', '16.28', null, '1', null, '2026-09-28 23:47:27', '2026-09-28 23:47:27', null);
INSERT INTO `sa_system_oper_log` VALUES ('433', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183]}', '16.19', null, '1', null, '2026-09-28 23:48:45', '2026-09-28 23:48:45', null);
INSERT INTO `sa_system_oper_log` VALUES ('434', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94]}', '13.95', null, '1', null, '2026-09-28 23:48:50', '2026-09-28 23:48:50', null);
INSERT INTO `sa_system_oper_log` VALUES ('435', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94, 173, 20]}', '15.33', null, '1', null, '2026-09-28 23:49:00', '2026-09-28 23:49:00', null);
INSERT INTO `sa_system_oper_log` VALUES ('436', 'admin', 'system', 'PUT', '/api/system/user/update/123', 'update', '127.0.0.1', '', '{\"id\": 123, \"avatar\": \"/uploads/2026/09/21/1790004203422_N67RXCuN.jpg\", \"username\": \"guojing11\", \"realname\": \"郭靖\", \"dept_id\": 5, \"phone\": \"18587\", \"email\": \"\", \"role_ids\": [3], \"post_ids\": [1], \"status\": 1, \"gender\": \"1\", \"remark\": \"11111444\"}', '22.7', null, '1', null, '2026-09-28 23:53:13', '2026-09-28 23:53:13', null);
INSERT INTO `sa_system_oper_log` VALUES ('437', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183, 20]}', '17.62', null, '1', null, '2026-09-28 23:53:21', '2026-09-28 23:53:21', null);
INSERT INTO `sa_system_oper_log` VALUES ('438', 'admin', 'system', 'PUT', '/api/system/user/menus/123', 'menus', '127.0.0.1', '', '{\"menu_ids\": [2, 74, 21, 93, 94, 20]}', '17.24', null, '1', null, '2026-09-28 23:53:25', '2026-09-28 23:53:25', null);
INSERT INTO `sa_system_oper_log` VALUES ('439', 'admin', 'system', 'PUT', '/api/system/role/menu-permission/2', 'menu-permission', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183, 5, 29, 30, 31, 32, 33, 97, 6, 34, 35, 36, 37, 38, 39, 7, 41, 42, 43, 44, 45, 46, 47, 8, 48, 49, 50, 51, 52, 18, 53, 54, 55, 98, 99, 100, 101, 102, 103]}', '41.39', null, '1', null, '2026-09-28 23:53:42', '2026-09-28 23:53:42', null);
INSERT INTO `sa_system_oper_log` VALUES ('440', 'admin', 'system', 'PUT', '/api/system/role/menu-permission/2', 'menu-permission', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183, 6, 34, 35, 36, 37, 38, 39, 7, 41, 42, 43, 44, 45, 46, 47, 8, 48, 49, 50, 51, 52, 18, 53, 54, 55, 98, 99, 100, 101, 102, 103]}', '36.85', null, '1', null, '2026-09-28 23:53:50', '2026-09-28 23:53:50', null);
INSERT INTO `sa_system_oper_log` VALUES ('441', 'admin', 'system', 'PUT', '/api/system/role/menu-permission/2', 'menu-permission', '127.0.0.1', '', '{\"menu_ids\": [1, 2, 74, 21, 93, 94, 173, 183, 6, 34, 35, 36, 37, 38, 39, 7, 41, 42, 43, 44, 45, 46, 47, 8, 48, 49, 50, 51, 52, 18, 53, 54, 55, 98, 99, 100, 101, 102, 103]}', '35.04', null, '1', null, '2026-09-28 23:53:55', '2026-09-28 23:53:55', null);
INSERT INTO `sa_system_oper_log` VALUES ('442', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"lqfv\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"evtibjh7r4fzjotiig4dbg\"}', '125', null, null, null, '2026-09-29 00:27:09', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('443', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"ke7q\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"b5elz3wgi2snsajsizhneg\"}', '284', null, null, null, '2026-10-13 00:29:10', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('444', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"e9x3\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"s6bmny7arxjy_o5lahegya\"}', '127', null, null, null, '2026-10-13 00:34:43', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('445', 'admin', 'system', 'POST', '/core/config/batchUpdate', '/api/core/config/batchUpdate', '127.0.0.1', null, '{\"config\":[{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":5,\"input_type\":\"input\",\"key\":\"site_record_number\",\"name\":\"网站备案号\",\"remark\":null,\"sort\":95,\"update_time\":\"2026-01-01 00:00:00\",\"updated_by\":1,\"value\":\"9527\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":1,\"input_type\":\"textarea\",\"key\":\"site_copyright\",\"name\":\"版权信息\",\"remark\":\"\",\"sort\":96,\"update_time\":\"2026-03-22 20:34:45\",\"updated_by\":1,\"value\":\"Copyright © 2026 FSSPHP Team\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":2,\"input_type\":\"textarea\",\"key\":\"site_desc\",\"name\":\"网站描述\",\"remark\":null,\"sort\":97,\"update_time\":\"2026-04-23 21:36:30\",\"updated_by\":1,\"value\":\"基于Vue3 + FSSPHP 的极速开发框架\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":3,\"input_type\":\"input\",\"key\":\"site_keywords\",\"name\":\"网站关键字\",\"remark\":null,\"sort\":98,\"update_time\":\"2026-04-23 21:36:23\",\"updated_by\":1,\"value\":\"FSSPHP, Workerman，symfony，Thinkphp，后台管理系统\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":4,\"input_type\":\"input\",\"key\":\"site_name\",\"name\":\"网站名称\",\"remark\":null,\"sort\":99,\"update_time\":\"2026-04-23 21:36:24\",\"updated_by\":1,\"value\":\"FssAdmin（go）版本\"}],\"group_id\":1}', '137', null, null, null, '2026-10-13 00:35:07', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('446', 'admin', 'system', 'POST', '/core/config/batchUpdate', '/api/core/config/batchUpdate', '127.0.0.1', null, '{\"config\":[{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":5,\"input_type\":\"input\",\"key\":\"site_record_number\",\"name\":\"网站备案号\",\"remark\":null,\"sort\":95,\"update_time\":\"2026-01-01 00:00:00\",\"updated_by\":1,\"value\":\"9527\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":1,\"input_type\":\"textarea\",\"key\":\"site_copyright\",\"name\":\"版权信息\",\"remark\":\"\",\"sort\":96,\"update_time\":\"2026-03-22 20:34:45\",\"updated_by\":1,\"value\":\"Copyright © 2026 FSSPHP Team\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":2,\"input_type\":\"textarea\",\"key\":\"site_desc\",\"name\":\"网站描述\",\"remark\":null,\"sort\":97,\"update_time\":\"2026-04-23 21:36:30\",\"updated_by\":1,\"value\":\"基于Vue3 + FSSPHP 的极速开发框架\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":3,\"input_type\":\"input\",\"key\":\"site_keywords\",\"name\":\"网站关键字\",\"remark\":null,\"sort\":98,\"update_time\":\"2026-04-23 21:36:23\",\"updated_by\":1,\"value\":\"FSSPHP, Workerman，symfony，Thinkphp，后台管理系统\"},{\"config_select_data\":[],\"create_time\":\"2026-01-01 00:00:00\",\"created_by\":1,\"delete_time\":null,\"display\":true,\"group_id\":1,\"id\":4,\"input_type\":\"input\",\"key\":\"site_name\",\"name\":\"网站名称\",\"remark\":null,\"sort\":99,\"update_time\":\"2026-04-23 21:36:24\",\"updated_by\":1,\"value\":\"FssAdmin（go）版\"}],\"group_id\":1}', '190', null, null, null, '2026-10-13 00:35:09', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('447', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"bcyp\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"kbleszwlx-mjhjwgnoq7hw\"}', '126', null, null, null, '2026-10-13 00:35:41', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('448', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"ks57\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"0cfsb-zqvc20eqhupgrhog\"}', '229', null, null, null, '2026-10-13 19:51:20', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('449', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"1234\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ascxevll-8nqgdegjuxz_q\"}', '0', null, null, null, '2026-10-13 20:29:47', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('450', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"1234\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ascxevll-8nqgdegjuxz_q\"}', '0', null, null, null, '2026-10-13 20:30:15', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('451', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\\', '0', null, null, null, '2026-10-13 20:30:15', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('452', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"1234\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"test\"}', '0', null, null, null, '2026-10-13 20:30:31', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('453', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"1234\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ascxevll-8nqgdegjuxz_q\"}', '0', null, null, null, '2026-10-13 20:31:16', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('454', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"1234\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"ascxevll-8nqgdegjuxz_q\"}', '0', null, null, null, '2026-10-13 20:31:48', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('455', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"EBSD\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"kgbomqpdhpkyytndzfdzjq\"}', '0', null, null, null, '2026-10-13 20:33:25', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('456', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"U73W\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"meci6jhkd1mi3e8kfq3kig\"}', '0', null, null, null, '2026-10-13 20:33:59', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('457', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"ftfj\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"2ahsp28fofonlq-dylvfpg\"}', '130', null, null, null, '2026-10-13 20:34:36', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('458', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"3pd3\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"56qj8ebjcyrha6vdijfbfg\"}', '135', null, null, null, '2026-10-13 20:35:36', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('459', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"rvhl\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"pbew8luqcehaqm6s89lnga\"}', '136', null, null, null, '2026-10-13 20:36:21', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('460', 'admin', 'system', 'DELETE', '/system/dept/delete/131', '/api/system/dept/delete/:id', '127.0.0.1', null, '', '32', null, null, null, '2026-10-13 20:57:45', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('461', 'admin', 'system', 'PUT', '/article/status/11', '/api/article/status/:id', '127.0.0.1', null, '{\"status\":0}', '33', null, null, null, '2026-10-13 20:58:51', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('462', 'admin', 'system', 'PUT', '/article/status/11', '/api/article/status/:id', '127.0.0.1', null, '{\"status\":1}', '30', null, null, null, '2026-10-13 20:58:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('463', 'admin', 'system', 'POST', '/platform/video/create', '/api/platform/video/create', '127.0.0.1', null, '{\"enqueue\":false,\"urls\":[\"https://www.bilibili.com/video/BV1N5Hk6JErG?trackid=web_pegasus_0.router-web-pegasus-2479516-f6fct.1791896522179.446\\u0026spm_id_from=333.1007.tianma.3-1-7.click\"]}', '1', null, null, null, '2026-10-13 21:02:24', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('464', 'admin', 'system', 'PUT', '/system/menu/update/19', '/api/system/menu/update/:id', '127.0.0.1', null, '{\"code\":\"Document\",\"component\":\"\",\"icon\":\"ri:file-copy-2-fill\",\"is_fixed_tab\":2,\"is_full_page\":2,\"is_hidden\":2,\"is_iframe\":1,\"is_keep_alive\":2,\"link_url\":\"https://v3.phpframe.org\",\"name\":\"官方文档\",\"parent_id\":0,\"path\":\"\",\"remark\":\"\",\"slug\":\"\",\"sort\":102,\"status\":1,\"type\":4}', '41', null, null, null, '2026-10-13 21:15:32', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('465', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"mf6c\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"-juonhvtjqhgq4qpcf6p0g\"}', '134', null, null, null, '2026-10-13 21:15:47', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('466', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"111\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"_zwmf2caolqq9mzm-xv1ta\"}', '0', null, null, null, '2026-10-13 21:16:47', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('467', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"pckn\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"_zwmf2caolqq9mzm-xv1ta\"}', '3', null, null, null, '2026-10-13 21:16:52', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('468', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"z2w3\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"8ycfkup4x47ajggs9srpww\"}', '129', null, null, null, '2026-10-13 21:16:58', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('469', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"xnbv\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"dt4abpdv0fdxqg4erkkyag\"}', '154', null, null, null, '2026-10-13 21:17:19', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('470', 'admin', 'system', 'DELETE', '/core/logs/deleteLoginLog', '/api/core/logs/deleteLoginLog', '127.0.0.1', null, '{\"ids\":[104]}', '66', null, null, null, '2026-10-13 21:17:32', null, '2026-10-13 21:21:58');
INSERT INTO `sa_system_oper_log` VALUES ('471', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"zrj7\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"grbvcrcjdtm2vgayiqdzfa\"}', '130', null, null, null, '2026-10-13 21:21:47', null, '2026-10-13 21:21:54');
INSERT INTO `sa_system_oper_log` VALUES ('472', 'admin', 'system', 'DELETE', '/core/logs/deleteOperLog', '/api/core/logs/deleteOperLog', '127.0.0.1', null, '{\"ids\":[471]}', '28', null, null, null, '2026-10-13 21:21:54', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('473', 'admin', 'system', 'DELETE', '/core/logs/deleteOperLog', '/api/core/logs/deleteOperLog', '127.0.0.1', null, '{\"ids\":[470]}', '64', null, null, null, '2026-10-13 21:21:58', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('474', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"yj2m\",\"password\":\"123456\",\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"vt2hnetitwm5rlef7ye0qa\"}', '114', null, null, null, '2026-10-13 21:24:37', null, null);
INSERT INTO `sa_system_oper_log` VALUES ('475', '', 'system', 'POST', '/core/login', '/api/core/login', '127.0.0.1', null, '{\"code\":\"QF5X\",\"password\":\"123456\",\"rememberPassword\":false,\"tenant_id\":1,\"username\":\"admin\",\"uuid\":\"qwx3mvcjvyuwpdtmbu-cva\"}', '127', null, null, null, '2026-10-13 21:25:27', null, null);

-- ----------------------------
-- Table structure for `sa_system_post`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_post`;
CREATE TABLE `sa_system_post` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '岗位名称',
  `code` varchar(100) DEFAULT NULL COMMENT '岗位代码',
  `sort` smallint(5) unsigned DEFAULT '0' COMMENT '排序',
  `status` smallint(6) DEFAULT '1' COMMENT '状态 (1正常 2停用)',
  `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '所属租户ID，0表示系统级',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';

-- ----------------------------
-- Records of sa_system_post
-- ----------------------------
INSERT INTO `sa_system_post` VALUES ('1', '司机岗', 'driver', '100', '1', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-09-21 23:32:12', null);
INSERT INTO `sa_system_post` VALUES ('2', '保安岗', 'security', '100', '1', '1', '', '1', '1', '2026-01-01 00:00:00', '2026-06-23 18:01:02', null);
INSERT INTO `sa_system_post` VALUES ('3', '11', '11', '100', '1', '1', '1233', '1', '1', '2026-03-22 12:12:55', '2026-03-22 12:13:12', '2026-03-22 12:13:12');
INSERT INTO `sa_system_post` VALUES ('4', '111', '111', '100', '2', '1', '11111', '1', '1', '2026-03-22 12:47:53', '2026-03-22 13:33:02', '2026-03-22 13:33:02');
INSERT INTO `sa_system_post` VALUES ('5', 'aa', 'aaa', '100', '1', '1', '', '1', '1', '2026-03-27 21:45:50', '2026-03-28 19:08:12', '2026-03-28 19:08:12');
INSERT INTO `sa_system_post` VALUES ('6', '111', '11111', '100', '1', '1', '', '1', '1', '2026-03-28 19:32:14', '2026-03-28 19:32:23', '2026-03-28 19:32:23');
INSERT INTO `sa_system_post` VALUES ('7', '开发岗', 'dev', '100', '1', '2', '', '1', '1', '2026-06-21 19:57:01', '2026-06-21 19:57:01', null);

-- ----------------------------
-- Table structure for `sa_system_role`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_role`;
CREATE TABLE `sa_system_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '父角色ID，0表示顶级角色',
  `name` varchar(64) NOT NULL COMMENT '角色名称',
  `code` varchar(64) NOT NULL COMMENT '角色标识(英文唯一)，如: hr_manager',
  `level` int(11) DEFAULT '1' COMMENT '角色级别(1-100)：用于行政控制，不可操作级别>=自己的角色',
  `data_scope` tinyint(4) DEFAULT '1' COMMENT '数据范围: 1全部, 2本部门及下属, 3本部门, 4仅本人, 5自定义',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sort` int(11) DEFAULT '100',
  `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '所属租户ID，0表示系统级',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 1启用, 0禁用',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色信息表';

-- ----------------------------
-- Records of sa_system_role
-- ----------------------------
INSERT INTO `sa_system_role` VALUES ('1', '0', '超级管理员', 'super_admin', '100', '1', '系统维护者，拥有所有权限', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-01-01 00:00:00', null);
INSERT INTO `sa_system_role` VALUES ('2', '0', '集团总裁', 'ceo', '1', '1', '查看全集团数据1111', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-09-28 22:18:19', null);
INSERT INTO `sa_system_role` VALUES ('3', '0', 'BG总裁', 'bg_president', '1', '2', '', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-03-22 18:19:47', null);
INSERT INTO `sa_system_role` VALUES ('4', '0', '部门总经理1', 'gm', '60', '2', '', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-03-22 12:48:24', null);
INSERT INTO `sa_system_role` VALUES ('5', '0', '组长', 'team_leader', '30', '3', '', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-03-21 23:24:29', null);
INSERT INTO `sa_system_role` VALUES ('6', '0', '普通员工', 'staff', '10', '6', '自定义部门权限', '100', '1', '1', '1', '1', '2026-01-01 00:00:00', '2026-07-18 23:52:01', null);
INSERT INTO `sa_system_role` VALUES ('7', '0', '111', '11', '1', '1', '11', '100', '1', '1', '1', '1', '2026-03-22 20:38:38', '2026-03-22 20:38:41', '2026-03-22 20:38:41');
INSERT INTO `sa_system_role` VALUES ('8', '0', 'ad', 'dddd', '1', '6', '啊大大、', '100', '1', '1', '1', '1', '2026-03-27 21:45:30', '2026-07-18 23:52:17', null);
INSERT INTO `sa_system_role` VALUES ('204', '0', '集团CEO', 'JTCEO', '1', '1', '222CEO', '100', '2', '1', '1', '1', '2026-04-24 21:46:40', '2026-06-21 19:23:15', null);

-- ----------------------------
-- Table structure for `sa_system_role_dept`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_role_dept`;
CREATE TABLE `sa_system_role_dept` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) unsigned NOT NULL,
  `dept_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色部门关联表';

-- ----------------------------
-- Records of sa_system_role_dept
-- ----------------------------
INSERT INTO `sa_system_role_dept` VALUES ('1', '6', '10');
INSERT INTO `sa_system_role_dept` VALUES ('2', '6', '2');
INSERT INTO `sa_system_role_dept` VALUES ('3', '8', '2');
INSERT INTO `sa_system_role_dept` VALUES ('4', '8', '5');

-- ----------------------------
-- Table structure for `sa_system_role_menu`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_role_menu`;
CREATE TABLE `sa_system_role_menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) unsigned NOT NULL,
  `menu_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1091 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='角色菜单关联表';

-- ----------------------------
-- Records of sa_system_role_menu
-- ----------------------------
INSERT INTO `sa_system_role_menu` VALUES ('322', '3', '1');
INSERT INTO `sa_system_role_menu` VALUES ('323', '3', '2');
INSERT INTO `sa_system_role_menu` VALUES ('324', '3', '74');
INSERT INTO `sa_system_role_menu` VALUES ('325', '3', '21');
INSERT INTO `sa_system_role_menu` VALUES ('326', '3', '93');
INSERT INTO `sa_system_role_menu` VALUES ('327', '3', '94');
INSERT INTO `sa_system_role_menu` VALUES ('402', '204', '10');
INSERT INTO `sa_system_role_menu` VALUES ('403', '204', '15');
INSERT INTO `sa_system_role_menu` VALUES ('404', '204', '64');
INSERT INTO `sa_system_role_menu` VALUES ('405', '204', '65');
INSERT INTO `sa_system_role_menu` VALUES ('406', '204', '16');
INSERT INTO `sa_system_role_menu` VALUES ('407', '204', '66');
INSERT INTO `sa_system_role_menu` VALUES ('408', '204', '67');
INSERT INTO `sa_system_role_menu` VALUES ('409', '204', '17');
INSERT INTO `sa_system_role_menu` VALUES ('410', '204', '68');
INSERT INTO `sa_system_role_menu` VALUES ('411', '204', '69');
INSERT INTO `sa_system_role_menu` VALUES ('412', '204', '11');
INSERT INTO `sa_system_role_menu` VALUES ('413', '204', '72');
INSERT INTO `sa_system_role_menu` VALUES ('414', '204', '73');
INSERT INTO `sa_system_role_menu` VALUES ('415', '204', '70');
INSERT INTO `sa_system_role_menu` VALUES ('416', '204', '71');
INSERT INTO `sa_system_role_menu` VALUES ('417', '204', '12');
INSERT INTO `sa_system_role_menu` VALUES ('418', '204', '56');
INSERT INTO `sa_system_role_menu` VALUES ('419', '204', '57');
INSERT INTO `sa_system_role_menu` VALUES ('420', '204', '13');
INSERT INTO `sa_system_role_menu` VALUES ('421', '204', '58');
INSERT INTO `sa_system_role_menu` VALUES ('422', '204', '59');
INSERT INTO `sa_system_role_menu` VALUES ('423', '204', '14');
INSERT INTO `sa_system_role_menu` VALUES ('424', '204', '60');
INSERT INTO `sa_system_role_menu` VALUES ('425', '204', '61');
INSERT INTO `sa_system_role_menu` VALUES ('426', '204', '62');
INSERT INTO `sa_system_role_menu` VALUES ('427', '204', '63');
INSERT INTO `sa_system_role_menu` VALUES ('428', '204', '104');
INSERT INTO `sa_system_role_menu` VALUES ('429', '204', '105');
INSERT INTO `sa_system_role_menu` VALUES ('430', '204', '106');
INSERT INTO `sa_system_role_menu` VALUES ('431', '6', '105');
INSERT INTO `sa_system_role_menu` VALUES ('432', '6', '106');
INSERT INTO `sa_system_role_menu` VALUES ('503', '204', '1');
INSERT INTO `sa_system_role_menu` VALUES ('504', '204', '2');
INSERT INTO `sa_system_role_menu` VALUES ('505', '204', '74');
INSERT INTO `sa_system_role_menu` VALUES ('506', '204', '21');
INSERT INTO `sa_system_role_menu` VALUES ('507', '204', '93');
INSERT INTO `sa_system_role_menu` VALUES ('508', '204', '94');
INSERT INTO `sa_system_role_menu` VALUES ('509', '204', '80');
INSERT INTO `sa_system_role_menu` VALUES ('510', '204', '81');
INSERT INTO `sa_system_role_menu` VALUES ('511', '204', '86');
INSERT INTO `sa_system_role_menu` VALUES ('512', '204', '87');
INSERT INTO `sa_system_role_menu` VALUES ('513', '204', '82');
INSERT INTO `sa_system_role_menu` VALUES ('514', '204', '83');
INSERT INTO `sa_system_role_menu` VALUES ('515', '204', '84');
INSERT INTO `sa_system_role_menu` VALUES ('516', '204', '85');
INSERT INTO `sa_system_role_menu` VALUES ('517', '204', '105');
INSERT INTO `sa_system_role_menu` VALUES ('518', '204', '106');
INSERT INTO `sa_system_role_menu` VALUES ('871', '8', '21');
INSERT INTO `sa_system_role_menu` VALUES ('872', '8', '1');
INSERT INTO `sa_system_role_menu` VALUES ('873', '8', '2');
INSERT INTO `sa_system_role_menu` VALUES ('1051', '2', '8');
INSERT INTO `sa_system_role_menu` VALUES ('1052', '2', '48');
INSERT INTO `sa_system_role_menu` VALUES ('1053', '2', '50');
INSERT INTO `sa_system_role_menu` VALUES ('1054', '2', '93');
INSERT INTO `sa_system_role_menu` VALUES ('1055', '2', '3');
INSERT INTO `sa_system_role_menu` VALUES ('1056', '2', '35');
INSERT INTO `sa_system_role_menu` VALUES ('1057', '2', '39');
INSERT INTO `sa_system_role_menu` VALUES ('1058', '2', '55');
INSERT INTO `sa_system_role_menu` VALUES ('1059', '2', '98');
INSERT INTO `sa_system_role_menu` VALUES ('1060', '2', '99');
INSERT INTO `sa_system_role_menu` VALUES ('1061', '2', '100');
INSERT INTO `sa_system_role_menu` VALUES ('1062', '2', '47');
INSERT INTO `sa_system_role_menu` VALUES ('1063', '2', '52');
INSERT INTO `sa_system_role_menu` VALUES ('1064', '2', '101');
INSERT INTO `sa_system_role_menu` VALUES ('1065', '2', '102');
INSERT INTO `sa_system_role_menu` VALUES ('1066', '2', '103');
INSERT INTO `sa_system_role_menu` VALUES ('1067', '2', '1');
INSERT INTO `sa_system_role_menu` VALUES ('1068', '2', '21');
INSERT INTO `sa_system_role_menu` VALUES ('1069', '2', '41');
INSERT INTO `sa_system_role_menu` VALUES ('1070', '2', '44');
INSERT INTO `sa_system_role_menu` VALUES ('1071', '2', '45');
INSERT INTO `sa_system_role_menu` VALUES ('1072', '2', '18');
INSERT INTO `sa_system_role_menu` VALUES ('1073', '2', '53');
INSERT INTO `sa_system_role_menu` VALUES ('1074', '2', '36');
INSERT INTO `sa_system_role_menu` VALUES ('1075', '2', '38');
INSERT INTO `sa_system_role_menu` VALUES ('1076', '2', '42');
INSERT INTO `sa_system_role_menu` VALUES ('1077', '2', '54');
INSERT INTO `sa_system_role_menu` VALUES ('1078', '2', '94');
INSERT INTO `sa_system_role_menu` VALUES ('1079', '2', '46');
INSERT INTO `sa_system_role_menu` VALUES ('1080', '2', '49');
INSERT INTO `sa_system_role_menu` VALUES ('1081', '2', '2');
INSERT INTO `sa_system_role_menu` VALUES ('1082', '2', '183');
INSERT INTO `sa_system_role_menu` VALUES ('1083', '2', '6');
INSERT INTO `sa_system_role_menu` VALUES ('1084', '2', '7');
INSERT INTO `sa_system_role_menu` VALUES ('1085', '2', '74');
INSERT INTO `sa_system_role_menu` VALUES ('1086', '2', '37');
INSERT INTO `sa_system_role_menu` VALUES ('1087', '2', '43');
INSERT INTO `sa_system_role_menu` VALUES ('1088', '2', '51');
INSERT INTO `sa_system_role_menu` VALUES ('1089', '2', '173');
INSERT INTO `sa_system_role_menu` VALUES ('1090', '2', '34');

-- ----------------------------
-- Table structure for `sa_system_tenant`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_tenant`;
CREATE TABLE `sa_system_tenant` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '租户ID',
  `tenant_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户名称',
  `tenant_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户编码（唯一）',
  `contact_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系人电话',
  `contact_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系人邮箱',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '租户地址',
  `logo_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '租户Logo URL',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=启用',
  `expire_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `max_users` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大用户数，0=无限制',
  `max_depts` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大部门数，0=无限制',
  `max_roles` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大角色数，0=无限制',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户表';

-- ----------------------------
-- Records of sa_system_tenant
-- ----------------------------
INSERT INTO `sa_system_tenant` VALUES ('1', '租户1', 'Tenant1', '张三丰', '88888888', 'admin@qq.com', '测试地址', '', '1', null, '0', '0', '0', '', '0', '1', null, '2026-09-21 23:34:23', null);
INSERT INTO `sa_system_tenant` VALUES ('2', '租户2', '88888', null, null, null, null, null, '1', null, '0', '0', '0', null, '1', '100', '2026-04-06 22:21:00', '2026-04-22 22:34:31', null);
INSERT INTO `sa_system_tenant` VALUES ('3', '租户3', '8888', '', '', '', '', '', '1', null, '0', '0', '0', '', '1', '1', '2026-04-06 22:31:31', '2026-07-18 23:25:40', null);
INSERT INTO `sa_system_tenant` VALUES ('10', '单租户测试', 'tenant_10', null, null, null, null, null, '1', null, '0', '0', '0', null, '0', '0', '2026-04-24 12:40:17', '2026-04-24 12:40:17', null);

-- ----------------------------
-- Table structure for `sa_system_user`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user`;
CREATE TABLE `sa_system_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(64) NOT NULL COMMENT '用户账号',
  `password` varchar(255) NOT NULL COMMENT '用户登录密码',
  `realname` varchar(64) DEFAULT NULL COMMENT '用户昵称',
  `gender` varchar(10) DEFAULT '0' COMMENT '性别',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像地址',
  `email` varchar(128) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `signed` varchar(255) DEFAULT NULL COMMENT '个性签名',
  `dashboard` varchar(255) DEFAULT 'work' COMMENT '工作台',
  `dept_id` bigint(20) unsigned DEFAULT NULL COMMENT '主归属部门',
  `is_super` tinyint(1) DEFAULT '0' COMMENT '是否超级管理员: 1是(跳过权限检查), 0否',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 1启用, 0禁用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `login_time` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `login_ip` varchar(45) DEFAULT NULL COMMENT '最后登录IP',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `delete_time` datetime(6) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDX_ac6e674d8be83ea453e356bd78` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户信息表';

-- ----------------------------
-- Records of sa_system_user
-- ----------------------------
INSERT INTO `sa_system_user` VALUES ('1', 'admin', '$2y$10$wnixh48uDnaW/6D9EygDd.OHJK0vQY/4nHaTjMKBCVDBP2NiTatqS', '冷月如霜', '1', 'https://img1.ali213.net/glpic/2025/02/05/584_2025020554520608.png', 'fssphp@admin.com', '15888888888', 'FSSADMIN是兼具设计美学与高效开发的后台系统!11', 'statistics', '1', '1', '1', null, '2026-10-13 21:25:27', '127.0.0.1', '1', '1', '2026-01-01 00:00:00.000000', '2026-10-13 21:25:27.286737', null);
INSERT INTO `sa_system_user` VALUES ('2', 'martin', '$2y$10$L3sEraye7Q8XPenbx5M8JOW6j9BP1B/E2Iox6o6mVYB1MjML942N2', '刘炽平', '1', 'https://static.wandongli.com/static/pc/images/png.png', 'martin1@163.com', '15888888888', null, 'work', '5', '0', '1', '', '2026-05-03 23:23:33', '127.0.0.1', '1', '1', '2026-01-01 00:00:00.000000', '2026-06-19 10:59:54.000000', null);
INSERT INTO `sa_system_user` VALUES ('3', 'allen', '$2y$10$H8d7riOjOiwPSopguEQ1fuKZz.fA0A54OvuzTqgJlbG1N3uOxEwM.', '张小龙', '1', 'https://static.wandongli.com/static/pc/images/png.png', '', '15888888888', null, 'work', '10', '0', '1', '', null, null, '1', '1', '2026-01-01 00:00:00.000000', '2026-03-21 23:24:03.000000', null);
INSERT INTO `sa_system_user` VALUES ('4', 'mark', '$2y$10$sY/4StKVV.N/8Ock8J8kdeIOK4jS4tAUoYjkzvB8Tzy0fLh.wA2KS', '任宇昕', '2', 'https://static.wandongli.com/static/pc/images/png.png', null, '15888888888', null, 'work', '11', '0', '1', null, null, null, '1', '1', '2026-01-01 00:00:00.000000', '2026-03-21 23:20:40.000000', null);
INSERT INTO `sa_system_user` VALUES ('5', 'dowson', '$2y$10$sY/4StKVV.N/8Ock8J8kdeIOK4jS4tAUoYjkzvB8Tzy0fLh.wA2KS', '汤道生', '1', 'https://static.wandongli.com/static/pc/images/png.png', null, '15888888888', null, 'work', '12', '0', '1', null, null, null, '1', '1', '2026-01-01 00:00:00.000000', '2026-01-01 00:00:00.000000', null);
INSERT INTO `sa_system_user` VALUES ('10', 'timi_boss', '$2y$10$a9S4v4i6ZpDEJQ1qgWsWnuifsq4dgGdVFZDearta9.mOz.IpcBWzK', '姚晓光', '1', 'https://static.wandongli.com/static/pc/images/png.png', '8888@qq.com', '15888888888', null, 'work', '111', '1', '1', '', '2026-05-15 07:51:18', '127.0.0.1', '1', '1', '2026-01-01 00:00:00.000000', '2026-06-21 21:13:06.000000', null);
INSERT INTO `sa_system_user` VALUES ('100', 'devwang', '$2y$10$vbnOKDkbm9hIEd8JWXITpO5pcRtl/KTBqswojEkuaP7vdGB5tPzES', '王程序员', '1', '', '888888@qq.com', '15888888888', null, 'work', '12', '0', '1', '1', '2026-09-28 23:42:13', '127.0.0.1', '1', '1', '2026-01-01 00:00:00.000000', '2026-09-28 23:42:12.988204', null);
INSERT INTO `sa_system_user` VALUES ('101', 'devli', '$2y$10$2fuWT7n6E8kyG357FbNrouRyRvulmTYXpmFE71bHOH3PQAgpPItW.', '李策划', '1', '/uploads/2026/03/28/69c7a3a67d5e50.12092222.png', null, '15888881234', null, 'work', '2', '0', '1', '1111', null, null, '1', '1', '2026-01-01 00:00:00.000000', '2026-03-28 17:50:57.000000', null);
INSERT INTO `sa_system_user` VALUES ('102', 'test', '$2y$10$wnixh48uDnaW/6D9EygDd.OHJK0vQY/4nHaTjMKBCVDBP2NiTatqS', 'admin1', '1', '', '', '13512344567', null, 'work', '2', '0', '1', '', null, null, null, null, '2026-03-22 21:42:54.000000', '2026-03-22 21:54:46.000000', '2026-03-22 21:54:46.000000');
INSERT INTO `sa_system_user` VALUES ('104', 'test2', '$2y$10$AQjV0REYZumtiT4sDpmKtODXLQtIL.9ralALUFKZGvrxKWcpHS9ii', 'test2', '2', 'http://127.0.0.1:8000/uploads/2026/03/28/69c7a3b2058589.44968839.webp', '', '', null, 'work', '2', '0', '1', '', '2026-04-22 22:07:17', '127.0.0.1', null, '1', '2026-03-22 21:58:24.000000', '2026-05-16 17:13:50.000000', null);
INSERT INTO `sa_system_user` VALUES ('105', 'test3', '$2y$10$LRECF.G/1CS14NMujqelpucMJ4kQX.OuLdk5D5DT3EjgS8.CnePHy', 'test3', '1', '/uploads/2026/03/28/69c7a3a9e6c335.87540530.png', '', '', null, 'work', '101', '0', '1', '1', null, null, null, '1', '2026-03-25 21:58:53.000000', '2026-03-28 17:50:39.000000', null);
INSERT INTO `sa_system_user` VALUES ('106', 'test3test3', '$2y$10$lDmHlmRsw/pPF4Yd/HcP7eE0xGpkqsNVVhC4TrAz31K7XckECcaQu', 'test3test3', '2', '/uploads/2026/03/28/69c7a3acd6b581.21163358.png', '', '', null, 'work', '102', '0', '1', '', null, null, null, '1', '2026-03-25 21:59:21.000000', '2026-03-28 17:50:29.000000', null);
INSERT INTO `sa_system_user` VALUES ('116', 'testtesttest', '$2y$10$0GmhEW3QFGv.pHltuKQIUuNKAaACDiDARMt3QLjRVZ0y.iolKIDyK', 'testtest', '1', '/uploads/2026/03/28/69c7a3b2058589.44968839.webp', '', '', null, 'work', '2', '0', '1', '', null, null, '1', '1', '2026-03-27 21:12:03.000000', '2026-03-28 17:49:22.000000', null);
INSERT INTO `sa_system_user` VALUES ('117', 'test1311', '$2y$10$wxvQ16EIyNTrarFQ3fM1Euvd1rzgeZPbEgMsRbpFdiWxC3pX9UOpW', '11231', '2', '', '', '', null, 'work', '2', '0', '1', '', null, null, '1', '1', '2026-03-27 21:29:06.000000', '2026-03-28 23:09:35.000000', '2026-03-28 23:09:35.000000');
INSERT INTO `sa_system_user` VALUES ('118', 'ddd', '$2y$10$GA/p/o7CH5FiJJxPGh6pDuAMhGNUoKYiSWBRhQwdB30aacnVwqC.W', 'ddd', '', '/uploads/2026/03/28/69c7a3b48aab47.53936592.png', '', '', null, 'statistics', '1', '0', '1', '', null, null, '1', '1', '2026-03-27 22:32:06.000000', '2026-03-28 19:07:29.000000', null);
INSERT INTO `sa_system_user` VALUES ('119', 'zhangsanfeng', '$2y$10$JH3nWeQNuRYPvmRH.Wouauaxme3pmcdjJFjdoJ0bZxI6oO2kJyLma', '张三丰', '1', '/uploads/2026/03/28/69c7a3acd6b581.21163358.png', '', '', null, 'work', null, '0', '1', '', null, null, '1', '1', '2026-05-05 18:02:28.000000', '2026-05-05 18:02:28.000000', null);
INSERT INTO `sa_system_user` VALUES ('120', 'qiaofeng', '$2y$10$0G0vZyI3r69vFZtlMfXjx.8fGuDM.5zaUAujf.DxetToTSPwRPNbK', '乔峰', '1', '/uploads/2026/03/28/69c7a3a83f9f14.20042528.png', '', '', null, 'work', null, '0', '1', '', null, null, '1', '1', '2026-05-05 18:04:51.000000', '2026-05-05 18:04:51.000000', null);
INSERT INTO `sa_system_user` VALUES ('121', 'yangguo', '$2y$10$0ruAFh29.cyxm6vTubHHcOP6xanbRTXp86nUZMyeA7Xp2M/1XLDri', '杨过', '1', '/uploads/2026/03/28/69c7a3a1cae578.20110121.png', '', '', null, 'work', null, '0', '1', '', null, null, '1', '1', '2026-05-05 18:06:55.000000', '2026-05-05 18:06:55.000000', null);
INSERT INTO `sa_system_user` VALUES ('122', 'xiaolongnv', '$2y$10$nKMfot7pTjwYguTFq.4bz.rLWGPKYRr/jBJms3uY4qzm9e6ClCZIC', '小龙女', '2', '', '', '', null, 'work', null, '0', '1', '', null, null, '1', '1', '2026-05-05 18:07:27.000000', '2026-05-07 23:37:58.000000', null);
INSERT INTO `sa_system_user` VALUES ('123', 'guojing11', '$2y$10$/CnyvA4nkw.Nx0SLTobdWOSgn1qOO6TEge6LELcz4sPNXc/.CyjvS', '郭靖', '1', '/uploads/2026/09/21/1790004203422_N67RXCuN.jpg', '', '18587', null, 'work', '5', '0', '1', '11111444', null, null, '1', '1', '2026-05-05 18:08:14.000000', '2026-09-28 23:53:13.236415', null);

-- ----------------------------
-- Table structure for `sa_system_user_dept`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user_dept`;
CREATE TABLE `sa_system_user_dept` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `tenant_id` bigint(20) unsigned NOT NULL COMMENT '租户ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `dept_id` bigint(20) unsigned NOT NULL COMMENT '部门ID',
  `created_by` bigint(20) unsigned DEFAULT NULL COMMENT '创建人ID',
  `updated_by` bigint(20) unsigned DEFAULT NULL COMMENT '更新人ID',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `delete_time` datetime(6) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='用户部门关联表';

-- ----------------------------
-- Records of sa_system_user_dept
-- ----------------------------
INSERT INTO `sa_system_user_dept` VALUES ('5', '2', '100', '129', '1', '1', null, '2026-04-24 21:47:04', null);
INSERT INTO `sa_system_user_dept` VALUES ('6', '1', '100', '12', '1', '1', '2026-04-24 21:52:00', '2026-04-24 21:52:24', null);
INSERT INTO `sa_system_user_dept` VALUES ('7', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `sa_system_user_dept` VALUES ('8', '1', '10', '1', '1', '1', '2026-04-25 09:26:06', '2026-04-25 09:26:06', null);
INSERT INTO `sa_system_user_dept` VALUES ('9', '1', '119', '5', '1', '1', '2026-05-05 18:02:28', '2026-05-05 18:02:28', null);
INSERT INTO `sa_system_user_dept` VALUES ('10', '1', '120', '2', '1', '1', '2026-05-05 18:04:51', '2026-05-05 18:04:51', null);
INSERT INTO `sa_system_user_dept` VALUES ('11', '1', '121', '101', '1', '1', '2026-05-05 18:06:55', '2026-05-05 18:06:55', null);
INSERT INTO `sa_system_user_dept` VALUES ('12', '1', '122', '102', '1', '1', '2026-05-05 18:07:27', '2026-05-05 18:07:27', null);
INSERT INTO `sa_system_user_dept` VALUES ('13', '1', '123', '5', '1', '1', '2026-05-05 18:08:14', '2026-09-28 23:53:13', null);
INSERT INTO `sa_system_user_dept` VALUES ('14', '1', '104', '12', '1', '1', '2026-05-16 17:13:51', '2026-05-16 17:13:51', null);

-- ----------------------------
-- Table structure for `sa_system_user_menu`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user_menu`;
CREATE TABLE `sa_system_user_menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `menu_id` bigint(20) unsigned NOT NULL COMMENT '菜单ID',
  `tenant_id` bigint(20) unsigned DEFAULT '0' COMMENT '租户ID',
  `created_by` bigint(20) unsigned DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) unsigned DEFAULT '0' COMMENT '更新人ID',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `is_show` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `is_create` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否新增',
  `is_update` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否修改',
  `is_delete` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_menu` (`user_id`,`menu_id`,`tenant_id`) USING BTREE,
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户菜单权限表';

-- ----------------------------
-- Records of sa_system_user_menu
-- ----------------------------
INSERT INTO `sa_system_user_menu` VALUES ('259', '100', '105', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('260', '100', '106', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('261', '100', '21', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('262', '100', '93', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('263', '100', '173', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('264', '100', '427', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('265', '100', '428', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('266', '100', '429', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('267', '100', '430', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('268', '100', '1', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('269', '100', '2', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('270', '100', '74', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('271', '100', '94', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('272', '100', '183', '1', '1', '1', '1', '2026-09-28 23:26:30', '2026-09-28 23:26:30', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('332', '123', '1', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('333', '123', '2', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('334', '123', '3', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('335', '123', '4', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('336', '123', '20', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('337', '123', '21', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('338', '123', '74', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('339', '123', '93', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');
INSERT INTO `sa_system_user_menu` VALUES ('340', '123', '94', '1', '1', '1', '1', '2026-09-28 23:53:25', '2026-09-28 23:53:25', null, '1', '1', '1', '1');

-- ----------------------------
-- Table structure for `sa_system_user_post`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user_post`;
CREATE TABLE `sa_system_user_post` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户主键',
  `post_id` bigint(20) unsigned NOT NULL COMMENT '岗位主键',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=启用',
  `created_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '租户上下文ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户岗位关联表';

-- ----------------------------
-- Records of sa_system_user_post
-- ----------------------------
INSERT INTO `sa_system_user_post` VALUES ('1', '1', '2', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('4', '1', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('32', '116', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('33', '106', '2', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('34', '105', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('36', '101', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('50', '100', '1', '1', '0', '0', null, null, '2026-09-28 23:26:42', '1');
INSERT INTO `sa_system_user_post` VALUES ('51', '104', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('53', '2', '2', '1', '1', '1', '2026-06-19 10:59:54', '2026-06-19 10:59:54', null, '1');
INSERT INTO `sa_system_user_post` VALUES ('54', '10', '1', '1', '0', '0', null, null, null, '1');
INSERT INTO `sa_system_user_post` VALUES ('55', '123', '1', '1', '1', '0', '2026-09-28 23:07:15', null, '2026-09-28 23:13:48', '1');
INSERT INTO `sa_system_user_post` VALUES ('56', '123', '1', '1', '1', '1', '2026-09-28 23:13:48', '2026-09-28 23:13:48', '2026-09-28 23:13:55', '1');
INSERT INTO `sa_system_user_post` VALUES ('57', '123', '1', '1', '1', '1', '2026-09-28 23:13:55', '2026-09-28 23:45:09', '2026-09-28 16:45:09', '1');
INSERT INTO `sa_system_user_post` VALUES ('58', '100', '1', '1', '1', '1', '2026-09-28 23:26:42', '2026-09-28 23:26:42', null, '1');
INSERT INTO `sa_system_user_post` VALUES ('59', '123', '1', '1', '1', '1', '2026-09-28 23:45:09', '2026-09-28 23:46:08', '2026-09-28 16:46:08', '1');
INSERT INTO `sa_system_user_post` VALUES ('60', '123', '1', '1', '1', '1', '2026-09-28 23:46:08', '2026-09-28 23:46:12', '2026-09-28 16:46:12', '1');
INSERT INTO `sa_system_user_post` VALUES ('61', '123', '1', '1', '1', '1', '2026-09-28 23:46:12', '2026-09-28 23:46:18', '2026-09-28 16:46:18', '1');
INSERT INTO `sa_system_user_post` VALUES ('62', '123', '2', '1', '1', '1', '2026-09-28 23:46:12', '2026-09-28 23:46:18', '2026-09-28 16:46:18', '1');
INSERT INTO `sa_system_user_post` VALUES ('63', '123', '1', '1', '1', '1', '2026-09-28 23:46:18', '2026-09-28 23:46:24', '2026-09-28 16:46:24', '1');
INSERT INTO `sa_system_user_post` VALUES ('64', '123', '1', '1', '1', '1', '2026-09-28 23:46:24', '2026-09-28 23:46:31', '2026-09-28 16:46:31', '1');
INSERT INTO `sa_system_user_post` VALUES ('65', '123', '1', '1', '1', '1', '2026-09-28 23:46:31', '2026-09-28 23:46:35', '2026-09-28 16:46:35', '1');
INSERT INTO `sa_system_user_post` VALUES ('66', '123', '1', '1', '1', '1', '2026-09-28 23:46:35', '2026-09-28 23:53:13', '2026-09-28 16:53:13', '1');
INSERT INTO `sa_system_user_post` VALUES ('67', '123', '1', '1', '1', '1', '2026-09-28 23:53:13', '2026-09-28 23:53:13', null, '1');

-- ----------------------------
-- Table structure for `sa_system_user_role`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user_role`;
CREATE TABLE `sa_system_user_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=启用',
  `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '租户上下文ID',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户角色关联表';

-- ----------------------------
-- Records of sa_system_user_role
-- ----------------------------
INSERT INTO `sa_system_user_role` VALUES ('1', '1', '1', '1', '1', null, null, null, null, null);
INSERT INTO `sa_system_user_role` VALUES ('12', '1', '2', '1', '1', null, null, null, null, null);
INSERT INTO `sa_system_user_role` VALUES ('43', '116', '8', '1', '1', '1', '1', '2026-03-28 17:49:22', '2026-03-28 17:49:22', null);
INSERT INTO `sa_system_user_role` VALUES ('44', '106', '4', '1', '1', '1', '1', '2026-03-28 17:50:29', '2026-03-28 17:50:29', null);
INSERT INTO `sa_system_user_role` VALUES ('45', '105', '2', '1', '1', '1', '1', '2026-03-28 17:50:39', '2026-03-28 17:50:39', null);
INSERT INTO `sa_system_user_role` VALUES ('47', '101', '2', '1', '1', '1', '1', '2026-03-28 17:50:57', '2026-03-28 17:50:57', null);
INSERT INTO `sa_system_user_role` VALUES ('63', '100', '204', '1', '2', '1', '1', '2026-04-24 21:47:04', '2026-04-24 21:47:04', null);
INSERT INTO `sa_system_user_role` VALUES ('73', '119', '2', '1', '1', '1', '1', '2026-05-05 18:02:28', '2026-05-05 18:02:28', null);
INSERT INTO `sa_system_user_role` VALUES ('74', '120', '3', '1', '1', '1', '1', '2026-05-05 18:04:51', '2026-05-05 18:04:51', null);
INSERT INTO `sa_system_user_role` VALUES ('75', '121', '4', '1', '1', '1', '1', '2026-05-05 18:06:55', '2026-05-05 18:06:55', null);
INSERT INTO `sa_system_user_role` VALUES ('79', '100', '2', '1', '1', '1', '1', '2026-05-07 23:30:43', '2026-05-07 23:30:43', '2026-09-28 23:26:42');
INSERT INTO `sa_system_user_role` VALUES ('81', '123', '2', '1', '1', '1', '1', '2026-05-07 23:37:46', '2026-08-28 21:56:32', '2026-08-28 21:56:32');
INSERT INTO `sa_system_user_role` VALUES ('82', '122', '3', '1', '1', '1', '1', '2026-05-07 23:37:58', '2026-05-07 23:37:58', null);
INSERT INTO `sa_system_user_role` VALUES ('83', '104', '2', '1', '1', '1', '1', '2026-05-16 17:13:50', '2026-05-16 17:13:50', null);
INSERT INTO `sa_system_user_role` VALUES ('85', '2', '2', '1', '1', '1', '1', '2026-06-19 10:59:54', '2026-06-19 10:59:54', null);
INSERT INTO `sa_system_user_role` VALUES ('86', '10', '6', '1', '1', null, null, null, null, null);
INSERT INTO `sa_system_user_role` VALUES ('87', '123', '2', '1', '1', '1', '1', '2026-08-28 21:56:32', '2026-08-28 21:58:20', '2026-08-28 21:58:20');
INSERT INTO `sa_system_user_role` VALUES ('88', '123', '2', '1', '1', '1', '1', '2026-08-28 21:58:20', '2026-08-28 22:12:22', '2026-08-28 22:12:22');
INSERT INTO `sa_system_user_role` VALUES ('89', '123', '2', '1', '1', '1', '1', '2026-08-28 22:12:22', '2026-08-28 22:12:38', '2026-08-28 22:12:38');
INSERT INTO `sa_system_user_role` VALUES ('90', '123', '2', '1', '1', '1', '1', '2026-08-28 22:12:38', '2026-08-28 22:12:38', '2026-09-21 23:23:32');
INSERT INTO `sa_system_user_role` VALUES ('91', '123', '2', '1', '1', '1', null, '2026-09-21 23:23:32', null, '2026-09-22 00:37:02');
INSERT INTO `sa_system_user_role` VALUES ('92', '123', '2', '1', '1', '1', null, '2026-09-22 00:37:02', null, '2026-09-28 23:05:41');
INSERT INTO `sa_system_user_role` VALUES ('93', '123', '2', '1', '1', '1', null, '2026-09-28 23:05:41', null, '2026-09-28 23:07:15');
INSERT INTO `sa_system_user_role` VALUES ('94', '123', '2', '1', '1', '1', null, '2026-09-28 23:07:15', null, '2026-09-28 23:13:48');
INSERT INTO `sa_system_user_role` VALUES ('95', '123', '2', '1', '1', '1', '1', '2026-09-28 23:13:48', '2026-09-28 23:13:48', '2026-09-28 23:13:55');
INSERT INTO `sa_system_user_role` VALUES ('96', '123', '3', '1', '1', '1', '1', '2026-09-28 23:13:55', '2026-09-28 23:45:09', '2026-09-28 16:45:09');
INSERT INTO `sa_system_user_role` VALUES ('97', '100', '2', '1', '1', '1', '1', '2026-09-28 23:26:42', '2026-09-28 23:26:42', null);
INSERT INTO `sa_system_user_role` VALUES ('98', '123', '3', '1', '1', '1', '1', '2026-09-28 23:45:09', '2026-09-28 23:46:08', '2026-09-28 16:46:08');
INSERT INTO `sa_system_user_role` VALUES ('99', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:08', '2026-09-28 23:46:12', '2026-09-28 16:46:12');
INSERT INTO `sa_system_user_role` VALUES ('100', '123', '2', '1', '1', '1', '1', '2026-09-28 23:46:08', '2026-09-28 23:46:12', '2026-09-28 16:46:12');
INSERT INTO `sa_system_user_role` VALUES ('101', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:12', '2026-09-28 23:46:18', '2026-09-28 16:46:18');
INSERT INTO `sa_system_user_role` VALUES ('102', '123', '2', '1', '1', '1', '1', '2026-09-28 23:46:12', '2026-09-28 23:46:18', '2026-09-28 16:46:18');
INSERT INTO `sa_system_user_role` VALUES ('103', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:18', '2026-09-28 23:46:24', '2026-09-28 16:46:24');
INSERT INTO `sa_system_user_role` VALUES ('104', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:24', '2026-09-28 23:46:31', '2026-09-28 16:46:31');
INSERT INTO `sa_system_user_role` VALUES ('105', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:31', '2026-09-28 23:46:35', '2026-09-28 16:46:35');
INSERT INTO `sa_system_user_role` VALUES ('106', '123', '3', '1', '1', '1', '1', '2026-09-28 23:46:35', '2026-09-28 23:53:13', '2026-09-28 16:53:13');
INSERT INTO `sa_system_user_role` VALUES ('107', '123', '3', '1', '1', '1', '1', '2026-09-28 23:53:13', '2026-09-28 23:53:13', null);

-- ----------------------------
-- Table structure for `sa_system_user_tenant`
-- ----------------------------
DROP TABLE IF EXISTS `sa_system_user_tenant`;
CREATE TABLE `sa_system_user_tenant` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `tenant_id` bigint(20) unsigned NOT NULL COMMENT '租户ID',
  `is_default` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否默认租户：0=否 1=是',
  `join_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `is_super` tinyint(4) NOT NULL DEFAULT '0' COMMENT '租户管理员',
  `created_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_tenant` (`user_id`,`tenant_id`),
  KEY `idx_tenant_user` (`tenant_id`,`user_id`),
  KEY `idx_user_default` (`user_id`,`is_default`),
  KEY `idx_join_time` (`join_time`),
  KEY `idx_is_super` (`is_super`),
  CONSTRAINT `sa_system_user_tenant_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `sa_system_tenant` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户-租户关联表';

-- ----------------------------
-- Records of sa_system_user_tenant
-- ----------------------------
INSERT INTO `sa_system_user_tenant` VALUES ('1', '1', '1', '1', '2026-03-21 02:38:46', '0', '0', '0', null, '2026-08-31 22:03:31', null);
INSERT INTO `sa_system_user_tenant` VALUES ('5', '106', '1', '0', '2026-03-25 21:59:21', '0', '1', '1', '2026-03-25 21:59:21', '2026-04-19 00:12:53', null);
INSERT INTO `sa_system_user_tenant` VALUES ('6', '116', '1', '0', '2026-03-27 21:12:03', '0', '1', '1', '2026-03-27 21:12:03', '2026-04-19 00:12:51', null);
INSERT INTO `sa_system_user_tenant` VALUES ('9', '3', '3', '0', '2026-04-06 22:31:46', '0', '1', '1', '2026-04-06 22:31:46', '2026-04-06 22:31:46', null);
INSERT INTO `sa_system_user_tenant` VALUES ('10', '100', '1', '0', '2026-04-18 23:27:30', '1', '1', '1', '2026-04-18 23:27:30', '2026-08-31 22:02:52', null);
INSERT INTO `sa_system_user_tenant` VALUES ('11', '100', '2', '1', '2026-04-22 22:11:29', '1', '1', '1', '2026-04-22 22:11:29', '2026-08-31 22:02:52', null);
INSERT INTO `sa_system_user_tenant` VALUES ('12', '1', '2', '0', '2026-04-23 23:37:22', '0', '1', '1', '2026-04-23 23:37:22', '2026-08-23 21:38:45', null);
INSERT INTO `sa_system_user_tenant` VALUES ('14', '10', '1', '1', '2026-04-25 09:23:56', '0', '1', '1', '2026-04-25 09:23:56', '2026-05-15 07:51:40', null);
INSERT INTO `sa_system_user_tenant` VALUES ('15', '10', '2', '0', '2026-04-25 09:24:22', '0', '1', '1', '2026-04-25 09:24:22', '2026-05-15 07:51:40', null);
INSERT INTO `sa_system_user_tenant` VALUES ('16', '2', '1', '0', '2026-05-03 23:21:43', '0', '0', '0', null, '2026-05-21 01:01:49', null);
INSERT INTO `sa_system_user_tenant` VALUES ('17', '119', '1', '1', '2026-05-05 18:02:28', '0', '1', '1', '2026-05-05 18:02:28', '2026-05-05 18:02:28', null);
INSERT INTO `sa_system_user_tenant` VALUES ('18', '120', '1', '1', '2026-05-05 18:04:51', '0', '1', '1', '2026-05-05 18:04:51', '2026-05-05 18:04:51', null);
INSERT INTO `sa_system_user_tenant` VALUES ('19', '121', '1', '1', '2026-05-05 18:06:55', '0', '1', '1', '2026-05-05 18:06:55', '2026-05-05 18:06:55', null);
INSERT INTO `sa_system_user_tenant` VALUES ('20', '122', '1', '1', '2026-05-05 18:07:27', '0', '1', '1', '2026-05-05 18:07:27', '2026-05-05 18:07:27', null);
INSERT INTO `sa_system_user_tenant` VALUES ('21', '123', '1', '1', '2026-05-05 18:08:14', '0', '1', '1', '2026-05-05 18:08:14', '2026-05-21 01:01:22', null);
INSERT INTO `sa_system_user_tenant` VALUES ('22', '4', '1', '1', '2026-05-21 01:01:59', '0', '1', '1', '2026-05-21 01:01:59', '2026-05-21 01:01:59', null);
INSERT INTO `sa_system_user_tenant` VALUES ('23', '124', '1', '1', '2026-05-28 22:05:22', '0', '1', '1', '2026-05-28 22:05:22', '2026-05-28 22:05:22', null);
INSERT INTO `sa_system_user_tenant` VALUES ('24', '118', '1', '1', '2026-05-28 22:42:36', '0', '1', '1', '2026-05-28 22:42:36', '2026-05-28 22:43:41', null);
INSERT INTO `sa_system_user_tenant` VALUES ('25', '125', '1', '1', '2026-06-07 18:37:23', '0', '1', '1', '2026-06-07 18:37:23', '2026-07-16 00:35:21', null);
INSERT INTO `sa_system_user_tenant` VALUES ('26', '126', '1', '1', '2026-06-07 18:38:04', '0', '1', '1', '2026-06-07 18:38:04', '2026-06-07 18:38:04', null);
INSERT INTO `sa_system_user_tenant` VALUES ('27', '127', '1', '1', '2026-09-01 23:53:26', '0', '127', '127', '2026-09-01 23:53:26', '2026-09-01 23:53:26', null);
INSERT INTO `sa_system_user_tenant` VALUES ('28', '128', '1', '1', '2026-09-02 00:30:35', '0', '128', '128', '2026-09-02 00:30:35', '2026-09-02 00:30:35', null);

-- ----------------------------
-- Table structure for `sa_tool_crontab`
-- ----------------------------
DROP TABLE IF EXISTS `sa_tool_crontab`;
CREATE TABLE `sa_tool_crontab` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) DEFAULT NULL COMMENT '任务名称',
  `type` smallint(6) DEFAULT '1' COMMENT '任务类型',
  `target` varchar(500) DEFAULT NULL COMMENT '调用任务字符串',
  `parameter` varchar(1000) DEFAULT NULL COMMENT '调用任务参数',
  `task_style` tinyint(1) DEFAULT NULL COMMENT '执行类型',
  `rule` varchar(32) DEFAULT NULL COMMENT '任务执行表达式',
  `singleton` smallint(6) DEFAULT '1' COMMENT '是否单次执行',
  `status` smallint(6) DEFAULT '1' COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='定时任务信息表';

-- ----------------------------
-- Records of sa_tool_crontab
-- ----------------------------

-- ----------------------------
-- Table structure for `sa_tool_crontab_log`
-- ----------------------------
DROP TABLE IF EXISTS `sa_tool_crontab_log`;
CREATE TABLE `sa_tool_crontab_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `crontab_id` int(11) unsigned DEFAULT NULL COMMENT '任务ID',
  `name` varchar(255) DEFAULT NULL COMMENT '任务名称',
  `target` varchar(500) DEFAULT NULL COMMENT '任务调用目标字符串',
  `parameter` varchar(1000) DEFAULT NULL COMMENT '任务调用参数',
  `exception_info` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  `status` smallint(6) DEFAULT '1' COMMENT '执行状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='定时任务执行日志表';

-- ----------------------------
-- Records of sa_tool_crontab_log
-- ----------------------------

-- ----------------------------
-- Table structure for `sa_tool_generate_columns`
-- ----------------------------
DROP TABLE IF EXISTS `sa_tool_generate_columns`;
CREATE TABLE `sa_tool_generate_columns` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_id` int(11) unsigned DEFAULT NULL COMMENT '所属表ID',
  `column_name` varchar(200) DEFAULT NULL COMMENT '字段名称',
  `column_comment` varchar(255) DEFAULT NULL COMMENT '字段注释',
  `column_type` varchar(50) DEFAULT NULL COMMENT '字段类型',
  `is_pk` smallint(6) DEFAULT '1' COMMENT '1 非主键 2 主键',
  `is_required` smallint(6) DEFAULT '1' COMMENT '1 非必填 2 必填',
  `is_insert` smallint(6) DEFAULT '1' COMMENT '1 非插入字段 2 插入字段',
  `is_edit` smallint(6) DEFAULT '1' COMMENT '1 非编辑字段 2 编辑字段',
  `is_list` smallint(6) DEFAULT '1' COMMENT '1 非列表显示字段 2 列表显示字段',
  `is_query` smallint(6) DEFAULT '1' COMMENT '1 非查询字段 2 查询字段',
  `query_type` varchar(100) DEFAULT 'eq' COMMENT '查询方式 eq 等于, neq 不等于, gt 大于, lt 小于, like 范围',
  `dict_type` varchar(200) DEFAULT NULL COMMENT '字典类型',
  `sort` tinyint(3) unsigned DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `java_type` varchar(500) NOT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) NOT NULL COMMENT 'JAVA字段名',
  `is_increment` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否自增（1是）',
  `html_type` varchar(200) NOT NULL DEFAULT '' COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `column_default` varchar(200) DEFAULT NULL COMMENT '默认值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';

-- ----------------------------
-- Records of sa_tool_generate_columns
-- ----------------------------
INSERT INTO `sa_tool_generate_columns` VALUES ('409', '2', 'id', '??', 'int(10)', '2', '1', '1', '1', '2', '1', 'eq', null, '0', null, '1', '1', '2026-03-30 23:20:55', '2026-06-19 20:30:44', null, 'String', 'id', '0', 'input', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('410', '2', 'category_id', '分类id', 'int(10)', '1', '1', '2', '2', '2', '1', 'eq', null, '1', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('411', '2', 'title', '文章标题', 'varchar(255)', '1', '1', '2', '2', '2', '1', 'eq', null, '2', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('412', '2', 'author', '文章作者', 'varchar(255)', '1', '1', '2', '2', '2', '1', 'eq', null, '3', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('413', '2', 'image', '文章图片', 'varchar(1000)', '1', '1', '2', '2', '2', '1', 'eq', null, '4', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('414', '2', 'describe', '文章简介', 'varchar(1000)', '1', '1', '2', '2', '2', '1', 'eq', null, '5', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('415', '2', 'content', '文章内容', 'text', '1', '1', '2', '2', '2', '1', 'eq', null, '6', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('416', '2', 'views', '浏览次数', 'int(11)', '1', '1', '2', '2', '2', '1', 'eq', null, '7', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('417', '2', 'sort', '排序', 'int(10) unsigned', '1', '1', '2', '2', '2', '1', 'eq', null, '8', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('418', '2', 'status', '状态', 'tinyint(1) unsigned', '1', '1', '2', '2', '2', '1', 'eq', null, '9', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('419', '2', 'is_link', '是否外链', 'tinyint(1)', '1', '1', '2', '2', '2', '1', 'eq', null, '10', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('420', '2', 'link_url', '链接地址', 'varchar(255)', '1', '1', '2', '2', '2', '1', 'eq', null, '11', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('421', '2', 'is_hot', '是否热门', 'tinyint(1) unsigned', '1', '1', '2', '2', '2', '1', 'eq', null, '12', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('422', '2', 'created_by', '创建者', 'int(11)', '1', '1', '1', '1', '1', '1', 'eq', null, '13', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('423', '2', 'updated_by', '更新者', 'int(11)', '1', '1', '1', '1', '1', '1', 'eq', null, '14', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('424', '2', 'create_time', '创建时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '15', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('425', '2', 'update_time', '修改时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '16', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('426', '2', 'delete_time', '删除时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '17', null, '1', '1', '2026-03-30 23:20:55', '2026-03-30 23:20:59', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('451', '3', 'id', '编号', 'int(11) unsigned', '2', '1', '1', '1', '2', '1', 'eq', null, '0', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'Number', 'id', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('452', '3', 'parent_id', '父级ID', 'int(11)', '1', '1', '2', '2', '2', '2', 'eq', null, '1', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'Number', 'parentId', '0', 'textarea', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('453', '3', 'category_name', '分类标题', 'varchar(255)', '1', '1', '2', '2', '2', '2', 'like', null, '2', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'String', 'categoryName', '0', 'textarea', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('454', '3', 'describe', '分类简介', 'varchar(255)', '1', '1', '2', '2', '2', '1', 'eq', null, '3', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'String', 'describe', '0', 'textarea', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('455', '3', 'image', '分类图片', 'varchar(255)', '1', '1', '2', '2', '2', '1', 'eq', null, '4', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'String', 'image', '0', 'imageUpload', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('456', '3', 'sort', '排序', 'int(10) unsigned', '1', '1', '2', '2', '2', '1', 'eq', null, '5', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'Number', 'sort', '0', 'textarea', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('457', '3', 'status', '状态', 'tinyint(1) unsigned', '1', '1', '2', '2', '2', '1', 'eq', 'data_status', '6', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, 'Number', '', '0', 'radio', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('458', '3', 'created_by', '创建者', 'int(11)', '1', '1', '1', '1', '1', '1', 'eq', null, '7', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('459', '3', 'updated_by', '更新者', 'int(11)', '1', '1', '1', '1', '1', '1', 'eq', null, '8', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('460', '3', 'create_time', '创建时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '9', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('461', '3', 'update_time', '修改时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '10', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, '', '', '0', '', null);
INSERT INTO `sa_tool_generate_columns` VALUES ('462', '3', 'delete_time', '删除时间', 'datetime', '1', '1', '1', '1', '1', '1', 'eq', null, '11', null, '1', '1', '2026-03-30 23:39:05', '2026-06-19 18:23:13', null, '', '', '0', '', null);

-- ----------------------------
-- Table structure for `sa_tool_generate_tables`
-- ----------------------------
DROP TABLE IF EXISTS `sa_tool_generate_tables`;
CREATE TABLE `sa_tool_generate_tables` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(200) DEFAULT NULL COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT NULL COMMENT '表注释',
  `package_name` varchar(100) DEFAULT NULL COMMENT '控制器包名',
  `business_name` varchar(50) DEFAULT NULL COMMENT '业务名称',
  `class_name` varchar(50) DEFAULT NULL COMMENT '类名称',
  `tpl_category` varchar(100) DEFAULT NULL COMMENT '生成类型,single 单表CRUD,tree 树表CRUD,parent_sub父子表CRUD',
  `options` varchar(1500) DEFAULT NULL COMMENT '其他业务选项',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` int(11) DEFAULT NULL COMMENT '创建者',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `tpl_web_type` varchar(30) NOT NULL DEFAULT 'element-plus' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `module_name` varchar(30) NOT NULL COMMENT '生成模块名',
  `function_name` varchar(50) NOT NULL COMMENT '生成功能名',
  `function_author` varchar(50) NOT NULL COMMENT '生成功能作者',
  `gen_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) NOT NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';

-- ----------------------------
-- Records of sa_tool_generate_tables
-- ----------------------------
INSERT INTO `sa_tool_generate_tables` VALUES ('2', 'sa_article', '文章表', 'Article', 'article', 'Article', 'single', '{\"relations\":[],\"tree_id\":\"id\",\"tree_name\":\"category_name\",\"tree_parent_id\":\"category_id\"}', '', '1', '1', '2026-03-30 00:36:12', '2026-06-19 20:30:44', null, null, null, 'element-plus', '', '', 'FssAdminTest', '0', '/');
INSERT INTO `sa_tool_generate_tables` VALUES ('3', 'sa_article_category', '文章分类表', 'ArticleCategory', 'articleCategory', 'ArticleCategory', 'tree', '{\"relations\":[],\"tree_id\":\"id\",\"tree_parent_id\":\"category_id\",\"tree_name\":\"category_name\"}', '', '1', '1', '2026-03-30 22:33:53', '2026-06-19 18:23:13', null, null, null, 'element-plus', 'Category', '分类模块', 'FssAdmin', '0', '/');

-- ----------------------------
-- Table structure for `task_job`
-- ----------------------------
DROP TABLE IF EXISTS `task_job`;
CREATE TABLE `task_job` (
  `job_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务ID',
  `job_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `trigger_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '触发方式: cron/interval/date/manual',
  `next_run_time` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '下次执行时间',
  `job_state` text COLLATE utf8mb4_unicode_ci COMMENT '任务状态信息',
  `result` text COLLATE utf8mb4_unicode_ci COMMENT '执行结果',
  `error` text COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `status` int(11) NOT NULL COMMENT '执行状态(0:待执行 1:执行中 2:成功 3:失败 4:超时 5:已取消)',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `uuid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'UUID全局唯一标识',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `tenant_id` int(11) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1518 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务执行日志表';

-- ----------------------------
-- Records of task_job
-- ----------------------------
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'manual', null, null, null, null, '1', null, '11', '4fc8d338-e29d-4430-b21f-66275dbba0ed', '2026-07-18 22:34:11', '2026-07-18 22:34:11', null, '1');
INSERT INTO `task_job` VALUES ('1', '演示任务', 'manual', null, null, null, null, '1', null, '12', '9224eaba-3640-4c25-b58c-849c6dfc9f58', '2026-07-18 22:34:37', '2026-07-18 22:34:37', null, '1');
INSERT INTO `task_job` VALUES ('4', '邮件批量发送', 'manual', null, null, null, null, '1', null, '13', '79df3b8c-b4c4-435b-b2f9-11bdc15e9fda', '2026-07-18 22:36:31', '2026-07-18 22:36:31', null, '1');
INSERT INTO `task_job` VALUES ('system_clean_expired', '过期租户归档清理(立即执行)', 'manual', '2026-08-01 02:00:00+08:00', '{\n  \"version\": 1,\n  \"id\": \"system_clean_expired\",\n  \"func\": \"app.api.v1.module_platform.tenant.service:TenantService.clean_expired_tenants\",\n  \"trigger\": \"cron[day=\'1\', hour=\'2\', minute=\'0\']\",\n  \"executor\": \"default\",\n  \"args\": [],\n  \"kwargs\": {},\n  \"name\": \"过期租户归档清理\",\n  \"misfire_grace_time\": 1,\n  \"coalesce\": true,\n  \"max_instances\": 5,\n  \"next_run_time\": \"2026-08-01 02:00:00+08:00\"\n}', null, null, '1', null, '42', 'fbfb9267-9901-437d-a168-082263452c9b', '2026-07-18 22:41:12', '2026-07-18 22:41:12', null, '1');
INSERT INTO `task_job` VALUES ('system_clean_expired', '过期租户归档清理(立即执行)', 'manual', '2026-08-01 02:00:00+08:00', '{\n  \"version\": 1,\n  \"id\": \"system_clean_expired\",\n  \"func\": \"app.api.v1.module_platform.tenant.service:TenantService.clean_expired_tenants\",\n  \"trigger\": \"cron[day=\'1\', hour=\'2\', minute=\'0\']\",\n  \"executor\": \"default\",\n  \"args\": [],\n  \"kwargs\": {},\n  \"name\": \"过期租户归档清理\",\n  \"misfire_grace_time\": 1,\n  \"coalesce\": true,\n  \"max_instances\": 5,\n  \"next_run_time\": \"2026-08-01 02:00:00+08:00\"\n}', null, null, '1', null, '43', '4a179510-fb70-48d4-9135-3c37523d0d04', '2026-07-18 22:41:12', '2026-07-18 22:41:12', null, '1');
INSERT INTO `task_job` VALUES ('system_cleanup_operation_log', '操作日志清理(立即执行)', 'manual', '2026-07-19 03:00:00+08:00', '{\n  \"version\": 1,\n  \"id\": \"system_cleanup_operation_log\",\n  \"func\": \"app.core.ap_scheduler:cleanup_operation_log\",\n  \"trigger\": \"cron[day_of_week=\'sun\', hour=\'3\', minute=\'0\']\",\n  \"executor\": \"default\",\n  \"args\": [],\n  \"kwargs\": {},\n  \"name\": \"操作日志清理\",\n  \"misfire_grace_time\": 1,\n  \"coalesce\": true,\n  \"max_instances\": 5,\n  \"next_run_time\": \"2026-07-19 03:00:00+08:00\"\n}', null, null, '1', null, '49', 'f380f4c0-7335-4190-90a0-271ecc189d38', '2026-07-18 22:42:31', '2026-07-18 22:42:31', null, '1');
INSERT INTO `task_job` VALUES ('1', '演示任务', 'manual', null, null, null, null, '1', null, '50', 'df50be74-1cdb-4d38-9c9f-0b923b797cfa', '2026-07-18 22:42:36', '2026-07-18 22:42:36', null, '1');
INSERT INTO `task_job` VALUES ('4', '邮件批量发送', 'manual', null, null, '{\'status\': \'success\', \'sent_count\': 0, \'failed_count\': 0, \'batch_size\': 50}', null, '2', null, '57', '523a9b5f-d36b-4cb7-8546-a4f6e1b153a6', '2026-07-18 22:47:43', '2026-07-18 22:47:43', null, '1');
INSERT INTO `task_job` VALUES ('10', '数据库还原', 'manual', '2026-09-28 23:58:58', '{\"args\":[],\"duration_ms\":13878,\"error\":\"第 395 条 SQL 失败：Error 1136 (21S01): Column count doesn\'t match value count at row 1\",\"finished_at\":\"2026-09-28 22:58:58\",\"handler\":\"database_restore\",\"kwargs\":{\"file\":\"static/restore/init.sql\",\"flush_redis\":true},\"next_run_time\":\"2026-09-28 23:58:58\",\"node\":{\"code\":\"database_restore\",\"id\":10,\"name\":\"数据库还原\"},\"pattern\":\"\",\"result\":\"null\",\"started_at\":\"2026-09-28 22:58:44\",\"trigger\":\"manual\",\"version\":2}', 'null', '第 395 条 SQL 失败：Error 1136 (21S01): Column count doesn\'t match value count at row 1', '3', null, '1472', 'v9b2l902g40dlr1e4u0nzy8500zs37hz', '2026-09-28 22:58:45', '2026-09-28 22:58:59', null, '1');
INSERT INTO `task_job` VALUES ('10', '数据库还原', 'manual', '2026-09-28 23:59:19', '{\"args\":[],\"duration_ms\":12878,\"error\":\"第 395 条 SQL 失败：Error 1136 (21S01): Column count doesn\'t match value count at row 1\",\"finished_at\":\"2026-09-28 22:59:19\",\"handler\":\"database_restore\",\"kwargs\":{\"file\":\"static/restore/init.sql\",\"flush_redis\":true},\"next_run_time\":\"2026-09-28 23:59:19\",\"node\":{\"code\":\"database_restore\",\"id\":10,\"name\":\"数据库还原\"},\"pattern\":\"\",\"result\":\"null\",\"started_at\":\"2026-09-28 22:59:06\",\"trigger\":\"manual\",\"version\":2}', 'null', '第 395 条 SQL 失败：Error 1136 (21S01): Column count doesn\'t match value count at row 1', '3', null, '1473', 'v9b2l902g40dlr1eesoh7wch00bcicun', '2026-09-28 22:59:06', '2026-09-28 22:59:19', null, '1');
INSERT INTO `task_job` VALUES ('5', '数据库定时备份', 'manual', '2026-09-28 22:59:35', '{\"args\":[],\"handler\":\"database_backup\",\"kwargs\":{\"dir\":\"static/bakup\",\"keep_days\":30,\"timeout\":900},\"node\":{\"code\":\"database_backup\",\"id\":5,\"name\":\"数据库定时备份\"},\"pattern\":\"\",\"started_at\":\"2026-09-28 22:59:35\",\"trigger\":\"manual\",\"version\":2}', null, null, '1', null, '1474', 'v9b2l902g40dlr1eryvmtewt00evxhpk', '2026-09-28 22:59:35', '2026-09-28 22:59:35', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:08:25', '{\"args\":[],\"duration_ms\":29,\"error\":\"\",\"finished_at\":\"2026-09-28 23:03:25\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:08:25\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:03:25\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:03:25\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:03:25\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1475', 'v9b2l902g40dlr1hq03o2ow3v0l5z7j5', '2026-09-28 23:03:26', '2026-09-28 23:03:26', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:13:25', '{\"args\":[],\"duration_ms\":43,\"error\":\"\",\"finished_at\":\"2026-09-28 23:08:25\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:13:25\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:08:25\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:08:25\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:08:25\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1476', 'v9b2l902g40dlr1ljtl52kg4m0wq0spx', '2026-09-28 23:08:26', '2026-09-28 23:08:26', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:22:49', '{\"args\":[],\"duration_ms\":46,\"error\":\"\",\"finished_at\":\"2026-09-28 23:17:49\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:22:49\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:17:49\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:17:49\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:17:49\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1477', 'v9b2l90h300dlr1squfrn2c230q78otv', '2026-09-28 23:17:50', '2026-09-28 23:17:50', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:36:35', '{\"args\":[],\"duration_ms\":51,\"error\":\"\",\"finished_at\":\"2026-09-28 23:31:35\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:36:35\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:31:35\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:31:35\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:31:35\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1478', 'v9b2l90klw0dlr23abm5rrc1t04ixyhg', '2026-09-28 23:31:36', '2026-09-28 23:31:36', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:41:35', '{\"args\":[],\"duration_ms\":31,\"error\":\"\",\"finished_at\":\"2026-09-28 23:36:35\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:41:35\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:36:35\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:36:35\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:36:35\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1479', 'v9b2l90klw0dlr27452q4v81w0vb87ad', '2026-09-28 23:36:36', '2026-09-28 23:36:36', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-28 23:46:35', '{\"args\":[],\"duration_ms\":31,\"error\":\"\",\"finished_at\":\"2026-09-28 23:41:35\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-28 23:46:35\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-28 23:41:35\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-28 23:41:35\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-28 23:41:35\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1480', 'v9b2l90klw0dlr2axyjen4k2h04bkfp1', '2026-09-28 23:41:36', '2026-09-28 23:41:36', null, '1');
INSERT INTO `task_job` VALUES ('system_cleanup_operation_log', '操作日志清理', 'cron', '2026-10-04 03:00:00+08:00', '{\n  \"version\": 1,\n  \"id\": \"system_cleanup_operation_log\",\n  \"func\": \"app.core.ap_scheduler:cleanup_operation_log\",\n  \"trigger\": \"cron[day_of_week=\'sun\', hour=\'3\', minute=\'0\']\",\n  \"executor\": \"default\",\n  \"args\": [],\n  \"kwargs\": {},\n  \"name\": \"操作日志清理\",\n  \"misfire_grace_time\": 1,\n  \"coalesce\": true,\n  \"max_instances\": 5,\n  \"next_run_time\": \"2026-10-04 03:00:00+08:00\"\n}', null, null, '0', null, '1483', '54ba7069-2501-4637-8bd6-32763b2baa37', '2026-09-28 23:52:48', '2026-09-28 23:52:48', null, '1');
INSERT INTO `task_job` VALUES ('system_database_backup', '数据库备份', 'cron', '2026-09-29 02:00:00+08:00', '{\n  \"version\": 1,\n  \"id\": \"system_database_backup\",\n  \"func\": \"app.core.ap_scheduler:backup_database\",\n  \"trigger\": \"cron[hour=\'2\', minute=\'0\']\",\n  \"executor\": \"default\",\n  \"args\": [],\n  \"kwargs\": {},\n  \"name\": \"数据库备份\",\n  \"misfire_grace_time\": 1,\n  \"coalesce\": true,\n  \"max_instances\": 5,\n  \"next_run_time\": \"2026-09-29 02:00:00+08:00\"\n}', null, null, '0', null, '1484', '47e109e7-99d1-44ff-b46a-fe66945dd4de', '2026-09-28 23:52:48', '2026-09-28 23:52:48', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-09-29 00:32:17', '{\"args\":[],\"duration_ms\":31,\"error\":\"\",\"finished_at\":\"2026-09-29 00:27:17\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-09-29 00:32:17\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-09-29 00:27:17\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-09-29 00:27:17\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-09-29 00:27:17\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1485', 'v9b2l90lxw0dlr39xgnfqfod0011uhci', '2026-09-29 00:27:17', '2026-09-29 00:27:18', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'manual', '2026-10-13 00:37:33', '{\"args\":[],\"duration_ms\":39,\"error\":\"\",\"finished_at\":\"2026-10-13 00:32:33\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 00:37:33\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 00:32:33\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 00:32:33\",\"trigger\":\"manual\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 00:32:33\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1486', 'v9b2l90lzk0dm305lb2vd0or0011hc9l', '2026-10-13 00:32:34', '2026-10-13 00:32:34', null, '1');
INSERT INTO `task_job` VALUES ('5', '数据库定时备份', 'manual', '2026-10-13 01:32:51', '{\"args\":[],\"duration_ms\":363,\"error\":\"\",\"finished_at\":\"2026-10-13 00:32:51\",\"handler\":\"database_backup\",\"kwargs\":{\"dir\":\"static/bakup\",\"keep_days\":30,\"timeout\":900},\"next_run_time\":\"2026-10-13 01:32:51\",\"node\":{\"code\":\"database_backup\",\"id\":5,\"name\":\"数据库定时备份\"},\"pattern\":\"\",\"result\":\"{\\\"bytes\\\":619323,\\\"file\\\":\\\"static\\\\\\\\bakup\\\\\\\\fssoa-net_20261013_003251.sql.gz\\\",\\\"gzip_bytes\\\":118754,\\\"kind\\\":\\\"database_backup\\\",\\\"method\\\":\\\"orm\\\",\\\"ok\\\":true,\\\"removed_old\\\":0}\",\"started_at\":\"2026-10-13 00:32:51\",\"trigger\":\"manual\",\"version\":2}', '{\"bytes\":619323,\"file\":\"static\\\\bakup\\\\fssoa-net_20261013_003251.sql.gz\",\"gzip_bytes\":118754,\"kind\":\"database_backup\",\"method\":\"orm\",\"ok\":true,\"removed_old\":0}', '', '2', null, '1487', 'v9b2l90lzk0dm305tfvhtbk1b0xav04r', '2026-10-13 00:32:51', '2026-10-13 00:32:52', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 19:52:34', '{\"args\":[],\"duration_ms\":398,\"error\":\"\",\"finished_at\":\"2026-10-13 19:47:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 19:52:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 19:47:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 19:47:33\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 19:47:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1488', 'v9b2l901qo0dm3opxbcnkvs100wzb84d', '2026-10-13 19:47:34', '2026-10-13 19:47:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 19:57:34', '{\"args\":[],\"duration_ms\":35,\"error\":\"\",\"finished_at\":\"2026-10-13 19:52:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 19:57:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 19:52:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 19:52:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 19:52:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1489', 'v9b2l901qo0dm3otrcvzi381e0oor2wc', '2026-10-13 19:52:34', '2026-10-13 19:52:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:02:34', '{\"args\":[],\"duration_ms\":34,\"error\":\"\",\"finished_at\":\"2026-10-13 19:57:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:02:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 19:57:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 19:57:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 19:57:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1490', 'v9b2l901qo0dm3oxl6cs1hk1h0md8578', '2026-10-13 19:57:34', '2026-10-13 19:57:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:07:34', '{\"args\":[],\"duration_ms\":37,\"error\":\"\",\"finished_at\":\"2026-10-13 20:02:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:07:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:02:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:02:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:02:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1491', 'v9b2l901qo0dm3p1ezsqqt81m08ht340', '2026-10-13 20:02:34', '2026-10-13 20:02:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:12:34', '{\"args\":[],\"duration_ms\":33,\"error\":\"\",\"finished_at\":\"2026-10-13 20:07:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:12:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:07:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:07:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:07:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1492', 'v9b2l901qo0dm3p58t949p81q0eqad7t', '2026-10-13 20:07:34', '2026-10-13 20:07:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:17:34', '{\"args\":[],\"duration_ms\":54,\"error\":\"\",\"finished_at\":\"2026-10-13 20:12:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:17:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:12:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:12:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:12:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1493', 'v9b2l901qo0dm3p92motho02e02dzqbr', '2026-10-13 20:12:34', '2026-10-13 20:12:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:22:34', '{\"args\":[],\"duration_ms\":47,\"error\":\"\",\"finished_at\":\"2026-10-13 20:17:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:22:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:17:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:17:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:17:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1494', 'v9b2l901qo0dm3pcwg4d53c2x09mgwxk', '2026-10-13 20:17:34', '2026-10-13 20:17:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:27:34', '{\"args\":[],\"duration_ms\":35,\"error\":\"\",\"finished_at\":\"2026-10-13 20:22:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:27:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:22:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:22:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:22:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1495', 'v9b2l901qo0dm3pgqbbil2w30024c3d1', '2026-10-13 20:22:34', '2026-10-13 20:22:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:32:34', '{\"args\":[],\"duration_ms\":47,\"error\":\"\",\"finished_at\":\"2026-10-13 20:27:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:32:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:27:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:27:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:27:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1496', 'v9b2l901qo0dm3pkk31tpmc350qrttys', '2026-10-13 20:27:34', '2026-10-13 20:27:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:37:34', '{\"args\":[],\"duration_ms\":47,\"error\":\"\",\"finished_at\":\"2026-10-13 20:32:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:37:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:32:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:32:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:32:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1497', 'v9b2l901qo0dm3podwicstg3l0pc8i4u', '2026-10-13 20:32:34', '2026-10-13 20:32:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:42:34', '{\"args\":[],\"duration_ms\":50,\"error\":\"\",\"finished_at\":\"2026-10-13 20:37:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:42:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:37:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:37:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:37:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1498', 'v9b2l901qo0dm3ps7pxvy186h0hnyr78', '2026-10-13 20:37:34', '2026-10-13 20:37:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:47:34', '{\"args\":[],\"duration_ms\":49,\"error\":\"\",\"finished_at\":\"2026-10-13 20:42:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:47:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:42:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:42:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:42:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1499', 'v9b2l901qo0dm3pw1l2ehw8830rkqs6y', '2026-10-13 20:42:34', '2026-10-13 20:42:34', null, '1');
INSERT INTO `task_job` VALUES ('5', '数据库定时备份', 'cron', '2026-10-13 21:42:34', '{\"args\":[],\"duration_ms\":212,\"error\":\"\",\"finished_at\":\"2026-10-13 20:42:34\",\"handler\":\"database_backup\",\"kwargs\":{\"dir\":\"static/bakup\",\"keep_days\":30,\"timeout\":900},\"next_run_time\":\"2026-10-13 21:42:34\",\"node\":{\"code\":\"database_backup\",\"id\":5,\"name\":\"数据库定时备份\"},\"pattern\":\"@every 1h0m0s\",\"result\":\"{\\\"bytes\\\":649207,\\\"file\\\":\\\"static\\\\\\\\bakup\\\\\\\\fssoa-net_20261013_204234.sql.gz\\\",\\\"gzip_bytes\\\":122803,\\\"kind\\\":\\\"database_backup\\\",\\\"method\\\":\\\"orm\\\",\\\"ok\\\":true,\\\"removed_old\\\":0}\",\"started_at\":\"2026-10-13 20:42:34\",\"trigger\":\"cron\",\"version\":2}', '{\"bytes\":649207,\"file\":\"static\\\\bakup\\\\fssoa-net_20261013_204234.sql.gz\",\"gzip_bytes\":122803,\"kind\":\"database_backup\",\"method\":\"orm\",\"ok\":true,\"removed_old\":0}', '', '2', null, '1500', 'v9b2l901qo0dm3pw1l2qfg4840ukn3yk', '2026-10-13 20:42:34', '2026-10-13 20:42:35', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:52:34', '{\"args\":[],\"duration_ms\":50,\"error\":\"\",\"finished_at\":\"2026-10-13 20:47:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:52:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:47:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:47:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:47:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1501', 'v9b2l901qo0dm3pzveii22c870f39yvh', '2026-10-13 20:47:34', '2026-10-13 20:47:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 20:57:34', '{\"args\":[],\"duration_ms\":33,\"error\":\"\",\"finished_at\":\"2026-10-13 20:52:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 20:57:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:52:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:52:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:52:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1502', 'v9b2l901qo0dm3q3p7yswfc8a0ddkuhi', '2026-10-13 20:52:34', '2026-10-13 20:52:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:02:34', '{\"args\":[],\"duration_ms\":45,\"error\":\"\",\"finished_at\":\"2026-10-13 20:57:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:02:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 20:57:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 20:57:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 20:57:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1503', 'v9b2l901qo0dm3q7j31o8hw8p0x1f0p1', '2026-10-13 20:57:34', '2026-10-13 20:57:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:07:34', '{\"args\":[],\"duration_ms\":36,\"error\":\"\",\"finished_at\":\"2026-10-13 21:02:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:07:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:02:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:02:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:02:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1504', 'v9b2l901qo0dm3qbcwi4qeoba0ld5cis', '2026-10-13 21:02:34', '2026-10-13 21:02:34', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:12:34', '{\"args\":[],\"duration_ms\":37,\"error\":\"\",\"finished_at\":\"2026-10-13 21:07:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:12:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:07:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:07:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:07:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1505', 'v9b2l901qo0dm3qf6rlylj8gq00wren3', '2026-10-13 21:07:35', '2026-10-13 21:07:35', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:17:34', '{\"args\":[],\"duration_ms\":37,\"error\":\"\",\"finished_at\":\"2026-10-13 21:12:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:17:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:12:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:12:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:12:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1506', 'v9b2l901qo0dm3qj0mpm1vghr0x50mbp', '2026-10-13 21:12:35', '2026-10-13 21:12:35', null, '1');
INSERT INTO `task_job` VALUES ('4', '邮件批量发送', 'manual', '2026-10-14 03:16:02', '{\"args\":[],\"duration_ms\":68,\"error\":\"命令执行失败：exit status 1\",\"finished_at\":\"2026-10-13 21:16:02\",\"handler\":\"shell_command\",\"kwargs\":{\"command\":\"dir c:/\",\"timeout\":300},\"next_run_time\":\"2026-10-14 03:16:02\",\"node\":{\"code\":\"email_batch\",\"id\":4,\"name\":\"邮件批量发送\"},\"pattern\":\"\",\"result\":\"{\\\"command\\\":\\\"dir c:/\\\",\\\"exit_code\\\":1,\\\"kind\\\":\\\"shell_command\\\",\\\"ok\\\":false,\\\"output\\\":\\\"��Ч���� - \\\\\\\"\\\\\\\"��\\\\r\\\\n\\\"}\",\"started_at\":\"2026-10-13 21:16:02\",\"trigger\":\"manual\",\"version\":2}', '{\"command\":\"dir c:/\",\"exit_code\":1,\"kind\":\"shell_command\",\"ok\":false,\"output\":\"��Ч���� - \\\"\\\"��\\r\\n\"}', '命令执行失败：exit status 1', '3', null, '1507', 'v9b2l901qo0dm3qlo1ro8qkij0q56xgl', '2026-10-13 21:16:02', '2026-10-13 21:16:02', null, '1');
INSERT INTO `task_job` VALUES ('5', '数据库定时备份', 'manual', '2026-10-13 22:16:06', '{\"args\":[],\"duration_ms\":127,\"error\":\"\",\"finished_at\":\"2026-10-13 21:16:06\",\"handler\":\"database_backup\",\"kwargs\":{\"dir\":\"static/bakup\",\"keep_days\":30,\"timeout\":900},\"next_run_time\":\"2026-10-13 22:16:06\",\"node\":{\"code\":\"database_backup\",\"id\":5,\"name\":\"数据库定时备份\"},\"pattern\":\"\",\"result\":\"{\\\"bytes\\\":690812,\\\"file\\\":\\\"static\\\\\\\\bakup\\\\\\\\fssoa-net_20261013_211606.sql.gz\\\",\\\"gzip_bytes\\\":128864,\\\"kind\\\":\\\"database_backup\\\",\\\"method\\\":\\\"orm\\\",\\\"ok\\\":true,\\\"removed_old\\\":0}\",\"started_at\":\"2026-10-13 21:16:06\",\"trigger\":\"manual\",\"version\":2}', '{\"bytes\":690812,\"file\":\"static\\\\bakup\\\\fssoa-net_20261013_211606.sql.gz\",\"gzip_bytes\":128864,\"kind\":\"database_backup\",\"method\":\"orm\",\"ok\":true,\"removed_old\":0}', '', '2', null, '1508', 'v9b2l901qo0dm3qlpxwkvmwin0j69w22', '2026-10-13 21:16:06', '2026-10-13 21:16:07', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:22:34', '{\"args\":[],\"duration_ms\":29,\"error\":\"\",\"finished_at\":\"2026-10-13 21:17:34\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:22:34\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:17:34\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:17:34\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:17:34\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1509', 'v9b2l901qo0dm3qmug5pghkjk03u6taw', '2026-10-13 21:17:35', '2026-10-13 21:17:35', null, '1');
INSERT INTO `task_job` VALUES ('10', '数据库还原', 'manual', '2026-10-13 21:21:20', '{\"args\":[],\"handler\":\"database_restore\",\"kwargs\":{\"file\":\"static/restore/init.sql\",\"flush_redis\":true},\"node\":{\"code\":\"database_restore\",\"id\":10,\"name\":\"数据库还原\"},\"pattern\":\"\",\"started_at\":\"2026-10-13 21:21:20\",\"trigger\":\"manual\",\"version\":2}', null, null, '1', null, '1510', 'v9b2l90nng0dm3qpqc5rpbk50024t64p', '2026-10-13 21:21:21', '2026-10-13 21:21:21', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:31:37', '{\"args\":[],\"duration_ms\":37,\"error\":\"\",\"finished_at\":\"2026-10-13 21:26:37\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:31:37\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:26:37\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:26:37\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:26:37\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1511', 'v9b2l904gk0dm3qtrltim3c230rh446t', '2026-10-13 21:26:37', '2026-10-13 21:26:37', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:36:37', '{\"args\":[],\"duration_ms\":35,\"error\":\"\",\"finished_at\":\"2026-10-13 21:31:37\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:36:37\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:31:37\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:31:37\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:31:37\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1512', 'v9b2l904gk0dm3qxlfa1nfs2n05u2tns', '2026-10-13 21:31:37', '2026-10-13 21:31:37', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:41:37', '{\"args\":[],\"duration_ms\":24,\"error\":\"\",\"finished_at\":\"2026-10-13 21:36:37\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:41:37\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:36:37\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:36:37\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:36:37\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1513', 'v9b2l904gk0dm3r1f8qh2m42q0xr807z', '2026-10-13 21:36:37', '2026-10-13 21:36:37', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:46:37', '{\"args\":[],\"duration_ms\":77,\"error\":\"\",\"finished_at\":\"2026-10-13 21:41:37\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:46:37\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:41:37\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:41:37\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:41:37\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1514', 'v9b2l904gk0dm3r5926q0j82t0jj3ort', '2026-10-13 21:41:37', '2026-10-13 21:41:37', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 21:51:37', '{\"args\":[],\"duration_ms\":29,\"error\":\"\",\"finished_at\":\"2026-10-13 21:46:37\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 21:51:37\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"{\\\"body\\\":\\\"{\\\\\\\"code\\\\\\\":200,\\\\\\\"msg\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"message\\\\\\\":\\\\\\\"success\\\\\\\",\\\\\\\"data\\\\\\\":{\\\\\\\"status\\\\\\\":\\\\\\\"ok\\\\\\\",\\\\\\\"time\\\\\\\":\\\\\\\"2026-10-13 21:46:37\\\\\\\"},\\\\\\\"status_code\\\\\\\":200,\\\\\\\"success\\\\\\\":true}\\\",\\\"kind\\\":\\\"http_request\\\",\\\"ok\\\":true,\\\"status\\\":200}\",\"started_at\":\"2026-10-13 21:46:37\",\"trigger\":\"interval\",\"version\":2}', '{\"body\":\"{\\\"code\\\":200,\\\"msg\\\":\\\"success\\\",\\\"message\\\":\\\"success\\\",\\\"data\\\":{\\\"status\\\":\\\"ok\\\",\\\"time\\\":\\\"2026-10-13 21:46:37\\\"},\\\"status_code\\\":200,\\\"success\\\":true}\",\"kind\":\"http_request\",\"ok\":true,\"status\":200}', '', '2', null, '1515', 'v9b2l904gk0dm3r92vm4qew2w05i7xpx', '2026-10-13 21:46:37', '2026-10-13 21:46:37', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 22:02:31', '{\"args\":[],\"duration_ms\":38,\"error\":\"请求失败：Get \\\"http://localhost:8181/api/health\\\": dial tcp [::1]:8181: connectex: No connection could be made because the target machine actively refused it.\",\"finished_at\":\"2026-10-13 21:57:31\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 22:02:31\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"\",\"started_at\":\"2026-10-13 21:57:31\",\"trigger\":\"interval\",\"version\":2}', '', '请求失败：Get \"http://localhost:8181/api/health\": dial tcp [::1]:8181: connectex: No connection could be made because the target machine actively refused it.', '3', null, '1516', 'v9b2l902fk0dm3rhffnhqac6000lyr7c', '2026-10-13 21:57:31', '2026-10-13 21:57:31', null, '1');
INSERT INTO `task_job` VALUES ('3', '健康检查任务', 'interval', '2026-10-13 22:07:31', '{\"args\":[],\"duration_ms\":45,\"error\":\"请求失败：Get \\\"http://localhost:8181/api/health\\\": dial tcp [::1]:8181: connectex: No connection could be made because the target machine actively refused it.\",\"finished_at\":\"2026-10-13 22:02:31\",\"handler\":\"http_request\",\"kwargs\":{\"expect_status\":200,\"method\":\"GET\",\"timeout\":60,\"url\":\"http://localhost:8181/api/health\"},\"next_run_time\":\"2026-10-13 22:07:31\",\"node\":{\"code\":\"health_check\",\"id\":3,\"name\":\"健康检查任务\"},\"pattern\":\"@every 5m0s\",\"result\":\"\",\"started_at\":\"2026-10-13 22:02:31\",\"trigger\":\"interval\",\"version\":2}', '', '请求失败：Get \"http://localhost:8181/api/health\": dial tcp [::1]:8181: connectex: No connection could be made because the target machine actively refused it.', '3', null, '1517', 'v9b2l902fk0dm3rl993pwywd00936tq1', '2026-10-13 22:02:31', '2026-10-13 22:02:31', null, '1');

-- ----------------------------
-- Table structure for `task_node`
-- ----------------------------
DROP TABLE IF EXISTS `task_node`;
CREATE TABLE `task_node` (
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节点名称',
  `code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节点编码',
  `jobstore` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '存储器',
  `executor` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '执行器',
  `trigger` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '触发器',
  `trigger_args` text COLLATE utf8mb4_unicode_ci COMMENT '触发器参数',
  `func` text COLLATE utf8mb4_unicode_ci COMMENT '代码块',
  `args` text COLLATE utf8mb4_unicode_ci COMMENT '位置参数',
  `kwargs` text COLLATE utf8mb4_unicode_ci COMMENT '关键字参数',
  `coalesce` tinyint(1) DEFAULT NULL COMMENT '是否合并运行',
  `max_instances` int(11) DEFAULT NULL COMMENT '最大实例数',
  `start_date` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开始时间',
  `end_date` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '结束时间',
  `status` int(11) NOT NULL COMMENT '状态(0:启动 1:停用)',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `uuid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'UUID全局唯一标识',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `tenant_id` int(11) NOT NULL COMMENT '租户ID',
  `created_by` int(11) DEFAULT NULL COMMENT '创建人ID',
  `updated_by` int(11) DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='节点类型表';

-- ----------------------------
-- Records of task_node
-- ----------------------------
INSERT INTO `task_node` VALUES ('演示任务', 'demo_job', 'default', 'default', 'interval', '0 0 0 1 0', 'http_request', null, '{\"url\":\"http://localhost:8181/api/health/live\",\"method\":\"GET\",\"expect_status\":200,\"timeout\":60}', '0', '1', null, null, '0', '最简演示任务，用于验证调度器基本功能', '1', 'bf192ea1-7c93-4395-a633-d77c15df6293', '2026-06-21 17:56:34', '2026-09-25 21:43:37', null, '1', null, '1');
INSERT INTO `task_node` VALUES ('数据库清理任务', 'db_cleanup', 'sqlalchemy', 'default', 'interval', '0 0 0 20 0', 'log_cleanup', null, '{\"table\":\"sa_system_oper_log\",\"days\":30,\"timeout\":300}', '1', '1', null, null, '0', '清理过期操作日志和临时数据，建议每天凌晨3点执行', '2', '3a3f2e3f-bc6e-4978-8244-c51e99306f1d', '2026-06-21 17:56:34', '2026-09-25 21:31:19', null, '1', null, '1');
INSERT INTO `task_node` VALUES ('健康检查任务', 'health_check', 'default', 'default', 'interval', '0 5 0 0 0', 'http_request', null, '{\"url\":\"http://localhost:8181/api/health\",\"method\":\"GET\",\"expect_status\":200,\"timeout\":60}', '1', '1', null, null, '0', '系统资源健康检查，建议每5分钟执行一次', '3', '8eea90c5-5bfd-48d7-a980-6d526a28ecfd', '2026-06-21 17:56:34', '2026-09-25 21:30:23', null, '1', null, '1');
INSERT INTO `task_node` VALUES ('邮件批量发送', 'email_batch', 'sqlalchemy', 'default', 'interval', '0 0 6 0 0', 'shell_command', null, '{\"command\":\"dir c:/\",\"timeout\":300}', '1', '1', null, null, '1', '批量发送待发送邮件，建议每分钟执行一次', '4', '9ee948a2-7583-4d42-b2d3-18ffb3bb3aec', '2026-06-21 17:56:34', '2026-10-13 00:33:01', null, '1', null, '1');
INSERT INTO `task_node` VALUES ('数据库定时备份', 'database_backup', 'default', 'default', 'cron', '@every 1h', 'database_backup', null, '{\"dir\":\"static/bakup\",\"keep_days\":30,\"timeout\":900}', '1', '1', null, null, '0', '每天备份数据库到 static/bakup', '5', 'v9b2l90khw0dlly1vl32eww800n1h3vm', '2026-09-22 23:18:21', '2026-09-28 22:21:34', null, '1', null, '1');
INSERT INTO `task_node` VALUES ('E2E test node', 'e2e_node_test', null, null, '', '', 'http_request', '', '{\"url\":\"http://127.0.0.1:8182/health\",\"expect_status\":200}', '0', '1', '', '', '0', 'temporary e2e node', '6', 'v9b2l901gc0dlofhd4f2qtgb00lyhbb7', '2026-09-25 21:23:14', '2026-09-25 21:23:14', '2026-09-25 21:26:01', '1', '1', null);
INSERT INTO `task_node` VALUES ('E2E test node', 'e2e_node_test', null, null, 'date', '2026-09-25 23:28:14', 'http_request', '', '{\"url\":\"http://127.0.0.1:8182/health\",\"expect_status\":200}', '0', '1', '', '', '1', 'temporary e2e node', '7', 'v9b2l904780dlofl73qno08900fc3uzm', '2026-09-25 21:28:14', '2026-09-25 21:28:14', '2026-09-25 21:28:14', '1', '1', null);
INSERT INTO `task_node` VALUES ('probe node', 'e2e_probe_node', null, null, '', '', 'http_request', '', '{\"url\":\"http://127.0.0.1:8182/health\",\"expect_status\":200}', '0', '1', '', '', '0', '', '8', 'v9b2l90m0o0dlofm0tgvh20500gs159i', '2026-09-25 21:29:19', '2026-09-25 21:29:19', '2026-09-25 21:29:19', '1', '1', null);
INSERT INTO `task_node` VALUES ('E2E test node', 'e2e_node_test', null, null, 'date', '2026-09-25 23:30:04', 'http_request', '', '{\"url\":\"http://127.0.0.1:8182/health\",\"expect_status\":200}', '0', '1', '', '', '1', 'temporary e2e node', '9', 'v9b2l90jsw0dlofmlro8nckh00akjp72', '2026-09-25 21:30:04', '2026-09-25 21:30:05', '2026-09-25 21:30:05', '1', '1', null);
INSERT INTO `task_node` VALUES ('数据库还原', 'database_restore', null, null, 'interval', '0 0 1 0 0', 'database_restore', null, '{\"file\":\"static/restore/init.sql\",\"flush_redis\":true}', '1', '1', null, null, '1', '演示环境每小时用 static/restore/init.sql 还原数据库并清空 Redis（会覆盖现有数据）', '10', 'v9b2l90jo80dlr1clrx5iys1002i3izs', '2026-09-28 22:56:45', '2026-10-13 00:32:47', null, '1', null, null);
