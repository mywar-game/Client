
TextureShowUIPanel = {
panel = nil,
}
function TextureShowUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function TextureShowUIPanel:Create()
    local p_name = "TextureShowUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--lua虚拟机内存占用
	local collectgarbageCount = collectgarbage("count")
	local textureInfo = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
	local listInfo = Split(textureInfo,"\n")
	
	local y = 0
	local layer = cc.Layer:create()
	for k=1,#listInfo - 2 do
				
		local list = Split(listInfo[k],"\"")
		local sprite = CreateCCSprite(list[2])
		sprite:setPosition(50,y)
		sprite:setAnchorPoint(0,0)
		layer:addChild(sprite)
		
		local height = sprite:getContentSize().height
		local label = CreateLabel(#listInfo-1-k)
		label:setAnchorPoint(0,0)
		label:setPosition(10,y+height/2)
		layer:addChild(label)
		
		local label = CreateLabel(list[3])
		label:setAnchorPoint(0,0)
		label:setPosition(400,y+height/2)
		layer:addChild(label)
		y = y + height + 10
	end
	
	self.panel:setLabelText("lab_img",listInfo[#listInfo-1],cc.c3b(255,0,0))
	
	local scrollView = self.panel:getChildByName("scr_cxt")
	scrollView:setInnerContainerSize(cc.size(960,y))
	scrollView:addChild(layer)
	
	local function btnCallBack(sender,tag)
		self:Release()
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack)
	
	return panel
end
--退出
function TextureShowUIPanel:Release()
	self.panel:Release()
end
--隐藏
function TextureShowUIPanel:Hide()
	self.panel:Hide()
end
--显示
function TextureShowUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
