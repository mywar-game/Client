EquipmentHomeUIPanel = {
panel = nil,
}
function EquipmentHomeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function EquipmentHomeUIPanel:Create(para)
    local p_name = "EquipmentHomeUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	--业务逻辑编写处
	return panel
end
--退出
function EquipmentHomeUIPanel:Release()
	self.panel:Release()
end
--隐藏
function EquipmentHomeUIPanel:Hide()
	self.panel:Hide()
end
--显示
function EquipmentHomeUIPanel:Show()
	self.panel:Show()
end
