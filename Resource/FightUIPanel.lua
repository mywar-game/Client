--战斗
require("HateAI")
require("SkillAI")
require("FightAI")
require("FightLogic")
require("SkillEffect")
require("SkeletonSkill")

FightUIPanel = {
panel = nil,
}

local scheduler	= Director.getScheduler()
function FightUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function FightUIPanel:Create(para)
    local p_name = "FightUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local curCrystalNum = 0
	local getCrystalTotal = 0 --获取水晶的总量
	local useCrystalTotal = 0 --使用水晶的总量,主要的主要是防止外挂改水晶。
	local battleReslut = nil
	local fightLogic = FightLogic:New()
	self.fightLogic = fightLogic
	self.actHeroList = {}
	self.defHeroList = {}
	
	local function formatNum(num)
        if num > 9999999 then
            num = math.floor(num/1000000)..'M'
        elseif num > 99999 then 
            num = math.floor(num/1000)..'K'
        end
        return num
    end
	
	local userBO = DataManager.getUserBO()
	self.panel:setLabelText("lab_moneyNum",formatNum(userBO.gold))

	--初始化
	local rootLayer = cc.Layer:create()
	rootLayer:setPosition(cc.p(0,0))
	self.panel.layer:addChild(rootLayer)
	
	local startBg = self.panel:getChildByName("btn_start")
	local size = startBg:getContentSize()
	local skeleton = CreateEffectSkeleton("t14")	
	skeleton:setPosition(cc.p(size.width/2,size.height/2))
	skeleton:setScale(0.8)
	startBg:setVisible(false)
	startBg:addChild(skeleton)
	
	local userInfo = DataManager.getUserBO()
	local systemConfig = DataManager.getSystemConfig()
	if userInfo.level < tonumber(systemConfig.team_skill_open_level) then --团长技能
		self.panel:setNodeVisible("img_headBg",false)
	end
	
	if para.fightResult.fightType == GameField.fightType2 then --野外
		self.panel:setNodeVisible("img_violent",false)
	elseif para.fightResult.fightType == GameField.fightType3 or 
	       para.fightResult.fightType == GameField.fightType4 then --pvp没有团长技能
		self.panel:setNodeVisible("img_headSkill",false)
	end

	fightLogic:setOnInitFightCallBack(function(curRounds,battleType,background,heroImgId)
		if heroImgId then
			self.panel:setImageTexture("img_heroHead","res/hero_icon/"..heroImgId..".png")
		end
		
		if battleType == GameField.battleType2 then
			self.panel:setNodeVisible("img_bossInfo",true)
		else
			self.panel:setNodeVisible("img_bossInfo",false)
		end
		rootLayer:removeChildByTag(10)
		local size = self.panel.layer:getContentSize()
		
		local bg = CreateCCSprite("res/map/"..background..".png")
		bg:setPosition(size.width/2,size.height/2)
		bg:setTag(10)
		rootLayer:addChild(bg,-1)
	end)
	
	fightLogic:setOnFrontFightCallBack(function(actHeroList,defHeroList)
		self.actHeroList = actHeroList
		self.defHeroList = defHeroList
		self.panel:setNodeVisible("btn_start",true)
	end)
	
	--回复水晶
	fightLogic:setOnReplyCrystalCallBack(function()
		if curCrystalNum < 10 then
			curCrystalNum = curCrystalNum + 1
			getCrystalTotal = getCrystalTotal + 1
			self.panel:setImageTexture("img_crystal"..curCrystalNum,IconPath.zhandou.."liangseshuijing.png")
			self.panel:setLabelText("lab_crystalNum",curCrystalNum.."/10")
		end
	end)
	
	--狂暴时间
	fightLogic:setOnViolentCallBack(function(num)
		self.panel:setLabelText("lab_downTime",num)
	end)
	
	--暂停
	fightLogic:setOnPauseCallBack(function(state)
		self.panel:setNodeVisible("btn_pause",state)
	end)
	
	--消耗水晶
	fightLogic:setOnConsumeCrystalCallback(function(crystalNum,needCareerList) 
		if crystalNum > 0 then
			for k=curCrystalNum,curCrystalNum-crystalNum+1,-1 do
				self.panel:setImageTexture("img_crystal"..k,IconPath.zhandou.."huiseshuijing.png")
			end
			curCrystalNum = curCrystalNum-crystalNum
			useCrystalTotal = useCrystalTotal + crystalNum
			self.panel:setLabelText("lab_crystalNum",curCrystalNum.."/10")
		else
			local str = GameString.playSkill1
			local len = #needCareerList
			for k,v in pairs(needCareerList)do
				if k == len then
					str = str ..GameString["careerId"..v]
				else
					str = str ..GameString["careerId"..v]..GameString.huozhe
				end
			end
			Tips(str)
		end
	end)
	
	--更新仇恨
	fightLogic:setOnUpdateHateCallback(function(hateList) 
		
	end)
	
	--更新boss血量
	fightLogic:setOnUpdateBossBloodCallback(function(curBlood,maxBlood)
		self.panel:setProgressBarPercent("ProgressBar_bloom",curBlood/maxBlood*100)
	end)
	
	--更新英雄血量
	fightLogic:setOnUpdateHeroBloodCallback(function(curBlood,maxBlood) 
		
	end)
	
	fightLogic:setOnCanPlaySkillCallBack(function(index)
		if index == 1 then
			
		elseif index == 2 then
		
		elseif index == 3 then
		
		end
	end)
	
	fightLogic:setOnShowSkillCallBack(function(headSkill)
		for k,v in pairs(headSkill)do 
			if k==1 then
				
			elseif k==2 then
			
			elseif k==3 then
			
			end
		end
	end)
	
	--战斗结束
	fightLogic:setOnFightOverCallback(function(battleType,reslut)
		battleReslut = reslut
		self.panel:setProgressBarPercent("ProgressBar_bloom",0)
		
		local fightStatus = GameField.FightState1
        if reslut == GameField.fightSuccess then 
			fightStatus = GameField.FightState3 
		end
		
		if para.fightResult.fightType == GameField.fightType1 or 
		   para.fightResult.fightType == GameField.fightType2 then
			if not para.fightResult.isFromCollect then--非采集请求接口
				local endAttackReq = ForcesAction_endAttackReq:New()
				endAttackReq:setInt_flag(fightStatus)
				NetReqLua(endAttackReq,false)
			else --采集请求接口
				local req  = ForcesAction_getCollectFightRewardReq:New()
				req:setInt_mapId(para.fightResult.forces.mapId)
				req:setInt_flag(fightStatus)
				req:setInt_forcesId(para.fightResult.forces.forcesId)
				NetReqLua(req,false)
			end
		elseif para.fightResult.fightType == GameField.fightType3 then
			local endPkFightReq = PkAction_endPkFightReq:New()
			endPkFightReq:setInt_flag(fightStatus)
			NetReqLua(endPkFightReq,false)
		end
	end)
	fightLogic:intiConfigFight(rootLayer,para.fightResult)
	
	--暂停
	local function pasueCallBack()
		fightLogic.fightPlayer.isstart =  false
		
        for k,v in pairs(self.actHeroList) do
			local x,y = v.skeleton:getPosition()
			local skeleton = CreateEffectSkeleton("t19008")
			skeleton:setPosition(cc.p(x,70))
			v.heroBg:addChild(skeleton,2)
			v:toFleeAction()
			v:clearWeakTime()
			v.heroBg:stopAllActions()
        end
		
        for k,v in pairs(self.defHeroList) do
			v:toHold()
			v:clearWeakTime()
			v.heroBg:stopAllActions()
        end
		fightLogic.onFightOverCallback(GameField.battleType1,GameField.fightFail)
	end
	
	--团长技能
	local headSkill = DataManager.getFightHeadSkillList()
	local function btnCallBack(sender,tag)
		if tag == 0 then
			LayerManager.show("FightPasueUIPanel",{callBack=pasueCallBack})
		elseif tag == 1 then
			fightLogic:doUserClickStartFight()
			self.panel:setNodeVisible("btn_start",false)
		else
			local skill = headSkill[tag]
			if skill and skill.needCrystal <= curCrystalNum then
				if useCrystalTotal + curCrystalNum <= getCrystalTotal then	
					fightLogic:doPlayHeadSkill(tag)
				else
					Tips(GameString.IllegalSoftware)
				end
			else
				Tips(GameString.skillCrystal)
			end
		end
	end
	
	for k,v in pairs(headSkill) do
		local btn = "btn_skill_"..v.pos
		local systemSkill = DataManager.getSystemSkillId(v.skillId)
		local imgId = "res/team_skill/"..systemSkill.imgId..".png"
		self.panel:setNodeVisible(btn,true)
		self.panel:getChildByName(btn):loadTextureNormal(imgId,ccui.TextureResType.localType)
		self.panel:addNodeTouchEventListener(btn,btnCallBack,v.pos)
		self.panel:setLabelText("lab_crystal_"..v.pos,v.needCrystal)
	end
	self.panel:addNodeTouchEventListener("btn_pause",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_start",btnCallBack,1)
	
    local function collectRewardAndFinishWar(msgObj)
        local arr = {}
		arr[1] = cc.DelayTime:create(2)
		arr[2] = cc.CallFunc:create(function()
			local dropPara = {battleReslut=battleReslut,fightResult=para.fightResult,body=msgObj.body}
			if battleReslut == GameField.fightSuccess then
				SoundEffect.playSoundEffect("win")
				LayerManager.show("FightResultUIPanel",dropPara)
			else
				SoundEffect.playSoundEffect("fail")
				LayerManager.show("FightResultUIPanel",dropPara)
			end
		end)
		local sq = cc.Sequence:create(arr)
		self.panel.layer:runAction(sq)
    end

    function FightUIPanel_HeroLevelUp(hero)
        --英雄升级
        for k,v in pairs(self.actHeroList) do
            if v.heroInfo.systemHero.systemHeroId == hero.systemHeroId then
                local x,y = v.skeleton:getPosition()
		        local skeletonSkill = SkeletonSkill:New()
		        local skeleton1 = skeletonSkill:Create("t11",0)
		        skeleton1:setPosition(cc.p(x+6,-102))
		        skeletonSkill:setCommonPlay(false)
		        v.heroBg:addChild(skeleton1,2)
            end
        end
    end

    function FightUIPanel_ForcesAction_getCollectFightReward(msgObj)
        collectRewardAndFinishWar(msgObj)
    end

	function FightUIPanel_ForcesAction_endAttack(msgObj)
		collectRewardAndFinishWar(msgObj)
	end
	
	function FightUIPanel_PkAction_endPkFight(msgObj)
		collectRewardAndFinishWar(msgObj)
	end
	
	--世界Boss进入
	function FightUIPanel_Boss_enter(msgObj)
		local heroList = {}
		local userHero = msgObj.body.userHeroBO
		userHero.posX = math.random(960)
		userHero.posY = math.random(460)
		userHero.equips = {}
		for m,n in pairs(msgObj.body.equipList) do
			table.insert(userHero.equips,DataTranslater.tranEquip(n))
		end
		table.insert(heroList,userHero)
		fightLogic.fightPlayer:toBossPushUser(heroList)
	end
	
	--推送攻击信息
	function FightUIPanel_Boss_pushUserAttackInfo(msgObj)
		fightLogic.fightPlayer:toBossPushUserAttackInfo(msgObj.body.attackList)
	end
	
	--推送用户退出boss战
	function FightUIPanel_Boss_pushUserLeave(msgObj)
		fightLogic.fightPlayer:toBossPushUserLeave(msgObj.body.userId)
	end
	SoundEffect.playBgMusic("fight")
	
	return panel
end

--退出
function FightUIPanel:Release()
	if self.frameHandler then
		Director.getScheduler():unscheduleScriptEntry(self.frameHandler)
		self.frameHandler = nil
	end
	self.fightLogic.fightPlayer:Release()
	self.panel:Release()
end

--隐藏
function FightUIPanel:Hide()
	self.panel:Hide()
end

--显示
function FightUIPanel:Show()
	self.panel:Show()
end

