--好友详情
FriendDetailUIPanel = {}
function FriendDetailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function FriendDetailUIPanel:Create(para)
	local p_name = "FriendDetailUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    local data = para.data
    self.panel:setLabelText("lab_name", data.name)
    self.panel:setLabelText("lab_teamLevel", data.level)
    self.panel:setLabelText("lab_equipLevel", data.effective)
    self.panel:setImageTexture("img_team", IconUtil.getTeamImgPath(data.camp))
	
	local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
	if systemHero then
		self.panel:setImageTexture("img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		self.panel:setImageTexture("img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
	end
	
	local function btnCallBack(sender,tag)
        if tag == 0 then
		    
        elseif tag == 1 then
			--显示好友阵容
            LayerManager.show("FriendLineupUIPanel", {friendId = data.userId})
        elseif tag == 2 then
            LayerManager.show("ChatUIPanel", {index = 4, friendId = data.userId, friendName = data.name})
        elseif tag == 3 then
            --拉黑
			para.callBack(data.userId)
        elseif tag == 4 then
            --发送信息
            LayerManager.show("EmailSenderUIPanel", {fromPanel = "FriendUIPanel", name=data.name})
        end
		self:Release() 
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
   	self.panel:addNodeTouchEventListener("btn_team",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_chat",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_toBlackList",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_leaveMessage",btnCallBack,4)
    
    return self.panel
end

--退出
function FriendDetailUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function FriendDetailUIPanel:Hide()
	self.panel:Hide()
end

--显示
function FriendDetailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end