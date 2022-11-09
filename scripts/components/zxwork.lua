
local CHOP_ITEM = "largechop_certificate"
local MINE_ITEM = "largeminer_certificate"
local MAX_CHOP_MULTI = 15
local MAX_MINE_MULTI = 10


local function itemTradeTest(inst, item, giver)
    local prefab = item.prefab
    if prefab == CHOP_ITEM and self.chopmulti < MAX_CHOP_MULTI then
        return true
    elseif prefab == MINE_ITEM and self.minemulti < MAX_MINE_MULTI then
        return true
    else
        return false
    end 
end


local function itemGive(inst, giver, item)
    local prefab = item.prefab
    local zxwork = inst.components.zxwork
    if prefab == CHOP_ITEM then
        local str = (zxwork.chopmulti == 0) and "可以使用武器进行伐木了！" or "伐木效率提升！"
        giver.components.talker:Say(str)
        zxwork.chopmulti = math.max(zxwork.chopmulti + 5, MAX_CHOP_MULTI)
        zxwork.inst.components.tool:SetAction(ACTIONS.CHOP, zxwork.chopmulti)
    elseif prefab == MINE_ITEM then
        local str = (zxwork.minemulti == 0) and "可以使用武器进行挖矿了！" or "挖矿效率提升！"
        giver.components.talker:Say(str)
        zxwork.minemulti = math.max(zxwork.minemulti + 3, MAX_MINE_MULTI)
        zxwork.inst.components.tool:SetAction(ACTIONS.MINE, zxwork.minemulti)
    end
end


local ZxWork = Class(function(self, inst)
    self.inst = inst
    self.chopmulti = 0
    self.minemulti = 0
    inst:AddComponent("tool")
    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)
end)


function ZxWork:OnSave()
    local data = {
       chopmulti = self.chopmulti,
       minemulti = self.minemulti,
    }
end


function ZxWork:OnLoad(data)
    self.chopmulti = data.chopmulti or 1
    self.minemulti = data.minemulti or 1
    if inst.components.tool ~= nil then
        if self.chopmulti > 0 then
            inst.components.tool:SetAction(ACTIONS.CHOP, self.chopmulti)
        end
        if self.minemulti > 0 then
            inst.components.tool:SetAction(ACTIONS.MINE, self.minemulti)
        end
    end
end


return ZxWork