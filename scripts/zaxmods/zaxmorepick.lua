
PICKABLE_DEFS = {
    "grass",
    "sapling",
    "reeds",
    "flower",
    "carrot_planted",
    "flower_evil",
    "berrybush",
    "berrybush2",
    "berrybush_juicy",
    "cactus",
    "oasis_cactus",
    "red_mushroom",
    "green_mushroom",
    "blue_mushroom",
    "cave_fern",
    "cave_banana_tree",
    "lichen",
    "marsh_bush",
    "flower_cave",
    "flower_cave_double",
    "flower_cave_triple",
    "sapling_moon",
    "succulent_plant",
    "bullkelp_plant",
    "wormlight_plant",
    "stalker_berry",
    "stalker_bulb",
    "stalker_bulb_double",
    "stalker_fern",
    "rock_avocado_bush",
    "rosebush", --棱镜蔷薇花
    "orchidbush", --棱镜兰草花
    "lilybush", --棱镜蹄莲花
    "monstrain", --棱镜雨竹
    "shyerryflower", --棱镜颤栗花
    "oceanvine",--苔藓藤条
    "bananabush",
}

-- 多倍采集组件
-- 支持给可采集的物品添加多倍采集功能
-- 不支持农场
local function calculatePickMulti(inst)
    local level = inst.components.rolelevel
    -- 没有等级，30%概率双倍采集
    if level == nil then
        if math.random() < 0.3 then
            return 2
        else
            return 1
        end 
    end

    -- 初始20%采集概率
    -- 等级提升概率提高，双倍采集和三倍采集的概率提高
    -- 双倍采集概率上限60%，三倍概率为双倍的1/10
    local rd = math.random()
    local range = math.min(math.max(level.level, 20)/100, 0.6)

    if rd < 0.005 then
        inst.components.talker:Say("太走运了！赶紧去买个彩票！")
        return 10
    elseif rd < range/10 then
        inst.components.talker:Say("运气还不错...")
        return 3
    elseif rd < range then return 2
    else return 1 end
end

local function morePick(inst)
    -- 不可采集直接返回
    if not inst.components.pickable then
        return
    end

    -- 记录原始函数
    inst.components.pickable.OldPick = inst.components.pickable.Pick
    
    function inst.components.pickable:Pick(picker)
        -- 记录原始数据
        local oldnum = self.numtoharvest
        self.numtoharvest = self.numtoharvest * calculatePickMulti(picker)
        -- 调用原始的采集函数，重置变量
        inst.components.pickable:OldPick(picker)
        self.numtoharvest = oldnum
    end

end


if GLOBAL.TheNet:GetIsServer() then
    local list = PICKABLE_DEFS
    for i = 1, #list do
        AddPrefabPostInit(list[i], function(inst)
            morePick(inst)
        end)
    end
end


