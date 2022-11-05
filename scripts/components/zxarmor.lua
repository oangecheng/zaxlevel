
local CON_UPGRADE_ITEM = "dragon_scales"
local CON_RECOVER_ITEM = "goldnugget"
local CON_MAX_VALUE = 10000


local function hookArmor(armor, self)
    armor.indestructible = true
    armor.ontakedamage = function(inst, damage)
    end
end


local function updateMaxCondition(inst, maxcondition)
    inst.components.armor.maxcondition = maxcondition
    local percent = inst.components.armor:GetPercent()
    inst.components.armor:SetPercent(percent)
end



local ZxArmor = Class(function(self, inst)
    self.inst = inst
    self.maxcondition = inst.components.armor.maxcondition
    self.condition  = self.maxcondition
    self.maxconditionunlock = false
end)



function ZxArmor:AcceptTest(item)
    local prefab = item.prefab
    if prefab == CON_UPGRADE_ITEM and self.maxcondition < CON_MAX_VALUE then
        return true
    elseif prefab == CON_RECOVER_ITEM then
        return true
    else
        return false
    end
end


function ZxArmor:GiveItem(giver, item)
    local prefab = item.prefab
    if prefab == CON_UPGRADE_ITEM then
        self.maxcondition = self.maxcondition + 200
        updateMaxCondition(self.inst, self.maxcondition)
    elseif prefab == CON_RECOVER_ITEM then
        local amount = math.max(300, self.maxcondition * 0.2)
        self.inst.components.armor:Repair(amount)
    end
end



function ZxArmor:OnSave()
    local data = {
        maxcondition = self.maxcondition,
        maxconditionunlock = self.maxconditionunlock,
    }
    return data
end


function ZxArmor:OnLoad(data)
    self.maxcondition = data.maxcondition or 100
    self.maxconditionunlock = data.maxconditionunlock or false
    updateMaxCondition(self.inst, self.maxcondition)
end



return ZxArmor