--世界地图内容
WorldMapContentUIPanel = {}
function WorldMapContentUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function WorldMapContentUIPanel:Create(para)
	local p_name = "WorldMapContentUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
    local nowPos = cc.p(0, 0)
    local size = Director.getRealWinSize()
    local contentSize = self.panel.studioUI:getContentSize()
    local minX = -math.abs(contentSize.width - size.width)
    local minY = -math.abs(contentSize.height - size.height)
	local systemScene = DataManager.getSystemScene()
    local curSceneId = DataManager.getCurrentSceneId()
    cclog("23:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    cclog("curSceneId:"..curSceneId)
    local openMapSquare = {}
    local cacheClickSquare
    
    --初始化地图(设置为灰度,和已经打开的地图)
    local function InitMaps()
        for k,v in pairs(systemScene) do
            local map = DataManager.getSystemMapId(v.mapId)

			local item = self.panel:getChildByName("img_"..v.mapId)
			if DataManager.isOpenMap(v.mapId) then
                cclog("666666666666666666666666666666666666666666666666666666666666666")
				local singleSquare = {}
				singleSquare.scene = DeepCopy(v)
				singleSquare.map = map
				singleSquare.item = item
				self.panel:setImageTexture("img_"..v.mapId, IconPath.shijiezhengchang..v.mapId..".png")
				table.insert(openMapSquare, singleSquare)
				
                local userBo = DataManager.getUserBO()
                local teamLevel = userBo.level
                local heroCamp = userBo.camp
                local mapMinLevel = v.minLevel
                
                if curSceneId == v.mapId then
                    local curMap = self.panel:getChildByName("img_"..v.mapId)

                    -- 读取骨骼
                    local path = "NewUi/xinqietu/worldmap/point/t32"
                    local size = cc.Director:getInstance():getWinSize()
                    local armature = CreateSkeleton(path,"t32")
                    armature:getAnimation():play("tx")
                    curMap:addChild(armature)

                    local redPoint = CreateCCSprite(IconPath.point .. "i_sjdtt.png")
                    redPoint:setScale(0.5)
                    curMap:addChild(redPoint)

                    if heroCamp == 1 then   --联盟
                        armature:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2-45))
                        redPoint:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2-3-45))
                    else   --部落
                        armature:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2+45))
                        redPoint:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2+3+45))
                    end
                end

                if teamLevel < mapMinLevel then
					local labSuggest = self.panel:getChildByName("lab_"..v.mapId.."_1")
                    if heroCamp == 1 then   --联盟
                        labSuggest:setColor(cc.c3b(0,0,255))
                    else   --部落
                        labSuggest:setColor(cc.c3b(255,0,0))
                    end
                end

                if DataManager.isHasTown(v.mapId) then
                    local curMap = self.panel:getChildByName("img_"..v.mapId)
                    if heroCamp == 1 then   --联盟
                        local townIcon = CreateCCSprite(IconPath.town .. "1.png")
                        townIcon:setScale(0.6)
                        townIcon:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2+55))
                        curMap:addChild(townIcon)
                    else   --部落
                        local townIcon = CreateCCSprite(IconPath.town .. "2.png")
                        townIcon:setScale(0.6)
                        townIcon:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2-55))
                        curMap:addChild(townIcon)
                    end
                end

                if DataManager.isInTown(v.mapId, curSceneId) then
                    local curMap = self.panel:getChildByName("img_"..v.mapId)
                    if heroCamp == 1 then   --联盟
                        local townIcon = CreateCCSprite(IconPath.town .. "1.png")
                        townIcon:setScale(0.6)
                        townIcon:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2+55))
                        curMap:addChild(townIcon)

                        -- 读取骨骼
                        local path = "NewUi/xinqietu/worldmap/point/t32"
                        local size = cc.Director:getInstance():getWinSize()
                        local armature = CreateSkeleton(path,"t32")
                        armature:getAnimation():play("tx")
                        townIcon:addChild(armature)

                        local redPoint = CreateCCSprite(IconPath.point .. "i_sjdtt.png")
                        redPoint:setScale(0.5)
                        townIcon:addChild(redPoint)

                        armature:setPosition(cc.p(townIcon:getContentSize().width/2, townIcon:getContentSize().height/2))
                        redPoint:setPosition(cc.p(townIcon:getContentSize().width/2, townIcon:getContentSize().height/2))
                    else   --部落
                        local townIcon = CreateCCSprite(IconPath.town .. "2.png")
                        townIcon:setScale(0.6)
                        townIcon:setPosition(cc.p(curMap:getContentSize().width/2, curMap:getContentSize().height/2-55))
                        curMap:addChild(townIcon)

                        -- 读取骨骼
                        local path = "NewUi/xinqietu/worldmap/point/t32"
                        local size = cc.Director:getInstance():getWinSize()
                        local armature = CreateSkeleton(path,"t32")
                        armature:getAnimation():play("tx")
                        townIcon:addChild(armature)

                        local redPoint = CreateCCSprite(IconPath.point .. "i_sjdtt.png")
                        redPoint:setScale(0.5)
                        townIcon:addChild(redPoint)

                        armature:setPosition(cc.p(townIcon:getContentSize().width/2, townIcon:getContentSize().height/2))
                        redPoint:setPosition(cc.p(townIcon:getContentSize().width/2, townIcon:getContentSize().height/2))
                    end
                end
			else
				self.panel:setNodeVisible("lab_"..v.mapId,false)
                self.panel:setNodeVisible("lab_"..v.mapId.."_1", false)
			end
        end
    end
    InitMaps()
    
    function WorldMapContentUIPanel:toScenePointCenter()
        nowPos = cc.p(minX/2, minY/2)
        self.panel.layer:setPosition(nowPos)
    end

    function WorldMapContentUIPanel:getClickSquare()
        return cacheClickSquare
    end
    
    function WorldMapContentUIPanel:switchCacheClickStatus(isHightLight)
        if cacheClickSquare then
			local mapId = cacheClickSquare.map.mapId
            if isHightLight then
                self.panel:setImageTexture("img_"..mapId,IconPath.shijiegaoliang..mapId..".png")
            else
                self.panel:setImageTexture("img_"..mapId,IconPath.shijiezhengchang..mapId..".png")
                cacheClickSquare = nil
            end
        end
    end

    function  WorldMapContentUIPanel:checkClick(worldPos)
        for k,v in pairs(openMapSquare) do
            local pos = v.item:convertToNodeSpace(worldPos)
            local s = v.item:getContentSize()
            local rect = cc.rect(0,0,s.width,s.height)
            if cc.rectContainsPoint(rect,pos) then
                local r,g,b,a = GetImagePosColor4B(IconPath.shijiezhengchang..v.map.mapId..".png", pos.x, pos.y)
                if a == 255 then
                    cacheClickSquare = v
                    return true
                end
            end
        end
        return false
    end

    function WorldMapContentUIPanel:updatePoint(moveVector)
        nowPos = cc.pAdd(nowPos, moveVector)
        if nowPos.x > 0 then
            nowPos.x = 0
        elseif nowPos.x < minX then
            nowPos.x = minX
        end
        if nowPos.y > 0 then
            nowPos.y = 0
        elseif nowPos.y < minY then
            nowPos.y = minY
        end
        self.panel.layer:setPosition(nowPos)
    end

    return self.panel
end

--退出
function WorldMapContentUIPanel:Release()
	self.panel:Release()
end

--隐藏
function WorldMapContentUIPanel:Hide()
	self.panel:Hide()
end

--显示
function WorldMapContentUIPanel:Show()
	self.panel:Show()
end