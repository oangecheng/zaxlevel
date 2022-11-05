-- 可升级精神恢复的mod
-- 首先需要使用暗影之心进行能力解锁
-- 解锁之后使用海象帽进行升级，每次升级，精神恢复+1
-- 开启概率升级之后，等级越高，升级失败的概率也越大， 前12级必然成功

-- 给予黑暗，必将获得光明，但也要支付代价
-- 代价是物品原有的恢复精神能力变为0

local UNLOCK_ITEM = "shadowheart"
local UPGRADE_ITEM = "walrushat"
local DAPPERNESS_RATIO = TUNING.DAPPERNESS_MED / 3


local ZxDapperness = Class(function(self, inst)
    self.inst = inst
    self.dapperness = 0
    self.dappernessunlock = false
end)


function ZxDapperness:AcceptTest(item)
    local prefab = item.prefab
    if not self.dappernessunlock  then
        if prefab == UNLOCK_ITEM then
            return true
        end
    elseif prefab == UPGRADE_ITEM then
        return true
    end

    return false
end


function ZxDapperness:GiveItem(giver, item)
    local prefab = item.prefab
    if prefab == UNLOCK_ITEM then
        self.dappernessunlock = true
        self.inst.components.equippable.dapperness = 0
        giver.components.talker:Say("现在可以使用海象帽提升精神恢复了！")
    elseif prefab == UPGRADE_ITEM then
        local success = true
        if TUNING.useUpgradePolicy then 
            if math.random(1, math.max(self.dapperness, 2)) > 12 then
                success = false
            end
        end
        if success then
            self.dapperness = self.dapperness + 1
            self.inst.components.equippable.dapperness = self.dapperness * DAPPERNESS_MED
        else
            giver.components.talker:Say("运气不好，失败了...")
        end
    end
end


function ZxDapperness:OnSave()
    local data = {
        dapperness = self.dapperness,
        dappernessunlock = self.dappernessunlock,
    }
    return data
end


function ZxDapperness:OnLoad(data)
    self.dapperness = data.dapperness or 0
    self.dappernessunlock = data.dappernessunlock or false

    if self.dappernessunlock and self.inst.components.equippable ~= nil then
        inst.components.equippable.dapperness = self.dapperness * DAPPERNESS_RATIO
    end
end


return ZxDapperness