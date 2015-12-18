--生活技能选择

LifeSkillsChangeUIPanel = {
panel = nil,
}

function LifeSkillsChangeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function LifeSkillsChangeUIPanel:Create(para)
    local p_name = "LifeSkillsChangeUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--根据传过来的参数设置该显示的选择
	local function btnCallBack(sender,tag)
		if tag == 1 or tag == 2 then
			para.callBack(tag)
		end
		self:Release()
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_wakuang",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_huapu",btnCallBack,2)
	
	return panel
end

--退出
function LifeSkillsChangeUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function LifeSkillsChangeUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function LifeSkillsChangeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
