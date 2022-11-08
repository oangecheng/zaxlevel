
local function calculateHarvestMulti(picker)
	local rolelevel = picker.components.rolelevel

	if rolelevel == nil and math.random() < 0.3 then
		return 2
	end

	-- 随等级提升概率上涨
	-- 2倍采集上限50%，3倍上限12.5%，千分之二概率10倍
	local range = math.min(rolelevel.level, 60)
	if math.random() < range/100 then
		return 2
	elseif math.random() < range/400 then
		return 3
	elseif math.random() < 0.002 then
		picker.components.talker:Say("我真是太走运了！")
		return 10
	else
		return 1
	end
end

local function farmharvest(inst)
	local pickable = inst.components.pickable
	if pickable == nil then
		return
	end
	inst:ListenForEvent("picked", function(data)
		if data.plant == nil or not data.plant.is_oversized then
			return
		end
		local picker  = data.picker
		if picker ~=nil and picker.components.zxfarmskill ~= nil then
			picker.components.zxfarmskill:OnLevelUp()
			picker.components.talker:Say("我的种田能力提升了！等级"..picker.components.zxfarmskill.level)
		end	
	end)

	local OldPick = pickable.Pick
	function pickable:Pick(picker)
		local oldnum =  pickable.numtoharvest
		pickable.numtoharvest = oldnum * calculateHarvestMulti(picker)
		pickable:OldPick(picker)
		self.numtoharvest = oldnum
	end
end


if GLOBAL.TheNet:GetIsServer() then
    --新版农场
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	local DEFS = {}
	for k, v in pairs(PLANT_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(WEED_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(DEFS) do
		if not v.data_only then
			AddPrefabPostInit(v.prefab, function(inst)
				farmharvest(inst)
			end)
		end
	end
end