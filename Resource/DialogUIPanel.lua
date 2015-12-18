--消息提示框逻辑
DialogUIPanel = {}
function DialogUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function DialogUIPanel:Create(msg,callBackFun, args)
	local p_name = "DialogUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	msg = msg or GameString.revival
	--[[
	if msg then
		local start = string.find(msg,"<")
		local ends = string.find(msg,">")
		if start and ends then
			local posX = 150
			local posY = 480
			local label1 = CreateLabel(string.sub(msg,1,start-1),nil,24)
			label1:setPosition(cc.p(posX,posY))
			label1:setAnchorPoint(cc.p(0,0.5))
			self.panel.layer:addChild(label1)
			local sz1 = label1:getContentSize()
			
			local sprite = CreateCCSprite(string.sub(msg,start+1,ends-1))
			sprite:setPosition(cc.p(sz1.width+posX,posY))
			sprite:setAnchorPoint(cc.p(0,0.5))
			self.panel.layer:addChild(sprite)
			local sz2 = sprite:getContentSize()
			
			local label2 = CreateLabel(string.sub(msg,ends+1,-1),nil,24)
			label2:setPosition(cc.p(sz1.width+sz2.width+posX,posY))
			label2:setAnchorPoint(cc.p(0,0.5))
			self.panel.layer:addChild(label2)
			
			self.panel:setLabelText("dialog_msg_txt","")
		else
			self.panel:setLabelText("dialog_msg_txt",msg)
		end
	end
	
	if iconPathPositive then
		local sprite_btn = CreateCCSprite(iconPathPositive) 
		self.panel.dialog_ok_btn:setTexture(sprite_btn:getTexture())
	end
	
	if iconPathNegative then
		local sprite_btn = CreateCCSprite(iconPathNegative) 
		self.panel.dialog_close_btn:setTexture(sprite_btn:getTexture())
	end
			
	local function callBack(i)
        
		if callBackFun then
			self:Release()
			callBackFun(i)
		end
	end
	
	if callBackFun then
		if btnNum > 1 then
            local hx,hy = self.panel.dialog_ok_btn:getPosition()
			self.panel.dialog_ok_btn_btn.item:registerScriptTapHandler(function() callBack(1) end)
			self.panel.dialog_ok_btn:setVisible(true)
            self.panel.dialog_ok_btn_btn:setVisible(true)
		else
			self.panel.dialog_ok_btn_btn.item:registerScriptTapHandler(function() callBack(1) end)
            self.panel.dialog_ok_btn:setVisible(true)
            self.panel.dialog_ok_btn_btn:setVisible(true)
		end		
	else
		self.panel:dialog_ok_btn:setVisible(false)
		self.panel:dialog_ok_btn_btn:setVisible(false)
	end]]
	self.panel:setLabelText("dialog_msg_txt", msg)
	local function btnCallBack(sender,tag)
		if tag == 1 and callBackFun then
			callBackFun(args)
		end
		self:Release(true) 
		
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack,1)
	
    return self.panel
end

--退出
function DialogUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function DialogUIPanel:Hide()
	self.panel:Hide()
end

--显示
function DialogUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end