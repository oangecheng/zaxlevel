local ch = locale == "zh" or locale == "zhr"
ch = true

-- 名称
name = "Zax Level Up"
-- 描述
description = 
ch and 
[[
V 0.2.6
你可以升级你的角色和物品，
可以通过战斗击杀对方获得经验，
可以吃下美味的食物获取经验，
可以通过给予物品升级女武神的长矛和普通长矛，
可以通过给予物品升级海象帽，
以上选项都可以通过设置自行选择开启还是关闭
提醒: mod 角色如果自带升级不一定兼容哦！
]]
or 
[[
V 0.2.6
You can upgrade your characters and items.
You can gain experience by killing opponents in battle.
You can eat delicious food to gain experience.
Wathgrithr spears and normal spears can be upgraded by giving items.
Walrushat can be upgraded by giving items.
All of the above options can be turned on or off through the settings.
Reminder: mod characters may not be compatible with their own upgrades!
]]


author = "Zax"
version = "0.2.6"
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dst_compatible = true
client_only_mod = false
all_clients_require_mod = true
api_version = 10


configuration_options = 
{

	{
		name = "UseRoleLevelUp",
		label = ch and "角色升级" or "upgrade character",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseMorePick",
		label = ch and "多倍采集" or "more pick",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseMoreDrop",
		label = ch and "额外掉落" or "more item drop",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseRoleStrenth",
		label = ch and "人物强化" or "strengthen character",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseWeaponLevelUp",
		label = ch and "长矛/战斗长矛可升级" or "upgrade weapon" ,
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseHatslLevelUp",
		label = ch and "帽子可升级" or "upgrade hats" ,
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	},

	{
		name = "UseUpgradePolicy",
		label = ch and "物品概率升级" or "item random upgrade",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = false,
	},
} 