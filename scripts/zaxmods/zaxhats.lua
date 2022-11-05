
local TRADDABLE_ITEM_DEFS = {
    "bearger_fur",
    "dragon_scales",
    "deerclops_eyeball",
    "townportaltalisman",
}

-- 给所有物品添加 tradable 组件
if GLOBAL.TheNet:GetIsServer() then
	local items = TRADDABLE_ITEM_DEFS
	-- 没有添加可交易组件的物品，添加上
	for i=1, #items do
		AddPrefabPostInit(items[i], function(inst) 
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end)
	end
end


local function acceptTest(inst, item, giver)
    return inst.components.zxinsulator:AcceptTest(inst, item, giver) 
        or inst.components.zxdapperness:AcceptTest(item)
        or inst.components.zxwaterproofer:AcceptTest(item)
end


local function onItemGiven(inst, giver, item)
   inst.components.zxinsulator:GiveItem(inst, giver, item)
   inst.components.zxdapperness:GiveItem(giver, item)
   inst.components.zxwaterproofer:GiveItem(giver, item)
end


if GLOBAL.TheNet:GetIsServer() then
    AddPrefabPostInit("walrushat", function(inst)
        inst:AddComponent("trader")
        inst:AddComponent("zxinsulator")
        inst:AddComponent("zxdapperness")
        inst:AddComponent("zxwaterproofer")
        inst.components.trader:SetAbleToAcceptTest(acceptTest)
        inst.components.trader.onaccept = onItemGiven
    end)

end