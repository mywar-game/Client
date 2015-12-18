require("BossQTE")
require("HeroQTE")

FightPlayer = {}

function FightPlayer:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function FightPlayer:init(fightLogic,fightReport)
	self.isstart = false
	self.violentNum = 1
	self.curRounds = 0
	self.battleType = 1
	self.attackType = 0
	self.atk_hero_list = {}
	self.def_cards_list = {}
	self.sheep_hero_list = {}
	self.fightLogic = fightLogic
	self.fightReport = fightReport
	self.rootLayer = fightLogic.rootLayer
	self.maxRounds = #fightReport.defs
	
	local scheduler	= Director.getScheduler()
	local function replyCrystalFunc()
		if self.isstart then
			self.fightLogic.onReplyCrystalCallBack()
		end
	end
	self.replyHandler = scheduler:scheduleScriptFunc(replyCrystalFunc,2,false) --水晶恢复
	
	local function violentFunc()
		if self.isstart then
			if self.violentNum > 0 then
				self.violentNum = self.violentNum - 1
				self.fightLogic.onViolentCallBack(self.violentNum)
			elseif self.violentNum == 0 then
				if self.fightReport.fightType == GameField.fightType3 then
					self.isstart = false
					self.fightLogic.onFightOverCallback(self.battleType,GameField.fightFail)
				else
					self:doHeroViolent()
				end
			end
		end
	end
	self.violentHandler = scheduler:scheduleScriptFunc(violentFunc,1,false) --狂暴
	
	self:doChangeBattleType() --初始化
	self:registerScriptTouch()
end

--狂暴
function FightPlayer:doHeroViolent()
	for k,v in pairs(self.def_cards_list)do
		v.heroBg:runAction(cc.ScaleTo:create(0.4,1.2))
		v.skeleton:setColor(cc.c3b(250,0,0))
	end
end

function FightPlayer:doStartFight(fightHero)
	fightHero:toGeneralBattle()
end

function FightPlayer:toPlaySkill(fightHero)
	for k,v in pairs(fightHero.heroInfo.activeSkillList) do
		if v.skillId == fightHero.battleSkillId then
			fightHero:toHeroChatBubble(v.textId) --气泡
			SkillAI.autoAI1(fightHero,v,self.atk_hero_list,self.def_cards_list,false)
			break
		end
	end
end

function FightPlayer:toPlaySkillEffect(effect,fightHero)
	SkillAI.runSkillBuff(effect,{fightHero},self.atk_hero_list,self.def_cards_list,StaticField.nowRunBuff1)
end

function FightPlayer:doCheckHeadSkillCd()
	local headSkill = self.fightReport.headSkill
	for k,v in pairs(headSkill) do
		v.nextPlayerTime = v.nextPlayerTime - 0.1
		if v.nextPlayerTime <= 0 then
			self.fightLogic.onCanPlaycallBack(k)
		end
	end
end

function FightPlayer:doHeroDead(fightHero)
	if fightHero.heroInfo.actMode == GameField.actMode1 then
		for k,v in pairs(self.fightReport.atks) do --设置复活
			local heroId1 = v.systemHero.systemHeroId
			local heroId2 = fightHero.heroInfo.systemHero.systemHeroId
			if heroId1 == heroId2 then
				v.heroState = StaticField.heroState2
				break
			end
		end
	end
	
	local function delCallback(delHero)
		local layer = self.rootLayer:getParent()
		HeroQTE.removeQteLayer(layer,delHero) --删除QTE
		delHero:toReslut(GameField.fightFail)
	end
	self:doDeleteHero(fightHero.heroInfo.fightHeroId,delCallback)
	self:doDeleteHero(fightHero.heroInfo.perentHeroId,delCallback)
end

function FightPlayer:doHeroNextWeak()
	self.isstart = false
	local function weakCallBack(fightHero,i)
		if i == 1 then
			self:doDelCallHero()
			self:doChangeBattleType()
		end
	end
	
	for k,v in pairs(self.atk_hero_list) do
		local layer = self.rootLayer:getParent()
		HeroQTE.removeQteLayer(layer,v) --过场删除QTE

		local scaleX = math.abs(v.skeleton:getScaleX())
		v.skeleton:setScaleX(scaleX)
		
		local x,y = v.heroBg:getPosition()
		local t = (UIConfig.stageWidth+100-x)/v.heroInfo.systemHeroAttr.moveSpeed
		v:toWeak(t,UIConfig.stageWidth+100,y,k,weakCallBack)
	end
	self.fightLogic.onPauseCallBack(false)
