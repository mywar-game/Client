require("MapHero")
require("SkeletonSkill")
require("SkeletonAction")

local jumpSceneIdx = 0
local jumpSceneList = {}

geziUIPanel = {
panel = nil,
}

function geziUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function geziUIPanel:Create(para)
	local p_name = "TileMapUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	para = para or {}
	local moveType1 = true
	local moveType2 = true
	local moveType3 = true
	local moveType4 = true
	local addMoveYNum = 0 --主城偏移量
	local addtileYNum = 0
	local curSceneId = nil --当前场景ID
	local bornpointX = nil --出生点X
	local bornpointY = nil --出生点Y
	local cacheForce = nil--地图怪物缓存
    local cacheCollection = nil--缓存的矿石
	local otherHero = {}
	local npcSprite = {}
	local forceSprite = {}
    local collectSprite = {}--矿物表
	local fishingSprite = {}--钓鱼
	local enterSprite = {}
	local objectList = {}
	local duplicateSprite = {}
	local recordTouch = {x=0,y=0}
	local sendUserTouch = {x=0,y=0}
	local mapPoint = {}

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
		addMoveYNum = -50
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
	local my = viewHeight/2 - bornpointY * GameField.tileHeight
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
	
	for x=1,maxTileNumX do
		mapPoint[x] = {}
		for y=1,maxTileNumY do
            mapPoint[x][y] = 0
		end
	end

	local point = Split(systemMap.breakPoint,"|")
	for k,v in pairs(point) do
		local mx,my = ConversionXY(maxTileNumY,v)
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
	
	local function saveData()
		local str = ""
		for x=1,maxTileNumX do
			for y=1,maxTileNumY do
				if mapPoint[x][y] == 1 then
					str = str..(x-1)..","..(y-1).."|"
				end
			end	
		end
		str = string.sub(str,1,string.len(str)-1)
		WriteFile("map"..curSceneId,str)
	end
	
	local function btnFunc()
		saveData()
	end
	self.panel.layer:addChild(createMenuItem("ui_editor/btn_2.png", "ui_editor/btn_1.png",480,320,btnFunc),1024)
	
	local save = CreateLabel("Save",nil,20,cc.c3b(255,0,0))
	save:setPosition(480,320)
	self.panel.layer:addChild(save,1024)
	
	--传送点
	for k,v in pairs(systemTransfer) do	
		v.x = v.x * 3
		v.y = v.y * 2
		local tx = GameField.tileWidth*v.x+GameField.tileWidth/2
		local ty = GameField.tileHeight*v.y+GameField.tileHeight/2
		local sprite = CreateEffectSkeleton(v.resId)
		sprite:setPosition(cc.p(tx,ty))
        sprite.transferData = v
		moveLayer:addChild(sprite,1)
		table.insert(enterSprite,sprite)
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
			cclog(IconPath.ditu..systemMap.imgId.."_0"..idx..".png")
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
	end
	
	local isMove = false
	local touch = {}
	function geziUIPanel_Ontouch(e,x,y)
		local mx=moveLayer:convertToNodeSpace(cc.p(x,y)).x
		local my=moveLayer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then	
			touch = {x=mx,y=my}
		elseif e=="moved" then
			isMove = true
			local tx,ty = moveLayer:getPosition()
			moveLayer:setPosition(tx+mx-touch.x,ty+my-touch.y)
		else
			if isMove ==  false and math.abs(touch.x-mx) < 5 and math.abs(touch.y-my) < 5 then
				local xx = math.ceil(mx/32)
				local yy = math.ceil(my/32)
				
				if mapPoint[xx][yy] == 0 then
					mapPoint[xx][yy] = 1
					spritePoint[xx][yy]:setTexture(batchNode2:getTexture())
				else
					mapPoint[xx][yy] = 0
					spritePoint[xx][yy]:setTexture(batchNode1:getTexture())
				end
			
				for k,v in pairs(enterSprite)do
					if isClickSprite(v,mx,my) then
						saveData()
						LayerManager.show("geziUIPanel",{oldSceneId=curSceneId,sceneId=systemTransfer[k].sceneId})
						break
					end
				end
			end
			isMove = false
		end
		return true
	end
	
	return panel
end

--退出
function geziUIPanel:Release()
	if self.panel then	
		if self.weakHandler then
			self.panel:unscheduleScriptEntry(self.weakHandler)
		end
		if self.frameHandler then
			self.panel:unscheduleScriptEntry(self.frameHandler)
		end
		self.panel.layer:removeFromParent(true)
		self.panel = nil
		self = nil
	end
end

--隐藏
function geziUIPanel:Hide()
	self.panel:Hide()
end

--显示
function geziUIPanel:Show()
	self.panel:Show()
	self.panel.layer:registerScriptTouchHandler(geziUIPanel_Ontouch,false,0,true)
end
