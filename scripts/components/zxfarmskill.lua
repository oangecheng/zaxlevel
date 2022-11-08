

local ZxFarmSkill = Class(function(self, inst)
    self.inst = inst
    self.level = 0
end)


function ZxFarmSkill:OnLevelUp()
    self.level = self.level + 1
end


function ZxFarmSkill:OnSave()
    return {
        level = self.level,
    }
end


function ZxFarmSkill:OnLoad(data)
    self.level = data.level or 0
end


return ZxFarmSkill