end

function FightPlayer:doNextPlay(fightHero)
	if table.getn(self.atk_hero_list) == 0 then
		for k,v in pairs(self.def_cards_list)do
			v:toReslut(GameField.fightSuccess)
		end
		self.isstart = false
		self.fightLogic.onFightOverCallback(self.battleType,GameField.fightFail)
	elseif table.getn(self.def_cards_list) == 0 then
		if self.curRounds >= self.maxRounds then
			for k,v in pairs(self.atk_hero_list)do
				v:toHeroWin(GameField.fightSuccess)
			end
			self.isstart = false
			self.fightLogic.onFightOverCallback(self.battleType,GameField.fightSuccess)
		else
			self:doHeroNextWeak()
		end
	end
end

--删除召唤的英雄
function FightPlayer:doDelCallHero()
	local num = #self.atk_hero_list
	for k=1,num do
		for n=#self.atk_hero_list,1,-1 do
			local hero = self.atk_hero_list[n]
			if hero.heroInfo.petType == StaticField.petType3 or 
			   hero.heroInfo.petType == StaticField.petType4 then
				hero:soulRelease()
				table.remove(self.atk_hero_list,n)
				break
			end
		end
	end
end

--废弃
function FightPlayer:doHeroSelect(fightHero)
	local curHero = self.atk_hero_list[1]
	for k,v in pairs(self.atk_hero_list)do
		if curHero.heroHateNum < v.heroHateNum then
			curHero = v
		end
		v:toShowSprite(false)
	end
	curHero:toShowSprite(true)
	
	local tx,ty = curHero.heroBg:getPosition()
	fightHero:toAttackTarget(tx)
end

function FightPlayer:doHeroBlood(fightHero)
	if self.battleType == GameField.battleType2 then
		local attr = fightHero.heroInfo.systemHeroAttr
		if fightHero.heroInfo.actMode == GameField.actMode1 then
			if fightHero.isSelect and self.fightLogic.onUpdateHeroBloodCallback then
				self.fightLogic.onUpdateHeroBloodCallback(attr.hp,attr.maxHp)
			end
		else
			if self.fightLogic.onUpdateBossBloodCallback then
				self.fightLogic.onUpdateBossBloodCallback(attr.hp,attr.maxHp)
			end
		end
	end
end

function FightPlayer:doPlayHeadSkill(pos)
	if not self.isstart then
		Tips(GameString.clickStart)
		return
	end
	
	local skill = self.fightReport.headSkill[pos]
	if skill == nil then
		return 
	end
	
	local atkHero = nil
	local systemSkill = DataManager.getSystemSkillId(skill.skillId)
	systemSkill.needCareer = "0"
	local needCareerList = Split(systemSkill.needCareer,",")
	for k,v in pairs(needCareerList)do
		if tonumber(v) > 0 then --需职业在场的团长技能
			for m,n in pairs(self.atk_hero_list)do
				if tonumber(v) == n.heroInfo.systemHero.careerId then
					atkHero = n
					break
				end
			end
		else
			atkHero = self.atk_hero_list[1]
			break
		end
	end
	
	if atkHero then
		SkillAI.autoAI(atkHero,systemSkill,self.atk_hero_list,self.def_cards_list,true)
		self.fightLogic.onConsumeCrystalCallback(skill.needCrystal,needCareerList)
	else
		self.fightLogic.onConsumeCrystalCallback(0,needCareerList)
	end
	
end

--获取英雄
function FightPlayer:toGetHero(fightHeroId)
	for k,v in pairs(self.atk_hero_list) do
		if v.heroInfo.fightHeroId == fightHeroId then
			return v
		end
	end
	
	for k,v in pairs(self.def_cards_list) do
		if v.heroInfo.fightHeroId == fightHeroId then
			return v
		end
	end
	
	for k,v in pairs(self.sheep_hero_list) do
		if v.heroInfo.fightHeroId == fightHeroId then
			return v
		end
	end
end

--删除英雄
function FightPlayer:doDeleteHero(fightHeroId,delCallback)
	if fightHeroId <= 0 then
		return
	end
	local function delFightHeroId(heroList)
		local size = #heroList
		for i=1,size do
			for k=#heroList,1,-1 do
				if heroList[k].heroInfo.fightHeroId == fightHeroId then  --英雄死亡
					delCallback(heroList[k])
					table.remove(heroList,k)
					break
				end
				
				if heroList[k].heroInfo.perentHeroId == fightHeroId then --当英雄死亡，宝宝和变身也需要死亡
				   if heroList[k].heroInfo.petType == StaticField.petType1 or 
					  heroList[k].heroInfo.petType == StaticField.petType2 then
						delCallback(heroList[k])
						table.remove(heroList,k)
						break
				    end
				end
			end
		end
	end
	delFightHeroId(self.atk_hero_list)	
	delFightHeroId(self.def_cards_list)	
	delFightHeroId(self.sheep_hero_list)
