

local MAX_SPEED = 1.5
local DEF_SPEED = 1.1


-- 可提升移动速度的物品
local ITEM_DEFS = {
	{"walrus_tusk", 0.01}, --海象牙
}

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
    local zxspeed = inst.components.zxspeed
    if zxspeed.speed < MAX_SPEED then
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
        local zxspeed = inst.components.zxspeed
        zxspeed.speed = math.min(zxspeed.speed + target[2], MAX_SPEED)
        giver.components.talker:Say("天下武功，为快不破！")
        if inst.components.equippable ~= nil then
            inst.components.equippable.walkspeedmult = zxspeed.speed
        end
    end
end


local ZxSpeed = Class(function(self, inst)
    self.inst = inst
    self.speed = DEF_SPEED

    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)
    if inst.components.equippable ~= nil then
        inst.components.equippable.walkspeedmult = self.speed
    end        
end)



function ZxSpeed:OnSave()
    return {
        speed = self.speed,
    }
end


function ZxSpeed:OnLoad(data)
    self.speed = data.speed or DEF_SPEED
    if self.inst.components.equippable ~= nil then
        self.inst.components.equippable.walkspeedmult = self.speed
    end
end

return ZxSpeed