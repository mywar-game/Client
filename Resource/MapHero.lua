require("Maze")
require("SkeletonAction")

MapHero = {}
function MapHero:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function MapHero:Create(moveLayer,systemMap,systemHeroId,bornpointX,bornpointY,userName,stopAction,userTouch,isPlayer)
	self.isRun = false
	self.offsetX = 0
	self.offsetY = 0
	self.targetX = 0
	self.targetY = 0
	self.nterval = 0
	
	self.click = 0
	self.clicks = 0
	self.endPoint = {x=0,y=0}
	self.mapPoint = {}
	self.mapPointTmp = {}
	self.mapPointTmp2 = {}
	self.isPlayer = isPlayer
	self.stopAction = stopAction
	self.userTouch = userTouch

	local maxTileNumX = 0
	local maxTileNumY = 0
	if systemMap.town == 1 then
		maxTileNumX = GameField.tileXNum * systemMap.mapNum
		maxTileNumY = GameField.tileYNum * systemMap.mapNum/2
	else
		maxTileNumX = GameField.tileXNum * systemMap.mapNum/2
		maxTileNumY = GameField.tileYNum * systemMap.mapNum/2
	end
	
	local zorder = (maxTileNumY-bornpointY-0.5)*GameField.tileHeight
	local bgLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
	bgLayer:setContentSize(cc.size(1,1))
	bgLayer:setPosition(cc.p(bornpointX*GameField.tileWidth,(bornpointY*2+1)*GameField.tileHeight/2))
	moveLayer:addChild(bgLayer,zorder)
	self.bgLayer = bgLayer

	local systemHero = DataManager.getStaticSystemHeroId(systemHeroId)
	local shadowsSprite = CreateCCSprite("fight/shadows.png")
	shadowsSprite:setPosition(cc.p(0,0))
	shadowsSprite:setScale(systemHero.modelScale)
	bgLayer:addChild(shadowsSprite)

	local skeletonAct = SkeletonAction:New()
	local skeleton = skeletonAct:Create(systemHero.resId)
	skeleton:setScale(systemHero.modelScale)
	skeleton:setPosition(cc.p(0,0))
	skeleton:getAnimation():play(ACTION_HOLD)
	self.skeleton = skeleton
	bgLayer:addChild(skeleton)
		
	local rect = skeleton:getBoundingBox()
	local offY = rect.y + rect.height + 15
	local heroTitle = systemHero.heroTitle
	if heroTitle ~= "" then
		heroTitle = "<"..heroTitle..">"
		local tltelLabel = CreateLabel(heroTitle,nil,18)
		tltelLabel:setPosition(0,offY)
		bgLayer:addChild(tltelLabel)
		offY = offY + 20
	end

	self.nameLabel = CreateLabel(userName,nil,18)
	self.nameLabel:setPosition(0,offY)
	bgLayer:addChild(self.nameLabel)
	
	for x=1,maxTileNumX do
		self.mapPoint[x] = {}
		for y=1,maxTileNumY do
            self.mapPoint[x][y] = 0
		end
	end

	local point = Split(systemMap.breakPoint,"|")
	for k,v in pairs(point) do
		local mx,my = ConversionXY(maxTileNumY,v)
		if systemMap.town == 1 then
			for ty=my,maxTileNumY do
				self.mapPoint[mx][ty] = 1
			end
		end
		self.mapPoint[mx][my] = 1
	end

	local function isCheck(x,y)
		local len = #self.mapPoint
		if x < 1 or x > len then
			return false
		end
		if y < 1 or y > len then
			return false
		end
		return self.mapPoint[x][y] == 0 and true or false
	end
	
	local function canReach(start,x,y,IsIgnoreCorner)
		if not isCheck(x,y) then
			return false
		else
			if math.abs(x-start.X) + math.abs(y-start.Y) == 1 then
				return true
			else
				if isCheck(math.abs(x-1),y) and isCheck(x,math.abs(y-1)) then
					return true
				else
					return IsIgnoreCorner
				end
			end
		end
	end
	
	--范围点预算
	local function surrroundPoints(point)
		local roundPoints = {}
		for x=point.X-1,point.X+1 do
			for y=point.Y-1,point.Y+1 do
				local point = Point:New()
				point.X = x
				point.Y = y
				if not isCheck( x,y) then
					point.island = true	--说明是不可到达的区域
				end
				table.insert(roundPoints,point)	
			end
		end
		return roundPoints
	end

	function pretreatmentMap()
			--地图预处理
		for x=1,maxTileNumX do
			self.mapPointTmp[x] = {}
			for y=1,maxTileNumY do
			local point = Point:New()
			point.X = x
			point.Y = y
			
			if not isCheck(x,y) then
				point.island = true
			end	
			--每个点都算出它的对应的展开范围
			self.mapPointTmp[x][y] = surrroundPoints(point)
			end
		end
	end
	pretreatmentMap()
	
	function timerCallBack()
		--如果不是按钮点击的移动不处理,因为没阵帧都会回调它如果不设定会导致重算坐标
		if self.click == true then
			self.click = false	
			if self.endPoint.x ~=0 or self.endPoint.y ~= 0  then
				--获取精灵当前所在区域
				local px,py = self.bgLayer:getPosition()
				--如果当前点击的点和要走到的点一致就不处理加快性能
				if self.endPoint.x ~= px or self.endPoint.y ~= py then
					--如果精灵还在就不处理
					if self.isRun == false then 
						Maze.init(self.mapPoint,self.mapPointTmp,self, {x=px,y=py},{x=self.endPoint.x,y=self.endPoint.y})	
					end		
				end		
			 end	
		end
	end
	--使用定时器去取最后点击坐标
    local function startimer()
		--按cocos2dx 的帧率速度来处理回调
		self.tick_handler = Scheduler.ScheduleScriptFunc(self, timerCallBack, 0, false)
	end


	--启动坐标重定位定时器
	startimer()
