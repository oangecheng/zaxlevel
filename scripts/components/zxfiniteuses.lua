

local MAX_USES = 2000
local REPAIRE_PERCENT = 0.2
local REPAIRE_ITEM = "goldnugget"

--扩充最大使用次数物品定义
local ITEM_DEFS = {
	{"dragon_scales", 100}, --龙鳞
}

-- 耐久为0
local function finish(inst)
	inst.components.finiteuses:SetPercent(0)
    -- 对于武器，需要将其攻击力设为0
    if inst.components.zxdamage ~= nil then
        inst.components.zxdamage:Lock()
    end
end


-- 耐久恢复
local function recover(inst)
    local finiteuses = inst.components.finiteuses
    local zxfiniteuses = inst.components.zxfiniteuses
	local percent = math.max(100/zxfiniteuses.max, 0.2)
	percent = math.min(finiteuses:GetPercent() + percent, 1)
	finiteuses:SetPercent(percent)
    -- 恢复武器攻击力
    if inst.components.zxdamage ~= nil then
        inst.components.zxdamage:UnLock()
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
    local zxfiniteuses = inst.components.zxfiniteuses
    if zxfiniteuses.max < MAX_USES then
        local target = findTargetItem(item)
        if target ~= nil then
            return true
        end
    end
    if item.prefab == REPAIRE_ITEM then
        return true
    end
    return false
end


-- 给予物品
local function itemGive(inst, giver, item)
    local target = findTargetItem(item)
    if target ~= nil then
        local zxfiniteuses = inst.components.zxfiniteuses
        zxfiniteuses.max = math.min(zxfiniteuses.max + target[2], MAX_USES)
        giver.components.talker:Say("武器更耐用了！")
        local finiteuses = inst.components.finiteuses
        local percent = finiteuses:GetPercent()
		finiteuses:SetMaxUses(zxfiniteuses.max)
		finiteuses:SetPercent(percent)
    end

    if item.prefab == REPAIRE_ITEM then
        recover(inst)
    end
end



local ZxFiniteuses = Class(function(self, inst)
    self.inst = inst
    self.max = 0

    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)      
    if inst.components.finiteuses ~= nil then
        self.max = inst.components.finiteuses.total
        inst.components.finiteuses:SetOnFinished(finish)
    end
end)



function ZxFiniteuses:OnSave()
    return {
        max = self.max,
    }
end


function ZxFiniteuses:OnLoad(data)
    self.max = data.max or 100
	local finiteuses = self.inst.components.finiteuses
	finiteuses:SetMaxUses(self.max)
	local percent = finiteuses:GetPercent()
	finiteuses:SetPercent(percent)
end

return ZxFiniteuses