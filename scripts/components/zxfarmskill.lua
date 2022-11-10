

local function calcLevelUpNumRequired(level)
    return level
end


local ZxFarmSkill = Class(function(self, inst)
    self.inst = inst
    self.large_plant_num = 0 
    self.level = 0
end)


-- 收获大作物
function ZxFarmSkill:OnHarvestLargePlant()
    self.large_plant_num = self.large_plant_num + 1
    -- 等级越高，升级需要采摘的大作物就越多
    local level_up_num = calcLevelUpNumRequired(self.level)
    if self.large_plant_num >= level_up_num then
        self.level = self.level + 1
        self.inst.components.talker:Say("我是农民我骄傲，农业水平又提高！ 等级 "..tostring(self.level))
        self.large_plant_num = 0
    end
end


function ZxFarmSkill:OnSave()
    return {
        large_plant_num = self.large_plant_num,
        level = self.level,
    }
end


function ZxFarmSkill:OnLoad(data)
    self.large_plant_num = data.large_plant_num or 0
    self.level = data.level or 0
end


return ZxFarmSkill