end

--玩家改昵称
function  MapHero:changeHeroName(name)
	self.nameLabel:setString(name)
end

--显示玩家聊天 头顶冒一个聊天气泡
function  MapHero:showHeroChatBubble(msg)
	local itype = tonumber(msg.type)
	if nil ~= self.chatBgSprite then
		self.chatBgSprite:stopAllActions()
		self.chatBgSprite:removeFromParent()
		self.chatBgSprite = nil
	end
	self.chatBgSprite = CreateCCSprite("NewUi/xinqietu/liaotian/i_qipao".. itype ..".png")
	local size = self.bgLayer:getContentSize()
	self.chatBgSprite:setPosition(cc.p(size.width/2, size.height + 160))
	self.bgLayer:addChild(self.chatBgSprite)
	
	local strLable = CreateLabel(msg.content, nil, 16, cc.c3b(0, 0, 0), 1, cc.size(130, 55))
	
	local changeStr = splitUTF8StrToSingleTab(msg.content)
	local newContent = ""
	local localLen = 0
	-- 最大能够显示24个汉字，也就是能够最大显示44个英文字符，  如果混合情况最大为43个 ， 所以做如下处理 
	if #changeStr > 24 then
		for k = 1, #changeStr do 
			newContent = string.format("%s%s", newContent, changeStr[k])
			if (string.byte(changeStr[k], 1)) >= 0xe0 then
				localLen = localLen + 2
			else
				localLen = localLen + 1
			end
			if localLen >= 43 then
				break
			end
		end
		strLable:setString(newContent .. "...")
	end
	
	strLable:setAnchorPoint(cc.p(0.5, 0.5))
	local size1 = self.chatBgSprite:getContentSize()
	strLable:setPosition(cc.p(size1.width/2 , size1.height/2 + 3))
	self.chatBgSprite:addChild(strLable)

	self.chatBgSprite:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(function(pSender)
																			self.chatBgSprite:removeFromParent()
																			self.chatBgSprite = nil
	end)))
end

function MapHero:wayfinding(rx,ry)
	self.isRun = false
	self.bgLayer:stopAllActions()
	local px,py = self.bgLayer:getPosition()
	Maze.init(self.mapPoint,self,{x=px,y=py},{x=rx,y=ry})
end

