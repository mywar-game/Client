--公告
NoticeUIPanel = {}
function NoticeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function NoticeUIPanel:Create(para)
	local p_name = "NoticeUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
    self.panel:setLabelText("lab_content", LabelChineseStr.NoticeUIPanel_1)
	local function btnCallBack(sender,tag)
		LayerManager.show("SystemSetUIPanel")
		--self:Release(true) 
	end
	self.panel:addNodeTouchEventListener("btn_comfirm",btnCallBack,0)
	
    return self.panel
end

--退出
function NoticeUIPanel:Release()
	self.panel:Release()
end

--隐藏
function NoticeUIPanel:Hide()
	self.panel:Hide()
end

--显示
function NoticeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end