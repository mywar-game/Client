require("WorldMapContentUIPanel")
--世界地图
WorldMapUIPanel = {}
function WorldMapUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function WorldMapUIPanel:Create(para)
	local p_name = "WorldMapUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
    local mapTiles = {}
    local mapContent
    local mapContentPanel
    local isMove = false--手指滑动轨迹总距离
    local cacheX = 0
    local cacheY = 0

    local function initUI()
        mapContent = WorldMapContentUIPanel:New()
        mapContentPanel = mapContent:Create()
        mapContentPanel.layer:setPosition(cc.p(0,0))
        self.panel:getChildByName("content"):addChild(mapContentPanel.layer, 1)
        --定位到中间
        mapContent:toScenePointCenter()
    end
    initUI()

	local function btnCallBack(sender,tag)
		self:Release() 
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)	

    function WorldMapUIPanel_Ontouch(e,x,y)
        local worldPos = cc.p(x, y)
		x=self.panel.layer:convertToNodeSpace(cc.p(x,y)).x
		y=self.panel.layer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then
            isMove = false
            cacheX = x
            cacheY = y
            if mapContent:checkClick(worldPos) then
                mapContent:switchCacheClickStatus(true)
            end
		elseif e=="moved" then
            local len = Utils.calcPointsDistance(cc.p(x,y), cc.p(cacheX,cacheY))
            if len > 5 then
			    isMove = true
                mapContent:switchCacheClickStatus(false)
            end
            mapContent:updatePoint(Utils.calcPointsVector(cc.p(cacheX,cacheY), cc.p(x,y)))
            cacheX = x
            cacheY = y
		else
            if not isMove then
                local clickSquare = mapContent:getClickSquare()
                if clickSquare then
                    LayerManager.showDialog(LabelChineseStr.WorldMapUIPanel_1..clickSquare.map.mapName,
                        function ()
                            --传送至该地图
				            LayerManager.show("TileMapUIPanel",{sceneId=clickSquare.scene.sceneId, isFromWorldMap = true})
                            self:Release()
                        end)
                    mapContent:switchCacheClickStatus(false)
                end
            end
		end
		return true
    end

    return self.panel
end

--退出
function WorldMapUIPanel:Release()
	self.panel:Release()
end

--隐藏
function WorldMapUIPanel:Hide()
	self.panel:Hide()
end

--显示
function WorldMapUIPanel:Show()
	self.panel:Show()
	self.panel.layer:registerScriptTouchHandler(WorldMapUIPanel_Ontouch,false,0,true)
end