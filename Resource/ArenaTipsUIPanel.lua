ArenaTipsUIPanel = {
panel = nil,
}
function ArenaTipsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function ArenaTipsUIPanel:Create(para)
    local p_name = "ArenaTipsUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
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
function ArenaTipsUIPanel:Release()
	self.panel:Release()
end
--隐藏
function ArenaTipsUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaTipsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end