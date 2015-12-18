--用于战斗前阵容选择(注意额外进入的阵容的是别人家的人)
FightDeployUIPanel = {
panel = nil,
}
function FightDeployUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function FightDeployUIPanel:Create(para)
    local p_name = "FightDeployUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local clickMenu = -1
	local effective = 0
	local addIntive = 0
	local addInItem = nil
	local addInHero = nil --附加英雄
	local selectHeroList = nil
	local addInHeroList = {}--附加进入的英雄列表
	local heroItemList = {}
    local waitHeroLeader = nil--缓存的待更换队长的英雄
	local skillSelectSprite = nil
	local battleNum = DataManager.getSystemBattleNum()
	
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
	local function showFriendItem(item)
		if addInHero then
			addIntive = addInHero.effective
			effective = effective + addIntive
			self.panel:setBitmapText("lab_effective",effective)
			
			self.panel:setItemNodeVisible(item,"img_itemBg",true)
			self.panel:setItemNodeVisible(item,"img_nullBg",false)
			
			local systemHero = DataManager.getStaticSystemHeroId(addInHero.systemHeroId)
			self.panel:setItemLabelText(item,"lab_infoLevel","Lv."..addInHero.level)
			self.panel:setItemImageTexture(item,"img_infoHead",IconPath.yingxiong..systemHero.imgId..".png")
			self.panel:setItemImageTexture(item,"img_infoColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		else
			self.panel:setBitmapText("lab_effective",effective-addIntive)
			self.panel:setItemNodeVisible(item,"img_itemBg",false)
			self.panel:setItemNodeVisible(item,"img_nullBg",true)
			self.panel:setItemNodeVisible(item,"img_itemSelect",false)
			self.panel:setItemImageTexture(item,"img_nullBg",IconPath.duiwupeizhi.."i_haoyou.png")
			self.panel:setItemImageTexture(item,"img_infotext",IconPath.duiwupeizhi.."t_xuanzhehy.png")
			addIntive = 0
		end
	end
	
	local function hero_OnItemShowCallback(scroll_view,item,data,idx)
		if clickMenu == StaticField.standId7 then
			self.panel:setItemLabelText(item,"lab_heroName",data.name)
		else
			self.panel:setItemLabelText(item,"lab_heroName",data.heroName)
		end
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
		self.panel:setItemBitmapText(item,"lab_heroLevel", "Lv."..data.level)
		self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemBitmapText(item,"lab_heroCareer", GameString.careerId1ToStr[systemHero.careerId])
	end
	
	local function hero_OnItemClickCallback(item,data,idx)
		if clickMenu == StaticField.standId7 then
			addInHero = data
			showFriendItem(friendItem)
			UserGuideUIPanel.stepClick("img_guideBg_guide")
		else
			if waitHeroLeader then
				actionChangeHeroPosReq(data.userHeroId,1)
				waitHeroLeader = data
			else
				if data.pos == 0 then
					local posId = DataManager.getCurrentBattlePos(battleNum)
					if posId > 0 then
						actionChangeHeroPosReq(data.userHeroId,posId)
					end
						
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
		self.panel:setBtnEnabled("btn_hy",heroType~=StaticField.standId7)
		
		if heroType == StaticField.standId7 then
			selectHeroList = addInHeroList
		else
			selectHeroList = DataManager.getCanBattleHeroList(heroType)
		end
		self.panel:InitListView(selectHeroList,hero_OnItemShowCallback,hero_OnItemClickCallback,"ListView_hero","ListItem_hero",3)
	end

	-----------------------上阵列表-----------------------
	local function showSelectVisible(idx)
		for k,v in pairs(heroItemList)do
			self.panel:setItemNodeVisible(v,"img_itemSelect",idx == 1)
		end
		self.panel:setNodeVisible("img_select",idx == 2)
		self.panel:setItemNodeVisible(friendItem,"img_itemSelect",idx == 3)
	end
	
	local function info_OnItemShowCallback(scroll_view,item,data,idx)
		if battleNum == idx then
			friendItem = item
			showFriendItem(item)
		else
			if data.systemHeroId > 0 then
				effective = effective + data.effective
				self.panel:setBitmapText("lab_effective",effective)
				
				self.panel:setItemBitmapText(item,"lab_infoLevel","Lv."..data.level)
				self.panel:setItemImageTexture(item,"img_infoHead",IconPath.yingxiong..data.imgId..".png")
				self.panel:setItemImageTexture(item,"img_infoColor",IconPath.pinzhiYaun..data.heroColor..".png")
				self.panel:setItemNodeVisible(item,"img_nullBg",false)
				self.panel:setItemNodeVisible(item,"img_itemBg",true)
			else
				if waitHeroLeader then
					self.panel:setItemNodeVisible(item,"img_itemSelect",false)
				end
				table.insert(heroItemList,item)
			end
		end
	end
	
	local function info_OnItemClickCallback(item,data,idx)
		waitHeroLeader = nil
		if battleNum == idx then
			addInHero = nil
			showFriendItem(item)
			showSelectVisible(3)
			refreshFightHero(StaticField.standId7)
		else
			showSelectVisible(1)
			if data.systemHeroId > 0 then
				actionChangeHeroPosReq(data.userHeroId,0)
			end
			if clickMenu == StaticField.standId7 then
				refreshFightHero(StaticField.standId0)
			end
			local listView = self.panel:getChildByName("ListView_info")
			listView:scrollToPercentHorizontal(0,0.5,true)
		end
	end
		
	--刷新信息
	local function refreshHeroInfo()
		local teamHero = DataManager.getSceneHero()
		self.panel:setBitmapText("lab_teamLevel","Lv."..teamHero.level)
		self.panel:setImageTexture("img_teamHead",IconPath.yingxiong..teamHero.imgId..".png")
		self.panel:setImageTexture("img_teamColor",IconPath.pinzhiYaun..teamHero.heroColor..".png")
		
		effective = teamHero.effective + addIntive
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
	
	function FightDeployUIPanel_HeroAction_changeHeroPos(msgObj)
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
	
	function FightDeployUIPanel_HeroAction_changeSkillPos(msgObj)
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
	
	local function netAttackReq()
		local attackReq = ForcesAction_attackReq:New()
		attackReq:setInt_mapId(para.forces.mapId)
		attackReq:setInt_forcesId(para.forces.forcesId)
		attackReq:setInt_forcesType(para.forcesDifficulty)
		NetReqLua(attackReq,true)
	end
	
	local function scrollToPercent(percent)
		
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
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
			if clickMenu == StaticField.standId7 then
				refreshFightHero(StaticField.standId0)
			end
        elseif tag == 6 then
		   UserGuideUIPanel.stepClick("btn_fight") -- 新手引导点击的回调
           netAttackReq()
		elseif tag == 7 then
			refreshFightHero(StaticField.standId0)
		elseif tag == 8 then
			refreshFightHero(StaticField.standId1)
		elseif tag == 9 then
			refreshFightHero(StaticField.standId2)
		elseif tag == 10 then
			refreshFightHero(StaticField.standId4)
		elseif tag == 11 then
			showSelectVisible(3)
			refreshFightHero(StaticField.standId7)
			local listView = self.panel:getChildByName("ListView_info")
			listView:scrollToPercentHorizontal(100,0.5,true)
			UserGuideUIPanel.stepClick("btn_hy")
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_skill_31",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_skill_32",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_skill_33",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_teamer",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_fight",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_qb",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_rd",btnCallBack,8)
	self.panel:addNodeTouchEventListener("btn_sc",btnCallBack,9)
	self.panel:addNodeTouchEventListener("btn_zl",btnCallBack,10)
	self.panel:addNodeTouchEventListener("btn_hy",btnCallBack,11)
	
	function FightDeployUIPanel_ForcesAction_attack(msgObj)
		local fightResult = {}
		fightResult.forces = para.forces
		fightResult.forcesDifficulty = para.forcesDifficulty
		fightResult.fightType = GameField.fightType1
	
		--附加第三方英雄
        local heros = DataManager.getUserHeroBattleList()
        if addInHero then
            addInHero.equips = DataTranslater.tranEquipList(msgObj.body.userEquipList)
            table.insert(heros,addInHero)
        end
		fightResult.hero = heros
		fightResult.monster = DataManager.getSystemForcesMonster(para.forces.forcesId,para.forcesDifficulty)		
		fightResult.headSkill = DataManager.getFightHeadSkillList()
		LayerManager.show("FightUIPanel",{fightResult=fightResult})
		DataManager.setReceiveTaskNpc()
		self:Release()
	end
	
	function FightDeployUIPanel_FriendAction_getJoinBattleUserList(battleUserList)
		--根据装等排个序
        table.sort(battleUserList, function (a, b)
            return a.effective > b.effective
        end)
		addInHeroList = battleUserList
		refreshFightHero(StaticField.standId0)
    end
	
	--请求获取当前可加入战斗列表
    local getJoinBattleUserReq = FriendAction_getJoinBattleUserListReq:New()
    NetReqLua(getJoinBattleUserReq, true)
	
	return panel
end
--退出
function FightDeployUIPanel:Release()
	self.panel:Release()
end
--隐藏
function FightDeployUIPanel:Hide()
	self.panel:Hide()
end
--显示
function FightDeployUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end