end

function FightPlayer:doAddToHeroList(actMode,hero)
	local function sortPosId(a,b)
		return a.heroInfo.posId < b.heroInfo.posId
	end
	if actMode == GameField.actMode1 then
		table.insert(self.atk_hero_list,hero)
		table.sort(self.atk_hero_list,sortPosId)
	else
		table.insert(self.def_cards_list,hero)
		table.sort(self.def_cards_list,sortPosId)
	end	
end

--召唤变身
function FightPlayer:toCallHeroSheep(heroId,callHeroId,fightHero)
	local x,y = fightHero.heroBg:getPosition()
	local posId = fightHero.heroInfo.posId
	local actMode = fightHero.heroInfo.actMode
	local zorder = fightHero.heroBg:getLocalZOrder()
	local level = fightHero.heroInfo.systemHeroAttr.level
	local perentHeroId = fightHero.heroInfo.fightHeroId
	fightHero.heroBg:setVisible(false)
	fightHero:clearSkillTime()
	
	local hero = FightHero:New()
	local heroInfo = FightReport.parseHero(0,0,heroId,{},level,actMode,posId,StaticField.petType1,perentHeroId,callHeroId[1])
	heroInfo.posId = posId + 10
	hero:Init(self,heroInfo)
	hero.heroBg:setPosition(cc.p(x,y))
	hero.heroBg:setLocalZOrder(zorder)
	hero:toCheckSkillCd()
	
	local scaleX = hero.skeleton:getScaleX()
	if fightHero.skeleton:getScaleX() > 0 then
		hero.skeleton:setScaleX(scaleX)
	else
		hero.skeleton:setScaleX(-scaleX)
	end
	
	local function delCallback(delHero)
		
	end
	self:doDeleteHero(fightHero.heroInfo.fightHeroId,delCallback)
	table.insert(self.sheep_hero_list,fightHero)
	
	self:doAddToHeroList(actMode,hero)
end

--删除变身
function FightPlayer:toDelHeroSheep(heroId,callHeroId,fightHero)
	local function delHeroCallback(delHero)
		delHero:soulRelease()
	end
	self:doDeleteHero(callHeroId[1],delHeroCallback)
	
	local function delSheepCallback(delHero)
		fightHero.heroBg:setVisible(true)
		fightHero:toCheckSkillCd()
		self:doAddToHeroList(fightHero.heroInfo.actMode,fightHero)
	end
	self:doDeleteHero(fightHero.heroInfo.fightHeroId,delSheepCallback)
end

--召唤英雄技能
function FightPlayer:toAddHeroSkillEffect(heroId,callHeroId,fightHero)
	local x,y = fightHero.heroBg:getPosition()
	local posId = fightHero.heroInfo.posId
	local actMode = fightHero.heroInfo.actMode
	local scaleX = fightHero.heroBg:getScaleX()
	local zorder = fightHero.heroBg:getLocalZOrder()
	local level = fightHero.heroInfo.systemHeroAttr.level
	
	local hero = FightHero:New()
	local heroInfo = FightReport.parseHero(0,0,heroId,{},level,actMode,posId,StaticField.petType4,0,callHeroId[1])
	local moveSpeed = heroInfo.systemHeroAttr.moveSpeed
	heroInfo.systemHeroAttr = DeepCopy(fightHero.heroInfo.systemHeroAttr)
	heroInfo.posId = 13 --特殊位置
	hero:Init(self,heroInfo)
	hero.heroBg:setPosition(cc.p(x,y+100))
	hero.heroBg:setLocalZOrder(100)
	hero.heroSkillState = StaticField.heroSkillState1
	hero:toCheckSkillCd()
	
	local mx = scaleX > 0 and 2024 or -1024
	local arr = {}
	arr[1] = cc.MoveTo:create(math.abs(mx-x)/moveSpeed,cc.p(mx,y+100))
	arr[2] = cc.CallFunc:create(function()
		hero.isStartFight = false
		hero.heroBg:setVisible(false)
	end)	
	hero.heroBg:runAction(cc.Sequence:create(arr))
	self:doAddToHeroList(actMode,hero)
