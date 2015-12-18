require("MapHero")
require("SkeletonSkill")
require("SkeletonAction")

local jumpSceneIdx = 0
local jumpSceneList = {}

TileMapUIPanel = {
panel = nil,
}

function TileMapUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function TileMapUIPanel:Create(para)
	local p_name = "TileMapUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	para = para or {}
	local moveType1 = false
	local moveType2 = false
	local moveType3 = true
	local moveType4 = true
	local moveType5 = true
	local isTouchFish = false
	local bossHeroId = 0 --bossId
	local addMoveTime = 0
	local addMoveYNum = 0 --主城偏移量
	local addtileYNum = 0
	local curSceneId = nil --当前场景ID
	local bornpointX = nil --出生点X
	local bornpointY = nil --出生点Y
	local cacheForce = nil--地图怪物缓存
    local cacheCollection = nil--缓存的矿石
	local userTouch = {}
	local otherHero = {}
	local npcSprite = {}
	local forceSprite = {}
    local collectSprite = {}--矿物表
	local fishingSprite = {}--钓鱼
	local enterSprite = {}
	local bossSprite = {}
	local objectList = {}
	local duplicateSprite = {}
	local recordTouch = {x=0,y=0}
	local sendUserTouch = {x=0,y=0}
	
	local longPressed = false
	local gmx = 0
	local gmy = 0

	--因為遇到新手引導的時候，如果彈出NPC界面，會死人的。
	--local function UserGuidSetpCheck()
	--	local maintask = DataManager.getMainlineTask()
	--	local systemTaskId = maintask.systemTaskId
		
	--	local recordGuideStep = DataManager.getRecordGuideStep() 
	--	local  guideCurStep = 0
	--	if  #recordGuideStep <=0  then  --默认是没有步骤。
	--		 guideCurStep = 0
	--	else
	--		 guideCurStep  = recordGuideStep[#recordGuideStep] 
	--	end
	--	if  1003 == systemTaskId  and  2002 == tonumber(guideCurStep)  then  --完成了1002那條指引，怕與背包的指引衝突。  這些數字要去  UserGuideUIPanel 查看 打开背包装备
	--		return false
	--	end
	--	if  1004 == systemTaskId and  3008 == tonumber(guideCurStep) then
	--	    cclog( "61  领取暴风城的时候不要 弹开 任何 内容 " )
	--	    return false
	--	end
		
	--	if  1009 == systemTaskId and  tonumber(guideCurStep) <9000  then
		--    cclog( "66  完成1008 这条任务之后 不要 弹出  1009 任务 " )
		--    return false
	--	end
		
	--	if   1009 == systemTaskId and tonumber(guideCurStep) < 10000 then  --为了正义这条任务 要10级才能接的
		--    cclog( "71  当我可以领取 10 级任务的时候 会有弹出框 显示探索，此时要屏蔽弹出框 " )
		--    return false
		--end

		
	--	return true 
	--end
	if para.sceneId then		
		curSceneId = tonumber(para.sceneId)
	else
		local array = Split(DataManager.getUserBO().prePosition,",")
		curSceneId = tonumber(array[1])
		bornpointX = tonumber(array[2])
		bornpointY = tonumber(array[3])
	end
	DataManager.setCurrentSceneId(curSceneId)

	if para.x then
		bornpointX = math.floor(para.x/GameField.tileWidth)
	end
	
	if para.y then
		bornpointY = math.floor(para.y/GameField.tileHeight)
	end
	
	if curSceneId == 1002 then --特殊处理主城
		addMoveTime = 0.5
		addtileYNum = GameField.tileYNum/2
	end
	
	local systemScene = DataManager.getSystemSceneId(curSceneId)
	local systemMap = DataManager.getSystemMapId(systemScene.mapId)
	local systemNpc = DataManager.getSystemMapNpc(systemMap.mapId)
	local systemForces = DataManager.getSystemMapForces(systemMap.mapId)
	local systemBigForces = DataManager.getSystemDuplicateList(systemMap.mapId)
	local systemTransfer = DataManager.getSystemMapTransfer(systemMap.mapId)
	if para.isFromWorldMap or para.oldSceneId then	
		for k,v in pairs(systemTransfer) do
			if para.oldSceneId and v.sceneId == para.oldSceneId and v.mapId == curSceneId then
				bornpointX = v.x
				bornpointY = v.y
            elseif para.isFromWorldMap and v.mapId == curSceneId then
                bornpointX = v.x
				bornpointY = v.y
			end
		end
	end
	
	if bornpointX == nil or bornpointY == nil then
		local array = Split(systemMap.mapBirth,",")
		bornpointX = tonumber(array[1])
		bornpointY = tonumber(array[2])
	else
		bornpointX = bornpointX
		bornpointY = bornpointY
	end
	
	local maxTileNumX = 0
	local maxTileNumY = 0
    local winSize = Director.getViewSizeScale()
    local viewWidth = winSize.width
    local viewHeight = winSize.height
	if systemMap.town == 1 then
		maxTileNumX = GameField.tileXNum * systemMap.mapNum
		maxTileNumY = GameField.tileYNum + addtileYNum
	else
		maxTileNumX = GameField.tileXNum * systemMap.mapNum/2
		maxTileNumY = GameField.tileYNum * systemMap.mapNum/2
	end
	
	if bornpointX > maxTileNumX then
		bornpointX = maxTileNumX/2
	end
	
	if bornpointY > maxTileNumY then
		bornpointY = maxTileNumY/2
	end
	
	local maxMoveX = viewWidth - maxTileNumX*GameField.tileWidth
	local maxMoveY = viewHeight - maxTileNumY*GameField.tileHeight
	
	local mx = viewWidth/2 - bornpointX * GameField.tileWidth
	local my = viewHeight/2 - bornpointY * GameField.tileHeight---1000
	if mx > 0 then
		mx = 0
	end
	if mx < maxMoveX then
		mx = maxMoveX 
	end
	
	if my > 0 then
		my = 0
	end
	if my < maxMoveY then
		my = maxMoveY
	end
	
	local vistaLayer = cc.Layer:create()
	vistaLayer:setPosition(cc.p(mx,0))
	self.panel.layer:addChild(vistaLayer, -1)
	
	local moveLayer = cc.Layer:create()
	moveLayer:setPosition(cc.p(mx,my))
	self.panel.layer:addChild(moveLayer,-1)
	
	self.tileMapBg = self.panel:getChildByName("img_tilemapbg")
	self.tileMapTitle = self.panel:getChildByName("lab_mapName")
	self.tileMapTitle:setString(systemMap.mapName)
	self.tileMapBg:setScale(1.4)
	self.tileMapBg:setOpacity(0)
	self.tileMapTitle:setOpacity(0)
	local actionArr = {}
	actionArr[1] = cc.FadeIn:create(2)
	actionArr[2] = cc.DelayTime:create(2)
	actionArr[3] = cc.FadeOut:create(2)
	actionArr[4] = cc.Hide:create()
	local actSequence = cc.Sequence:create(actionArr)
	self.tileMapBg:runAction(actSequence:clone())
	self.tileMapTitle:runAction(actSequence)
	if 1 == 0 then
		local mapPoint = {}
		for x=1,maxTileNumX do
			mapPoint[x] = {}
			for y=1,maxTileNumY do
				mapPoint[x][y] = 0
			end
		end
	
		local point = Split(systemMap.breakPoint,"|")
		for k,v in pairs(point) do
			local mx,my = ConversionXY(maxTileNumY,v)
			if systemMap.town == 1 then
				for ty=my,maxTileNumY do
					mapPoint[mx][ty] = 1
				end
			end
			mapPoint[mx][my] = 1
		end
		
		local batchNode1 = cc.SpriteBatchNode:create("fight/gezi.png", 100)
		batchNode1:setPosition(cc.p(300,300))
		moveLayer:addChild(batchNode1)
		
		local batchNode2 = cc.SpriteBatchNode:create("fight/gezi2.png", 100)
		batchNode2:setPosition(cc.p(300,300))
		moveLayer:addChild(batchNode2)
		moveLayer:setTouchEnabled(true)
		
		local spritePoint = {}
		for x=1,maxTileNumX do
			spritePoint[x] = {}
			for y=1,maxTileNumY do
				if mapPoint[x][y] == 1 then
				local geSprite
				local imgRes = ""
				
				if mapPoint[x][y] == 0 then
					geSprite = cc.Sprite:createWithTexture(batchNode1:getTexture())
				else
					geSprite = cc.Sprite:createWithTexture(batchNode2:getTexture())
				end
				geSprite:setPosition(cc.p((x-1)*GameField.tileWidth,(y-1)*GameField.tileHeight))
				geSprite:setAnchorPoint(cc.p(0,0))
				moveLayer:addChild(geSprite,1000)
				
				local size = geSprite:getContentSize()
				local numLabel = CreateLabel((x-1)..","..(y-1),nil,12)
				numLabel:setPosition(cc.p(size.width/2,size.height/2))
				geSprite:addChild(numLabel)
				spritePoint[x][y] = geSprite
				end
			end
		end
	end
	
	--延迟弹出
	local function delayPopNpcFunction(taskHero)
		local sx,sy = taskHero.bgLayer:getPosition()
		local arr = {}
		arr[1] = cc.DelayTime:create(1)
		arr[2] = cc.CallFunc:create(function() 
			local ex,ey = taskHero.bgLayer:getPosition()
			if math.abs(sx-ex) <= 5 and math.abs(sy-ey) <= 5 then
				taskHero:clickMap(sx+2,sy+2)
			end
		end)
		local sq = cc.Sequence:create(arr)
		self.panel.layer:runAction(sq)
	end
	
	--碰撞Npc
	local function isCollisionNpc(rx,ry,tx,ty)
		local mx=math.ceil(rx/GameField.tileWidth)-1
		local my=math.ceil(ry/GameField.tileHeight)-1
		for x=-3,3 do
			for y=0,1 do
				if tx == mx + x and ty == my + y then
					return true
				end
			end
		end
		return false
	end
	
	--碰撞物品
	local function isCollision(rx,ry,tx,ty)
		local mx=math.ceil(rx/GameField.tileWidth)-1
		local my=math.ceil(ry/GameField.tileHeight)-1
		for x=-1,1 do
			for y=0,1 do
				if tx == mx + x and ty == my + y then
					return true
				end
			end
		end
		return false
	end
	
	--英雄
	local mapHero
    local function weakCallBack(x,y)
		recordTouch.x = x
		recordTouch.y = y

		local state = true
		local mx,my = mapHero.bgLayer:getPosition()
		DataManager.setUserTileMapInfo(mx,my,curSceneId)

		if longPressed then
			cclog("313:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			longPressedMoved(mx, my)
		end

		for k,v in pairs(npcSprite)do
			if isCollisionNpc(x,y,v.npcInfo.x,v.npcInfo.y) then
				local receiveTaskNpc = Split(DataManager.getReceiveTaskNpc(),",")
				local tasklibrary = tonumber(receiveTaskNpc[4])
				local systemTaskId = tonumber(receiveTaskNpc[5])
				if tasklibrary == GameField.tasklibrary2 then	
					local commitTaskReq = TaskAction_commitTaskReq:New()
					commitTaskReq:setInt_systemTaskId(systemTaskId)
					commitTaskReq:setInt_times(1)
					NetReqLua(commitTaskReq)
				else
					--任务回调
					local function callback()
						delayPopNpcFunction(mapHero)
					end
				--	local temp  = UserGuidSetpCheck()
				--	if temp == true then  --因為新手指引而增加的
					LayerManager.show("NpcFunctionUIPanel",{curSceneId=curSceneId,npcInfo=v.npcInfo,callback=callback})
				--	end
				end
				
				local scaleX = math.abs(mapHero.skeleton:getScaleX())
				if x > v.npcInfo.x*GameField.tileWidth then
					mapHero.skeleton:setScaleX(-scaleX)
				else
					mapHero.skeleton:setScaleX(scaleX)
				end
				recordTouch.x = x
				recordTouch.y = y
				break
			end
		end
		
		for k,v in pairs(forceSprite)do --野怪
			if isCollision(x,y,v.force.x,v.force.y) and v:isVisible() then
                cacheForce = v.force
                local attackReq = ForcesAction_attackReq:New()
			    attackReq:setInt_mapId(v.force.mapId)
			    attackReq:setInt_forcesId(v.force.forcesId)
			    attackReq:setInt_forcesType(GameField.forcesDifficulty1)
			    NetReqLua(attackReq)
				recordTouch.x = x
				recordTouch.y = y
				break
			end
		end
		
		for k,v in pairs(bossSprite) do --世界Boss
			if isCollision(x,y,v.x,v.y) then
				local startAttackBossReq = BossAction_startAttackBossReq:New()
			    startAttackBossReq:setInt_mapId(systemScene.mapId)
			    startAttackBossReq:setInt_x(v.x)
			    startAttackBossReq:setInt_y(v.y)
			    NetReqLua(startAttackBossReq,true)
				break
			end
		end

        for k,v in pairs(collectSprite)do--矿物
			if isCollision(x,y,v.force.x,v.force.y) and v:isVisible() then
                cacheCollection = v
                local req = ForcesAction_startCollectReq:New()
                req:setInt_mapId(v.force.mapId)
                req:setInt_forcesId(v.force.forcesId)
                NetReqLua(req, true)
                break
            end
        end
		
		for k,v in pairs(fishingSprite)do --钓鱼
			if isCollisionNpc(x,y,v.force.x,v.force.y) and v:isVisible() then
				local scaleX = math.abs(mapHero.skeleton:getScaleX())
				if x > v.force.x*GameField.tileWidth then
					mapHero.skeleton:setScaleX(-scaleX)
				else
					mapHero.skeleton:setScaleX(scaleX)
				end
				
				cacheCollection = v
                local req = ForcesAction_startCollectReq:New()
                req:setInt_mapId(v.force.mapId)
                req:setInt_forcesId(v.force.forcesId)
                NetReqLua(req, true)
				break
			end
		end

		for k,v in pairs(duplicateSprite)do
			if isClickSprite(v,x,y) then
				LayerManager.show("FightDropUIPanel",{forces=v.bigForcesValue})
				recordTouch.x = x
				recordTouch.y = y
				break
			end
		end
		
		for k,v in pairs(enterSprite)do
			if isClickSprite(v,x,y) then
                if v.transferData.sceneId == 0 then
                    if not DataManager.isOpenMap(systemScene.mapId) then
						local req = UserAction_recordOpenMapReq:New()
                        req:setInt_mapId(systemScene.mapId)
                        NetReqLua(req, true)
                    else
                        MainMenuUIPanel_openWorldMap()
                    end
                else
					if v.transferData.level <= DataManager.getUserBO().level then
						state = false
						LayerManager.show("TileMapUIPanel",{oldSceneId=curSceneId,sceneId=systemTransfer[k].sceneId})
					else
						Tips(v.transferData.level..GameString.tileMapLevel)
					end
                end
				break
			end
		end
		
		if state then
			jumpSceneIdx = 0 
			jumpSceneList = {}
			DataManager.setReceiveTaskNpc()
		end
    end
	
	--停止动画
	local function stopLayerActions()
		--moveType1 = false
		--moveType2 = true
		--moveType3 = true
		moveType4 = true
		moveType5 = true
		moveLayer:stopAllActions()
		vistaLayer:stopAllActions()
	end
	
	local function userTouchCallBack()
		return moveType2
	end
	
	local function stopHeroCallBack()
		if moveType2 then
			local mx=moveLayer:convertToNodeSpace(cc.p(userTouch.x,userTouch.y)).x
			local my=moveLayer:convertToNodeSpace(cc.p(userTouch.x,userTouch.y)).y
			mapHero:clickMap(mx,my)
		else
			stopLayerActions()
		end
	end
	
    function TileMapUIPanel_showUserHero()
        local userName = DataManager.getUserBO().roleName
	    local sceneHero = DataManager.getSceneHero()
        local cacheX
        local cacheY
        if mapHero then
            cacheX = mapHero.bgLayer:getPositionX()
            cacheY = mapHero.bgLayer:getPositionY()
            mapHero:Release()
        end
	    mapHero = MapHero:New()
	    mapHero:Create(moveLayer,systemMap,sceneHero.systemHeroId,bornpointX,bornpointY,userName,stopHeroCallBack,userTouchCallBack,true)
        if cacheX and cacheY then mapHero.bgLayer:setPosition(cc.p(cacheX, cacheY)) end
		mapHero:setWeakCallBack(weakCallBack)
		
		local mx,my = mapHero.bgLayer:getPosition()
		DataManager.setUserTileMapInfo(mx,my,curSceneId)
    end
    TileMapUIPanel_showUserHero()
	
	--改名成功后 更新英雄头顶上的名称
	function TileMapUIPanel_ChangeUserHeroName(name)
		if nil ~= mapHero then
			mapHero:changeHeroName(name)
		end
	end
	
	--跳转屏幕
	local function getJumpScene(npcSceneId)
		local temp = {}
		local data = StaticDataManager.getSystemTransfer()
		function selectMapId(mapId,sceneId)
			for k,v in pairs(data) do
				if v.mapId == mapId then
					if v.sceneId == sceneId then
						tempId = v.mapId
						table.insert(temp,v)
						break
					else
						local flag = true
						for m,n in pairs(temp)do
							if n.sceneId == v.mapId and n.mapId == v.sceneId then
								flag = false
							end
						end
						
						if flag then
							table.insert(temp,v)
							selectMapId(v.sceneId,sceneId)
						end
					end
				end
			end
		end
		selectMapId(curSceneId,npcSceneId)
		
		for k=#temp,1,-1 do
			local v = temp[k]
			if v.sceneId == npcSceneId then
				npcSceneId = v.mapId
				table.insert(jumpSceneList,1,v)
			end
		end
	end
	
	function TileMapUIPanel_cleanJumpScene()
		jumpSceneIdx = 0 --跳转+1
		jumpSceneList = {}
	end
	
	--自动寻找NPC做任务
	function TileMapUIPanel_autoFindNpcTask()
		local receiveTaskNpc = Split(DataManager.getReceiveTaskNpc(),",")
		local npcSceneId = tonumber(receiveTaskNpc[1])
		local systemNpcId = tonumber(receiveTaskNpc[2])
		local state = tonumber(receiveTaskNpc[3])
		stopLayerActions()			
		if npcSceneId == curSceneId then
			if state == 0 then --NPC接受任务
				for k,v in pairs(systemNpc) do
					if systemNpcId == v.systemNpcId then
						local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
						local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
						mapHero:clickMap(tx, ty)
						break
					end
				end
			elseif state == 1 then --1副本 
				for k,v in pairs(systemBigForces) do
					if systemNpcId == v.bigForcesId then
						local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
						local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
						mapHero:clickMap(tx, ty)
						break
					end
				end
			elseif state == 2 then --野怪
				for k,v in pairs(systemForces) do
					if v.forcesId == systemNpcId and v.forcesCategory == GameField.forcesCategory1 then--怪物
						local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
						local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
						mapHero:clickMap(tx, ty)
						break
					end
				end
			end
		else
			if #jumpSceneList == 0 then
				getJumpScene(npcSceneId)
			end
			jumpSceneIdx = jumpSceneIdx + 1 --跳转+1
			local systemTransfer = jumpSceneList[jumpSceneIdx]
			if systemTransfer then
				local tx = GameField.tileWidth * systemTransfer.x + GameField.tileWidth/2
				local ty = GameField.tileHeight * systemTransfer.y + GameField.tileHeight/2
				mapHero:clickMap(tx*3,ty*2)
			end
		end
	end
	
	--NPC任务的标志
	local function createTaskTipSprite(skeleton,systemNpcId)
		if skeleton.taskTipSprite then
			skeleton.taskTipSprite:removeFromParent(true)
			skeleton.taskTipSprite = nil
		end

		local systemTask = DataManager.getHaveNpcTask(curSceneId,systemNpcId)
		if systemTask then
			local tipSprite
			--接受任务
			if systemTask.status == GameField.taskStatus0 then --状态
				if systemTask.taskType == GameField.taskType2 or
				   systemTask.taskType == GameField.taskType3 then--日常 支线
					tipSprite = "langantan.png"
				else
					if systemTask.limitMinLevel <= DataManager.getUserBO().level then
						tipSprite = "huanggantan.png"
					else
						tipSprite = "huise_tanhao.png"
					end
				end
			elseif systemTask.status == GameField.taskStatus1 then
				tipSprite = "huise_wenhao.png"
			elseif systemTask.status == GameField.taskStatus2 then
				if systemTask.taskType == GameField.taskType2 or 
				   systemTask.taskType == GameField.taskType3 then--日常 支线
					tipSprite = "lanwenhao.png"
				else
					tipSprite = "huangwenhao.png"
				end
			end
			
			if tipSprite then
				local tx,ty = skeleton.shadowsSprite:getPosition()
				local scale = skeleton:getScale()
				local size = skeleton:getContentSize()
				local taskTipSprite = CreateCCSprite(IconPath.wenhaogantanhao..tipSprite)
				taskTipSprite:setAnchorPoint(cc.p(0.5,0))
				taskTipSprite:setPosition(cc.p(tx,ty+size.height*scale+30))
				moveLayer:addChild(taskTipSprite,1000)
				skeleton.taskTipSprite = taskTipSprite
			end
		end
	end
	
	--更新任务图标
	function TileMapUIPanel_Task_update()
		for k,v in pairs(npcSprite)do 
			createTaskTipSprite(v,v.npcInfo.systemNpcId)
		end
	end
	
	--地图
	if systemMap.town == 1 then --城镇
		local idx = 0
		for k=1,systemMap.mapNum do
			idx = idx + 1
			local sprite = CreateCCSprite(IconPath.ditu..systemMap.imgId.."_0"..idx..".png")
			local size = sprite:getContentSize()
			sprite:setPosition(cc.p((2*k-1)*size.width/2,size.height/2))			
			moveLayer:addChild(sprite,-1)
		end
		
		for k=1,systemMap.mapNum do
			idx = idx + 1
			local sprite = CreateCCSprite(IconPath.ditu..systemMap.imgId.."_0"..idx..".png")
			local size = sprite:getContentSize()
			sprite:setPosition(cc.p((2*k-1)*size.width/2,viewHeight-size.height/2))
			vistaLayer:addChild(sprite,1)
		end
	else
		for k=1,systemMap.mapNum do
			local sprite = CreateCCSprite(IconPath.ditu..systemMap.imgId.."_0"..k..".png")
			local size = sprite:getContentSize()
			if k % 2 == 0 then
				sprite:setPosition(cc.p(size.width*3/2,size.height*(math.ceil(k/2)*2-1)/2))
			else
				sprite:setPosition(cc.p(size.width/2,size.height*(math.ceil(k/2)*2-1)/2))
			end
			
			moveLayer:addChild(sprite,-1)
		end
	end
	
	--地图物件
	if systemMap.thingResId ~= "none" then
		local filePath = "tileMap/"..systemMap.thingResId..".json"
		local tileMapUI = ccs.GUIReader:getInstance():widgetFromJsonFile(filePath)
		moveLayer:addChild(tileMapUI,2)
		
		local pendantList = tileMapUI:getChildren()
		for k,v in pairs(pendantList)do
			local name =  v:getName()
			if string.sub(name,1,2) == "c_" then --物件的碰撞
				local x,y = v:getPosition()
				table.insert(objectList,v)
			end
		end
	end
	
	--npc	
	for k,v in pairs(systemNpc) do
		v.x = v.x*3
		v.y = v.y*2
		local actionNum = math.random(20)
		local tz = (maxTileNumY-v.y-0.5)*GameField.tileHeight
		local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
		local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
		
		local shadowsSprite = CreateCCSprite("fight/shadows.png")
		local size = shadowsSprite:getContentSize()
		shadowsSprite:setPosition(cc.p(tx,ty))
		moveLayer:addChild(shadowsSprite,tz)
		
		local npc =  SkeletonAction:New() 
		local skeleton = npc:Create(v.resId)
		skeleton:setScale(v.modelScale)
		skeleton:setPosition(cc.p(size.width/2,size.height/2))
		skeleton:getAnimation():play(ACTION_HOLD)
		--skeleton:getAnimation():setSpeedScale(math.random(0.9,1.1))
		skeleton.npcInfo = v
		skeleton.shadowsSprite = shadowsSprite
		shadowsSprite:addChild(skeleton)
		table.insert(npcSprite,skeleton)
		createTaskTipSprite(skeleton,v.systemNpcId)
		
		local rect = skeleton:getBoundingBox()
		local offY = rect.y + rect.height
		
		local npcTitle = v.npcTitle
		if npcTitle ~= "" then
			npcTitle = "<"..npcTitle..">" --称号
			local titleLabel = CreateLabel(npcTitle,nil,18)
			titleLabel:setPosition(size.width/2,offY+size.height/2)
			shadowsSprite:addChild(titleLabel)
			offY = offY + 18
		end
		
		local nameLabel = CreateLabel(v.npcName,nil,18) --名称
		nameLabel:setPosition(size.width/2,offY+size.height/2)
		shadowsSprite:addChild(nameLabel,10)
		
		local function rCallBack()
			
		end
		
		local function eCallBack(movementID) --随机播放
			if movementID == ACTION_SHOW01 or 
			   movementID == ACTION_SHOW02 then
				skeleton:getAnimation():play(ACTION_HOLD)
			elseif movementID == ACTION_HOLD then
				actionNum = actionNum - 1
				if actionNum <= 0 then
					actionNum = 10+math.random(5)
					if skeleton:getAnimation():getAnimationData():getMovement(ACTION_SHOW01) then	
						skeleton:getAnimation():play(ACTION_SHOW01) 
					end
				end
			end
		end
		npc:setFrameCallBack(rCallBack,eCallBack)
	end
	
	--关卡
	for k,v in pairs(systemForces) do
		v.x = v.x*3
		v.y = v.y*2
					
		local offY = 0
		local tz = (maxTileNumY-v.y-0.5)*GameField.tileHeight
		local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
		local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
		
		local shadowsSprite = CreateCCSprite("fight/shadows.png")
		local size = shadowsSprite:getContentSize()
		shadowsSprite:setPosition(cc.p(tx,ty))
		moveLayer:addChild(shadowsSprite,tz)
		
		if v.forcesCategory == GameField.forcesCategory1 then--怪物
			local forces =  SkeletonAction:New()
			local skeleton = forces:Create(v.imgId)				
			skeleton:setScale(v.modelScale)
			skeleton:setPosition(cc.p(size.width/2,size.height/2))
			skeleton:getAnimation():play(ACTION_HOLD)
			skeleton:getAnimation():setSpeedScale(math.random(0.9,1.1))
			skeleton.force = v
			skeleton.shadowsSprite = shadowsSprite
			shadowsSprite:addChild(skeleton,tz)
			table.insert(forceSprite,skeleton)
			
			local rect = skeleton:getBoundingBox()
			offY = rect.y + rect.height
			
			if DataManager.getWorldBossInfo().mapId == systemMap.mapId then
				shadowsSprite:setVisible(false)
			end
			
		elseif v.forcesCategory == GameField.forcesCategory3 then--采集矿
			local enterSprite = CreateCCSprite(IconPath.caikuang..v.imgId..".png")
			enterSprite:setScale(v.modelScale)
			enterSprite:setPosition(cc.p(size.width/2,size.height))
			shadowsSprite:addChild(enterSprite)
			shadowsSprite.enterSprite = enterSprite
			shadowsSprite.force = v
			
			local spriteSize = enterSprite:getContentSize()
			local skeleton = CreateEffectSkeleton("t26")
			skeleton:setPosition(cc.p(spriteSize.width/2,spriteSize.height * 0.2))
			skeleton.force = v
			skeleton.shadowsSprite = shadowsSprite
			enterSprite:addChild(skeleton,tz)
			table.insert(collectSprite,shadowsSprite)
			
			offY = enterSprite:getContentSize().height*2/3 + 10
		elseif v.forcesCategory == GameField.forcesCategory4 then --钓鱼
			local skeleton = CreateEffectSkeleton("t23")
			skeleton:setScale(v.modelScale)
			skeleton:setPosition(cc.p(size.width/2,size.height/2))
			skeleton.force = v
			skeleton.shadowsSprite = shadowsSprite
			shadowsSprite:addChild(skeleton,tz)
			table.insert(fishingSprite,skeleton)
			
			local rect = skeleton:getBoundingBox()
			offY = rect.y + rect.height
		end
		
		local forcesTitle = v.forcesTitle or ""
		if forcesTitle ~= "" then --称号
			forcesTitle = "<"..forcesTitle..">"
			local titleLabel = CreateLabel(forcesTitle,nil,18)
			titleLabel:setPosition(size.width/2,offY+size.height/2)
			shadowsSprite:addChild(titleLabel)
			offY = offY + 20
		end			
		
		local nameLabel = CreateLabel(v.forcesName, nil, 18) --名称
		nameLabel:setPosition(size.width/2,offY+size.height/2)
		shadowsSprite:addChild(nameLabel)
	end
	
	--副本
	for k,v in pairs(systemBigForces) do
		v.x = v.x*3
		v.y = v.y*2
		local tx = GameField.tileWidth*v.x+GameField.tileWidth/2*k
		local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
		local shadowsSprite = CreateCCSprite("fight/shadows.png")
		shadowsSprite:setPosition(cc.p(tx,ty))
		moveLayer:addChild(shadowsSprite)
		
		local nameLabel = CreateLabel(v.bigForcesName,nil,18)
		nameLabel:setPosition(tx,ty+150)
		moveLayer:addChild(nameLabel,50)
		
		local enterSprite = CreateCCSprite("tileMap/yuansu/enter3.png")
        enterSprite.bigForcesValue = v
		enterSprite:setPosition(cc.p(tx,ty))
		moveLayer:addChild(enterSprite,maxTileNumY-v.y)
		table.insert(duplicateSprite,enterSprite)
	end
	
	--传送点
	for k,v in pairs(systemTransfer) do	
		v.x = v.x*3
		v.y = v.y*2
		local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
		local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
		local sprite = CreateEffectSkeleton(v.resId)
		sprite:setPosition(cc.p(tx,ty))
        sprite.transferData = v
		moveLayer:addChild(sprite,20)
		table.insert(enterSprite,sprite)
	end
	
	function longPressedMoved(moveX, moveY)
		local mx = moveX
		local my = moveY

		cclog("857:>>>>>>>>>>>>>>>>>>>>>>>>")
		mapHero:clickMap(mx, my)
	end

	function TileMapUIPanel_Ontouch(e,x,y)
		local mx=moveLayer:convertToNodeSpace(cc.p(x,y)).x
		local my=moveLayer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then
			userTouch.x = x
			userTouch.y = y
			
			moveType2 = true
			jumpSceneIdx = 0 
			jumpSceneList = {}
			stopLayerActions()
			DataManager.setReceiveTaskNpc()
			mapHero:clickMap(mx,my)
            MainMenuUIPanel_menuMove(false)
			
		elseif e=="moved" then
			if math.abs(userTouch.x-x) >= 16 and math.abs(userTouch.y-y) >= 16 then
				userTouch.x = x
				userTouch.y = y
				mapHero:clickMap(mx,my)
			end
		else
			if self.longPressedTimeHandler then
				longPressed = false
				self.panel:unscheduleScriptEntry(self.longPressedTimeHandler)
			end
			self.longPressedTimeHandler = nil
	
			isTouchFish = false
			for k,v in pairs(npcSprite)do --点击NPC
				local boxRect = v:getBoundingBox()
				local location = v.shadowsSprite:convertToNodeSpace(cc.p(x,y))
				if location.x > boxRect.x and location.x < boxRect.x+boxRect.width and 
				   location.y > boxRect.y and location.y < boxRect.y+boxRect.height then
					if mx < v.npcInfo.x * GameField.tileWidth then
						mx = (v.npcInfo.x - 2) * GameField.tileWidth
						my = v.npcInfo.y * GameField.tileHeight
					else
						mx = (v.npcInfo.x + 2) * GameField.tileWidth
						my = v.npcInfo.y * GameField.tileHeight
					end
					
					if v:getAnimation():getCurrentMovementID() ~= ACTION_SHOW02 and 
					   v:getAnimation():getAnimationData():getMovement(ACTION_SHOW02) then
						v:getAnimation():play(ACTION_SHOW02)
					end
					break
				end
			end
			
			for k,v in pairs(forceSprite)do
				local boxRect = v:getBoundingBox()
				local location = v.shadowsSprite:convertToNodeSpace(cc.p(x,y))
				if location.x > boxRect.x and location.x < boxRect.x+boxRect.width and 
				   location.y > boxRect.y and location.y < boxRect.y+boxRect.height and 
				   v:isVisible() then 
					mx = v.force.x * GameField.tileWidth
					my = v.force.y * GameField.tileHeight
				end
			end
			
			for k,v in pairs(fishingSprite)do
				local boxRect = v:getBoundingBox()
				local location = v.shadowsSprite:convertToNodeSpace(cc.p(x,y))
				if location.x > boxRect.x and location.x < boxRect.x+boxRect.width and 
				   location.y > boxRect.y and location.y < boxRect.y+boxRect.height and 
				   v.shadowsSprite:isVisible() then
					if mx < v.force.x * GameField.tileWidth then
						mx = (v.force.x - 2) * GameField.tileWidth
						my = v.force.y * GameField.tileHeight
					else
						mx = (v.force.x + 2) * GameField.tileWidth
						my = v.force.y * GameField.tileHeight
					end
					isTouchFish = true
				end
			end
			moveType1 = false
			moveType2 = false
			mapHero:clickMap(mx,my)
			--[[
			jumpSceneIdx = 0 
			jumpSceneList = {}
			stopLayerActions()
			DataManager.setReceiveTaskNpc()
			mapHero:clickMap(mx,my)
            MainMenuUIPanel_menuMove(false)]]
		end
		return true
	end
	
	--显示其他的玩家
	local function showSceneOtherHero(hero)
		local gameHero = MapHero:New()
		gameHero:Create(moveLayer,systemMap,hero.heroId,hero.posX,hero.posY,hero.userName,nil,nil,false)
		gameHero.userId = hero.userId
		table.insert(otherHero,gameHero)
	end
	
	--显示同屏幕玩家说话的气泡框
	local function showSceneOtherHeroChatBubble(msg)
		for k, v in pairs(otherHero) do
			if v.userId == msg.userId then
				v:showHeroChatBubble(msg)
				break
			end
		end
	end
	
	--自己聊天推送消息  （由本地推送过来）
    function TileMapUIPanel_OwnChat_pushChatInfo(msg)
		--if LayerManager.isPanelActive(TileMapUIPanel) then
		--end
		mapHero:showHeroChatBubble(msg)
    end
	
	--聊天推送消息
    function TileMapUIPanel_Chat_pushChatInfo(msgObj)
		showSceneOtherHeroChatBubble(msgObj.body.userChatRecordBO)
    end
	
	--用户进入场景
	function TileMapUIPanel_Scene_enter(msgObj)
		showSceneOtherHero(msgObj.body)
	end
	
	--用户退出场景
	function TileMapUIPanel_Scene_exit(msgObj)
		for k=#otherHero,1,-1 do
			if otherHero[k].userId == msgObj.body.userId then
				otherHero[k]:Release()
				table.remove(otherHero,k)
				break
			end
		end
	end
	
	--用户移动
	function TileMapUIPanel_Scene_move(msgObj)
		for k=#otherHero,1,-1 do
			if otherHero[k].userId == msgObj.body.userId then
				local tx = msgObj.body.posX*GameField.tileWidth
				local ty = msgObj.body.posY*GameField.tileHeight
				local skeleton = otherHero[k]
				skeleton:clickMap(tx,ty)
				break
			end
		end
	end
	-- 此处被我屏蔽。因为我还没想到处理新手指引的 事情
	function TileMapUIPanel_TaskAction_commitTask()
	    if 0==0 then 
		   cclog( "678 SSSSSSSSSSSSSSSSSSSSS 领取了一条任务之后会 弹出这些 东西。哥不要先" )
		   return 
	    end
		cclog( "678 SSSSSSSSSSSSSSSSSS  哥  无法控制 ！！！！！" )
		local function callback()
			delayPopNpcFunction(mapHero)
		end
		
		local x,y = mapHero.bgLayer:getPosition()
		for k,v in pairs(npcSprite)do
			if isClickSprite(v.shadowsSprite,x,y) then
				LayerManager.show("NpcFunctionUIPanel",{curSceneId=curSceneId,npcInfo=v.npcInfo,callback=callback})
				break
			end
		end
	end
	
	--显示全部其他的玩家
	local function showSceneAllOtherHero(heroList)
		local systemConfig = DataManager.getSystemConfig()
		local pepNums = nil
		
		--获取本地保存同屏玩家数
		pepNums =  tonumber(ConfigManager.getLocalValueByKey(ConfigManager.showPeopelNums))
		if pepNums == nil then 
			--如果没有保存就使用总推过来的默认值
			pepNums = tonumber(systemConfig.screen_display_lower_num)
		end 
		
		for k,v in pairs(heroList) do
			if #otherHero > pepNums then 
				break
			end		
			showSceneOtherHero(v)
		end
		
		if DataManager.getReceiveTaskNpc() then
			TileMapUIPanel_autoFindNpcTask()
		end
	end
	
	--加载场景完成
	local function showLoadedSceneHero()
		function TileMapUIPanel_SceneAction_loaded(msgObj)
			local function sendWalkFunc()
				if recordTouch.x ~= sendUserTouch.x or recordTouch.y ~= sendUserTouch.y then
					local tx = math.floor(recordTouch.x/GameField.tileWidth)
					local ty = math.floor(recordTouch.y/GameField.tileHeight)
					local moveReq=SceneAction_moveReq:New()
					moveReq:setInt_sceneId(curSceneId)
					moveReq:setInt_posX(tx)
					moveReq:setInt_posY(ty)
					NetReqLua(moveReq,false)
					sendUserTouch.x = recordTouch.x --值传递
					sendUserTouch.y = recordTouch.y
				end
			end
			self.weakHandler = self.panel:scheduleScriptFunc(sendWalkFunc,3)
			showSceneAllOtherHero(msgObj.body.sceneUsersList)
		end
		local loadedReq = SceneAction_loadedReq:New()
		loadedReq:setInt_sceneId(curSceneId)
		NetReqLua(loadedReq,false)
	end
	
	--进入场景
	function TileMapUIPanel_SceneAction_enter(msgObj)
		if systemScene.sceneType == GameField.sceneType2 then
			showLoadedSceneHero()
		end
	end
	
	local enterReq = SceneAction_enterReq:New()
	enterReq:setInt_sceneId(curSceneId)
	enterReq:setInt_posX(bornpointX)
	enterReq:setInt_posY(bornpointY)
	NetReqLua(enterReq,true)
		
	local of = 0.8
	local moveHYUp = 450
	local moveHYDown = 380
	local function checkRun(ts)
		if mapHero.isRun and mapHero.interval > 0 then
			local tx = 0
			local ty = 0
			local kx = 0
			local lenX = mapHero.targetX/math.ceil(mapHero.interval/ts)
			local lenY = mapHero.targetY/math.ceil(mapHero.interval/ts)
			
			local mx,my = moveLayer:getPosition()
			local vx,vy = vistaLayer:getPosition()
			local hx,hy = mapHero.bgLayer:getPosition()

			--[[
			cclog("1114:>>>>>>>>>>>>>>>>>>>>>>>>")
			cclog("hx:"..hx)
			cclog("hy:"..hy)
			]]
			
			kx = vx + lenX/2
			tx = mx + lenX
			mapHero.offsetX = mapHero.offsetX + lenX
			
			ty = my + lenY
			mapHero.offsetY = mapHero.offsetY + lenY
			
			--[[
			local testLayer = cc.LayerColor:create(cc.c4b(255,0,0,255))
			testLayer:setContentSize(cc.size(1920*2,3))
			testLayer:setPosition(cc.p(0,moveHYUp))
			moveLayer:addChild(testLayer,100)

			testLayer = cc.LayerColor:create(cc.c4b(0,0,0,255))
			testLayer:setContentSize(cc.size(1920*2,3))
			testLayer:setPosition(cc.p(0,moveHYDown))
			moveLayer:addChild(testLayer,100)
			]]

			if addMoveTime > 0 and mapHero.targetY < 0 and hy >= moveHYUp and hx > 1200 and hx < 2500 then--my < maxMoveY/4
				moveType1 = true
				ty = ty - of
			end
			
			if addMoveTime > 0 and mapHero.targetY > 0 and my > maxMoveY and hy <= moveHYDown and hx > 1200 and hx < 2500 then--my > maxMoveY + 80
				moveType3 = true
				ty = ty + of
			end
			
			if math.abs(mapHero.offsetX) < GameField.tileWidth/2 then
				tx = mx
			end
			
			if math.abs(mapHero.offsetY) < GameField.tileHeight/2-50 then
				ty = my
			end
			
			local world = mapHero.bgLayer:convertToWorldSpace(cc.p(0,0))
			if (mapHero.targetX > 0 and world.x > viewWidth/2) or 
			   (mapHero.targetX < 0 and world.x < viewWidth/2) then
				tx = mx
			end
			
			if (mapHero.targetY > 0 and world.y > viewHeight/2) or (mapHero.targetY < 0 and world.y < viewHeight/2 and addMoveTime == 0) then
				ty = my
			end
			
			if (mapHero.targetY < 0 and world.y < viewHeight/3 and addMoveTime > 0 and my > maxMoveY/4) then
				ty = my
			end
			
			tx = tx > 0 and 0 or tx
			tx = tx < maxMoveX and maxMoveX or tx
			
			ty = ty > 0 and 0 or ty
			ty = ty < maxMoveY and maxMoveY or ty
			
			if tx == mx then
				kx = vx
			end
			
			moveLayer:setPosition(cc.p(tx,ty))
			vistaLayer:setPosition(cc.p(kx,vy))
			mapHero.bgLayer:setPosition(hx-lenX,hy-lenY)
		else
			if moveType1 then
				local mx,my = moveLayer:getPosition()
				local hx,hy = mapHero.bgLayer:getPosition()
				if addMoveTime > 0 and maxMoveY < my - of and hy >= moveHYUp then
					moveLayer:setPosition(cc.p(mx,my - of))
				else
					moveType1 = false
				end
			end
			
			if moveType3 then
				local mx,my = moveLayer:getPosition()
				local hx,hy = mapHero.bgLayer:getPosition()
				if addMoveTime > 0 and my + of <= 0 and hy <= moveHYDown then
					moveLayer:setPosition(cc.p(mx,my + of))
				else
					moveType3 = false
				end
			end
		end
		
		--[[
		local mx,my = moveLayer:getPosition()
		local tx,ty = vistaLayer:getPosition()
		if mapHero.isRun then
			local at = mapHero.interval
			local hx,hy = mapHero.bgLayer:getPosition()
			local offsetX = mapHero.offsetX
			local offsetY = mapHero.offsetY
			
			if moveType1 and systemMap.town == 1 and
   			   hx >= viewWidth/2 and hx <= viewWidth/2 - maxMoveX then
				moveType1 = false
				moveLayer:runAction(cc.MoveTo:create(at,cc.p(mx + offsetX,my)))
				vistaLayer:runAction(cc.MoveTo:create(at,cc.p(tx + offsetX/3,ty)))
			end
			
			if moveType4 and systemMap.town == 1 and
   			   hy >= viewHeight/2 and hy <= viewHeight/2 - maxMoveY then
				moveType4 = false
				if addMoveYNum > 0 and offsetY < 0 and my + offsetY < maxMoveY/2 then
					moveType5 = false
					local arr = {}
					arr[1] = cc.MoveTo:create(at+addMoveTime,cc.p(mx,maxMoveY))
					arr[2] = cc.CallFunc:create(function()
						moveType5 = true
					end)
					local sq = cc.Sequence:create(arr)
					moveLayer:runAction(sq)
				else
					moveLayer:runAction(cc.MoveTo:create(at,cc.p(mx,my+offsetY)))
				end
				vistaLayer:runAction(cc.MoveTo:create(at,cc.p(tx,ty)))
			end
			
			if moveType2 and systemMap.town == 0 and 
			   hx >= viewWidth/2 and hx <= viewWidth/2 - maxMoveX then
				moveType2 = false
				moveLayer:runAction(cc.MoveTo:create(at,cc.p(mx + offsetX,my)))
			end
			
			if moveType3 and systemMap.town == 0 and
			   hy >= viewHeight/2 and hy <= viewHeight/2 - maxMoveY then
				moveType3 = false
				moveLayer:runAction(cc.MoveTo:create(at,cc.p(mx,my+offsetY)))
			end
		else
			if addMoveYNum > 0 then
				if moveType5 then
					stopLayerActions()
				end
			else
				stopLayerActions()
			end
		end
		
		mx = mx > 0 and 0 or mx
		mx = mx < maxMoveX and maxMoveX or mx
		
		tx = tx > 0 and 0 or tx
		tx = tx < maxMoveX and maxMoveX or tx
		
		my = my > 0 and 0 or my
		my = my < maxMoveY and maxMoveY or my
		
		--ty = ty > 0 and 0 or ty
		--ty = ty < maxMoveY + winSize.height and maxMoveY + winSize.height or ty
		
		moveLayer:setPosition(cc.p(mx,my))
		
		if mx == 0 or mx == maxMoveX then
			vistaLayer:stopAllActions()
		end]]
	end
	
	local function checkCollision(hero)
		if not hero.isRun then
			return
		end
		local bx,by = hero.bgLayer:getPosition()
		local zorder = maxTileNumY*GameField.tileHeight - by
		hero.bgLayer:setLocalZOrder(zorder)
		hero:setMapOpacity(255)
		
		for k,v in pairs(forceSprite) do
			if isClickSprite(v,bx,by) then
				if zorder < v:getLocalZOrder() then
					v:setOpacity(255)
				else
					v:setOpacity(180)
				end
			else
				v:setOpacity(255)
			end
		end
		
		for k,v in pairs(duplicateSprite) do
			if isClickSprite(v,bx,by) then
				hero:setMapOpacity(160)
				break
			end
		end
		
		for k,v in pairs(objectList) do
			if isClickSprite(v,bx,by) then
				hero:setMapOpacity(160)
				break
			end
		end
	end
	
	local function checkFrameFunc(ts)
		checkRun(ts)
		checkCollision(mapHero)
		for k,v in pairs(otherHero) do
			checkCollision(v)
		end
	end
	self.frameHandler = self.panel:scheduleScriptFunc(checkFrameFunc,0)	

	function TileMapUIPanel_ForcesAction_attack()		
		local fightResult = {}
		fightResult.forces = cacheForce
		fightResult.fightType = GameField.fightType2
		fightResult.forcesDifficulty = GameField.forcesDifficulty1
		fightResult.hero = DataManager.getUserHeroBattleList()
		fightResult.monster = DataManager.getSystemForcesMonster(cacheForce.forcesId,GameField.forcesDifficulty1)	
		fightResult.headSkill = DataManager.getFightHeadSkillList()	
		LayerManager.show("FightUIPanel",{fightResult=fightResult})
	end
	
	--团队升级
	function TileMapUIPanel_heroLevelUpgrade()
		if LayerManager.isPanelActive("TileMapUIPanel") then
			local x,y = mapHero.skeleton:getPosition()
			local skeletonSkill = SkeletonSkill:New()
			local skeleton1 = skeletonSkill:Create("t12",0)
			skeleton1:setPosition(cc.p(x+6,-78))
			skeletonSkill:setCommonPlay(false)
			mapHero.bgLayer:addChild(skeleton1,1)
			
			for k,v in pairs(npcSprite)do 
				createTaskTipSprite(v,v.npcInfo.systemNpcId)
			end
            cclog( "928 TileMapUIPanel_heroLevelUpgrade  团队升级的时候在此触发 " )
            MainMenuUIPanel_updateOpenIcon(true)
		end
	end
    
    --请求获取地图矿物信息 
    local function reqMapCollection()
        local req = ForcesAction_getMapCollectionInfoReq:New()
        req:setInt_mapId(systemScene.mapId)
        NetReqLua(req, true)
    end
	
    if systemMap.town == 0 then--野外地图才请求
        reqMapCollection()
    end
	
    --请求采矿结束
    local function reqMapCollectionEnd(isEnd)
		if isEnd then
			local req = ForcesAction_endCollectReq:New()
			req:setInt_mapId(systemScene.mapId)
			req:setInt_forcesId(cacheCollection.force.forcesId)
			NetReqLua(req)
		else
			local req = ForcesAction_cancelCollectRes:New()
			NetReqLua(req)
		end
    end

    --开始采集
    function TileMapUIPanel_ForcesAction_startCollect(msgObj)
        LayerManager.show("CollectionUIPanel",{secTim=cacheCollection.force.collectionTime,
											    forcesCategory=cacheCollection.force.forcesCategory,
												callBack=reqMapCollectionEnd})
    end

    --结束采集
    function TileMapUIPanel_ForcesAction_endCollect(msgObj)
        if msgObj.body.isFightAgain == 0 then
            LayerManager.show("DialogRewardsNewUIPanel",{data = msgObj.body.drop})--展示获得东西
            reqMapCollection()
        else--战斗
            local x,y = mapHero.bgLayer:getPosition()
		    local fightResult = {}
		    fightResult.forces = cacheCollection.force
            fightResult.isFromCollect = true--来自采集直接打
			fightResult.fightType = GameField.fightType2
		    fightResult.forcesDifficulty = GameField.forcesDifficulty1
		    fightResult.hero = DataManager.getUserHeroBattleList()
		    fightResult.monster = DataManager.getSystemForcesMonster(cacheCollection.force.forcesId,GameField.forcesDifficulty1)		
		    fightResult.headSkill = DataManager.getFightHeadSkillList()		
		    LayerManager.show("FightUIPanel",{x=x,y=y,sceneId=curSceneId,fightResult=fightResult})
        end
    end

    --获取地图矿物信息
    function TileMapUIPanel_ForcesAction_getMapCollectionInfo(msgObj)
        --更新地图矿物信息    
        for k,v in pairs(collectSprite) do
            v:setVisible(false)
            for k2,v2 in pairs(msgObj.body.userCollectList) do
                if v2.forcesId == v.force.forcesId then
                    v:setVisible(true)
                    break
                end
            end
        end
    end
	
    --激活传送点
    function TileMapUIPanel_UserAction_recordOpenMap(msgObj)
        DataManager.addOpenMapId(systemScene.mapId)
        MainMenuUIPanel_openWorldMap()
    end
	SoundEffect.playBgMusic(systemMap.soundEffectId)
	
	--boss模型
	local function showBossSkeleton()
		local bossInfo = DataManager.getWorldBossInfo()
		cclog(systemScene.mapId.."==="..bossInfo.mapId)
		if bossInfo.mapId ~= systemScene.mapId then
			return
		end
		
		local bossHero = DataManager.getBossHero(bossInfo.mapId)
		if bossHero then
			local tx = 960
			local ty = 640
			local shadowsSprite = CreateCCSprite("fight/shadows.png")
			local size = shadowsSprite:getContentSize()
			shadowsSprite:setPosition(cc.p(tx,ty))
			moveLayer:addChild(shadowsSprite)
		
			local forces = SkeletonAction:New()
			local skeleton = forces:Create(bossHero.imgId)				
			skeleton:setScale(bossHero.modelScale)
			skeleton:setPosition(cc.p(size.width/2,size.height/2))
			skeleton:getAnimation():play(ACTION_HOLD)
			skeleton.x = tx/GameField.tileWidth
			skeleton.y = ty/GameField.tileHeight
			shadowsSprite:addChild(skeleton,100)
			table.insert(bossSprite,skeleton)

			bossHeroId = bossHero.systemHeroId --bossHeroID的
			self.panel:setNodeVisible("img_bossInfo",true)
			self.panel:setBitmapText("lab_name",bossHero.heroName)
			self.panel:setImageTexture("img_heroHead",IconPath.yingxiong..bossHero.imgId..".png")
			self.panel:setImageTexture("img_headColor",IconPath.pinzhiYaun..bossHero.heroColor..".png")
			self.panel:setProgressBarPercent("ProgressBar_bloom",bossInfo.currentLife/bossInfo.maxLife*100)
			
			for k,v in pairs(forceSprite)do --隐藏野怪
				v.shadowsSprite:setVisible(false)
			end
			
			local function bossTimeFunc()
				bossInfo.continueTimes = bossInfo.continueTimes - 1000
				self.panel:setBitmapText("lab_time",Utils.remainTimeToStringMMSS(bossInfo.continueTimes))
			end
			self.bossTimeHandler = Director.getScheduler():scheduleScriptFunc(bossTimeFunc, 1, false)
		end
	end
	showBossSkeleton()
	
	--推送世界Boss信息
	function TileMapUIPanel_Boss_pushWorldBossInfo(msgObj)
		showBossSkeleton()
	end
	
	--复活
	function TileMapUIPanel_BossAction_relive(msgObj)
		
	end
	
	--开始攻打世界boss
	function TileMapUIPanel_BossAction_startAttackBoss(msgObj)		
		local heroList = {}
		for k,v in pairs(msgObj.body.userDataList)do
			local userHero = v.userHeroBO
			userHero.posX = math.random(960)
			userHero.posY = math.random(460)
			userHero.equips = {}
			for m,n in pairs(v.equipList) do
				table.insert(userHero.equips,DataTranslater.tranEquip(n))
			end
			table.insert(heroList,userHero)
		end
		
		local fightResult = {}
		fightResult.forces = {}
		fightResult.headSkill = {}
		fightResult.hero = heroList
		fightResult.fightType = GameField.fightType4
		fightResult.forcesDifficulty = GameField.forcesDifficulty1
		fightResult.monster = {monsterId=bossHeroId}
		LayerManager.show("FightUIPanel",{fightResult=fightResult})
	end
	
	--推送世界Boss结束信息
	function TileMapUIPanel_Boss_pushWorldBossDie(msgObj)
		for k,v in pairs(forceSprite)do --隐藏野怪
			v.shadowsSprite:setVisible(true)
		end
		self.panel:setNodeVisible("img_bossInfo",false)
	end
	
	--推送世界Boss当前血量
	function TileMapUIPanel_Boss_pushWorldBossCurrentLife(msgObj)
		local bossInfo = DataManager.getWorldBossInfo()
		self.panel:setProgressBarPercent("ProgressBar_bloom",bossInfo.currentLife/bossInfo.maxLife*100)
	end
	
	--场景特效
	-- 天气事件刷新
	local sceneWeather = DataManager.getWeatherList(curSceneId)
	local weatherSprite = nil
	local lightSprite = nil 	--闪电天气(因为要混合到打雷天气中  所以需要定义变量额外保存)
	local rainSprite = nil		--下雨天气(因为要混合到雷电天气中  所以需要定义变量额外保存)
	local perChangeTime = 30
	local weatherNum = 4				--天气数量
	local playTime = {30, 30, 30, 30}		--不同天气播放的时间长度  {正常，下雪， 下雨， 雷电雨}
	self.timeHandler = nil
	local addSenceEffect = nil
	
	local function checkWeatherTime()
		local oldTime = DataManager.getGameTime()
		local nowTime = os.time()
		if nowTime - oldTime > perChangeTime then
			local rd = math.random(weatherNum)
			DataManager.setWeatherStartTime(nowTime)
			DataManager.setCurrentWeather(sceneWeather[rd])
			addSenceEffect(sceneWeather[rd])
		end
	end
	
	addSenceEffect = function(weatherId, times)
		if nil ~= weatherSprite then
			weatherSprite:stopAllActions()
			weatherSprite:removeFromParent()
			weatherSprite = nil
		end
		if nil ~= lightSprite then
			lightSprite:stopAllActions()
			lightSprite:removeFromParent()
			lightSprite = nil
		end
		if nil ~= rainSprite then
			rainSprite:stopAllActions()
			rainSprite:removeFromParent()
			rainSprite = nil
		end
		
		if 2 == weatherId then			
			weatherSprite =  cc.ParticleSnow:create()
			weatherSprite:setSpeed(100)
		elseif 3 == weatherId then
			weatherSprite = CreateEffectSkeleton("t24")
			weatherSprite:setPosition(cc.p(winSize.width/2, winSize.height * 0.8))
			--weatherSprite = cc.ParticleRain:create()
			--weatherSprite:setTexture(cc.Director:getInstance():getTextureCache():addImage("NewUi/xinqietu/fuben/b_kais.png"))
			--weatherSprite:setSpeed(100)
		elseif 4 == weatherId then
			weatherSprite = CreateEffectSkeleton("t27")
			weatherSprite:setPosition(cc.p(winSize.width/2, winSize.height * 0.5))
			lightSprite = CreateEffectSkeleton("t28")
			lightSprite:setPosition(cc.p(winSize.width/2, winSize.height * 0.5))
			rainSprite = CreateEffectSkeleton("t24")
			rainSprite:setPosition(cc.p(winSize.width/2, winSize.height * 0.8))
		end
		if nil ~= self.timeHandler then
			Director.getScheduler():unscheduleScriptEntry(self.timeHandler)
			self.timeHandler = nil
		end
		if nil ~= weatherSprite then 
			self.panel.layer:addChild(weatherSprite, 10000)
			if nil ~= lightSprite then
				self.panel.layer:addChild(lightSprite, 10005)
				lightSprite:runAction(cc.Sequence:create( cc.Hide:create(), cc.DelayTime:create(3),
														  cc.Show:create(), cc.DelayTime:create(5),
														  cc.Hide:create(), cc.DelayTime:create(4),
														  cc.Show:create(), cc.DelayTime:create(3),
														  cc.Hide:create(), cc.DelayTime:create(8),
														  cc.Show:create(), cc.DelayTime:create(5)
				))
			end
			if nil ~= rainSprite then
				self.panel.layer:addChild(rainSprite, 9999)
			end			
			self.panel.layer:runAction(cc.Sequence:create(cc.DelayTime:create(times or playTime[weatherId]),
														cc.CallFunc:create(function(pSender)
															if nil ~= weatherSprite then
																weatherSprite:removeFromParent()
																weatherSprite = nil
															end
															if nil ~= lightSprite then
																lightSprite:stopAllActions()
																lightSprite:removeFromParent()
																lightSprite = nil
															end
															if nil ~= rainSprite then
																rainSprite:stopAllActions()
																rainSprite:removeFromParent()
																rainSprite = nil
															end
															local nowTime = os.time()
															DataManager.setGameTime(nowTime)
															self.timeHandler = Director.getScheduler():scheduleScriptFunc(checkWeatherTime, 6, false)
														end))
			)
		else
			self.panel.layer:runAction(cc.Sequence:create(cc.DelayTime:create(times or playTime[weatherId]),
														cc.CallFunc:create(function(pSender)
															local nowTime = os.time()
															DataManager.setGameTime(nowTime)
															self.timeHandler = Director.getScheduler():scheduleScriptFunc(checkWeatherTime, 6, false)
														end))
										)
		end
	end
	
	
	local function checStartTimeHandler()
		local systemCurrentWeather = DataManager.getCurrentWeather()
		if nil == playTime[systemCurrentWeather] then
			return true
		end
		if nil == systemCurrentWeather or 0 == systemCurrentWeather then 
			return true
		end
		if systemCurrentWeather > weatherNum then
			return true
		end
		local oldTime = DataManager.getWeatherStartTime()
		local nowTime = os.time()
		local dicTime = nowTime - oldTime
		if dicTime > 2 * playTime[systemCurrentWeather]  then			-- 时间太长了   就重新启动天气
			return true
		end
		
		if 1 == systemCurrentWeather and  dicTime < playTime[systemCurrentWeather]  then
			addSenceEffect(systemCurrentWeather, playTime[systemCurrentWeather] - dicTime)
			return false
		end
		if  dicTime < playTime[systemCurrentWeather]  then
			addSenceEffect(systemCurrentWeather, playTime[systemCurrentWeather] - dicTime)
			return false
		end
		return true
	end
	
	if 0 == systemMap.town and nil ~= sceneWeather then			--野外地图才有天气
		local isStartTimeHandler = checStartTimeHandler()
		weatherNum = #sceneWeather
		if isStartTimeHandler then
			self.timeHandler = Director.getScheduler():scheduleScriptFunc(checkWeatherTime, 6, false)
		end
	end
	
	return panel
end

--退出
function TileMapUIPanel:Release()
	if self.bossTimeHandler then
		Director.getScheduler():unscheduleScriptEntry(self.bossTimeHandler)
	end
	self.bossTimeHandler = nil
	
	if self.timeHandler then
		Director.getScheduler():unscheduleScriptEntry(self.timeHandler)
	end
	self.timeHandler = nil
	
	if self.weakHandler then
		self.panel:unscheduleScriptEntry(self.weakHandler)
	end
	self.weakHandler = nil
		
	if self.frameHandler then
		self.panel:unscheduleScriptEntry(self.frameHandler)
	end
	self.frameHandler = nil

	if self.longPressedTimeHandler then
		self.panel:unscheduleScriptEntry(self.longPressedTimeHandler)
	end
	self.longPressedTimeHandler = nil
	
	self.tileMapBg:stopAllActions()
	self.tileMapTitle:stopAllActions()
			
	self.panel.layer:stopAllActions()
	self.panel.layer:removeFromParent(true)
	self.panel = nil
	self = nil
end

--隐藏
function TileMapUIPanel:Hide()
	self.panel:Hide()
end

--显示
function TileMapUIPanel:Show()
	self.panel:Show()
	self.panel.layer:registerScriptTouchHandler(TileMapUIPanel_Ontouch,false,0,true)
end
