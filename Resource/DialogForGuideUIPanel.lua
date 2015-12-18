--消息提示框逻辑
DialogForGuideUIPanel = {}
function DialogForGuideUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function DialogForGuideUIPanel:Create(msg,callBackFun)
	local p_name = "DialogForGuideUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    local msg_indes = 1 
	self.panel:setLabelText("text_name", msg[msg_indes].name)
	self.panel:setLabelText("text_content", msg[msg_indes].test)
	local function btnCallBack(sender)
	
	    if  msg_indes<#msg  then
		    msg_indes = msg_indes+1 
			self.panel:setLabelText("text_name", msg[msg_indes].name)
	        self.panel:setLabelText("text_content", msg[msg_indes].test)
		else
		    self:Release(true) 
			if  callBackFun then
				callBackFun()
			end
		end
	    		
	end
	self.panel:addNodeTouchEventListener("big_box",btnCallBack)

    return self.panel
end

--退出
function DialogForGuideUIPanel:Release()
	self.panel:Release()
end

--隐藏
function DialogForGuideUIPanel:Hide()
	self.panel:Hide()
end

--显示
function DialogForGuideUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end