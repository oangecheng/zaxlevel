
local CHOP_ITEM = "largechop_certificate"
local MINE_ITEM = "largeminer_certificate"
local MAX_CHOP_MULTI = 15
local MAX_MINE_MULTI = 10


local ZxWork = Class(function(self, inst)
    self.inst = inst
    self.chopmulti = 0
    self.minemulti = 0
    inst:AddComponent("tool")
end)


function ZxWork:AccpeptTest(item)
    local prefab = item.prefab
    if prefab == CHOP_ITEM and self.chopmulti < MAX_CHOP_MULTI then
        return true
    elseif prefab == MINE_ITEM and self.minemulti < MAX_MINE_MULTI then
        return true
    else
        return false
    end 
end


function ZxWork:GiveItem(giver, item)
    local prefab = item.prefab
    if prefab == CHOP_ITEM then
        self.chopmulti = math.max(self.chopmulti + 5, MAX_CHOP_MULTI)
        self.inst.components.tool:SetAction(ACTIONS.CHOP, self.chopmulti)
        giver.components.talker:Say("伐木效率提升！")
    elseif prefab == MINE_ITEM then
        self.minemulti = math.max(self.minemulti + 3, MAX_MINE_MULTI)
        self.inst.components.tool:SetAction(ACTIONS.MINE, self.minemulti)
        giver.components.talker:Say("挖矿效率提升！")
    end
end


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