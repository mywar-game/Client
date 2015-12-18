SkillCycleAI = {}
--技能周期效果
function SkillCycleAI:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function SkillCycleAI:autoAI(effect,singleCallBack,multiCallBack)
	self.validityBuff = true --buff有效期
	self.playSingleCallBack = singleCallBack
	self.playMultiCallBack = multiCallBack
	self:runAI(effect)
end

function SkillCycleAI:runAI(effect)
	local runNum = 0 --总次数
	local cycleNum = 0 --单个循环的次数
	local temp = Split(effect.round,":")
	local times = tonumber(temp[1])
	local types = tonumber(temp[2])
	local interval = 0.1 --间隔0.1s
	
	local function playRoundEffect()
		runNum = runNum + 1
		cycleNum = cycleNum + 1
		if runNum <= times/interval then
			if types == StaticField.cycleRound0 then
				if self.playMultiCallBack then
					self.playMultiCallBack()
				end
			else
				if cycleNum >= types/interval then
					cycleNum = 0
					if self.playSingleCallBack then
						self.playSingleCallBack()
					end
				end
			end
		else
			self:Release()
		end
	end
	self.effect = effect
	self.validityBuff = true
	if self.handler == nil then
		self.handler = Director.getScheduler():scheduleScriptFunc(playRoundEffect,interval,false)
	end
end

--buff有效期
function SkillCycleAI:getValidityBuff()
	return self.validityBuff
end

--检测buff是否存在
function SkillCycleAI:isCheckSameBuff(effect)
	if self.effect.skillEffectId == effect.skillEffectId then
		return true
	else
		return false
	end
end

--清除buff
function SkillCycleAI:removeAbleDeBuff(effect)
	if self.effect.effectId == StaticField.attackFormula10000 and
	   self.effect.removeAble == StaticField.removeAble1 and
	   effect.effectId == StaticField.skillEffectDefiner1 then --是否可被清除
		self:Release()
	end
end


--覆盖buff
function SkillCycleAI:addTypeDeBuff(effect)
	if self.effect.skillEffectId == effect.skillEffectId and
	   self.effect.addType == StaticField.addType2 then --持续时间
		self:runAI(effect)
	end
end

--释放
function SkillCycleAI:Release()
	if self.handler then
		self.validityBuff = false --buff有效期
		Director.getScheduler():unscheduleScriptEntry(self.handler)
		self.handler = nil
	end
end