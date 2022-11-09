local _G = GLOBAL

-- 概率升级物品
local useUpgradePolicy = GetModConfigData('UseUpgradePolicy')
TUNING.useUpgradePolicy = useUpgradePolicy

local useRoleLevelUp = GetModConfigData('UseRoleLevelUp')
local useMorePick = GetModConfigData('UseMorePick')
local useMoreDrop = GetModConfigData('UseMoreDrop')
local useRoleStrenth = GetModConfigData('UseRoleStrenth')
local useWeaponLevelUp = GetModConfigData('UseWeaponLevelUp')
local useHatslLevelUp = GetModConfigData('UseHatslLevelUp')


if useMorePick then
	modimport("scripts/zaxmods/zaxmorepick.lua")
end

if useSpearLevelUp then
	modimport("scripts/zaxmods/zaxweapons.lua")
end

if useHatslLevelUp then
	modimport("scripts/zaxmods/zaxhats.lua")
end


-- 初始化角色，添加组件
-- init character and add components
local function initPalyer(inst)
	-- 角色升级
	if useRoleLevelUp then 			
		inst:AddComponent("rolelevel")
	end
	-- 额外掉落
	if useMoreDrop then 
		inst:AddComponent("zxmoredrop")
	end
	-- 角色强化
	if useRoleStrenth then
		inst:AddComponent("rolestrenth")
	end

	inst.components.talker:Say("我又来到这个奇怪的世界！")	
end


if GLOBAL.TheNet:GetIsServer() then
	AddPlayerPostInit(initPalyer)
end


