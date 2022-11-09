-- 武器提升攻击力组件
-- 给予其他物品提升攻击力，上限80点

-- 最大攻击力80
local MAX_DAMAGE = 80

-- 可以提升攻击力的物品
local ITEM_DEFS = {
	{"ruins_bat", 0.5}, --铥矿棒
	{"tentaclespike", 0.02}, --触手尖刺
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
        zxdamage.damage = math.min(zxdamage.damage + target[2], MAX_DAMAGE)
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
    self.unlock = data.unlock or true
    updateDamage(self)
end


return ZxDamage