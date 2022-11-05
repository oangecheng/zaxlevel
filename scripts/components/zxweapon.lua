MAX_DAMAGE = 80 -- 最大攻击力
MAX_WALK_SPEED = 1.5 -- 最大移速加成
MAX_USES = 2000 -- 最大使用次数上限
DEF_SPEED = 1.1


local function onUseFinished(inst)
	inst.components.finiteuses:SetPercent(0)
	inst.components.weapon:SetDamage(0)
end


local ZxWeapon = Class(
	function(self, inst)
		self.inst = inst
		self.damage = 0
		self.maxuses = 0
		self.walkspeed = DEF_SPEED
		self.onupgrage = nil
		
		if inst.components.finiteuses ~= nil then
			self.maxuses = inst.components.finiteuses.total
			inst.components.finiteuses:SetOnFinished(onUseFinished)
		end
		if inst.components.weapon ~= nil then
			self.damage = inst.components.weapon.damage
		end
		if self.inst.components.equippable ~= nil then
			self.inst.components.equippable.walkspeedmult = self.walkspeed
		end
	end,
	nil,
	{}
)

-- 攻击升级
function ZxWeapon:UpgradeDamage(value)
	self.damage = math.min(self.damage + value, MAX_DAMAGE)
	if self.inst.components.weapon ~= nil then
		self.inst.components.weapon:SetDamage(self.damage)
	end
end


-- 最大次数升级
function ZxWeapon:UpgradeMaxUses(value)
	self.maxuses = math.min(self.maxuses + value, MAX_USES)
	local finiteuses = self.inst.components.finiteuses
	if finiteuses ~= nil then
		local percent = finiteuses.current / finiteuses.total
		finiteuses:SetMaxUses(self.maxuses)
		finiteuses:SetPercent(percent)
	end
end


-- 移速升级
function ZxWeapon:UpgradeWalkSpeed(value)
	self.walkspeed = math.min(self.walkspeed + value, MAX_WALK_SPEED)
	if self.inst.components.equippable ~= nil then
		self.inst.components.equippable.walkspeedmult = self.walkspeed
	end
end

-- 恢复耐久
function ZxWeapon:RecoverUses(value)
	local finiteuses = self.inst.components.finiteuses
	if finiteuses ~=nil then 
		local percent = math.max(100/self.maxuses, value)
		percent = math.min(finiteuses:GetPercent() + percent, 1)
		finiteuses:SetPercent(percent)
		-- 恢复攻击力
		self.inst.components.weapon:SetDamage(self.damage)
	end
end


-- 判断是否未到伤害上限
function ZxWeapon:IsNotMaxDamage()
	return self.damage < MAX_DAMAGE
end


-- 判断是否未到移速上限
function ZxWeapon:IsNotMaxWalkSpeed()
	return self.walkspeed < MAX_WALK_SPEED
end


-- 判断是否未到最大次数上限
function ZxWeapon:IsNotMaxUses()
	return self.maxuses < MAX_USES
end


function ZxWeapon:OnSave()
	local data = {
		damage = self.damage,
		maxuses = self.maxuses,
		walkspeed = self.walkspeed,
	}
	return data
end

function ZxWeapon:OnLoad(data)
	self.damage = data.damage or 0
	self.walkspeed = data.walkspeed or DEF_SPEED
	self.maxuses = data.maxuses or 0

	-- 更新次数
	local finiteuses = self.inst.components.finiteuses
	if finiteuses ~= nil then
		finiteuses:SetMaxUses(self.maxuses)
		-- 更新下百分比，否则显示百分比会有问题
		local percent = finiteuses:GetPercent()
		finiteuses:SetPercent(percent)
	end
	-- 更新伤害值
	if self.inst.components.weapon ~= nil then
		self.inst.components.weapon:SetDamage(self.damage)
	end

	-- 更新移速加成
	if self.inst.components.equippable ~= nil then
		self.inst.components.equippable.walkspeedmult = self.walkspeed
	end
end

return ZxWeapon

