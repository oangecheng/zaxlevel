-- 交易组件
-- 能够更好的处理多个组件都能交易的情况，避免trader函数被覆盖
-- 如果其他mod没有对函数做兼容，abletoaccepttest 有可能被覆盖导致功能失效

local ZxTrader  = Class(function(self, inst)
    self.inst = inst
    self.testfnlist = {}
    self.accpetfnlist = {}

    if inst.components.trader == nil then 
        inst:AddComponent("trader")
    end

    local trader = inst.components.trader
    -- 如果之前有其他功能设置过可给予的功能，需要保存下
    local oldTradeTest = trader.abletoaccepttest
    local oldGiveFn = trader.onaccept

    trader:SetAbleToAcceptTest(function(inst, item, giver)
        for i = 1, #testfnlist do
            local fn = testfnlist[i]
            if fn == nil or fn(inst, item, giver) then
                return true
            end
        end
        if oldTradeTest == nil or oldTradeTest(inst, item, giver) then
            return true
        end
        return false
    end)

    trader.onaccept = function(inst, giver, item)
        if oldGiveFn ~= nil then
            oldGiveFn(inst, giver, item)
        end
        for i = 1, #accpetfnlist do
            local fn =  accpetfnlist[i]
            if fn ~= nil then 
                fn(inst, giver, item)
            end
        end
        giver.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
    end

end)


function ZxTrader:SetAbleToAcceptTest(fn)
    table.insert(testfnlist, fn)
end


function ZxTrader:SetOnAcceptItem(fn)
    if fn ~= nil then
        table.insert(accpetfnlist, fn)
    end
end



return ZxTrader