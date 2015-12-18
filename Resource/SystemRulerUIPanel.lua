SystemRulerUIPanel = {
panel = nil,
}
function SystemRulerUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function SystemRulerUIPanel:Create(para)
    local p_name = "SystemRulerUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	local distance = 30
	local data = LabelChineseStr["SystemRulerUIPanelText_" .. para.id]
	self.panel:setLabelText("lab_title", data.title)
	local scrollView = self.panel:getChildByName("ScrollView_73")
	local labRuler = CreateLabel(data.rulers, nil, 20, nil, 1, cc.size(400, 0))
	labRuler:setAnchorPoint(cc.p(0, 1))
	local labelSize = labRuler:getContentSize()
	scrollView:setInnerContainerSize(labelSize)
	local size = scrollView:getContentSize()
	local height 
	if labelSize.height > size.height then
		height = labelSize.height
	else
		height = size.height
	end
	labRuler:setPosition(cc.p(0, height))
	scrollView:addChild(labRuler)
	
    --按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
		
	return panel
end
--退出
function SystemRulerUIPanel:Release()
	self.panel:Release()
end
--隐藏
function SystemRulerUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function SystemRulerUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end