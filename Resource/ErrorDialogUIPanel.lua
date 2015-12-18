--消息提示框逻辑
ErrorDialogUIPanel = {}

function ErrorDialogUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ErrorDialogUIPanel:Create(msg)
	local p_name = "ErrorDialogUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	msg = msg or LabelChineseStr.ErrorDialogUIPanel_1
	cclog("msg===="..msg)
	self.panel:setLabelText("lab_msgTxt",msg)

	self.panel:addNodeTouchEventListener("dialog_ok",function() 
		NetReconnect()
		self:Release(true)
	end)
		
    return self.panel
end

--退出
function ErrorDialogUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function ErrorDialogUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ErrorDialogUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end