function MapHero:clickMap(rx,ry)
	--获取精灵的当前位置
	local px,py = self.bgLayer:getPosition()
	local endPointX = math.ceil(rx/GameField.tileWidth) 
	local endPointY = math.ceil(ry/GameField.tileHeight)

	--过滤岛国区
	local function isCheck(x,y)
		local len = #self.mapPoint
		if x < 1 or x > len then
			return false
		end
		
		if y < 1 or y > len then
			return false
		end
		
		if self.mapPoint[x][y] == 0 then
			return true
		else
			return false
		end
	end

	if isCheck(endPointX,endPointY) then
		--如果目标的点击距离较短为了直接使用曼哈顿算出距离
		if math.abs( rx - px ) <= 32*2 and math.abs( ry - py ) <= 32*2 then
			self.isRun = false
			self.bgLayer:stopAllActions()
			
			local actionTime = math.abs(math.sqrt((rx-px)*(rx-px)+(ry-py)*(ry-py))/GameField.heroMoveSpeed)
			local arr = {}
			arr[1] = cc.DelayTime:create(actionTime)
			arr[2] = cc.CallFunc:create(function() 
				self.isRun = false
				self:weakOver()
				self:stopAnimte()
			end)
			local sq = cc.Sequence:create(arr)
			self.bgLayer:runAction(sq)
			
			local movementID = self.skeleton:getAnimation():getCurrentMovementID()
			if movementID ~= ACTION_RUN then
				self.skeleton:getAnimation():play(ACTION_RUN)
			end
			
			local cx = math.abs(self.skeleton:getScaleX())
			if rx <= px then
				self.skeleton:setScaleX(-cx)
			else
				self.skeleton:setScaleX(cx)
			end
			
			self.isRun = true
			self.offsetX = px - rx
			self.offsetY = py - ry
			self.targetX = px - rx
			self.targetY = py - ry
			self.interval = actionTime
		else
			self.isRun = false
			self.bgLayer:stopAllActions()
				
			--最后点击的点		
			self.endPoint.x = rx
			self.endPoint.y = ry
		
			--设置为按钮点击了
			self.click = true
		end
		--[[
		self.isRun = false
		self.bgLayer:stopAllActions()
			
		--最后点击的点		
		self.endPoint.x = rx
		self.endPoint.y = ry
	
		--设置为按钮点击了
		self.click = true]]
	end	
	
end

function MapHero:autoWalk(rx,ry,isFilp,callback)
	local px,py = self.bgLayer:getPosition()
	local actionTime = math.sqrt((rx-px)*(rx-px)+(ry-py)*(ry-py))/GameField.heroMoveSpeed
	
	local arr = {}
	if self.isPlayer then
		arr[1] = cc.DelayTime:create(actionTime)
	else
		self.bgLayer:stopAllActions()
		arr[1] = cc.MoveTo:create(actionTime,cc.p(rx,ry))
	end
	arr[2] = cc.CallFunc:create(function() 
		if self.stopAction then
			self.stopAction()
		end
		self.isRun = false
		callback()
	end)
	local sq = cc.Sequence:create(arr)
	self.bgLayer:runAction(sq)
	
	local movementID = self.skeleton:getAnimation():getCurrentMovementID()
	if movementID ~= ACTION_RUN then
		self.skeleton:getAnimation():play(ACTION_RUN)
	end
	
	if isFilp then
		local cx = math.abs(self.skeleton:getScaleX())
		if rx < px then
			self.skeleton:setScaleX(-cx)
		else
			self.skeleton:setScaleX(cx)
		end
	end
	
	self.isRun = true
	self.offsetX = px - rx
	self.offsetY = py - ry
	self.targetX = px - rx
	self.targetY = py - ry
	self.interval = actionTime
end

function MapHero:setWeakCallBack(weakCallBack)
	self.weakCallBack = weakCallBack
end

function MapHero:weakOver()
	if self.userTouch and self.userTouch() then
		
	else
		if self.weakCallBack then
			self.weakCallBack(self.bgLayer:getPosition())
		else
			self.skeleton:getAnimation():play(ACTION_HOLD)
		end
	end
end

function MapHero:stopAnimte()
	if self.userTouch and self.userTouch() then
		
	else
		self.bgLayer:stopAllActions()
		self.skeleton:getAnimation():play(ACTION_HOLD)
	end
end

function MapHero:setMapOpacity(newOpacity)
	local oldOpacity = self.bgLayer:getOpacity()
	if oldOpacity == 255 then
		if newOpacity ~=  255 then
			self.skeleton:setOpacity(newOpacity)
			self.bgLayer:setOpacity(newOpacity)
		end
	else
		self.skeleton:setOpacity(newOpacity)
		self.bgLayer:setOpacity(newOpacity)
	end
end

function MapHero:Release()
	Scheduler.UnscheduleScriptEntry(self.tick_handler)
	self.bgLayer:stopAllActions()
	self.skeleton:getAnimation():play(ACTION_HOLD)
	self.bgLayer:removeFromParent(true)
end

