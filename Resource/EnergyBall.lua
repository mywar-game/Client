EnergyBall = {}

function EnergyBall:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function EnergyBall:Init(para)
	local width = 100
	local height = 100
		
	local ballType = math.random(3)
    local bgLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
	bgLayer:setContentSize(cc.size(width,height))
	
	local iconSprite = CreateCCSprite("fight/energy_icon_"..ballType..".png")
	iconSprite:setPosition(cc.p(width/2,height/2))
	bgLayer:addChild(iconSprite)
	
	local isAnimte = true
	local function EnergyBall_ontouch(e,x,y)
		local tx = bgLayer:convertToNodeSpace(cc.p(x,y)).x
		local ty = bgLayer:convertToNodeSpace(cc.p(x,y)).y
		local isTouch = isClickSprite(iconSprite,tx,ty)
		if isTouch then
			if e == "began" then
				if isAnimte then
					local arr = {}
					local mx = 0
					local my = 35
					if ballType == GameField.ballType1 then
						mx = 650
					elseif ballType == GameField.ballType2 then 
						mx = 110
					elseif ballType == GameField.ballType3 then
						mx = 380
					end
					
					iconSprite:runAction(cc.FadeOut:create(0.5))
					local move = cc.MoveTo:create(0.5,cc.p(mx,my))
					arr[1] = cc.EaseExponentialOut:create(move) 
					arr[2] = cc.DelayTime:create(0.1)
					arr[3] = cc.CallFunc:create(function() 
							if para.clickCallBack then
								para.clickCallBack(ballType)
							end
							bgLayer:removeFromParent()
						end)
					local sq = cc.Sequence:create(arr)
					bgLayer:stopAllActions()
					bgLayer:runAction(sq)
					isAnimte = false
				end
			elseif e == "moved" then
				
			else
				
			end
			return true
		end
	end
	bgLayer:registerScriptTouchHandler(EnergyBall_ontouch,false,0,true)
	bgLayer:setTouchEnabled(true)
	
	if math.random(2) == 1 then
		self:moveWithParabola(bgLayer,iconSprite,{x=100,y=100},{x=100+math.random(300),y=-200-math.random(50)},60,200,2)
	else
		self:moveWithParabola(bgLayer,iconSprite,{x=-100,y=100},{x=-100-math.random(300),y=-200-math.random(50)},60,200,2)
	end	
	return bgLayer
end

--  抛物线运动并同时旋转    -Himi   
--mSprite：需要做抛物线的精灵  
--startPoint:起始位置  
--endPoint:中止位置  
--startA:起始角度  
--endA:中止角度  
--dirTime:起始位置到中止位置的所需时间
  
function EnergyBall:moveWithParabola(mSprite,iconSprite,startPoint,endPoint,startAngle,endAngle,interval)
    local sx = startPoint.x
    local sy = startPoint.y
    local ex =endPoint.x+50 
    local ey =endPoint.y+150  
    local h = mSprite:getContentSize().height*0.5 
    --设置精灵的起始角度  
    mSprite.rotation= startAngle
	
	local bezier={} -- 创建贝塞尔曲线  
    bezier[1] = cc.p(sx, sy) -- 起始点  
    bezier[2] = cc.p(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200) --控制点  
    bezier[3] = cc.p(endPoint.x-30, endPoint.y+h) -- 结束位置     
    local actionMove = cc.BezierTo:create(interval,bezier)
    --创建精灵旋转的动作  
    local actionRotate =cc.RotateTo:create(interval,100+math.random(endAngle))
    --将两个动作封装成一个同时播放进行的动作  
    local action = cc.Spawn:create(actionMove,actionRotate)
	mSprite:runAction(action)
	
	local arr = {}
	arr[1] = cc.DelayTime:create(interval+5)
	arr[2] = cc.FadeOut:create(1)
	arr[3] = cc.CallFunc:create(function()
		mSprite:removeFromParent()
	end)
	local sequence = cc.Sequence:create(arr)
	iconSprite:runAction(sequence)
end

