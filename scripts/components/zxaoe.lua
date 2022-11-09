

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
	local oldonattack = weapon.onattack
	weapon:SetOnAttack(aoeAttack)
end


local ZxAoe = Class(function(self, inst)
    self.inst = inst
    addAoe(inst)
end)


return ZxAoe