end

--删除召唤英雄
function FightPlayer:toDelHeroSkillEffect(heroId,callHeroId,fightHero)
	local function delHeroCallback(delHero)
		delHero:soulRelease()
	end
	self:doDeleteHero(callHeroId[1],delHeroCallback)
end

--召唤英雄
function FightPlayer:toAddCallHero(heroId,callHeroId,fightHero)
	local function getGeneralPosid(heroList)
		for k=1,12 do
			local flag = true
			for m,n in pairs(heroList)do
				if k == n.heroInfo.posId then
					flag = false
					break
				end
			end
			if flag then
				return k
			end
		end
	end
	
	local function getAdvancedPosid(heroList,state)	
		local mIdx1 = 6
		local mIdx2 = 6
		local posIdx1 = {1,1,1,1,1,1}
		local posIdx2 = {1,1,1,1,1,1}
		for k,v in pairs(heroList)do
			local standId = v.heroInfo.systemHero.standId
			if standId == StaticField.standId1 or standId == StaticField.standId2 then
				posIdx1[v.posIdx] = 0				
			elseif standId == StaticField.standId3 or standId == StaticField.standId4 then
				posIdx2[v.posIdx] = 0
			end
		end
		
		if state then
			for k,v in pairs(posIdx1)do
				if v == 1 then
					mIdx1 = k
					break
				end
			end
		else
			for k,v in pairs(posIdx2)do
				if v == 1 then
					mIdx2 = k
					break
				end
			end
		end
		return mIdx1,mIdx2
	end
	
	for k,v in pairs(callHeroId) do
		local idx1 = 0
		local idx2 = 0
		local state = false
		local posId = fightHero.heroInfo.posId
		local actMode = fightHero.heroInfo.actMode
		local level = fightHero.heroInfo.systemHeroAttr.level
		local fightHeroId = fightHero.heroInfo.fightHeroId
		local hero = FightHero:New()
		local heroInfo = FightReport.parseHero(0,0,heroId,{},level,actMode,posId,StaticField.petType3,fightHeroId,callHeroId[k])
		local standId = heroInfo.systemHero.standId 
		hero:Init(self,heroInfo)
		hero:toCheckSkillCd()
	    
		if standId == StaticField.standId1 or standId == StaticField.standId2 then
			state = true
		elseif standId == StaticField.standId3 or standId == StaticField.standId4 then
			state = false
		end 
		
		if actMode == GameField.actMode1 then
			idx1,idx2 = getAdvancedPosid(self.atk_hero_list,state)
			heroInfo.posId = getGeneralPosid(self.atk_hero_list)
			table.insert(self.atk_hero_list,hero)
		else
			idx1,idx2 = getAdvancedPosid(self.def_cards_list,state)
			heroInfo.posId = getGeneralPosid(self.def_cards_list)
			table.insert(self.def_cards_list,hero)
		end

		if state then
			hero.posIdx = idx1
		else
			hero.posIdx = idx2
		end
		
		if fightHero.heroInfo.battleType == GameField.battleType1 then
			local pt = FightConfig.runCommPosition(heroInfo.posId,heroInfo.petType)
			local zorder = FightConfig.getCommZorder(heroInfo.posId)
			hero.heroBg:setPosition(cc.p(pt.x,pt.y))
			hero.heroBg:setLocalZOrder(960-pt.y)
		else			
			local pt = FightConfig.runBossPosition(idx1,idx2,state,heroInfo.petType)
			local zorder = FightConfig.getBossZorder(idx1,idx2,state,heroInfo.petType)
			hero.heroBg:setPosition(cc.p(pt.x,pt.y))
			hero.heroBg:setLocalZOrder(960-pt.y)
			if (state and idx1 % 2 == 0) or (not state and idx2 % 2 == 0) then
				local sx = hero.skeleton:getScaleX()
				hero.skeleton:setScaleX(-sx)
			end
		end
	end
end

--删除召唤英雄
function FightPlayer:toDelCallHero(heroId,callHeroId,fightHero)	
	for k,v in pairs(callHeroId) do
		local function delHeroCallback(delHero)
			delHero:soulRelease()
		end
		self:doDeleteHero(callHeroId[k],delHeroCallback)
	end
end

