SkeletonAction = {}
ACTION_START = "start"
ACTION_HOLD = "hold"
ACTION_RUN = "run"
ACTION_DEAD = "dead"
ACTION_HURT = "hurt"
ACTION_VICTORY = "victory"
ACTION_ATTACK0 = "attack01"
ACTION_ATTACK1 = "attack02"
ACTION_ATTACK2 = "attack03"
ACTION_ATTACK3 = "attack04"
ACTION_SHOW01 = "show01"
ACTION_SHOW02 = "show02"
ACTION_FIRE = "fire"
ACTION_TS = "ts"
function SkeletonAction:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建骨骼
function SkeletonAction:Create(name)
	self.armature = CreateHeroSkeleton(name)
	return self.armature
end

function SkeletonAction:setFrameCallBack(rCallBack,eCallBack)
	local function frameEventCallFunc(bone, evt, originFrameIndex, currentFrameIndex)
		if rCallBack then
			rCallBack(evt)
		end
	end
	
	local function movementEventCallFunc(armature, movementType, movementID)
		if eCallBack and movementType == 2 then
			eCallBack(movementID)
		end
	end
	self.armature:getAnimation():setFrameEventCallFunc(frameEventCallFunc)
	self.armature:getAnimation():setMovementEventCallFunc(movementEventCallFunc)
end

--播放
function SkeletonAction:play(actionType,runCallBack,endCallBack)
	self.actionStack = {aType=actionType,rCallBack=runCallBack,eCallBack=endCallBack}
	self.armature:getAnimation():play(actionType)
end

--开始
function SkeletonAction:playStart(runCallBack)
	self:play("start",runCallBack)
end

--站住
function SkeletonAction:playHold(actionTime,callBack)
	if actionTime then
		local arr = {}
		arr[1] = cc.DelayTime:create(actionTime)
		arr[2] = cc.CallFunc:create(function() if callBack then callBack() end end)
		local sq = cc.Sequence:create(arr)
		self.armature:runAction(sq)
	end
	self:play("hold")
end

--跑步
function SkeletonAction:playRun(targetXY,callBack)	
	local arr = {}
	arr[1] = cc.CallFunc:create(function() 
		local move = cc.MoveTo:create(5,cc.p(targetXY.x,targetXY.y))
		self.sprite:runAction(move)
	end)
	arr[2] = cc.DelayTime:create(5)
	arr[3] = cc.CallFunc:create(function() 
		if callBack then 
			callBack() 
		end 
	end)
	local sq = cc.Sequence:create(arr)
	self.armature:runAction(sq)
	self:play("run")
end

function SkeletonAction:playMapRun(action)
	self.armature:stopAllActions()
	self.armature:runAction(action)
	
	local movementID = self.armature:getAnimation():getCurrentMovementID()
	if movementID ~= "run" then
		self:play("run")
	end
end

--攻击
function SkeletonAction:playAttack(runCallBack,endCallBack)
	self:play("attack0",runCallBack,endCallBack)
end

--死亡
function SkeletonAction:playDead(endCallBack)
	self:play("dead",nil,endCallBack)
	self.armature:getAnimation():setSpeedScale(1) --恢复攻击速度
end

--胜利
function SkeletonAction:playVictory()
	self:play("victory")
	self.armature:getAnimation():setSpeedScale(1)--恢复攻击速度
end

function SkeletonAction:stopAllActions()
	self.armature:stopAllActions()
end

--停止
function SkeletonAction:stop()
	self.armature:getAnimation():stop()
end

--暂停
function SkeletonAction:pause()
	self.armature:getAnimation():pause()
end

--恢复
function SkeletonAction:resume()
	self.armature:getAnimation():resume()
end

--X翻转
function SkeletonAction:setScaleX(x)
	self.armature:setScaleX(x)
end

--X翻转
function SkeletonAction:getScaleX()
	return self.armature:getScaleX()
end

--Y翻转
function SkeletonAction:setScaleY(y)
	self.armature:setScaleY(y)
end

function SkeletonAction:getScaleY()
	return self.armature:getScaleY()
end

--攻击速度
function SkeletonAction:setSpeedScale(speed,frame)
	self.armature:getAnimation():setSpeedScale(frame*speed/30)
end

--换装 
--layer 替换的图层
--imgName 替换后的图片名称
function SkeletonAction:changeSkin(layer,imgName)
	local skin = ccs.Skin:createWithSpriteFrameName(imgName)	
    local bone = self.armature:getBone(layer)
	bone:addDisplay(skin,1)
	bone:changeDisplayWithIndex(1,true)
	bone:setPosition(cc.p(-50,10))
end

function SkeletonAction:setPosition(x,y)
	self.armature:setPosition(cc.p(x,y))
end

function SkeletonAction:getPosition()
	return self.armature:getPosition()
end

function SkeletonAction:getContentSize()
	return self.armature:getContentSize()
end

function SkeletonAction:addChild(node)
	self.armature:addChild(node)
end

function SkeletonAction:setLocalZOrder(z)
	self.armature:setLocalZOrder(z)
end

--退出
function SkeletonAction:Release()
	self.armature:stopAllActions()
	self.armature:getAnimation():stop()
	self.armature:removeFromParent(true)
end

