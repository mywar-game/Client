--添加好友
FriendAddUIPanel = {}
function FriendAddUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function FriendAddUIPanel:Create(para)
	local p_name = "FriendAddUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    --创建输入框	
	local txt = {}
    local bigBox = self.panel:getChildByName("img_border")
	local size = bigBox:getContentSize()
	txt.name = "team_name"
	txt.offset = {y=size.height/2,x=size.width/2,}
	txt.input = {max_length=10,place_holder='',pic=IconPath.qiming..'i_qmshuru.png',}
	local name_txt = self.panel:createEditBox(txt)
    bigBox:addChild(name_txt)
	
	local function btnCallBack(sender,tag)
        if tag == 0 then
		    self:Release()
        elseif tag == 1 then
            local name = name_txt:getText()
            if not name or name == "" then
                Tips(LabelChineseStr.FriendAddUIPanel_1)
            else
                para.callBack(name)
				self:Release()
            end
        end 
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_ok",btnCallBack,1)

    return self.panel
end

--退出
function FriendAddUIPanel:Release()
	self.panel:Release()
end

--隐藏
function FriendAddUIPanel:Hide()
	self.panel:Hide()
end

--显示
function FriendAddUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end