function FightPlayer:doChangeBattleType()
	self.isstart = false
	self.curRounds = self.curRounds + 1
	self.battleType = GameField.battleType1
	local defs = self.fightReport.defs[self.curRounds]
	
	if self.collisionHandler then
		local scheduler	= Director.getScheduler()
		scheduler:unscheduleScriptEntry(self.collisionHandler)
		self.collisionHandler = nil
	end
	SkillEffect.clearFixedBuffEffect() --清除固定的特性
		
	--重新排序
	local function sortPosId(a,b)
		return math.abs(a.heroInfo.posId) < math.abs(b.heroInfo.posId)
	end
	
	for k,v in pairs(defs)do
		if v.systemMonster.monsterType == StaticField.monsterType3 then
			self.battleType = GameField.battleType2
			break
		end
	end
		
	for k,v in pairs(defs)do
		v.battleType = self.battleType
	end
	
	for k,v in pairs(self.fightReport.atks)do
		v.battleType = self.battleType
	end
		
	for k,v in pairs(self.atk_hero_list)do
		v:toResetHeroAttr(self.battleType)
	end
	
	for k,v in pairs(defs) do--怪物
		local hero = FightHero:New()
		hero:Init(self,v)
		table.insert(self.def_cards_list,hero)
	end
	table.sort(self.def_cards_list,sortPosId)
		
	--初始化英雄
	for k,v in pairs(self.fightReport.atks) do--英雄
		local state = false
		if v.heroState == StaticField.heroState0 then
			state = true
			v.heroState = StaticField.heroState1
		end
		
		if v.heroState == StaticField.heroState2  then
			state = true
		end
		
		if state then
			local hero = FightHero:New()
			hero:Init(self,v)
			table.insert(self.atk_hero_list,hero)
		end
	end
	table.sort(self.atk_hero_list,sortPosId)
	
	self:doHeroEnterScene(self.atk_hero_list,GameField.actMode1,false)
	self:doHeroEnterScene(self.def_cards_list,GameField.actMode2,false)
			
	--怪物被动技能
	for k,v in pairs(self.def_cards_list)do
		for m,n in pairs(v.heroInfo.passiveSkillList)do
			SkillAI.autoAI(v,n,self.atk_hero_list,self.def_cards_list,false)
		end
	end
	
	--英雄被动技能
	for k,v in pairs(self.atk_hero_list)do
		for m,n in pairs(v.heroInfo.passiveSkillList)do
			SkillAI.autoAI(v,n,self.atk_hero_list,self.def_cards_list,false)
		end
	end
	
	local heroImgId = nil
	for k,v in pairs(self.def_cards_list)do
		if self.battleType == GameField.battleType2 then
			heroImgId = v.heroInfo.systemHero.imgId
			break
		end
	end
	
	--演示
	if self.battleType == GameField.battleType2 and 
	   DataManager.getUserBO().level == 3 then
		self:showDomeStory()
	end
	
	local background = self.fightReport.background[self.curRounds]
	self.fightLogic.onInitFightCallBack(self.curRounds,self.battleType,background,heroImgId)
end
	
function FightPlayer:doHeroEnterScene(actHeroList,actMode,isAddUser)
	local petList = {}
	local heroList = {}
	for k,v in pairs(actHeroList)do
		if v.heroInfo.petType==StaticField.petType1 then
			table.insert(heroList,v)
		else
			table.insert(petList,v)
		end
	end
	
	local function getPet(petId)
		for k,v in pairs(petList)do
			if v.heroInfo.systemHeroId == petId then
				return v
			end
		end
		return nil
	end
	
	local function weakAtkCallBack(fightHero,idx)
		if idx > 1 then
			return
		end
		
		if self.fightReport.fightType == GameField.fightType4 then
			if DataManager.getWorldBossRoomOwner() then
				self:doActionAttack()
			end
		else
			self.fightLogic.onFrontFightCallBack(self.atk_hero_list,self.def_cards_list)
		end
	end
	
	local function heroWeak(hero,idx,pt,mx,my)
		if hero then			
			if actMode == GameField.actMode1 then
				if not isAddUser and not DataManager.getUserHeroId(hero.heroInfo.userHeroId) then --不是新增英雄和不是自己
					hero.heroBg:setPosition(cc.p(hero.heroInfo.posX,hero.heroInfo.posY))
					hero.heroBg:setLocalZOrder(UIConfig.stageHeight-hero.heroInfo.posY)
					hero:toHold()
				else
					local t = UIConfig.stageWidth/hero.heroInfo.systemHeroAttr.moveSpeed/3
					hero.heroBg:setLocalZOrder(UIConfig.stageHeight-pt.y-my)
					hero.heroBg:setPosition(cc.p(pt.x-mx-UIConfig.stageWidth/3,pt.y-my))
					hero:toWeak(t,pt.x-mx,pt.y-my,idx,weakAtkCallBack)
				end
			else
				hero.heroBg:setLocalZOrder(UIConfig.stageHeight-pt.y-my)
				hero.heroBg:setPosition(cc.p(pt.x+mx,pt.y-my))
				hero:toHold()
			end
		end
	end
	
	for k,v in pairs(heroList)do		
		local mx = FightConfig.petOffset.x
		local my = FightConfig.petOffset.y
		local posId = (actMode == GameField.actMode1 and k or v.heroInfo.posId)
		local pt = FightConfig.startHeroPosition(posId,actMode)
		local pet = getPet(v.heroInfo.systemHero.systemHeroId)
		heroWeak(v,k,pt,0,0)
		heroWeak(pet,k,pt,mx,my)
	end
