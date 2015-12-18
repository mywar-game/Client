--用于阵容查看
HeroTeamUIPanel = {
panel = nil,
}
function HeroTeamUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroTeamUIPanel:Create(para)
    local p_name = "HeroTeamUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local clickMenu = -1
	local effective = 0
    local heroItemList = {}
	local selectHeroList = nil
	local waitHeroLeader = nil--缓存的待更换队长的英雄
	local skillSelectSprite = nil
	local selectHero = DataManager.getSceneHero() --默认队长
	local battleNum = DataManager.getSystemBattleNum() - 1 --除去队长
	
	-------------------------团长技能-------------------------
	local function actionChangeSkillPosReq(pos,userHeroSkillId)
		if userHeroSkillId then
			local changeSkillPosReq = HeroAction_changeSkillPosReq:New()
			changeSkillPosReq:setInt_pos(pos)
			changeSkillPosReq:setString_userSkillId(userHeroSkillId)
			NetReqLua(changeSkillPosReq,false)	
		end
	end
	
	local function actionChangeHeroPosReq(userHeroId,pos)
		local changeHeroPosReq = HeroAction_changeHeroPosReq:New()
		changeHeroPosReq:setString_userHeroId(userHeroId)
		changeHeroPosReq:setInt_pos(pos)
		NetReqLua(changeHeroPosReq,false)
	end
	
	local function skill_OnItemShowCallback(scroll_view,item,data,idx)
		local systemSkill = DataManager.getSystemSkillId(data.systemHeroSkillId)
		self.panel:setItemLabelText(item,"lab_skillName",systemSkill.name)
		self.panel:setItemLabelText(item,"lab_crystalNum",data.needCrystal)
		self.panel:setItemImageTexture(item,"img_skillHead",IconPath.tuanji..systemSkill.imgId..".png")
        
		--注册特别事件用于显示技能详情
        local imgSkillDetail = self.panel:getChildByName("img_skillDetail")
        local labSkillDesc = self.panel:getItemChildByName(item,"img_skillBg")
        labSkillDesc:addTouchEventListener(function (sender,eventType)
            if eventType == ccui.TouchEventType.began then
                local size = labSkillDesc:getContentSize()
                local pos = labSkillDesc:convertToWorldSpace(cc.p(size.width, size.height/2))
                pos = imgSkillDetail:getParent():convertToNodeSpace(pos)
                imgSkillDetail:setPosition(pos)
				self.panel:setNodeVisible("img_skillDetail",true)
                self.panel:setLabelText("lab_skillDetail", systemSkill.remark)
            else--移动消失
                self.panel:setNodeVisible("img_skillDetail",false)
            end
        end)
	end
	
	local function skill_OnItemClickCallback(item,data,idx)
		if skillSelectSprite then
			skillSelectSprite:setVisible(false)
		end
		skillSelectSprite = self.panel:getItemChildByName(item,"img_select")
		skillSelectSprite:setVisible(true)
		
		if data.pos > 0 then
			actionChangeSkillPosReq(0,data.userHeroSkillId)
		else
			local skillPos = DataManager.getUserHeroSkillPos()
			if skillPos > 0 then
				actionChangeSkillPosReq(skillPos,data.userHeroSkillId)
			else
				for k=1,3 do --英雄主动技能位置31，32，33
					local skillSprite = self.panel:getChildByName("btn_skill_3"..k)
					if skillSprite then
						local arr  ={}
						arr[1] = cc.ScaleTo:create(0.2,1.2)
						arr[2] = cc.ScaleTo:create(0.2,1)
						local sq = cc.Sequence:create(arr)
						skillSprite:runAction(sq)
					end
				end
			end
		end
	end
	
	local function refreshSkillInfo()
		local skillList = DataManager.getUserHeroSkillList()
		self.panel:InitListView(skillList,skill_OnItemShowCallback,skill_OnItemClickCallback,"ListView_skill","ListItem_skill")
	end
	refreshSkillInfo()
	
	----------------------------英雄选择-----------------------------
	local function hero_OnItemShowCallback(scroll_view,item,data,idx)
		local systemHero = DataManager.getUserHeroId(data.userHeroId)
		self.panel:setItemLabelText(item,"lab_heroName",systemHero.heroName)
		self.panel:setItemBitmapText(item,"lab_heroLevel", "Lv."..data.level)
		self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemBitmapText(item,"lab_heroCareer", GameString.careerId1ToStr[systemHero.careerId])
	end
	
	local function hero_OnItemClickCallback(item,data,idx)
		selectHero = data
		if waitHeroLeader then
			actionChangeHeroPosReq(data.userHeroId,1)
			waitHeroLeader = data
		else
			if data.pos == 0 then
				local posId = DataManager.getCurrentBattlePos(battleNum)
				if posId > 0 then
					actionChangeHeroPosReq(data.userHeroId,posId)
			        UserGuideUIPanel.stepClick("img_guideBg_guide") 
				end
			end
		end
	end
	
	local function refreshFightHero(heroType)
		if clickMenu == heroType then
			return
		end
		
		clickMenu = heroType
		self.panel:setBtnEnabled("btn_qb",heroType~=StaticField.standId0)
		self.panel:setBtnEnabled("btn_rd",heroType~=StaticField.standId1)
		self.panel:setBtnEnabled("btn_sc",heroType~=StaticField.standId2)
		self.panel:setBtnEnabled("btn_zl",heroType~=StaticField.standId4)
		selectHeroList = DataManager.getCanBattleHeroList(heroType)
		selectHeroList = DataManager.getSortHeroList(selectHeroList)
		self.panel:InitListView(selectHeroList,hero_OnItemShowCallback,hero_OnItemClickCallback,"ListView_hero","ListItem_hero",3,nil,1)
	end
	refreshFightHero(StaticField.standId0)
	
	-----------------------上阵列表-----------------------
	local function showSelectVisible(idx)
		for k,v in pairs(heroItemList)do
			self.panel:setItemNodeVisible(v,"img_itemSelect",idx == 1)
		end
		self.panel:setNodeVisible("img_select",idx == 2)
	end
	
	local function info_OnItemShowCallback(scroll_view,item,data,idx)
		if data.systemHeroId > 0 then
			effective = effective + data.effective
			self.panel:setBitmapText("lab_effective",effective)
			
			self.panel:setItemNodeVisible(item,"img_itemBg",true)
			self.panel:setItemNodeVisible(item,"img_nullBg",false)
	
			self.panel:setItemBitmapText(item,"lab_infoLevel","Lv."..data.level)
			self.panel:setItemImageTexture(item,"img_infoHead",IconPath.yingxiong..data.imgId..".png")
			self.panel:setItemImageTexture(item,"img_infoColor",IconPath.pinzhiYaun..data.heroColor..".png")
		else
			if waitHeroLeader then
				self.panel:setItemNodeVisible(item,"img_itemSelect",false)
			end
			table.insert(heroItemList,item)
		end
	end
	
	local function info_OnItemClickCallback(item,data,idx)
		waitHeroLeader = nil
		showSelectVisible(1)
		if data.systemHeroId > 0 then
			actionChangeHeroPosReq(data.userHeroId,0)
		end
	end
		
	--刷新信息
	local function refreshHeroInfo()
		heroItemList = {}
		local teamHero = DataManager.getSceneHero()
		self.panel:setBitmapText("lab_teamLevel","Lv."..teamHero.level)
		self.panel:setImageTexture("img_teamHead",IconPath.yingxiong..teamHero.imgId..".png")
		self.panel:setImageTexture("img_teamColor",IconPath.pinzhiYaun..teamHero.heroColor..".png")
		effective = teamHero.effective
		self.panel:setBitmapText("lab_effective",effective)
		
		local heroList = DataManager.getUserHeroBattlePos(battleNum)
		self.panel:InitListView(heroList,info_OnItemShowCallback,info_OnItemClickCallback,"ListView_info","ListItem_info")
	end
	refreshHeroInfo()
	
	local skillSpriteList = {}
	local function refreshHeadSkill()
		local fightSkillList = DataManager.getFightHeadSkillList()	
		for k,v in pairs(skillSpriteList)do
			v:removeFromParent(true)
		end
		skillSpriteList = {}
		
		for k,v in pairs(fightSkillList)do
			if v.pos > 0 then
				local systemSkill = DataManager.getSystemSkillId(v.systemHeroSkillId)
				local skillSprite = CreateCCSprite("res/team_skill/"..systemSkill.imgId..".png")
				local skillBtn = self.panel:getChildByName("btn_skill_"..v.pos)
				local size = skillBtn:getContentSize()
				skillSprite:setPosition(size.width/2,size.height/2) --英雄主动技能位置31，32，33
				skillBtn:addChild(skillSprite,-1)
				table.insert(skillSpriteList,skillSprite)
			end
		end
	end
	refreshHeadSkill()
	
	function HeroTeamUIPanel_HeroAction_changeHeroPos(msgObj)
		for k,v in pairs(msgObj.body.updateHeroList)do
			for m,n in pairs(selectHeroList)do
				if v.systemHeroId == n.systemHeroId then
					n.pos = v.pos
					n.isTeamLeader = v.isTeamLeader
				end
			end
		end
		if waitHeroLeader then
			DataManager.changeTeamLeader(waitHeroLeader)
			UserInfoUIPanel_refresh()
			TileMapUIPanel_showUserHero()
		end
		refreshHeroInfo()
	end
	
	function HeroTeamUIPanel_HeroAction_changeSkillPos(msgObj)
		refreshHeadSkill()
	end
	
	local function getShowHeadSkillId(pos)
		local skillList = DataManager.getUserHeroSkillList()
		for k,v in pairs(skillList)do
			if v.pos == pos then
				return v.userHeroSkillId
			end
		end
		return nil
	end
	
	local function borderMove(flag,pos)
		local x = flag and 130 or 0
		local infoBg = self.panel:getChildByName("img_border")
		local skillBg = self.panel:getChildByName("img_skillBg")
		if flag and skillBg:isVisible() then
			actionChangeSkillPosReq(0,getShowHeadSkillId(pos))
		end
		skillBg:setVisible(flag)
		infoBg:runAction(cc.MoveTo:create(0.3,cc.p(x,-18)))
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
			UserGuideUIPanel.stepClick("btn_back")
		elseif tag == 1 then
			borderMove(false,0)
		elseif tag == 2 then
			borderMove(true,31)
		elseif tag == 3 then
			borderMove(true,32)
		elseif tag == 4 then
			borderMove(true,33)
		elseif tag == 5 then
			showSelectVisible(2)
			waitHeroLeader = DataManager.getSceneHero()
        elseif tag == 6 then
            LayerManager.show("HeroDescUIPanel",{hero=selectHero,idx=GameField.heroDescSkill})
		elseif tag == 7 then
			refreshFightHero(StaticField.standId0)
		elseif tag == 8 then
			refreshFightHero(StaticField.standId1)
		elseif tag == 9 then
			refreshFightHero(StaticField.standId2)
		elseif tag == 10 then
			refreshFightHero(StaticField.standId4)
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_skill_31",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_skill_32",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_skill_33",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_teamer",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_heroHome",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_qb",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_rd",btnCallBack,8)
	self.panel:addNodeTouchEventListener("btn_sc",btnCallBack,9)
	self.panel:addNodeTouchEventListener("btn_zl",btnCallBack,10)

	return panel
end
--退出
function HeroTeamUIPanel:Release()
	self.panel:Release()
end
--隐藏
function HeroTeamUIPanel:Hide()
	self.panel:Hide()
end
--显示
function HeroTeamUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end
