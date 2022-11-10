-- 最大肥力倍率
local MAX_FERTILIZE_MULTI = 3


-- 作物被采集的时候监听事件
-- 收获巨大作物种植等级+1
local function onPlantPicked(inst)
    inst:ListenForEvent("picked", function(inst, data)
        if data and data.picker and data.plant then
            local farmskill = data.picker.components.zxfarmskill
            if farmskill and data.plant.is_oversized then
                farmskill:OnHarvestLargePlant()
            end
        end
    end)
end


-- 对作物采集进行监听
local function listenPlantPickedEvent()
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	local DEFS = {}
	for k, v in pairs(PLANT_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(DEFS) do
		if not v.data_only then
			AddPrefabPostInit(v.prefab, onPlantPicked)
		end
	end
end



-- 计算施肥倍率
-- 每20级提升一个倍率，倍率无上限，但是施肥的最大值是 100
local function calcFertilizeMulti(deployer)
    if not deployer then return 1 end
    local farmskill = deployer.components.zxfarmskill
    if farmskill then
        local lv = farmskill.level
        return 1 + (lv / 20)
    end
    -- default value
    return 1
end



-- 根据用户等级计算肥力值的倍率对肥力值进行修改
-- 并且返回原始的肥力值，如果之前的肥力值不存在，则返回nil
local function tryModifyNutrients(fertilizer, deployer)
    if not fertilizer or not deployer then return nil end
    local cacheValue = fertilizer.nutrients
    if not cacheValue then return nil end

    local multi = calcFertilizeMulti(deployer)
    local newValue = {}
    for i,v in ipairs(cacheValue) do
        -- 土地肥力值的上限就是100
        table.insert(newValue, math.min(math.floor(v * multi), 100))
    end
    fertilizer.nutrients = newValue
    return cacheValue
end



-- hook ondeploy函数
-- 在回调之前篡改肥力值，回调后恢复
local function hookOnDeploy(deployable)
    deployable.OldDeploy = deployable.Deploy
    function deployable:Deploy(pt, deployer, rot)
        local inst = self.inst
        local fertilizer = inst.components.fertilizer
        local ret = tryModifyNutrients(fertilizer, deployer)
        deployable:OldDeploy(pt, deployer, rot)
        if ret then
            inst.components.fertilizer.nutrients = ret
        end
    end
end



local function hookDeployable()
    AddComponentPostInit("deployable", hookOnDeploy)
end



-- 这里不处理植物人吃肥料
if GLOBAL.TheNet:GetIsServer() then
    listenPlantPickedEvent()
    hookDeployable()
end