end

--演示情节
function FightPlayer:showDomeStory()
	local ax = 780
	local ay = 200
	local dx = 680
	local dy = 200
	local heroId = 0
	if DataManager.getUserBO().camp == GameField.Camp_Alliance then --演示的Id
		heroId = 10010
	else
		heroId = 20030
	end
	
	local heroInfo = FightReport.parseHero(0,0,heroId,{},1,GameField.actMode1,10,StaticField.petType1)--小女生
	local modelScale = heroInfo.systemHero.modelScale
	local actHero = FightHero:New()
	actHero:Init(self,heroInfo)
	actHero.skeleton:setScaleX(-modelScale)
	actHero.heroBg:setPosition(cc.p(ax,ay))
	actHero:toHold()
	table.insert(self.atk_hero_list,actHero)
	
	local bossHero = self.def_cards_list[1]
	local bossScale = bossHero.heroInfo.systemHero.modelScale
	bossHero.skeleton:setScaleX(bossScale)
	bossHero.skeleton:getAnimation():play(ACTION_ATTACK0)
end

function FightPlayer:doPlayBossQTE(qteTriggerType)
	local function qteFinishCallBack(state,skillId)
		if state then
			local systemSkill = DataManager.getSystemSkillId(skillId)	
			SkillAI.autoAI1(self.atk_hero_list[1],systemSkill,self.atk_hero_list,self.def_cards_list,false)
		end
	end
	local layer = self.rootLayer:getParent()
	BossQTE.autoQTE(layer,self.fightReport.qte[self.curRounds],qteTriggerType,
					self.atk_hero_list,self.def_cards_list,qteFinishCallBack)
end

--怪物是触发型的
function FightPlayer:toTriggerMonster(fightHero)
	local monsterType = fightHero.heroInfo.systemMonster.monsterType
	if self.attackType == 0 and monsterType ~= StaticField.monsterType4 then
		self.attackType = 1
		for k=#self.def_cards_list,1,-1 do
			self.def_cards_list[k]:toCheckSkillCd()
		end
	end
end

--开始战斗
function FightPlayer:doActionAttack()
	self.isstart = true
	self.attackType = 0
	self.violentNum = GameField.violentNum
	self.fightLogic.onPauseCallBack(true)
	
	for m=1,6 do --删除灵魂的英雄，最多6个
		for k=#self.atk_hero_list,1,-1 do
			if self.atk_hero_list[k].heroInfo.heroState == StaticField.heroState2 then
				self.atk_hero_list[k]:soulRelease()
				table.remove(self.atk_hero_list,k)
				break
			end
		end
	end
	
	if #self.atk_hero_list == 0 then
		self.fightLogic.onFightOverCallback(self.battleType,GameField.fightFail)
		return
	end
	
	for k=#self.atk_hero_list,1,-1 do --定时器后添加先触发
		--self.atk_hero_list[k].heroBg:setPosition(cc.p(100*k,100*k))
		self.atk_hero_list[k].heroBg:stopAllActions()
		self.atk_hero_list[k]:toCheckSkillCd()
	end
	
	local attackType = self.def_cards_list[1].heroInfo.systemHeroAttr.attackType
	if attackType == GameField.attackType1 then
		self.attackType = 1
		for k=#self.def_cards_list,1,-1 do
			--self.def_cards_list[k].heroBg:setPosition(cc.p(700,320))
			self.def_cards_list[k].heroBg:stopAllActions()
			self.def_cards_list[k]:toCheckSkillCd()
		end
	end
end

