UserInfoDetailUIPanel = {
panel = nil,
}

function UserInfoDetailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function UserInfoDetailUIPanel:Create(para)
    local p_name = "UserInfoDetailUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local teamEpx1,teamEpx2 = DataManager.getSystemTeamExp()
	local userBo = DataManager.getUserBO()
	local battleNum = DataManager.getSystemBattleNum()
	local heroList = DataManager.getUserHeroList()
	
	local systemHero = DataManager.getSceneHero()
	self.panel:setImageTexture("img_heroHead","res/hero_icon/"..systemHero.imgId..".png")
	self.panel:setImageTexture("img_headColor","common/head_color_"..systemHero.heroColor..".png")
	
	self.panel:setLabelText("lab_heroNum",#heroList)
	self.panel:setLabelText("lab_teamName",userBo.roleName)
	self.panel:setLabelText("lab_teamExp",userBo.exp-teamEpx1.exp)
	self.panel:setLabelText("lab_account",userBo.ftId)
	self.panel:setLabelText("lab_max_level",battleNum)
	self.panel:setLabelText("lab_teamLevel","Lv."..userBo.level)
	
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
		
		elseif tag == 2 then
		
		elseif tag == 3 then
			LayerManager.show("ChangeNameUIPanel")
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	--self.panel:addNodeTouchEventListener("btn_set",btnCallBack,1)
	--self.panel:addNodeTouchEventListener("btn_change",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_rename",btnCallBack,3)
	
	return panel
end

--退出
function UserInfoDetailUIPanel:Release()
	self.panel:Release()
end
--隐藏
function UserInfoDetailUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function UserInfoDetailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
