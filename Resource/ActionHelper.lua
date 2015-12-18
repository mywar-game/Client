require("FrameAnimConfig")
require("SoundEffect")
ActionHelper = {}


--闪一下 淡入淡出一次,默认淡入0.5秒，淡出0.5秒
function ActionHelper.createFadeInFadeOutOneTime(fadeInTime,fadeOutTime,delay)
    fadeInTime = fadeInTime or 0.5
    fadeOutTime = fadeOutTime or 0.5
    delay = delay or 0
    local arr = CCArray:create()
    arr:addObject(cc.FadeOut:create(fadeOutTime))
    arr:addObject(cc.FadeIn:create(fadeInTime))
    if delay > 0 then
        arr:addObject(cc.DelayTime:create(delay))
    end
    return cc.Sequence:create(arr)
end

--闪动 循环淡入淡出
function ActionHelper.createFadeInFadeOutForever(fadeInTime,fadeOutTime)
    return cc.RepeatForever:create(ActionHelper.createFadeInFadeOutOneTime(fadeInTime,fadeOutTime))
end

--闪动 循环淡入淡出
function ActionHelper.createFadeInFadeOutDealyForever(fadeInTime,fadeOutTime,delay)
    return cc.RepeatForever:create(ActionHelper.createFadeInFadeOutOneTime(fadeInTime,fadeOutTime,delay))
end

--闪一下 淡入淡出一次,默认淡入0.5秒，淡出0.5秒
function ActionHelper.createCardShine(fadeInTime,fadeOutTime,delay)
    local arr = CCArray:create()
    arr:addObject(cc.FadeOut:create(fadeOutTime))
	arr:addObject(cc.DelayTime:create(delay))
    arr:addObject(cc.FadeIn:create(fadeInTime))
	arr:addObject(cc.DelayTime:create(delay))
	
    return cc.Sequence:create(arr)
end

--闪动 循环淡入淡出
function ActionHelper.createCardShineForever(fadeInTime,fadeOutTime,delay)
    return CCRepeatForever:create(ActionHelper.createCardShine(fadeInTime,fadeOutTime,delay))
end


--登陆抽奖 left 逆方向旋转
function ActionHelper.LoginRotatingStartLeft( fc )
	local actionRotate_1 = CCRotateTo:create(0.5,-360)
	local actionRotate_2 = CCRotateTo:create(0.5,-720)
	local actionRotate_3 = CCRotateTo:create(0.5,-1080)  
	local arr = CCArray:create()
	arr:addObject(actionRotate_1)
	arr:addObject(actionRotate_2)
	arr:addObject(actionRotate_3)
    arr:addObject( CCCallFunc:create( fc ))
	local sequence = cc.Sequence:create(arr)	
	return sequence
end


--登陆抽奖 right
function ActionHelper.LoginRotatingStartRight( fc )
	local actionRotate_1 = CCRotateTo:create(0.5,360)
	local actionRotate_2 = CCRotateTo:create(0.5,720)
	local actionRotate_3 = CCRotateTo:create(0.5,1080)  
	local arr = CCArray:create()
	arr:addObject(actionRotate_1)
	arr:addObject(actionRotate_2)
	arr:addObject(actionRotate_3)
    arr:addObject( CCCallFunc:create( fc ))
	local sequence = cc.Sequence:create(arr)
	return sequence
end

--抽奖用的旋转
function ActionHelper.LotteryRotatingStart( function_callbac)	
	local actionRotate_1 = CCRotateBy:create(0.5, 360)
	local actionRotate_2 = CCRotateBy:create(0.5, 720)
	local actionRotate_3 = CCRotateBy:create(0.5, 1080)
	local arr = CCArray:create()
	arr:addObject(actionRotate_1)
	arr:addObject(actionRotate_2)
	arr:addObject(actionRotate_3)
    arr:addObject( CCCallFunc:create(   function_callbac ))
	local sequence = cc.Sequence:create(arr)
	return sequence
end



--抽奖用的旋转
function ActionHelper.LotteryRotating( times , angles  , function_callbac)	
	local actionRotate_1 = CCRotateTo:create(times, angles)
	local arr = CCArray:create()
	arr:addObject(actionRotate_1)
    arr:addObject( CCCallFunc:create(   function_callbac ))
	local sequence = cc.Sequence:create(arr)
	return sequence
end

--总共2秒，0.3秒动画，1.7秒停留后循环。1.旋转角度45° 2.透明度为0
function ActionHelper.createBlingRotate()		
	local actionRotate = CCRotateBy:create(0.3, 45)
	local arr = CCArray:create()
	arr:addObject(actionRotate)
	arr:addObject(actionRotate:reverse())
    arr:addObject(cc.DelayTime:create(1.7))

	local sequence = cc.Sequence:create(arr)
	local actionFadeout = cc.FadeOut:create(0.3)
	local spawn = CCSpawn:createWithTwoActions(actionFadeout,sequence)
	return spawn