--boss进入推送用户进入
function FightPlayer:toBossPushUser(userHeroList)
	local atkHeroList = {}
	for k,v in pairs(userHeroList)do
		local heroInfo = FightReport.parseHero(v.userId,v.userHeroId,v.systemHeroId,v.equips,v.level,GameField.actMode1,0,StaticField.petType1)
		local actHero = FightHero:New()
		actHero:Init(self,heroInfo)
		table.insert(atkHeroList,actHero)
	end
	self:doHeroEnterScene(atkHeroList,GameField.actMode1,true)
	
	for k,v in pairs(atkHeroList)do
		table.insert(self.atk_hero_list,v)
	end
	
	--英雄被动技能
	for k,v in pairs(atkHeroList)do
		for m,n in pairs(v.heroInfo.passiveSkillList)do
			SkillAI.autoAI(v,n,self.atk_hero_list,self.def_cards_list,false)
		end
	end
end

--攻击信息
function FightPlayer:toBossPushUserAttackInfo(attackList)
	local function getTargetHeroList(userId)
		for k,v in pairs(self.atk_hero_list)do
			if v.heroInfo.userId == userId then
				return v
			end
		end
		
		for k,v in pairs(self.def_cards_list)do
			if v.heroInfo.userId == userId then
				return v
			end
		end
		return nil
	end
	
	local function getAttackSkill(userId,skillId,effectList)
		local hero = getTargetHeroList(userId)
		if hero then
			local idx = 0
			for k,v in pairs(hero.heroInfo.activeSkillList) do
				if v.skillId == skillId then
					idx = k
				end
			end
			
			local heroBuffList = {}
			for k,v in pairs(effectList)do
				local heroIdList = Split(v.buff)
				for m,n in pairs(heroIdList) do
					local buffHero = getTargetHeroList(n)
					if buffHero then
						table.insert(heroBuffList,buffHero)
					end
				end
			end
			
			v:toSkillBattle(heroBuffList,skillId,idx,5)
		end
	end
	
	for k,v in pairs(attackList)do
		getAttackSkill(v.userId,v.skillId,v.effectList)
	end
end

--用户离开
function FightPlayer:toBossPushUserLeave(userId)
	local function delCallback(delHero)
		delHero:toReslut(GameField.fightFail)
	end
	for k,v in pairs(self.atk_hero_list)do
		if v.heroInfo.userId == userId then
			self:doDeleteHero(v.heroInfo.fightHeroId,delCallback)
			break
		end
	end
end

