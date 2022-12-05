-- 武器提升攻击力组件
-- 给予其他物品提升攻击力，上限80点

-- 最大攻击力100
local MAX_DAMAGE = 100

-- 武器升级的阈值和倍率
-- 51之前一个铥矿棒能够加 4 攻击力， 68之前为2， 80之前为1
local DAMAGE_NORMAL = {51, 1}
local DAMAGE_SENIOR = {68, 0.5}
local DAMAGE_HIGH = {80, 0.25}
local DAMAGE_SUPER = {MAX_DAMAGE, 0.1}


-- 可以提升攻击力的物品
local ITEM_DEFS = {
	{"ruins_bat", 4}, --铥矿棒
	{"tentaclespike", 2}, --触手尖刺
}


-- 更新武器的攻击力
local function updateDamage(zxdamage)
    if zxdamage.inst.components.weapon ~= nil then
        local damage = zxdamage.unlock and zxdamage.damage or 0
        zxdamage.inst.components.weapon:SetDamage(damage)
    end
end


-- 查找对应列表中物品
local function findTargetItem(item)
	if item == nil or item.prefab == nil then
		return nil
	end

	for i = 1, #ITEM_DEFS do
		if item.prefab == ITEM_DEFS[i][1] then
			return ITEM_DEFS[i]
		end
	end

	return nil
end


-- 可交易
local function itemTradeTest(inst, item, giver)
    local zxdamage = inst.components.zxdamage
    if zxdamage.damage < MAX_DAMAGE then
        local target = findTargetItem(item)
        if target ~= nil then
            return true
        end
    end
    return false
end


-- 给予物品
local function itemGive(inst, giver, item)
    local target = findTargetItem(item)
    if target ~= nil then

        local zxdamage = inst.components.zxdamage
        local damage = target[2]
        local policy = nil

        
        if zxdamage.damage < DAMAGE_NORMAL[1] then
            policy = DAMAGE_NORMAL
        elseif zxdamage.damage < DAMAGE_SENIOR[1] then
            policy = DAMAGE_SENIOR
        elseif zxdamage.damage < DAMAGE_HIGH[1] then
            policy = DAMAGE_HIGH
        else 
            policy = DAMAGE_SUPER
        end


        if policy ~= nil then
            damage = damage * policy[2]
            zxdamage.damage = math.min(zxdamage.damage + damage, policy[1])
        end

        giver.components.talker:Say("这武器锻造的越来越完美了！")
        updateDamage(zxdamage)
    end
end



local ZxDamage = Class(function(self, inst)
    self.inst = inst
    self.damage = 0
    self.unlock = true
        
    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)
    if inst.components.weapon ~= nil then
        self.damage = inst.components.weapon.damage
    end

end)


-- 锁定，攻击力变为0
function ZxDamage:Lock()
    self.unlock = false
    updateDamage(self)
end


-- 解锁
function ZxDamage:UnLock()
    self.unlock = true
    updateDamage(self)
end


function ZxDamage:OnSave()
    return {
        damage = self.damage,
        unlock = self.unlock,
    }
end


function ZxDamage:OnLoad(data)
    self.damage = data.damage or 30
    self.unlock = data.unlock
    updateDamage(self)
end


return ZxDamage