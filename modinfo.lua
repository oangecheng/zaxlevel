-- 名称
name = "Zax Level Up"
-- 描述
description = "level up role and item! 0.2.1"
-- 作者
author = "Zax"
-- 版本
version = "0.2.1"
-- klei官方论坛地址，为空则默认是工坊的地址
forumthread = ""
-- modicon 下一篇再介绍怎么创建的
-- icon_atlas = "images/modicon.xml"
-- icon = "images/modicon.tex"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
-- dst兼容
dst_compatible = true
-- 是否是客户端mod
client_only_mod = false
-- 是否是所有客户端都需要安装
all_clients_require_mod = true
-- 饥荒api版本，固定填10
api_version = 10

-- mod的配置项，后面介绍
configuration_options = {
	{
		name = "UseUpgradePolicy",
		label = "物品升级概率成功",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	{
		name = "UseRoleLevelUp",
		label = "角色升级",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	{
		name = "UseMorePick",
		label = "多倍采集",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	{
		name = "UseMoreDrop",
		label = "额外掉落",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	{
		name = "UseRoleStrenth",
		label = "人物强化",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	{
		name = "UseWeaponLevelUp",
		label = "战斗长矛可升级",
		options = {
			{description = "开启", data = true},
			{description = "关闭", data = false},
		},
		default = false,
	},

	
}