function FightPlayer:registerScriptTouch()
	local touch = {}
	
	local function weakCallBack(fightHero,k)
		self:doStartFight(fightHero)
	end
	
	--英雄暂停和恢复
	local function heroPause(fightHero,state,zorder,sx,mx,my)
		for k,v in pairs(self.atk_hero_list) do
			if v.heroInfo.posId ~= fightHero.heroInfo.posId then
				if state then
					v.hero:pause()
				else
					v.hero:resume()
				end
			end
		end
		
		for k,v in pairs(self.def_cards_list) do
			if state then
				v.hero:pause()
			else
				v.hero:resume()
			end
		end
		fightHero.heroBg:setScale(sx)
		fightHero.heroBg:setLocalZOrder(zorder)
		fightHero.heroBg:setPosition(cc.p(mx,my))
	end
	
	local function qteClickCallBack(fightHero,cdTime,isTouch)
		local activeSkillList = fightHero.heroInfo.activeSkillList
		for k,v in pairs(activeSkillList) do
			if v.skillPos == 1 and (isTouch or fightHero.isStartFight) then
				fightHero:toQTEBattle(v.skillId,cdTime)
				break
			end
		end
	end
	
	local function qteFinishCallBack(fightHero)
		if fightHero.heroInfo then --释放完QTE英雄已死亡
			fightHero:toPlaySlaySkill()
		end
	end
	
	local function heroQTEClick(fightHero)
		local layer = self.rootLayer:getParent()
		HeroQTE.autoQTE(layer,fightHero,qteFinishCallBack,qteClickCallBack)
	end
	
	--英雄播放必杀技的表现
	local function heroPlaySlay(fightHero)
		local sx = fightHero.heroBg:getScale()
		local mx,my = fightHero.heroBg:getPosition()
		local zorder = fightHero.heroBg:getLocalZOrder()		
		local grayLayer = LayerHelper.createTranslucentLayer()
		grayLayer:setScale(1.3)
		self.fightLogic.rootLayer:addChild(grayLayer,99)
		heroPause(fightHero,true,100,sx+0.2,mx,my)
		
		local arr = {}
		arr[1] = cc.DelayTime:create(1)
		arr[2] = cc.CallFunc:create(function()
			fightHero.weakOverState = GameField.weakOver3 --需要检查是否走路
			fightHero.isWaitQTE = true
			heroPause(fightHero,false,zorder,sx,mx,my)
			grayLayer:removeFromParent(true)
			heroQTEClick(fightHero)
		end)
		local sq = cc.Sequence:create(arr)
		grayLayer:runAction(sq)
		
		fightHero:toCanSlayState() --改变状态
		fightHero:doPlaySimpleEffect("t103",false) --闪光
	end
	
	local function isClickHero(sprite,skeleton,x,y)
		local sz1 = sprite:getContentSize()
		local sz2 = skeleton:getContentSize()
		
		local x1,y1 = sprite:getPosition()
		local x2,y2 = skeleton:getPosition()
		local pos_x = x1+x2-sz1.width/2
		local pos_y = y1+y2-0
		
		local mid_w = sz2.width/2*skeleton:getScaleX()
		local mid_h = sz2.height/2*skeleton:getScaleY()
		if math.abs(x-pos_x)<math.abs(mid_w) and 
		   math.abs(y-pos_y)<math.abs(mid_h) then
			return true
		end
		return false
	end

	local function FightUIPanel_Ontouch(e,x,y)
		x=self.rootLayer:convertToNodeSpace(cc.p(x,y)).x
		y=self.rootLayer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then	
			touch.x = x
			touch.y = y
		elseif e=="moved" then
			if math.abs(x-touch.x) > 10 and math.abs(y-touch.y) > 10 then
				touch = {x=0,y=0}
			end
		else
			if math.abs(x-touch.x) < 5 and math.abs(y-touch.y) < 5 then
				if self.isstart then --游戏开始
					for k,v in pairs(self.atk_hero_list)do		
						if isClickHero(v.heroBg,v.skeleton,x,y) then
							if v.isCanSlay and v.weakOverState == GameField.weakOver3 and
							   v.invincibleState == StaticField.invincible0 and
							   v.comaState == StaticField.comaState0 and
							   v.dizzinessState == StaticField.dizzinessState0 and
							  (v.heroInfo.systemHero.standId == StaticField.standId2 or 
							   v.heroInfo.systemHero.standId == StaticField.standId3) then
								heroPlaySlay(v)
							end
							break
						end
					end
				else --点击灵魂
					for k,v in pairs(self.atk_hero_list)do
						if v.heroInfo.heroState == StaticField.heroState2 then
							if isClickHero(v.heroBg,v.skeleton,x,y) then
								function FightUIPanel_ForcesAction_relive()
									v:revivalLife()
								end
								LayerManager.showDialog(GameString.reviveHero,function()
									local reliveReq = ForcesAction_reliveReq:New()
									reliveReq:setString_userHeroId(v.heroInfo.userHeroId)
									NetReqLua(reliveReq)
								end)
								break
							end
						end
					end
				end
			end
		end
		return true
	end
	self.rootLayer:setTouchEnabled(true)
	self.rootLayer:registerScriptTouchHandler(FightUIPanel_Ontouch,false,0,true)
end

function FightPlayer:weakTime(heroBg,moveSpeed,targetPT)
	local mx,my = heroBg:getPosition()
	local tx,ty = targetPT.x,targetPT.y
	tx = mx > tx and mx or tx
	local t = math.sqrt((mx-tx)*(mx-tx)+(my-ty)*(my-ty))/moveSpeed
	return t,tx,ty
end

function FightPlayer:Release()
	for k,v in pairs(self.atk_hero_list)do
		v:clearHero()
	end
	
	for k,v in pairs(self.def_cards_list)do
		v:clearHero()
	end
	
	for k,v in pairs(self.atk_hero_list)do
		v:removeNil()
	end
	
	for k,v in pairs(self.def_cards_list)do
		v:removeNil()
	end
	
	local scheduler	= Director.getScheduler()
	if self.frameHandler then
		scheduler:unscheduleScriptEntry(self.frameHandler)
		self.frameHandler = nil
	end
	
	if self.skillHandler then
		scheduler:unscheduleScriptEntry(self.skillHandler)
		self.skillHandler = nil
	end
	
	if self.replyHandler then
		scheduler:unscheduleScriptEntry(self.replyHandler)
		self.replyHandler = nil
	end
	
	if self.collisionHandler then
		scheduler:unscheduleScriptEntry(self.collisionHandler)
		self.collisionHandler = nil
	end
	
	if self.violentHandler then
		scheduler:unscheduleScriptEntry(self.violentHandler)
		self.violentHandler = nil
	end
end
