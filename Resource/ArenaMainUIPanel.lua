ArenaMainUIPanel = {
panel = nil,
}
function ArenaMainUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function ArenaMainUIPanel:Create(para)
    local p_name = "ArenaMainUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	self.scheduler = nil
	local remainderTime = nil
	local challengeTimes = nil
	local defenceHeroList = nil
	
	local function showUserPkInfoBO()
		local idx = 0
		if challengeTimes <= 0 then
			idx = 2
		else
			if remainderTime <= 0 then
				idx = 3
			else
				idx = 1
			end
		end
		
		if idx == 1 then
			local resetMoney = DataManager.getSystemConfig().pk_reset_waiting_time_cost
			self.panel:setBitmapText("lab_money",resetMoney)
		elseif idx == 2 then
			local resetMoney = DataManager.getSystemConfig().pk_cost_challenge_times
			self.panel:setBitmapText("lab_money",resetMoney)
		end 
		
		self.panel:setNodeVisible("img_money",(idx ~= 3))
		self.panel:setNodeVisible("lab_money",(idx ~= 3))
		self.panel:setNodeVisible("btn_reset",(idx == 1))
		self.panel:setNodeVisible("btn_buyPk",(idx == 2))
		self.panel:setNodeVisible("btn_update",(idx == 3))
		
		local pkTimes = DataManager.getSystemConfig().pk_challenge_times
		self.panel:setBitmapText("lab_num",challengeTimes.."/"..pkTimes)
		self.panel:setBitmapText("lab_time",formatTime(remainderTime))
	end
	
	local function fightCountdown()
		if remainderTime > 1 then
			remainderTime = remainderTime-1
			self.panel:setBitmapText("lab_time",formatTime(remainderTime))
		else
			showUserPkInfoBO()
			self.panel:unscheduleScriptEntry(self.scheduler)
			self.scheduler = nil
		end
	end
	
	local function showCountdown()
		if remainderTime > 0 then
			self.scheduler = self.panel:scheduleScriptFunc(fightCountdown,1)
		end
	end
		
	local function showUserDefenceHero(list)
		local tempList = {}
		for k,v in pairs(list)do
			local systemHero = DataManager.getUserHeroId(v)
			table.insert(tempList,systemHero)
		end
		
		local function sortStandId(a,b)
			return a.standId < b.standId
		end
		
		table.sort(tempList,sortStandId)
		
		local effective = 0
		for k=1,5 do
			local flag = false
			if tempList[k] then
				flag = true
				effective = effective + tempList[k].effective
				self.panel:setImageTexture("img_head_"..k,IconPath.yingxiong..tempList[k].imgId..".png")
				self.panel:setImageTexture("img_color_"..k,IconPath.pinzhiYaun..tempList[k].heroColor..".png")
			end
			self.panel:setNodeVisible("img_bg_"..k,flag)
		end
		self.panel:setBitmapText("lab_effective",effective)
	end
	
	local function refreshCallBack(list)
		defenceHeroList = list
		showUserDefenceHero(list)
	end
	
	-- 获取指定英雄穿戴
	function getEquipList(equipList,userHeroId)
		local retEquipList = { }
		for k, v in pairs(equipList) do
			if userHeroId == v.userHeroId then
				table.insert(retEquipList,v)
			end
		end
		return retEquipList
	end
	
	local function getMonsterList(userHeroList,userEquipList)
		local heroList = {}
		for k,v in pairs(userHeroList) do
			local hero = DeepCopy(v)
			local equipList = getEquipList(userEquipList,v.userHeroId)
			hero.equips = DataTranslater.tranEquipList(equipList)
			table.insert(heroList,hero)
		end
		return heroList
	end

	function ArenaMainUIPanel_PkAction_startPkFight(msgObj)
		local fightResult = {}
		fightResult.forces = {}
		fightResult.forcesDifficulty = 0
		fightResult.fightType = GameField.fightType3		
   		fightResult.hero = DataManager.getUserHeroBattleList()
		fightResult.monster = getMonsterList(msgObj.body.userHeroList,msgObj.body.userEquipList)		
		fightResult.headSkill = DataManager.getFightHeadSkillList()
		LayerManager.show("FightUIPanel",{x=0,y=0,sceneId=0,fightResult=fightResult})
		self:Release()
	end
		
	local function OnItemShowCallback(scroll_view,item,data,idx)
		self.panel:setItemLabelText(item,"lab_userName",data.challengerName)
		self.panel:setItemBitmapText(item,"lab_userRank",data.rank)
		self.panel:setItemBitmapText(item,"lab_userEquipNum",data.power)
		
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
		self.panel:setItemImageTexture(item,"img_head",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemImageTexture(item,"img_color",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		self.panel:addItemNodeTouchEventListener(item,"btn_dare",function(sender,tag) 
			local startPkFightReq = PkAction_startPkFightReq:New()
			startPkFightReq:setString_targetUserId(data.userId)
			NetReqLua(startPkFightReq,true)
		end,0)
	end
	
	local function OnItemClickCallback(item,data,idx)
		local startPkFightReq = PkAction_startPkFightReq:New()
			startPkFightReq:setString_targetUserId(data.userId)
			NetReqLua(startPkFightReq,true)
	end
		
	function ArenaMainUIPanel_PkAction_enterPk(msgObj)
		remainderTime = msgObj.body.userPkInfoBO.remainderTime/1000
		challengeTimes = msgObj.body.userPkInfoBO.challengeTimes
		defenceHeroList = msgObj.body.userDefenceHeroList
		showCountdown()
		showUserPkInfoBO()
		showUserDefenceHero(defenceHeroList)
		
		local rank = msgObj.body.userPkInfoBO.rank
		if rank < 4 then
			self.panel:setNodeVisible("lab_rank",false)
			self.panel:setNodeVisible("img_rank",true)
			if rank == 1 then
				self.panel:setImageTexture("img_rank",IconPath.jingjichang.."t_mcdiyi.png")
			elseif rank == 2 then
				self.panel:setImageTexture("img_rank",IconPath.jingjichang.."t_mcdier.png")
			elseif rank == 3 then
				self.panel:setImageTexture("img_rank",IconPath.jingjichang.."t_mcdisan.png")
			end
		else
			self.panel:setBitmapText("lab_rank",rank)
		end
		
		self.panel:InitListView(msgObj.body.userPkList,OnItemShowCallback,OnItemClickCallback)
	end
	
	function ArenaMainUIPanel_PkAction_resetWaitingTime(msgObj)
		remainderTime = 0
		showUserPkInfoBO()
	end
	
	function ArenaMainUIPanel_PkAction_refreshChallenger(msgObj)
		self.panel:InitListView(msgObj.body.userPkList,OnItemShowCallback,OnItemClickCallback)
	end
	
	function ArenaMainUIPanel_PkAction_buyChallengeTimes(msgObj)
		challengeTimes = challengeTimes + 1
		showUserPkInfoBO()
	end
	
	--按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			UserGuideUIPanel.stepClick("btn_join")
			LayerManager.show("ArenaHeroUIPanel",{list=defenceHeroList,callback=refreshCallBack})
		elseif tag == 2 then
			local resetWaitingTimeReq = PkAction_resetWaitingTimeReq:New()
			NetReqLua(resetWaitingTimeReq,true)
		elseif tag == 3 then
			LayerManager.show("ArenaTipsUIPanel")
		elseif tag == 4 then
			LayerManager.show("ArenaRankUIPanel")
		elseif tag == 5 then
			LayerManager.show("ArenaLogUIPanel")
		elseif tag == 6 then
			LayerManager.show("ArenaShopUIPanel")
		elseif tag == 7 then
			local refreshChallengerReq = PkAction_refreshChallengerReq:New()
			NetReqLua(refreshChallengerReq)
		elseif tag == 8 then
			local buyChallengeTimesReq = PkAction_buyChallengeTimesReq:New()
			NetReqLua(buyChallengeTimesReq)
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_join",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_reset",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_rule",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_rank",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_log",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_reward",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_update",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_buyPk",btnCallBack,8)
	
	--首次进入
	local enterPkReq = PkAction_enterPkReq:New()
	NetReqLua(enterPkReq,true)
	
	return panel
end
--退出
function ArenaMainUIPanel:Release()
	if self.scheduler then
		self.panel:unscheduleScriptEntry(self.scheduler)
	end
	self.panel:Release()
end
--隐藏
function ArenaMainUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaMainUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end