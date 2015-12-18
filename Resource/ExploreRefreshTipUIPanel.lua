--探索刷新界面(auto or not)
ExploreRefreshTipUIPanel = {}
function ExploreRefreshTipUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ExploreRefreshTipUIPanel:Create(para)
	local p_name = "ExploreRefreshTipUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

	local stringTab = {}
    local noRefreshTipToday = false--仅限于单次refresh
	local costMoney = DataManager.getSystemConfig().explore_refresh_cost

    if para.isAuto then
        self.panel:getChildByName("ckbox_nomind"):setVisible(false)
        table.insert(stringTab, {str=LabelChineseStr.ExploreRefreshTipUIPanel_3,color=cc.c3b(255,255,255)})
        table.insert(stringTab, {str=costMoney..LabelChineseStr.common_zuanshi,color=cc.c3b(0,0,255)})
        table.insert(stringTab, {str=LabelChineseStr.ExploreRefreshTipUIPanel_4,color=cc.c3b(255,255,255)})
    else
        table.insert(stringTab, {str=LabelChineseStr.ExploreRefreshTipUIPanel_1,color=cc.c3b(255,255,255)})
        table.insert(stringTab, {str=costMoney..LabelChineseStr.common_zuanshi,color=cc.c3b(0,0,255)})
        table.insert(stringTab, {str=LabelChineseStr.ExploreRefreshTipUIPanel_2,color=cc.c3b(255,255,255)})
    end
	
	local lab_info = self.panel:getChildByName("lab_info_locate")
	local size = lab_info:getContentSize()
	local x,y = lab_info:getPosition()
    local lab = createRichColorLabel(stringTab,28,size)
    lab:setPosition(x,y)
    self.panel:getChildByName("img_border"):addChild(lab)

	local function btnCallBack(sender,tag)
        if tag == 1 and para.sureCallFunc then
			if noRefreshTipToday then
				DataManager.setShowWindowTips(GameField.windowTips1)
				local setDailyTipsReq = SettingAction_setDailyTipsReq:New()
				setDailyTipsReq:setInt_tip(GameField.windowTips1)
				NetReqLua(setDailyTipsReq)
			end
		
			if DataManager.getUserBO().money >= tonumber(costMoney) then
				para.sureCallFunc(noRefreshTipToday)
			else
			end
        end
		self:Release()
	end
		
    local function selectedEvent(sender, eventType, tag)
        if eventType == ccui.CheckBoxEventType.selected then
            noRefreshTipToday = true
        elseif eventType == ccui.CheckBoxEventType.unselected then
            noRefreshTipToday = false
        end 
    end
	
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_cancel",btnCallBack,2)
    self.panel:addCheckBoxNodeSelectEvent("ckbox_nomind",selectedEvent,0)  

    return self.panel
end

--退出
function ExploreRefreshTipUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function ExploreRefreshTipUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ExploreRefreshTipUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end