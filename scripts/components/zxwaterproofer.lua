
local UNLOCK_ITEM = "deerclops_eyeball"
local UPGRADE_ITEM = "pigskin"


local function getEffectiveness(zxwaterproofer)
    return math.min(1, zxwaterproofer/100)
end

local ZxWaterProofer = Class(function(self, inst)
    self.inst = inst
    self.waterproofer = 0
    self.waterprooferunlock = false

    -- 没有防水组件，添加
    if inst.components.waterproofer == nil then
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(0)
    else
        self.waterproofer = inst.components.waterproofer:GetEffectiveness()
    end
end)


function ZxWaterProofer:AcceptTest(item)
    local prefab = item.prefab
    if not self.waterprooferunlock then
        if prefab == UNLOCK_ITEM  then
            return true
        end
    elseif prefab == UPGRADE_ITEM and self.waterproofer < 1 then
        return true
    end
    return false
end


function ZxWaterProofer:GiveItem(giver, item)
    local prefab = item.prefab
    -- 解锁防水
    if prefab == UNLOCK_ITEM then
        self.waterprooferunlock = true
        giver.components.talker:Say("现在可以使用猪皮升级防水了！")
    -- 猪皮升级
    elseif prefab == UPGRADE_ITEM then
        local success = true
        -- 开启概率升级，等级越高概率越低
        if TUNING.useUpgradePolicy then 
            if math.random(1, math.max(2, self.waterproofer * 100)) > 60 then
                success = false
            end
        end
        if success then
            self.waterproofer = self.waterproofer + 0.01
            self.inst.components.waterproofer:SetEffectiveness(self.waterproofer) 
        else
            giver.components.talker:Say("这猪皮质量不太行...")
        end
    end
end


function ZxWaterProofer:OnSave()
    local data = {
        waterproofer = self.waterproofer,
        waterprooferunlock = self.waterprooferunlock,
    }
end


function ZxWaterProofer:OnLoad(data)
    self.waterproofer = data.waterproofer
    self.waterprooferunlock = data.waterprooferunlock

    if self.waterprooferunlock then
        self.inst.components.waterproofer:SetEffectiveness(self.waterproofer)
    end
end


return ZxWaterProofer