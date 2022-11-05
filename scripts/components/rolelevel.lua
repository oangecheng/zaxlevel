--角色升级组件
--角色初始属性都会被替换为三维 100 100 100
--每提升一级全属性 +1
--击杀怪物 或者 吃好吃的食物 获得经验进行升级


-- 可获得经验的食物定义
local FOOD_DEFS = {
    {"moqueca", 3000}, -- 海鲜杂烩
    {"lobsterdinner", 3000}, --龙虾正餐
    {"surfnturf", 2000}, -- 海鲜牛排
    {"honeyham", 2000}, -- 蜜汁火腿
    {"turkeydinner", 2000}, -- 火鸡正餐
    {"bonestew", 1000}, -- 大肉汤
    {"meat_dried", 500}, -- 风干肉
    {"fish", 500}, -- 包含鱼的食物
    {"eel", 300}, -- 鳗鱼
}


local DEF_HUNGER = 100
local DEF_SANITY = 100
local DEF_HEALTH = 100


-- 查找吃下的食物是否能够获得经验
-- 这里使用string.find函数，也就是加buff的料理同样能够获得经验
local function findFood(inst, food)
    if food == nil or food.prefab == nil then
        return nil
    end

    local name = food.prefab
    local list = FOOD_DEFS

    for i=1, #list do
        local index = string.find(name, list[i][1])
        if index ~=nil then
            return list[i]
        end
    end

    return nil
end


-- 角色升级
local function onLevelUp(inst)

	local lv = inst.components.rolelevel.level
	-- 播放音效
	inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	inst.components.talker:Say("我变得更强了! 等級"..lv)

    --饥饿判定
	local hunger_percent = inst.components.hunger:GetPercent()
	inst.components.hunger.max = DEF_HUNGER + lv * 1
	inst.components.hunger:SetPercent(hunger_percent)
	--脑力判定
	local sanity_percent = inst.components.sanity:GetPercent()
	inst.components.sanity.max = DEF_SANITY + lv * 1
	inst.components.sanity:SetPercent(sanity_percent)
	--血量判定
	local health_percent = inst.components.health:GetPercent()
	inst.components.health.maxhealth = DEF_HEALTH + lv * 1
	inst.components.health:SetPercent(health_percent)
end


-- 处理获得经验
local function onGetExp(inst, exp)
    local clevel = inst.components.rolelevel
    local maxExp = 200 * clevel.level + 100

    clevel.exp = clevel.exp + exp
    if clevel.exp > maxExp then
        clevel.exp = 0
        clevel.level = clevel.level + 1

        onLevelUp(inst)
        -- 升级后回血20%
        inst.components.health:DoDelta(inst.components.health.maxhealth / 5)
    end
end


-- 监听杀怪物的事件
local function onKilledOther(inst, data)
    local victim = data.victim
    local maxVictimHealth = 0
    if victim.components.freezable or victim:HasTag("monster") and victim.components.health then
         maxVictimHealth = math.ceil(victim.components.health.maxhealth)
    end

    if maxVictimHealth == 0 then
        return
    end

    onGetExp(inst, maxVictimHealth)
end


-- 监听吃食物的事件
local function onEatFood(inst, data)
    local target = findFood(inst, data)
    if target ~= nil then
        local foodExp = target[2]
        inst.components.talker:ShutUp()
        inst.components.talker:Say("味道好极了! 经验 +"..foodExp)
        onGetExp(inst, foodExp)
    end
end



local rolelevel = Class(
    function(self, inst)
        self.inst = inst
        self.level = 0
        self.exp = 0
        self.zhunger = DEF_HUNGER
        self.zhealth = DEF_HEALTH
        self.zsanity = DEF_SANITY

        inst.components.hunger.max = self.zhunger
        inst.components.health.maxhealth = self.zhealth
        inst.components.sanity.max = self.zsanity
        inst.components.hunger:SetPercent(1)
        inst.components.sanity:SetPercent(1)
        inst.components.health:SetPercent(1)

        -- 监听杀怪事件
        self.inst:ListenForEvent("killed", onKilledOther)
        self.inst.components.eater:SetOnEatFn(onEatFood)

    end,
    nil,
    {}
)


function rolelevel:OnSave()
    local data = {
        level = self.level,
        exp = self.exp,
        zhunger = math.ceil(self.inst.components.hunger.current),
        zhealth = math.ceil(self.inst.components.health.currenthealth),
        zsanity = math.ceil(self.inst.components.sanity.current),
    }
    return data
end


function rolelevel:OnLoad(data)
    -- 读取存储的值
    self.level = data.level or 0
    self.exp = data.exp or 0
    self.zhunger = data.zhunger or DEF_HUNGER
    self.zhealth = data.zhealth or DEF_HEALTH
    self.zsanity = data.zsanity or DEF_SANITY

    -- 角色属性赋值
    local inst = self.inst
    local clevel = inst.components.rolelevel
    inst.components.hunger.max = 100 + clevel.level * 1
    inst.components.sanity.max = 100 + clevel.level * 1
    inst.components.health.maxhealth = 100 + clevel.level * 1
    inst.components.hunger:SetPercent(clevel.zhunger / inst.components.hunger.max)
    inst.components.sanity:SetPercent(clevel.zsanity / inst.components.sanity.max)
    inst.components.health:SetPercent(clevel.zhealth / inst.components.health.maxhealth)
end


return rolelevel


