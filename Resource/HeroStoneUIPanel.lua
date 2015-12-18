HeroStoneUIPanel = {
panel = nil,
}
function HeroStoneUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--����
function HeroStoneUIPanel:Create(para)
    local p_name = "HeroStoneUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--��ʾ����ʯ	
	local function showStoneTool()
		local tempTool = {}
		local toolList = {1369,1370,1371} --�����У��ߣ�����ʯ
		for k,v in pairs(toolList)do
			local userTool = DataManager.getUserTool(v)
			if userTool then
				table.insert(tempTool,userTool)
			end
			self.panel:setNodeVisible("img_tool"..k,false)
		end
		
		for k,v in pairs(tempTool) do
			local function iconTouchEvent(type,touchPos)
				if type == GameField.Event_DoubleClick and v.type == GameField.tool then--����
					para.callBack(v)
					self:Release()
				end
			end
			
			local toolSprite = self.panel:getChildByName("img_tool"..k)
			local size = toolSprite:getContentSize()
			local iconSprite = IconUtil.GetIconByIdType(v.type,v.toolId,nil,{data=v,touchCallBack=iconTouchEvent})
			iconSprite:setPosition(cc.p(size.width/2,size.height/2))
			toolSprite:addChild(iconSprite)
	
			self.panel:setLabelText("lab_name"..k,v.name)
			self.panel:setLabelText("lab_num"..k,v.toolNum)
			self.panel:setNodeVisible("img_tool"..k,true)
		end
	end
	showStoneTool()
	
	return panel
end

--�˳�
function HeroStoneUIPanel:Release()
	self.panel:Release()
end

--����
function HeroStoneUIPanel:Hide()
	self.panel:Hide()
end

--��ʾ
function HeroStoneUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
