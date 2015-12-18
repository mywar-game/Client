--探索开始后的而选择界面
ExploreSelectUIPanel = {}
function ExploreSelectUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ExploreSelectUIPanel:Create(para)
	local p_name = "ExploreSelectUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local idx1 = math.random(2)
	local idx2 = idx1 == 1 and 2 or 1
	
    local mapInfo = DataManager.getSystemExploreMap(para.mapId)
    local rewards = DataManager.getSystemExploreReward(para.mapId)
    self.panel:setLabelText("lab_detail", mapInfo.description)
	self.panel:setLabelText("lab_one", rewards[idx1].description)
	self.panel:setLabelText("lab_two", rewards[idx2].description)
	
	local function btnCallBack(sender,tag)
		if tag == 1 then
			para.callFunc(rewards[idx1].type, rewards[idx1].mapId)
			UserGuideUIPanel.stepClick("btn_one")	
		elseif tag == 2 then
			para.callFunc(rewards[idx2].type, rewards[idx2].mapId)
		end
		self:Release(true) 
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_one", btnCallBack, 1)  
    self.panel:addNodeTouchEventListener("btn_two", btnCallBack, 2)

    return self.panel
end

--退出
function ExploreSelectUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function ExploreSelectUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ExploreSelectUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end