end

--闪烁无极限
function ActionHelper.createBlingRotateForever()
    return CCRepeatForever:create(ActionHelper.createBlingRotate())
end

--星图水文 神奇的坐标调整
function ActionHelper.createMoveScale(selected_button)
    local size =selected_button:getContentSize()
	
	local actionScale = CCScaleBy:create(0.2,1.2)
	local actionMove = CCMoveBy:create(0.2,ccp( size.width/12*1.2 , size.height/12*1.2 +10))

	local spawnin_1 = CCSpawn:createWithTwoActions(actionMove,actionScale)
	local spawnin_2 = CCSpawn:createWithTwoActions(actionMove:reverse(),actionScale:reverse())
	
	local arr = CCArray:create()
	arr:addObject(spawnin_1)
	arr:addObject(spawnin_2)
	
	local sequence_1 = cc.Sequence:create(arr)
	
    return sequence_1

end
--总共1秒，旋转 透明 放大
function ActionHelper.createRotateFade()		
	local actionRotate = CCRotateBy:create(0.5, 90)
	local actionScale = CCScaleBy:create(0.5,1.08)
	
	local spawnin_1 = CCSpawn:createWithTwoActions(actionRotate,actionScale)
	local spawnin_2 = CCSpawn:createWithTwoActions(actionRotate,actionScale:reverse())
	
	local arr = CCArray:create()
	arr:addObject(spawnin_1)
	arr:addObject(spawnin_2)
	
	local sequence_1 = cc.Sequence:create(arr)
	local actionFadeout = cc.FadeOut:create(1.2)

	local spawn = CCSpawn:createWithTwoActions(actionFadeout,sequence_1)
	local spawn_3 = CCSpawn:createWithTwoActions(actionFadeout:reverse(),sequence_1)
	
	local arr_all = CCArray:create()
    arr_all:addObject(spawn)
    arr_all:addObject(spawn_3)
	
    local sequence = cc.Sequence:create(arr_all)
	
	return spawn
end


--总共1秒，旋转 透明 
function ActionHelper.createRotateAlphaForEver()	
   
	local actionRotate = CCRotateBy:create(1, 360)
	local actionFadeout = cc.FadeOut:create(100)
	local arr = CCArray:create()
	arr:addObject(actionRotate)

	local sequence = cc.Sequence:create(arr)
	
	return CCRepeatForever:create(sequence)
end


--无限转
function ActionHelper.createRotateFadeForever()
    return CCRepeatForever:create(ActionHelper.createRotateFade())
end

--总共0.4秒，0.2 放大 ，0.2恢复
function ActionHelper.createScaleAction(n,runtime)
	n = n or 1
	runtime = runtime or 0.2
	local actionScale = cc.ScaleTo:create(runtime,1.2*n)
	local actionScale_back = cc.ScaleTo:create(runtime,1*n)
	local sequence = cc.Sequence:create(actionScale, actionScale_back)
	return sequence
end

--闪烁无极限
function ActionHelper.createScaleActionForever(n)
    return cc.RepeatForever:create(ActionHelper.createScaleAction(n))
end

--总共0.4秒，0.5 移动 ，0.5恢复
function ActionHelper.createMoveAction(startX,startY)		
	local actionMove = CCMoveBy:create(0.2,ccp(startX, startY))
	local arr = CCArray:create()
	arr:addObject(actionMove)
	arr:addObject(actionMove:reverse())

	local sequence = cc.Sequence:create(arr)
	return sequence
end

--总共跳步次数
function ActionHelper.createMoveActionOneTime(startX,startY,times,move)		
	
	local arr = CCArray:create()
	for i=1,times do
		local actionMove = CCMoveBy:create(move,ccp(startX, startY))
		arr:addObject(actionMove)
		arr:addObject(cc.DelayTime:create(0.05))
	end
	local sequence = cc.Sequence:create(arr)
	return sequence
end

