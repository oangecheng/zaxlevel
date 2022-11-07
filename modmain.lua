local _G = GLOBAL


local useUpgradePolicy = GetModConfigData('UseUpgradePolicy')
-- 是否开启角色升级功能
local useRoleLevelUp = GetModConfigData('UseRoleLevelUp')
-- 是否开启多倍采集功能
local useMorePick = GetModConfigData('UseMorePick')
-- 是否开启额外掉落功能
local useMoreDrop = GetModConfigData('UseMoreDrop')
-- 是否开启人物强化功能
local useRoleStrenth = GetModConfigData('UseRoleStrenth')
-- 是否开启武器可升级
-- 目前仅支持战斗长矛
local useWeaponLevelUp = GetModConfigData('UseWeaponLevelUp')


TUNING.useUpgradePolicy = useUpgradePolicy


if useMorePick then
	modimport("scripts/zaxmods/zaxmorepick.lua")
end

if useWeaponLevelUp then
	modimport("scripts/zaxmods/zaxweapons.lua")
end

modimport("scripts/zaxmods/zaxhats.lua")



if GLOBAL.TheNet:GetIsServer() then
	-- 角色初始化
	AddPlayerPostInit(function (inst)

		-- 角色升级
		if useRoleLevelUp then 			
			inst:AddComponent("rolelevel")
		end

		-- 额外掉落
		if useMoreDrop then 
			inst:AddComponent("extradrop")
		end

		-- 角色强化
		if useRoleStrenth then
			inst:AddComponent("rolestrenth")
		end


		inst.components.talker:Say("我又来到这个奇怪的世界！")

	end)

	-- 和勋章联动
	-- AddPrefabPostInit("largechop_certificate", function(inst)
	-- 	inst:AddComponent("edibal")
	-- end)
	-- AddPrefabPostInit("largeminer_certificate", function(inst)
	-- 	inst:AddComponent("edibal")
	-- end)
end


