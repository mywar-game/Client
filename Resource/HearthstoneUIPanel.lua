--炉石(传送提示框)
HearthstoneUIPanel = {}
function HearthstoneUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function HearthstoneUIPanel:Create(para)
	local p_name = "HearthstoneUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	self.panel:setLabelText("dialog_msg_txt", msg)
	local function btnCallBack(sender,tag)
		if tag == 1 and callBackFun then
			callBackFun()
		end
		self:Release(true) 
		
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack,1)
	
    return self.panel
end

--退出
function HearthstoneUIPanel:Release()
	self.panel:Release()
end

--隐藏
function HearthstoneUIPanel:Hide()
	self.panel:Hide()
end

--显示
function HearthstoneUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end