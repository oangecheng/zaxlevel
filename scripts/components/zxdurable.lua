-- 耐久升级组件
local UNLOCK_ITEM = "dragon_scales"
local UPGRADE_ITEM_ARMOR = "steelwool"
local UPGRADE_ITEM_WEAPON = "livinglog"
local RECOVER_ITEM_ARMOR = "goldnugget"
local RECOVER_ITEM_WEAPON = "houndstooth"
local MAX_WEAPON = 2000
local MAX_ARMOR = 10000


local function isArmor(self)
    return self.inst.components.armor ~= nil
end


local function isWeapon(self)
    return self.inst.components.finiteuses ~= nil
end


local function updateMaxDurable(inst, maxdurable)
    local finiteuses = inst.components.finiteuses
    local armor = inst.components.armor
    if finiteuses ~= nil then
        finiteuses.maxuses = maxdurable
        local percent = finiteuses:GetPercent()
        finiteuses:SetPercent(percent)
    elseif armor ~= nil then
        armor.maxcondition = maxdurable
        local percent = armor:GetPercent()
        armor:SetPercent(percent)
     end
end


local ZxDurable = Class(function(self, inst)
    self.inst = inst
    self.maxdurable = 0
    self.maxdurableunlock = false

    if inst.components.finiteuses ~= nil then
        self.maxdurable = inst.components.finiteuses.maxuses
    elseif inst.components.armor ~=nil then
        self.maxdurable = inst.components.armor.maxcondition
    end
end)




function ZxDurable:AcceptTest(item)
    local prefab = item.prefab
    if not self.maxdurableunlock then
        if prefab == UNLOCK_ITEM then
            return true
        end
    elseif isWeapon(self) then 
        if prefab == UPGRADE_ITEM_WEAPON then
            return self.maxdurable < MAX_WEAPON
        elseif prefab == RECOVER_ITEM_WEAPON then
            return true
        end
    else 
        if prefab == UPGRADE_ITEM_ARMOR then
            return self.maxdurable < MAX_ARMOR
        elseif prefab == RECOVER_ITEM_ARMOR then
            return true
        end 
    end

    return false
    
end


function ZxDurable:GiveItem(giver, item)
    local prefab = item.prefab

    if prefab == UNLOCK_ITEM then 
        self.maxdurableunlock = true
        giver.components.talker:Say("可以升级和修复耐久了！")

    -- 升级武器耐久
    elseif prefab == UPGRADE_ITEM_WEAPON then
        local success = true
        if TUNING.useUpgradePolicy then
            success = math.random(1, math.max(2, self.maxdurable)) < (MAX_WEAPON * 0.3)
        end
        if success then
            self.maxdurable = math.max(self.maxdurable + 100, MAX_WEAPON)
            updateDurable(self.inst, self.maxdurable)
        else
            giver.components.talker:Say("材料太脆弱了...")
        end
    elseif prefab == RECOVER_ITEM_WEAPON then
        

    -- 升级护甲耐久
    elseif prefab == UPGRADE_ITEM_ARMOR then 
        local success = true
        if TUNING.useUpgradePolicy then
            success =  math.random(1, math.max(2, self.maxdurable)) < (MAX_ARMOR * 0.3)
        end
        if success then
            self.maxdurable = math.max(self.maxdurable + 100, MAX_ARMOR)
            updateDurable(self.inst, self.maxdurable)
        else
            giver.components.talker:Say("材料太脆弱了...")
        end
    
    end
end



function ZxDurable:OnSave()
    local data = {
        maxdurable = self.maxdurable,
        maxdurableunlock = self.maxdurableunlock,
    }
    return data
end



function ZxDurable:OnLoad(data)
    self.maxdurable = data.maxdurable or 100
    self.maxdurableunlock = data.maxdurableunlock or false

    if self.maxdurableunlock then
        updateDurable(self.inst, self.maxdurable)
    end
    
end


return ZxDurable