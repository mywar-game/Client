ACTION_BT = "bt"
ACTION_NT = "nt"
ACTION_ET = "et"

SkeletonSkill = {}
function SkeletonSkill:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建骨骼
function SkeletonSkill:Create(name,buffIndex,resId)
	self.name = name
	self.resId = resId
	self.iscycleSkill = false
	self.buffIndex = buffIndex 
	self.armature = CreateSkillSkeleton(name)
	self.armature:getAnimation():play("tx")
	return self.armature
end

--轨迹
function SkeletonSkill:setWeakPlay(t,x,y,r,bCallback,sCallback,eCallback,beingAttackState)
	if sCallback then
		sCallback(self.buffIndex)
	end
	
	local offsetX = self.armature:getAnchorPoint().x == 1 and 120 or -120 --偏移量
	
	local arr = {}
	arr[1] = cc.MoveTo:create(t,cc.p(x,y))
	arr[2] = cc.CallFunc:create(function() 
		self.armature:setLocalZOrder(50)
	end)
	arr[3] = cc.DelayTime:create(0.1)
	arr[4] = cc.CallFunc:create(function()
		if beingAttackState == StaticField.beingAttackState2 then
			self.armature:setRotation(r+180)
			self.armature:setPosition(cc.p(x+offsetX,y))
		else
			if bCallback then
				bCallback()
			end
			
			if eCallback then
				eCallback(self.buffIndex)
			end
		end
	end)
	
	if beingAttackState == StaticField.beingAttackState2 then
		local mx,my = self.armature:getPosition()
		arr[5] = cc.MoveTo:create(t,cc.p(mx+offsetX/2,my))
		arr[6] = cc.CallFunc:create(function()
			if bCallback then
				bCallback()
			end
			
			if eCallback then
				eCallback(self.buffIndex)
			end
			self:Release(true)
		end)
	end
	
	local sq = cc.Sequence:create(arr)
	self.armature:setRotation(r)
	self.armature:runAction(sq)
end

--原点
function SkeletonSkill:setOriginPlay(effectTimes,effect,bCallback,cycleCallback,sCallback,eCallback,frameCallback)	
	local runNum = 0
	local round = string.gsub(effect.round, "：", ":")
	local temp = Split(round,":")
	local times = tonumber(temp[1])
	local types = tonumber(temp[2])
	local function delayRelease(tm,flag)
		local arr = {}
		arr[1] = cc.DelayTime:create(tm)
		arr[2] = cc.CallFunc:create(function()
			if effect.round == "20:0" then
				cclog("===================================")
			end
			if eCallback then
				eCallback(self.buffIndex)
			end
		end)
		if flag then
			self.armature:stopAllActions()
			self.armature:getAnimation():stop()
		end
		local sq = cc.Sequence:create(arr)
		self.armature:runAction(sq)
	end
	
	local function movementEventCallFunc(armature, movementType, movementID)
		if times == 0 then --单次完整的效果
			delayRelease(0.01,true)
		end
	end
	
	local function frameEventCallFunc(bone,evt,originFrameIndex,currentFrameIndex)
		if evt == ACTION_ET then
			self:skillAppearType(effect.appearType)
		elseif evt == ACTION_BT or evt == ACTION_NT or frameCallback then
			frameCallback(evt)
		end
	end
	self.armature:getAnimation():setFrameEventCallFunc(frameEventCallFunc)
	self.armature:getAnimation():setMovementEventCallFunc(movementEventCallFunc)
	self.armature:setAnchorPoint(cc.p(0.5,0))
	
	if sCallback then
		sCallback(self.buffIndex)
	end
	
	if bCallback then
		bCallback()
	end
	
	if times > 0 then --主要是持续性的效果，例如10S
		if types > 0 then
			local function callBackFunc()
				cycleCallback(self.buffIndex)
			end
			self.handler = Director.getScheduler():scheduleScriptFunc(callBackFunc,types,false)
		end
		self.iscycleSkill = true
		delayRelease(times+0.01,false) --0.01客户端做延迟，怕定时器会提前取消。
	end
end

--原点
function SkeletonSkill:setCommonPlay(isCycle)
	local num = 0
	local function delayRelease(tm)
		local arr = {}
		arr[1] = cc.DelayTime:create(tm)
		arr[2] = cc.CallFunc:create(function()
			self:Release(true)
		end)
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
		local sq = cc.Sequence:create(arr)
		self.armature:runAction(sq)
	end
	local function movementEventCallFunc(armature, movementType, movementID)
		if not isCycle then
			delayRelease(0.01,true)
		end
	end
	self.armature:getAnimation():setMovementEventCallFunc(movementEventCallFunc)
	self.armature:setAnchorPoint(cc.p(0.5,0))
end

function SkeletonSkill:skillAppearType(appearType)
	if appearType == 1 then --
		
	elseif appearType == 2 then --
	
	elseif appearType == 3 then --
	
	elseif appearType == 4 then --冻结
		self.armature:getAnimation():stop()
	elseif appearType == 5 then --减速
	
	elseif appearType == 6 then --隐藏
		self.armature:setVisible(false)
	end
end

function SkeletonSkill:stopTimer()
	if self.handler then
		Director.getScheduler():unscheduleScriptEntry(self.handler)
		self.handler = nil
	end
end

function SkeletonSkill:hide()
	self:stopTimer()
	if self.iscycleSkill then
		self.armature:stopAllActions()
		self.armature:getAnimation():stop()
		self.armature:setVisible(false)
	end
end

function SkeletonSkill:Release()
	self:stopTimer()
	self.armature:stopAllActions()
	self.armature:getAnimation():stop()
	self.armature:removeFromParent(true)
	self = nil
end

