ArenaTipsUIPanel = {
panel = nil,
}
function ArenaTipsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--����
function ArenaTipsUIPanel:Create(para)
    local p_name = "ArenaTipsUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
    --��ť�¼�
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
		
	return panel
end
--�˳�
function ArenaTipsUIPanel:Release()
	self.panel:Release()
end
--����
function ArenaTipsUIPanel:Hide()
	self.panel:Hide()	
end
--��ʾ
function ArenaTipsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end