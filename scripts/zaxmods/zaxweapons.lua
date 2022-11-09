


-- 可以提升攻击力的物品
DAMAGE_ITEM_DEFS = {
	{"ruins_bat", 0.5}, --铥矿棒
	{"tentaclespike", 0.02}, --触手尖刺
}
-- 可提升移动速度的物品
SPEED_ITEM_DEFS = {
	{"walrus_tusk", 0.01}, --海象牙
}
--扩充最大使用次数物品定义
MAX_USES_ITEM_DEFS = {
	{"dragon_scales", 100}, --龙鳞
}
--补充耐久物品
USES_ITEM_DEFS = {
	{"goldnugget", 0.2}, -- 金块
}


local WEAPON_DEFS = {
	"spear",
	"spear_wathgrithr",
}


-- 所有物品
ALL_ITEMS = {} 
for i=1, #DAMAGE_ITEM_DEFS do
	table.insert(ALL_ITEMS, DAMAGE_ITEM_DEFS[i][1])
end
for i=1, #SPEED_ITEM_DEFS do
	table.insert(ALL_ITEMS, SPEED_ITEM_DEFS[i][1])
end
for i=1, #MAX_USES_ITEM_DEFS do
	table.insert(ALL_ITEMS, MAX_USES_ITEM_DEFS[i][1])
end
for i=1, #USES_ITEM_DEFS do
	table.insert(ALL_ITEMS, USES_ITEM_DEFS[i][1])
end


-- 给所有物品添加 tradable 组件
if GLOBAL.TheNet:GetIsServer() then
	local items = ALL_ITEMS
	-- 没有添加可交易组件的物品，添加上
	for i=1, #items do
		AddPrefabPostInit(items[i], function(inst) 
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end)
	end
end


-- 判断物品是否可以给予
local function itemTradeTest(inst, item)
	local finiteuses = inst.components.finiteuses
	local zxweapon = inst.components.zxweapon
	
	local ret = false

	if zxweapon:IsNotMaxDamage() then ret = true
	elseif zxweapon:IsNotMaxUses() then ret = true
	elseif zxweapon:IsNotMaxWalkSpeed() then ret = true
	elseif finiteuses~=nil and finiteuses:GetPercent() < 1 then ret = true 
	end

	if ret then 
		for i=1, #ALL_ITEMS do
			if item.prefab == ALL_ITEMS[i] then
				return true
			end
		end
	end

	if inst.components.zxwork ~= nil then
		if inst.components.zxwork:AccpeptTest(item) then
			return true
		end
	end

	return false
end


-- 查找对应列表中物品的属性值
local function findItemValue(item, items)
	if item==nil or item.prefab==nil then
		return nil
	end

	for i=1, #items do
		if item.prefab == items[i][1] then
			return items[i][2]
		end
	end

	return nil

end

-- 给予物品
-- 提升攻击力/移速加成/最大使用次数/恢复耐久
local function onItemGiven(inst, giver, item)
	local zxweapon = inst.components.zxweapon

	local damage = findItemValue(item, DAMAGE_ITEM_DEFS)
	if damage ~= nil then
		zxweapon:UpgradeDamage(damage)
	end

	local wlspeed = findItemValue(item, SPEED_ITEM_DEFS)
	if wlspeed ~= nil then
		zxweapon:UpgradeWalkSpeed(wlspeed)
	end

	local maxuses = findItemValue(item, MAX_USES_ITEM_DEFS)
	if maxuses ~= nil then
		zxweapon:UpgradeMaxUses(maxuses)
	end

	local uses = findItemValue(item, USES_ITEM_DEFS)
	if uses ~= nil then
		zxweapon:RecoverUses(uses)
	end

	if inst.components.zxwork ~= nil then
		inst.components.zxwork:GiveItem(giver, item)
	end

	giver.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end


-- 初始化物品，添加组件
local function initWeapon(inst)
	inst:AddComponent("trader")
	inst:AddComponent("zxweapon")
	inst:AddComponent("zxwork")

	inst.components.trader:SetAbleToAcceptTest(itemTradeTest)
	inst.components.trader.onaccept = onItemGiven
end


-- 给战斗长矛添加可升级组件
if GLOBAL.TheNet:GetIsServer() then
	for i=1, #WEAPON_DEFS do
		AddPrefabPostInit(WEAPON_DEFS[i], initWeapon)
	end
end





