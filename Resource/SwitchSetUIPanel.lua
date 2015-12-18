SwitchSetUIPanel = {
panel = nil,
}

function SwitchSetUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function SwitchSetUIPanel:Create(para)
    local p_name = "SwitchSetUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

    local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			--关闭网络链接
			--NetEventHandler.onSocketManuallyClose()
			--点击切换转到登陆界面
			--LayerManager.show("LoginUIPanel")
						
		end
    end

	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_switch",btnCallBack,1)
	--self.panel:addNodeTouchEventListener("btn_notice",btnCallBack,2)
	
	return panel
end


--退出
function SwitchSetUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function SwitchSetUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function SwitchSetUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
