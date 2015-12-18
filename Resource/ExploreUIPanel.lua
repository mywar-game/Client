--探索第一个界面(主界面)
ExploreUIPanel = {}
function ExploreUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ExploreUIPanel:Create(para)
	local p_name = "ExploreUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local mapId = 0
    local isAuto = false
	local integral = 0
    local exploreTimes = 0
	
	local function stopAutoRefresh()
		isAuto = false
		self:stopAutoHandler()
		self.panel:setNodeVisible("btn_autoStop",false)
		self.panel:setNodeVisible("btn_autoRefresh",true)
	end
	
    --刷新
	local function doAutoHandler()
		if DataManager.getUserBO().money >= tonumber(DataManager.getSystemConfig().explore_refresh_cost) then
			local autoRefreshReq = ExploreAction_autoRefreshReq:New()
			NetReqLua(autoRefreshReq, true)
		else
			stopAutoRefresh()
			Tips(GameString.moneyNotEnough)
		end
	end
	
	--自动刷新
	local function autoRefreshCallBack()
		isAuto = true
		self.panel:setNodeVisible("btn_autoStop",true)
		self.panel:setNodeVisible("btn_autoRefresh",false)
		doAutoHandler()
		self.autoHandler = self.panel:scheduleScriptFunc(doAutoHandler,3)
	end
	
	--手动刷新
    local function manualRefreshFunc()
		local refreshMapReq = ExploreAction_refreshMapReq:New()
		NetReqLua(refreshMapReq,true)
    end
	
	local lastTypeId
	local lastMapId
    --选择
    local function selectFunc(type, mapId)
		lastTypeId = type
		lastMapId = mapId
        local exploreReq = ExploreAction_exploreReq:New()
        exploreReq:setInt_type(type)
	    NetReqLua(exploreReq,true)
    end
	
	local function btnCallBack(sender,tag)
		if isAuto then
			Tips(GameString.stopRefreshMap)
			return
		end
		
        if tag == 0 then 
            self:Release()
        elseif tag == 1 then
            LayerManager.show("ExploreRefreshTipUIPanel",{isAuto=true,sureCallFunc=autoRefreshCallBack})
        elseif tag == 2 then--refresh
            if DataManager.getIsShowWindowTips(GameField.windowTips1) then
                manualRefreshFunc(false)
            else
				LayerManager.show("ExploreRefreshTipUIPanel",{isAuto=false,sureCallFunc=manualRefreshFunc})
            end
        elseif tag == 3 then--exchange
            LayerManager.show("ExploreExchangeUIPanel",{retData = {mapId=mapId, exploreTimes=exploreTimes, integral=integral}})
        elseif tag == 4 then--explore
            if exploreTimes <= 0 then
                Tips(LabelChineseStr.ExploreUIPanel_3)
            else
                LayerManager.show("ExploreSelectUIPanel", {mapId=mapId, callFunc=selectFunc})
				UserGuideUIPanel.stepClick("btn_explore")   
            end	
		elseif 6 == tag then
			LayerManager.show("SystemRulerUIPanel", {id = 1})
        end
	end

	local function stopCallBack(sender,tag)
		stopAutoRefresh()
	end
	
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_autoRefresh",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_refresh",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_exchange",btnCallBack,3)
    self.panel:addNodeTouchEventListener("btn_explore",btnCallBack,4)
    self.panel:addNodeTouchEventListener("btn_autoStop",stopCallBack,5)
	self.panel:addNodeTouchEventListener("btn_help",btnCallBack,6)
    
	function refreshRandomMapUI(data)
		mapId = data.mapId 
		
		local height = 0
		local mapRes = DataManager.getSystemExploreMapList(mapId)
		local mapCount = #mapRes
		local layer = cc.Layer:create()
		for k=1,mapCount do
			local sprite = CreateCCSprite(IconPath.tansuoditu..mapRes[k]..".png")
			local size = sprite:getContentSize()
			sprite:setPosition(cc.p(size.width/2,(2*k-1)*size.height/2))
			
			layer:addChild(sprite)
			height = size.height
		end
		
		local t = 1
		local d = 10
		local s = {10,20,30,40,40,30,20,10,8,5}
		local y = height*(1-mapCount)
		local scrollViewMap = self.panel:getChildByName("scrollView_map")
		scrollViewMap:removeAllChildren()
		layer:setPosition(cc.p(0,y))
		scrollViewMap:addChild(layer)
		
		local function doFrameHandler(dt)
			local c = #s
			local m = math.ceil(t/d)
			m = m > c and s[c] or s[m]
			t = t + 1
			y = y + m
			
			if y <= -height/2 then
				layer:setPosition(cc.p(0,y))
			else
				self:stopFrameHandler()
				layer:runAction(cc.MoveTo:create(0.2,cc.p(0,-height)))
			end
		end
		self:stopFrameHandler()
		self.frameHandler = self.panel:scheduleScriptFunc(doFrameHandler,0)
	end

    --刷新UI
	function refreshIntegralUI(data)
		integral = data.integral
		self.panel:setLabelText("lab_score", data.integral)
	end
	
	--刷新UI
	function refreshExploreTimesUI(data)
		exploreTimes = data.exploreTimes
		self.panel:setLabelText("lab_count", exploreTimes)
	end
	
    function refreshInitMapUI(data)
		mapId = data.mapId 
		local mapInfo = DataManager.getSystemExploreMap(mapId)
		local sprite = CreateCCSprite(IconPath.tansuoditu..mapInfo.resId..".png")
		local size = sprite:getContentSize()
		sprite:setPosition(cc.p(size.width/2,size.height/2))			
		local scrollViewMap = self.panel:getChildByName("scrollView_map")
		scrollViewMap:addChild(sprite)
    end
	
	--list监听
    local function OnItemShowCallback(scroll_view, item, data, idx)
        local img_bkg = self.panel:getItemChildByName(item, "img_bkg")
        local heroIcon = IconUtil.createHeroIcon(data,true)
        heroIcon:setPosition(cc.p(img_bkg:getContentSize().width/2, img_bkg:getContentSize().height/2))
        img_bkg:addChild(heroIcon)
    end
	
    local function OnItemClickCallback(item, data, idx) 
	-- 添加显示英雄详细界面
		LayerManager.show("HeroInfoDetailUIPanel", {data = data})
	end
	
	function refreshHeroUI()
		local heroList = DataManager.getSystemExploreRewardHero()
        self.panel:setNodeVisible("img_left", #heroList >= 7)
        self.panel:setNodeVisible("img_right",#heroList >= 7)
        self.panel:InitListView(heroList, OnItemShowCallback, OnItemClickCallback)
    end

	--刷新
    function ExploreUIPanel_ExploreAction_refreshMap(msgObj)
        refreshRandomMapUI(msgObj.body)
		refreshIntegralUI(msgObj.body)
    end
	
	--自动刷新
    function ExploreUIPanel_ExploreAction_autoRefresh(msgObj)
		if msgObj.body.cost == 1 then
			stopAutoRefresh()
		end
		
        Tips(LabelChineseStr.ExploreUIPanel_2..msgObj.body.cost)
        refreshRandomMapUI(msgObj.body)
		refreshIntegralUI(msgObj.body)
    end
	
	--探索
    function ExploreUIPanel_ExploreAction_explore(msgObj)
		if #msgObj.body.drop.heroList > 0 then --刷新英雄列表
			refreshHeroUI()
		end
		refreshRandomMapUI(msgObj.body)
		refreshExploreTimesUI(msgObj.body)
		local rewards = DataManager.getSystemExploreReward(lastMapId)
		local titleString = nil
		for k, v in pairs(rewards) do
			if v.type == lastTypeId then
				 titleString = v.result
				 break
			end
		end
		LayerManager.show("DialogRewardsNewUIPanel",{data = msgObj.body.drop, titleString = titleString})--展示获得东西
    end
	
	--获取探索
    function ExploreUIPanel_ExploreAction_getUserExploreInfo(msgObj)
		refreshHeroUI()
		refreshInitMapUI(msgObj.body.userExploreInfoBO)
		refreshIntegralUI(msgObj.body.userExploreInfoBO)
		refreshExploreTimesUI(msgObj.body.userExploreInfoBO)
    end
	
	local function netUserExploreInfoReq()
		local userExploreInfoReq = ExploreAction_getUserExploreInfoReq:New()
		NetReqLua(userExploreInfoReq, true)
	end
	netUserExploreInfoReq()
	
    return self.panel
end

function ExploreUIPanel:stopAutoHandler()
	if self.autoHandler then
		self.panel:unscheduleScriptEntry(self.autoHandler)
		self.autoHandler = nil
	end
end

function ExploreUIPanel:stopFrameHandler()
	if self.frameHandler then
		self.panel:unscheduleScriptEntry(self.frameHandler)
		self.frameHandler = nil
	end
end

--退出
function ExploreUIPanel:Release()
	self:stopFrameHandler()
	self:stopAutoHandler()
	self.panel:Release()
end

--隐藏
function ExploreUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ExploreUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end