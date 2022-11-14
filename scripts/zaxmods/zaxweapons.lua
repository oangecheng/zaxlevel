-- 可升级武器定义
local WEAPON_DEFS = {
	"spear",
	"spear_wathgrithr",
}

-- 物品需要添加traddable组件
local TRADDABLE_ITEM_DEFS = {
	"ruins_bat",
	"tentaclespike",
	"walrus_tusk",
	"dragon_scales",
	"largechop_certificate",
	"largeminer_certificate",
	"bee_king_certificate",
}




-- 给所有物品添加 tradable 组件
if GLOBAL.TheNet:GetIsServer() then
	local items = TRADDABLE_ITEM_DEFS
	-- 没有添加可交易组件的物品，添加上
	for i=1, #items do
		AddPrefabPostInit(items[i], function(inst) 
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end)
	end
end



-- 初始化物品，添加组件
local function initWeapon(inst)
	inst:AddComponent("zxtrader")
	inst:AddComponent("zxwork")
	inst:AddComponent("zxspeed")
	inst:AddComponent("zxfiniteuses")
	inst:AddComponent("zxaoe")
	inst:AddComponent("zxdamage")
end



-- 给战斗长矛添加可升级组件
if GLOBAL.TheNet:GetIsServer() then
	for i=1, #WEAPON_DEFS do
		AddPrefabPostInit(WEAPON_DEFS[i], initWeapon)
	end
end





