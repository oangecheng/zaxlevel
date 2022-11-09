
local AOE_ITEM = "bee_king_certificate"


local EXCLUDE_TAG_DEFS = {
	"INLIMBO",
	"companion", 
	"wall",
	"abigail", 
}

-- 判断是否为仆从
local function isFollower(inst, target)
	if inst.components.leader ~= nil then
		return inst.components.leader:IsFollower(target)
	end
	return false
end


-- 范围攻击
local function aoeAttack(inst, attacker, target)
    local combat = attacker.components.combat
    local x,y,z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, { "_combat" }, EXCLUDE_TAG_DEFS)
    for i, ent in ipairs(ents) do
        if ent ~= target and ent ~= attacker and combat:IsValidTarget(ent) and (not isFollower(attacker, ent)) then
            attacker:PushEvent("onareaattackother", { target = ent, weapon = inst, stimuli = nil })
            local damage = combat:CalcDamage(ent, inst, 1)
            ent.components.combat:GetAttacked(attacker, damage, inst, nil)
        end
    end
end


-- 添加aoe
local function addAoe(inst)
	local weapon = inst.components.weapon
	if weapon == nil then return end
	weapon:SetOnAttack(aoeAttack)
end



-- 可交易
local function itemTradeTest(inst, item, giver)
    local aoe = inst.components.zxaoe
    if not aoe.unlock then
        if item.prefab == AOE_ITEM then
            return true
        end
    end
    return false
end


-- 给予物品
local function itemGive(inst, giver, item)
    local aoe = inst.components.zxaoe
    if item.prefab == AOE_ITEM then
        aoe.unlock = true
        addAoe(inst)
        giver.components.talker:Say("获得范围伤害能力！")
    end
end


local ZxAoe = Class(function(self, inst)
    self.inst = inst
    self.unlock = false

    inst.components.zxtrader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.zxtrader:SetOnAcceptItem(itemGive)
end)


function ZxAoe:OnSave()
    return {
        unlock = self.unlock,
    }
end


function ZxAoe:OnLoad(data)
    self.unlock = data.unlock or false
    if self.unlock then
        addAoe(self.inst)
    end
end


return ZxAoe