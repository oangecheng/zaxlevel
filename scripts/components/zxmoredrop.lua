--击杀怪物额外掉落组件
--开启后击杀生物 30% 概率掉落双倍物品

local MAX_LEVEL = 200


-- 额外掉落
function moreItemDrop(inst, data)
    local victim = data.victim
    local dropper = victim.components.lootdropper

    if dropper == nil then
        return
    end
   
    if victim.components.freezable or victim:HasTag("monster") then
        -- 50%概率双倍掉落
        -- 5% 三倍掉落
        local moredrop = inst.components.zxmoredrop
        local ratio = (moredrop.level + 300) / 1000
        local rd = math.random()
        if rd < ratio/10 then 
            dropper:DropLoot()
            dropper:DropLoot()
        elseif rd < ratio then
            dropper:DropLoot() 
        end            

        if victim.components.health ~= nil then
            local maxHealth = math.ceil(victim.components.health.maxhealth)
            if not maxHealth < 1000 then
                inst.components.zxmoredrop:OnLevelUp()
            end
        end
    end
    
end


local ZxMoreDrop = Class(function(self, inst)
    self.inst = inst
    self.level = 0
    self.inst:ListenForEvent("killed", moreItemDrop)
end)


function ZxMoreDrop:OnLevelUp()
    self.level = math.max(self.level + 1, MAX_LEVEL)
end


function ZxMoreDrop:OnSave()
    return {
        level = self.level,
    }
end


function ZxMoreDrop:OnLoad(data)
    self.level = data.level or 0
end


return ZxMoreDrop