--进度条跳步
function ActionHelper.createProStepAction(hero_exp_progress_frontground,from,top,max_value,isShowAnim)	
	local arr = CCArray:create()
	local from_temp = from 
	local act_hero_exp_progress = nil
	local blood_anim
	local blood_sprite=nil
	local content_size = hero_exp_progress_frontground:getContentSize()
	local x,y = hero_exp_progress_frontground:getPosition()
	
	local function removeCurrent()
		if blood_sprite then
			blood_sprite:removeFromParent(true)
			blood_sprite=nil
		end
	end
	
	local function addBloodCurrent()
		removeCurrent()
		if not blood_sprite then
			if isShowAnim == 1 then
				blood_sprite,blood_anim = ActionHelper.createFrameAnim("red_blood")
				blood_sprite:setPosition(0,content_size.height)--content_size.width*((max_value-from)/max_value) (-
			else
				blood_sprite,blood_anim = ActionHelper.createFrameAnim("blue_blood")
				blood_sprite:setPosition(content_size.width*(1-((max_value-from)/max_value)),content_size.height/2)
			end
			blood_sprite:runAction(blood_anim)
			hero_exp_progress_frontground:addChild(blood_sprite)
			blood_sprite:setVisible(false)
		end
	end
	
	local function setBloodX(x)
		if blood_sprite then
			blood_sprite:setPositionX(x)
			blood_sprite:setVisible(true)
		end
	end
	
	if isShowAnim then
		if top < max_value then
			addBloodCurrent()
		end
	end
	arr:addObject(cc.DelayTime:create(0.01))
	arr:addObject(CCCallFuncN:create(function()
			if top >= max_value then
				hero_exp_progress_frontground:setPercentage(max_value*100/max_value)
				hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
			else
				if top - from < 0 then
					from_temp = from_temp - 1
					
					if from_temp >= top then 
						hero_exp_progress_frontground:setPercentage(from_temp)
						-- cclog("from_temp:"..from_temp.."  x:"..(from_temp/from*(content_size.width*from/100)))
						setBloodX(from_temp/from*(content_size.width*from/100))
					else
						hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
						if isShowAnim then
							removeCurrent()
						end
					end
					
				else
					from_temp = from_temp + 1
					
					if from_temp <= top then 
						hero_exp_progress_frontground:setPercentage(from_temp)
						setBloodX(from_temp/top*(content_size.width*top/100))
					else
						hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
						if isShowAnim then
							removeCurrent()
						end
					end
					
				end
			end
		end))
	act_hero_exp_progress = CCRepeatForever:create(cc.Sequence:create(arr))	
	
	return act_hero_exp_progress
end

--进度条跳步
function ActionHelper.createUpgradeProStepAction(hero_exp_progress_frontground,from,top)
	local arr = {}
	local state = false
	local from_temp = from 
	local step = from > top and -1 or 1
	local act_hero_exp_progress = nil
	hero_exp_progress_frontground:setPercent(from)
	
	arr[1] = cc.DelayTime:create(0.01)
	arr[2] = cc.CallFunc:create(function()
		from_temp = from_temp + step
		hero_exp_progress_frontground:setPercent(from_temp)
		if (step == 1 and from_temp >= top ) or 
		   (step == -1 and from_temp <= top) then
		   hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
		end
	end)
	act_hero_exp_progress = cc.RepeatForever:create(cc.Sequence:create(arr))
	
	return act_hero_exp_progress
end

--进度条跳步
function ActionHelper.createBossProStepAction(hero_exp_progress_frontground,from,top,max_value,isShowAnim)	
	local arr = CCArray:create()
	local from_temp = from 
	local act_hero_exp_progress = nil
	local blood_anim
	local blood_sprite=nil
	local content_size = hero_exp_progress_frontground:getContentSize()
	local x,y = hero_exp_progress_frontground:getPosition()
	
	local function removeCurrent()
		if blood_sprite then
			blood_sprite:removeFromParent(true)
			blood_sprite=nil
		end
	end
	
	local function addBloodCurrent()
		removeCurrent()
		if not blood_sprite then
			if isShowAnim == 1 then
				blood_sprite,blood_anim = ActionHelper.createFrameAnim("red_blood")
				blood_sprite:setPosition(0,content_size.height)--content_size.width*((max_value-from)/max_value) (-
			else
				blood_sprite,blood_anim = ActionHelper.createFrameAnim("blue_blood")
				blood_sprite:setPosition(content_size.width*(1-((max_value-from)/max_value)),content_size.height/2)
			end
			blood_sprite:runAction(blood_anim)
			hero_exp_progress_frontground:addChild(blood_sprite)
			blood_sprite:setVisible(false)
		end
	end
	
	local function setBloodX(x)
		if blood_sprite then
			blood_sprite:setPositionX(x)
			blood_sprite:setVisible(true)
		end
	end
	
	if isShowAnim then
		if top < max_value then
			addBloodCurrent()
		end
	end
	arr:addObject(cc.DelayTime:create(0.01))
	arr:addObject(CCCallFuncN:create(function()
			if top >= max_value then
				hero_exp_progress_frontground:setPercentage(max_value*100/max_value)
				hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
			else
				if top - from < 0 then
					from_temp = from_temp - 1
					
					if from_temp >= top then 
						hero_exp_progress_frontground:setPercentage(from_temp)
						-- cclog("from_temp:"..from_temp.."  x:"..(from_temp/from*(content_size.width*from/100)))
						setBloodX(from_temp/from*(content_size.width*from/100))
					else
						hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
						if isShowAnim then
							removeCurrent()
						end
					end
					
				else
					from_temp = from_temp + 1
					
					if from_temp <= top then 
						hero_exp_progress_frontground:setPercentage(from_temp)
						setBloodX(from_temp/top*(content_size.width*top/100))
					else
						hero_exp_progress_frontground:stopAction(act_hero_exp_progress)
						if isShowAnim then
							removeCurrent()
						end
					end
					
				end
			end
		end))
	act_hero_exp_progress = CCRepeatForever:create(cc.Sequence:create(arr))	
	
	return act_hero_exp_progress,blood_sprite
end

--数据跳步
function ActionHelper.createDataStepAction(hero_txt,from,top,callback)	
	local arr = {}
	local from_temp = from 
	local step = top - from
	local act_hero_exp_progress = nil	
	cclog("top===="..top)
	cclog("from===="..from)
	if step >= 0 then
		if step > 100000 then
		   step = 11111
		elseif step > 10000 then
		   step = 1111
		elseif step > 1000 then
		   step = 111
		elseif step > 100 then
		   step = 11
		else
			step = 1
		end
	else
		if step < -100000 then
		   step = -11111
		elseif step < -10000 then
		   step = -1111
		elseif step < -1000 then
		   step = -111
		elseif step < -100 then
		   step = -11
		else
			step = -1
		end
	end
	
	arr[1] = cc.CallFunc:create(function()
		from_temp = from_temp + step
		if step > 0 then 
			if from_temp <= top then 
				hero_txt:setString(from_temp)
			else
				if callback then
					callback()
				end
				hero_txt:setString(top)
				hero_txt:stopAction(act_hero_exp_progress)
			end
		else
			if from_temp >= top then 
				hero_txt:setString(from_temp)
			else
				if callback then
					callback()
				end
				hero_txt:setString(top)
				hero_txt:stopAction(act_hero_exp_progress)
			end
		end
	end)
	act_hero_exp_progress = cc.RepeatForever:create(cc.Sequence:create(arr))
	return act_hero_exp_progress
end

--移动无极限
function ActionHelper.createMoveActionForever(startX,startY)
    return CCRepeatForever:create(ActionHelper.createMoveAction(startX,startY))
end


-- 适用于武将升级成功，或进阶成功动画
function ActionHelper.createFadeInMoveUpOneTime(animCallback)
    local actionFadeIn = cc.FadeIn:create(1)
    local actionFadeInBack = actionFadeIn:reverse()
    local actionUp = CCMoveBy:create(0.3, ccp(0, 50))
    
    local arr = CCArray:create()
    arr:addObject(actionFadeIn)
    arr:addObject(cc.DelayTime:create(0.6))
    arr:addObject(actionFadeInBack)
    arr:addObject(CCCallFunc:create(animCallback))
    
    local sequence = cc.Sequence:create(arr)
    local spawn = CCSpawn:createWithTwoActions(actionUp,sequence)
    local delay = cc.DelayTime:create(0.3)
    
    return cc.Sequence:createWithTwoActions(delay,spawn)
end

--创建序列帧动画
function ActionHelper.createFrameAnim(frame_anim_name,isRun)
   -- cclog( " 474  ActionHelper.createFrameAnim = "..frame_anim_name)
    local config = FrameAnimConfig.getConfig(frame_anim_name)
    if not config then error("ActionHelper.createFrameAnim -> cannot find frame_anim_name:"..frame_anim_name) return end

	local animFrames = {}
    local cache = cc.SpriteFrameCache:getInstance()
    LoadSpriteFrames("frame_anim/"..config.plist, "frame_anim/"..config.pic)
    for i = 1,config.frame_count do
        local framePath = string.format(config.frame_path.."/%02d.png", i)
        local frame = cache:getSpriteFrame(framePath)
		table.insert(animFrames,frame)
    end
    local animation = cc.Animation:createWithSpriteFrames(animFrames, config.duration/config.frame_count)
    local animSprite = CreateBlankCCSprite()
    
    animSprite:setScale(config.scale)
    
    local action = cc.Animate:create(animation)
    if config.is_repeat_forever then
        action = cc.RepeatForever:create(action)
    else
        action = cc.Sequence:create(action,cc.CallFunc:create(function() animSprite:removeFromParent(true) end))
    end
	
    if config.sound then
        SoundEffect.playSoundEffect(config.sound)
    end
	
	if isRun then
		animSprite:runAction(action)
	end
    
    return animSprite,action
end



