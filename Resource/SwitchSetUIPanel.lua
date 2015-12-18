SwitchSetUIPanel = {
panel = nil,
}

function SwitchSetUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--����
function SwitchSetUIPanel:Create(para)
    local p_name = "SwitchSetUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

    local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			--�ر���������
			--NetEventHandler.onSocketManuallyClose()
			--����л�ת����½����
			--LayerManager.show("LoginUIPanel")
						
		end
    end

	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_switch",btnCallBack,1)
	--self.panel:addNodeTouchEventListener("btn_notice",btnCallBack,2)
	
	return panel
end


--�˳�
function SwitchSetUIPanel:Release()
	self.panel:Release(true)
end
--����
function SwitchSetUIPanel:Hide()
	self.panel:Hide()	
end
--��ʾ
function SwitchSetUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
