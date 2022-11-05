-- 给物品添加可给予组件
function TryAddTraddable(inst)
    -- 服务端才能加组件
    if not GLOBAL.TheNet:GetIsServer() then
        return
    end

    -- 如果没有可交易组件，添加
    if inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
end


-- 给预制体添加可给予组件
function TryAddTraddablePerfab(prefab)
    AddPrefabPostInit(prefab, function(inst)
        TryAddTraddable(inst)
    end)
end


-- 尝试给物品添加可交易组件
function TryAddTrader(inst, testfn, givefn)
    if not GLOBAL.TheNet:GetIsServer() then
        return
    end
    if inst.components.trader == nil then
        inst:AddComponent("trader")
    end

    local trader = inst.components.trader
    local oldTestFn = trader.abletoaccepttest
    local oldGiveFn = trader.onaccept

    trader:SetAbleToAcceptTest(function(inst, item, giver)
        if oldTestFn ~= nil then
            return oldTestFn(inst, item, giver) or testfn(inst, item, giver)
        else
            return testfn(inst, item, giver) 
        end
    end)

    trader.onaccept = function(inst, giver, item)
        if oldGiveFn ~=nil then
            oldGiveFn(inst, giver, item)
        end
        givefn(inst, giver, item)
    end
end