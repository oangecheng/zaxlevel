
-- 能力解锁
UNLOCK_ITEM_W = "bearger_fur" -- 熊皮解锁保暖
UNLOCK_ITEM_S = "townportaltalisman" -- 砂石解锁隔热

-- 能力提升
UPGRDADE_ITEM_W = "trunk_winter" -- 冬象鼻提升保暖
UPGRDADE_ITEM_S = "trunk_summer" -- 夏象鼻提升隔热

-- 模式切换
CHAGE_ITEM_W = "bluegem" -- 蓝宝石切换保暖模式
CHAGE_ITEM_S = "redgem" -- 红宝石切换成隔热模式


local ZxInsulator = Class(
    function(self, inst)
        self.inst = inst
        -- 如果已经有保暖组件，附上物品初始的保暖值
        -- 如果没有，加上保暖组件
        local insulator = inst.components.insulator
        if insulator == nil then
            inst:AddComponent("insulator")
            insulator = inst.components.insulator
        end

        self.zxinsulation_w = 0
        self.zxinsulatorunlock_w = false
        self.zxinsulation_s = 0
        self.zxinsulatorunlock_s = false
        self.zxiswinter = insulator:IsType(SEASONS.WINTER)

        -- 物品如果有基础值，作为初始值
        if self.zxiswinter then
            self.zxinsulation_w = insulator.insulation
        else
            self.zxinsulation_s = insulator.insulation
        end
    end,
    nil,
    {}
)


function ZxInsulator:AcceptTest(inst, item, giver)
    local prefab = item.prefab

    -- 未解锁保暖，必须是解锁物品
    -- 已解锁保暖，必须是提升保暖的物品, 或者是模式切换物品
    if not self.zxinsulatorunlock_w then
        if prefab == UNLOCK_ITEM_W then
            return true
        end
    elseif prefab == UPGRDADE_ITEM_W then
        return true
    elseif prefab == CHAGE_ITEM_W then
        if not inst.components.insulator:IsType(SEASONS.WINTER) then
            return true
        end
    end

    if not self.zxinsulatorunlock_s then
        if prefab == UNLOCK_ITEM_S then
            return true
        end
    elseif prefab == UPGRDADE_ITEM_S then
        return true
    elseif prefab == CHAGE_ITEM_S then
        if not inst.components.insulator:IsType(SEASONS.SUMMER) then
            return true
        end
    end

    return false
end


function ZxInsulator:GiveItem(inst, giver, item)
    local ins = inst.components.insulator

    local str = nil

    if item.prefab == UNLOCK_ITEM_W then
        str = "解锁保暖升级，使用冬日象鼻升级..."
        self.zxinsulatorunlock_w = true
    end

    if item.prefab == UPGRDADE_ITEM_W then
        str = "保暖升级成功"
        self.zxinsulation_w = self.zxinsulation_w + 20
        if ins:IsType(SEASONS.WINTER) then
            ins:SetInsulation(self.zxinsulation_w)
        end
    end

    if item.prefab == CHAGE_ITEM_W then
        str = "切换到保暖模式"
        ins:SetInsulation(self.zxinsulation_w)
        ins:SetWinter()
    end

    if item.prefab == UNLOCK_ITEM_S then
        str = "解锁隔热升级，使用夏日象鼻升级..."
        self.zxinsulatorunlock_s = true
    end

    if item.prefab == UPGRDADE_ITEM_S then
        str = "隔热升级成功"
        self.zxinsulation_s = self.zxinsulation_s + 20
        if ins:IsType(SEASONS.SUMMER) then
            ins:SetInsulation(self.zxinsulation_s)
        end
    end

    if item.prefab == CHAGE_ITEM_S then
        str = "切换到隔热模式"
        ins:SetInsulation(self.zxinsulation_s)
        ins:SetSummer()
    end

    if str ~= nil then
        giver.components.talker:Say(str)
    end
end



function ZxInsulator:OnSave()
    local data = {
        zxinsulation_w = self.zxinsulation_w,
        zxinsulatorunlock_w = self.zxinsulatorunlock_w,
        zxinsulation_s = self.zxinsulation_s,
        zxinsulatorunlock_s = self.zxinsulatorunlock_s,
        zxiswinter = self.zxiswinter,
    }
    return data
end



function ZxInsulator:OnLoad(data)
    self.zxinsulation_w = data.zxinsulation_w or 0
    self.zxinsulatorunlock_w = data.zxinsulatorunlock_w or false
    self.zxinsulation_s = data.zxinsulation_s or 0
    self.zxinsulatorunlock_s = data.zxinsulatorunlock_s or false
    self.zxiswinter = data.zxiswinter or true

    local insulator = self.inst.components.insulator
    if self.zxiswinter and self.zxinsulatorunlock_w then
        insulator:SetInsulation(self.zxinsulation_w)
        insulator:SetWinter() 
    end
    if not self.zxiswinter and self.zxinsulatorunlock_s then
        insulator:SetInsulation(self.zxinsulation_s)
        insulator:SetSummer()
    end
end



return ZxInsulator