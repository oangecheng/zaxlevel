--击杀怪物额外掉落组件
--开启后击杀生物 30% 概率掉落双倍物品


-- 额外掉落
function moreItemDrop(inst, data)
    local victim = data.victim
    local dropper = victim.components.lootdropper

    if dropper == nil then
        return
    end
   
    if victim.components.freezable or victim:HasTag("monster") then
        -- 50%概率双倍掉落
        if math.random(1, 100) <= 30 then
            dropper:DropLoot()
        end
    end
    
end

local extradrop = Class(
    function(self, inst)
        self.inst = inst
        self.inst:ListenForEvent("killed", moreItemDrop)
    end,
    nil,
    {}
)

return extradrop