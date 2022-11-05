--角色强化组件
--击杀血量高于4000的怪物能够增强攻击和防御属性

MAX_ABSORB = 0.3
MAX_DAMAGE = 1.5

DEF_ABSORB = 0
DEF_DAMAGE = 1


-- 击杀血量高于4000的怪物可获得防御/攻击/移速加强
function onkilledother(inst, data)

    local victim = data.victim

    if victim.components.health == nil then
        return
    end

    local monsterMaxHealth = math.ceil(victim.components.health.maxhealth)
    if monsterMaxHealth < 4000 then
        return
    end

    -- 获取加强组件
    local strenth = inst.components.rolestrenth
    -- 攻击上限50%
    if strenth.zdamage < MAX_DAMAGE then
        inst.components.talker:Say("属性提升!")
        strenth.zdamage = strenth.zdamage + 0.01
        inst.components.combat.externaldamagemultipliers:SetModifier("zdamage", strenth.zdamage)
    end

    -- 防御上限30%
    if strenth.zabsorb < MAX_ABSORB then
        strenth.zabsorb = strenth.zabsorb + 0.01
        inst.components.health.externalabsorbmodifiers:SetModifier("zabsorb", strenth.zabsorb)
    end

end


local rolestrenth = Class(
    function(self, inst)
        self.inst = inst
        self.zdamage = DEF_DAMAGE
        self.zabsorb = DEF_ABSORB
        -- 监听杀怪事件
        self.inst:ListenForEvent("killed", onkilledother)
    end,
    nil,
    {}
)

function rolestrenth:OnSave()
    local data = {
        zdamage = self.zdamage,
        zabsorb = self.zabsorb,
    }
    return data
end


function rolestrenth:OnLoad(data)
    self.zdamage = data.zdamage or DEF_DAMAGE
    self.zabsorb = data.zabsorb or DEF_ABSORB

    -- 初始化时配置角色属性
    self.inst.components.combat.externaldamagemultipliers:SetModifier("zdamage", self.zdamage)
    self.inst.components.health.externalabsorbmodifiers:SetModifier("zabsorb", self.zabsorb)
end

return rolestrenth