
local CHOP_ITEM = "largechop_certificate"
local MINE_ITEM = "largeminer_certificate"
local MAX_CHOP_MULTI = 15
local MAX_MINE_MULTI = 10


local function chop(inst)
    local zxwork = inst.components.zxwork
    local m = math.max(MAX_CHOP_MULTI - zxwork.chopmulti, 1)
    inst.components.tool:SetAction(ACTIONS.CHOP, MAX_CHOP_MULTI/m)
end

local function mine(inst)
    local zxwork = inst.components.zxwork
    local m = math.max(MAX_MINE_MULTI - zxwork.minemulti, 1)
    inst.components.tool:SetAction(ACTIONS.MINE, MAX_MINE_MULTI/m)
end


local function itemTradeTest(inst, item, giver)
    local zxwork = inst.components.zxwork
    local prefab = item.prefab
    local s = zxwork.chopmulti
    print("hahahh"..s)
    if zxwork.chopmulti < MAX_CHOP_MULTI then
        if prefab == CHOP_ITEM then
            return true
        end
    end

    if zxwork.minemulti < MAX_MINE_MULTI then
       if prefab == MINE_ITEM then
            return true
        end
    end 

    return false
end


local function itemGive(inst, giver, item)
    local prefab = item.prefab
    local zxwork = inst.components.zxwork
    if prefab == CHOP_ITEM then
        local str = (zxwork.chopmulti == 0) and "可以使用武器进行伐木了！" or "伐木效率提升！"
        giver.components.talker:Say(str)
        zxwork.chopmulti = math.min(zxwork.chopmulti + 5, MAX_CHOP_MULTI)
        chop(inst)
    elseif prefab == MINE_ITEM then
        local str = (zxwork.minemulti == 0) and "可以使用武器进行挖矿了！" or "挖矿效率提升！"
        giver.components.talker:Say(str)
        zxwork.minemulti = math.min(zxwork.minemulti + 3, MAX_MINE_MULTI)
        mine(inst)
    end
end


local ZxWork = Class(function(self, inst)
    self.inst = inst
    self.chopmulti = 0
    self.minemulti = 1
    inst:AddComponent("tool")
    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)
end)


function ZxWork:OnSave()
    return {
       chopmulti = self.chopmulti,
       minemulti = self.minemulti,
    }
end


function ZxWork:OnLoad(data)
    self.chopmulti = data.chopmulti or 0
    self.minemulti = data.minemulti or 1
    if self.inst.components.tool ~= nil then
        if self.chopmulti > 0 then
           chop(self.inst)
        end
        if self.minemulti > 1 then
            mine(self.inst)
        end
    end
end


return ZxWork