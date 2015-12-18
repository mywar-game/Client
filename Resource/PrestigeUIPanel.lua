--探索兑换英雄界面
PrestigeUIPanel = {}
function PrestigeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function PrestigeUIPanel:Create(para)
	local p_name = "PrestigeUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    self.panel.para=para
	-- 业务逻辑编写处
	
	local iniviteHeroId = 0
    local skillArray = {}
    local skeleton = nil
    local skeletonAction = nil
    local systemHero = nil
	local selectItem = nil
	local selectSprite = nil
	local inviteHeroList = {}
    local userBO = DataManager.getUserBO()
	
    local function showHeroInfo(item,hero)
		if systemHero and systemHero.systemHeroId == hero.systemHeroId then
			return
		end
	
		if selectSprite then
			selectSprite:setVisible(false)
		end
		
		if skeletonAction then
            skeletonAction:Release()
        end
		skeleton = nil
		skeletonAction = nil
		
		systemHero = hero
		selectItem = item
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:setVisible(true)
		
        local shadowSprite = self.panel:getChildByName("shadow")
        local spriteSize = shadowSprite:getContentSize()
        skeletonAction = SkeletonAction:New()
        skeleton = skeletonAction:Create(hero.resId)
        skeleton:setPosition(cc.p(spriteSize.width/2, spriteSize.height/2))
        skeleton:setScale(0.8)
        skeleton:getAnimation():play(ACTION_HOLD)
        shadowSprite:addChild(skeleton)

        local heroAttribute = DataManager.getSystemHeroAttributeId(hero.systemHeroId,1)
        self.panel:setLabelText("lab_strength", heroAttribute.strength)-- 力量
        self.panel:setLabelText("lab_agile", heroAttribute.agile) -- 敏捷
        self.panel:setLabelText("lab_stamina", heroAttribute.stamina)  -- 耐力
        self.panel:setLabelText("lab_intelligence", heroAttribute.intelligence)-- 智慧
        self.panel:setLabelText("lab_phyCrit", heroAttribute.phyCrit)-- 暴击
        self.panel:setLabelText("lab_dodge", heroAttribute.dodge)-- 闪避
        self.panel:setLabelText("lab_parry", heroAttribute.parry)-- 格挡
        
		self.panel:setLabelText("lab_level","Lv.1")
        self.panel:setLabelText("lab_hp",math.ceil(heroAttribute.hp))
		self.panel:setBitmapText("lab_needGold", hero.needGold)
		self.panel:setBitmapText("lab_needLevel", hero.level)
	    self.panel:setLabelText("lab_career", GameString.careerId1ToStr[hero.careerId])
		
		for k,v in pairs(inviteHeroList)do
			if v.systemHeroId == hero.systemHeroId then
				self.panel:setLabelText("lab_name", v.heroName)
				break
			end
		end
		
        -- 声望等级
        if userBO.level < hero.level or userBO.gold < hero.needGold then
			if userBO.gold < hero.needGold then 
				self.panel:getChildByName("lab_needGold"):setColor(cc.c3b(255, 0, 0)) 
			end
			
			if userBO.level < hero.level then
				self.panel:getChildByName("lab_needLevel"):setColor(cc.c3b(255, 0, 0)) 
			end
			self.panel:setBtnEnabled("btn_exchange",false)
        else
			if iniviteHeroId == hero.systemHeroId then
				self.panel:setBtnEnabled("btn_exchange",false)
			else
				self.panel:setBtnEnabled("btn_exchange",true)
			end
        end
		
        -- 技能
        for k = 1,4 do
			local systemSkillId = hero["skill0"..k]
            if systemSkillId > 0 then
				local bgSprite = self.panel:getChildByName("img_skill_"..k)
				local size = bgSprite:getContentSize()
                local heroSkill = DataManager.getSystemHeroSkillId(systemSkillId,1)
                local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
                local skillSprite = CreateCCSprite(IconPath.jineng.. systemSkill.imgId .. ".png")
                skillSprite:setPosition(cc.p(size.width / 2, size.height / 2+2))
                bgSprite:addChild(skillSprite)
				
				systemSkill.systemHeroId = systemHero.systemHeroId --传递英雄ID
				IconUtil.addCommonTouchEvent(skillSprite,GameField.heroSkill,systemSkill)
				skillArray[k] = skillSprite
            end
        end
    end

    local function OnItemShowCallback(scroll_view, item, data, idx)
        if idx == 1 then-- 默认选中第一个
            showHeroInfo(item, data)
        end
		
        if userBO.gold >= data.needGold and userBO.level >= data.level then
			self.panel:setItemNodeVisible(item, "img_allowExchange", true)
        end
		
		for k,v in pairs(inviteHeroList)do
			if v.systemHeroId == data.systemHeroId then
				self.panel:setItemLabelText(item, "lab_heroName", v.heroName)
				break
			end
		end
        self.panel:setItemBitmapText(item, "lab_heroCareer", GameString.careerId1ToStr[data.careerId])
        self.panel:setItemImageTexture(item, "img_headColor", IconPath.pinzhiYaun .. data.heroColor .. ".png")
        self.panel:setItemImageTexture(item, "img_heroHead", IconPath.yingxiong.. data.imgId .. ".png")
    end

    local function OnItemClickCallback(item, data, idx)
        showHeroInfo(item,data)
    end

    local function refreshListInfo()		
        local data = DataManager.getSystemIniviteHero()
        self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback)
    end
    
	function PrestigeUIPanel_PrestigeAction_inviteHero(msgObj)
		userBO = DataManager.getUserBO()
		self.panel:setBtnEnabled("btn_exchange",false)
		self.panel:setItemImageTexture(selectItem,"img_allowExchange",IconPath.zhaomu.."yiyaoqing.png")
        if userBO.gold < systemHero.needGold then
			self.panel:getChildByName("lab_needGold"):setColor(cc.c3b(255, 0, 0)) 
        end
    end
	
	local function btnCallBack(sender,tag)
        if tag == 0 then
			UserGuideUIPanel.stepClick( "btn_back" ) --添加新手引导的回调
            self:Release()
        elseif tag == 1 then
			if systemHero then
				local heroName = ""
				for k,v in pairs(inviteHeroList)do
					if v.systemHeroId == systemHero.systemHeroId then
						heroName = v.heroName
						break
					end
				end
				iniviteHeroId = systemHero.systemHeroId
				local inviteHeroReq = PrestigeAction_inviteHeroReq:New()
				inviteHeroReq:setInt_systemHeroId(systemHero.systemHeroId)
				inviteHeroReq:setString_heroName(heroName)
				NetReqLua(inviteHeroReq, true)
				UserGuideUIPanel.stepClick( "btn_exchange" ) --添加新手引导的回调。
			end
        end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_exchange",btnCallBack,1)

    --英雄预览动作
    local playIndex = 1
    local function playAttack()
        playIndex = playIndex + 1
        if playIndex >= 4 then
            playIndex = 1
        end
		
        if skeleton then
            if playIndex == 1 then
                skeleton:getAnimation():play(ACTION_HOLD)
            elseif playIndex == 2 then
                skeleton:getAnimation():play(ACTION_RUN)
            elseif playIndex == 3 then
                skeleton:getAnimation():play(ACTION_ATTACK0)
            end
        end
    end
    self.frameHandler = self.panel:scheduleScriptFunc(playAttack, 3, false)
	
	function PrestigeUIPanel_PrestigeAction_getInviteHeroInfo(msgObj)
		inviteHeroList = msgObj.body.inviteHeroList
		refreshListInfo()
	end
	
	local getInviteHeroInfoReq = PrestigeAction_getInviteHeroInfoReq:New()
	NetReqLua(getInviteHeroInfoReq, true)
	
    return self.panel
end

--退出
function PrestigeUIPanel:Release()
    self.panel:unscheduleScriptEntry(self.frameHandler)
	self.panel:Release()
end

--隐藏
function PrestigeUIPanel:Hide()
	self.panel:Hide()
end

--显示
function PrestigeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end