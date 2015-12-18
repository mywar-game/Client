--探索兑换英雄界面
ExploreExchangeUIPanel = {}
function ExploreExchangeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ExploreExchangeUIPanel:Create(para)
	local p_name = "ExploreExchangeUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    self.panel.para=para
	-- 业务逻辑编写处

    local skillArray = { }
    local skeleton = nil
    local skeletonAction = nil
    local selectHero = nil
	local selectSprite = nil
	local integral = para.retData.integral
    local userBO = DataManager.getUserBO()
    local function clearHeroInfo()--清空界面
		
		if selectSprite then
			selectSprite:setVisible(false)
		end
		
        if skeletonAction then
            skeletonAction:Release()
        end
		
		selectHero = nil
		skeleton = nil
        skeletonAction = nil

        for k,v in pairs(skillArray) do
            v:removeFromParent(true)
        end
        skillArray = {}
		
        --数值类界面元素清空
        self.panel:setBtnEnabled("btn_exchange",false)
		
		self.panel:setLabelText("lab_strength", "???")-- 力量
        self.panel:setLabelText("lab_agile", "???") -- 敏捷
        self.panel:setLabelText("lab_stamina", "???")  -- 耐力
        self.panel:setLabelText("lab_intelligence", "???")-- 智慧
        self.panel:setLabelText("lab_phyCrit", "???")-- 暴击
        self.panel:setLabelText("lab_dodge", "???")-- 闪避
        self.panel:setLabelText("lab_parry", "???")-- 格挡
		self.panel:setLabelText("lab_hp", "???")
		self.panel:setLabelText("lab_vip", "???")
        self.panel:setLabelText("lab_needScore", "???")
		 self.panel:setLabelText("lab_scoreNum", "???")
        self.panel:getChildByName("lab_vip"):setColor(cc.c3b(255, 255, 255))
        self.panel:getChildByName("lab_needScore"):setColor(cc.c3b(255, 255, 255))
    end
	
    local function showHeroInfo(item,hero)
        clearHeroInfo()
        selectHero = hero
		
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:setVisible(true)
		
        local shadowSprite = self.panel:getChildByName("shadow")
        local spriteSize = shadowSprite:getContentSize()
        skeletonAction = SkeletonAction:New()
        skeleton = skeletonAction:Create(hero.resId)
        skeleton:setPosition(cc.p(spriteSize.width / 2, spriteSize.height / 2))
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
		
		self.panel:setLabelText("lab_name", hero.heroName)
		self.panel:setLabelText("lab_level","Lv.1")
        self.panel:setLabelText("lab_hp",math.ceil(heroAttribute.hp))
	    self.panel:setLabelText("lab_career", GameString.careerId1ToStr[hero.careerId])
		
		self.panel:setLabelText("lab_scoreNum", integral)
        self.panel:setLabelText("lab_needLevel", hero.needLevel)
        self.panel:setLabelText("lab_needScore", hero.needIntegral)
        self.panel:setLabelText("lab_vip", hero.needVipLevel)
		self.panel:setNodeVisible("img_vip",hero.needVipLevel > 0)
		self.panel:setNodeVisible("img_vipBg",hero.needVipLevel > 0)
		
        -- 声望等级
        local txt = nil
        if integral < hero.needIntegral or hero.alreadyExist or
		   userBO.level < hero.needLevel or 
		   userBO.vipLevel < hero.needVipLevel then
            --什么材料不够就显示红色
            if integral < hero.needIntegral then 
				self.panel:getChildByName("lab_needScore"):setColor(cc.c3b(255, 0, 0)) 
			end
            
			if userBO.level < hero.needLevel then 
				self.panel:getChildByName("lab_needLevel"):setColor(cc.c3b(255, 0, 0)) 
			end
			
			if userBO.vipLevel < hero.needVipLevel then
				self.panel:getChildByName("lab_vip"):setColor(cc.c3b(255, 0, 0)) 
			end
			
			self.panel:setBtnEnabled("btn_exchange",false)
        else
            self.panel:setBtnEnabled("btn_exchange",true)
        end
		
        -- 技能
        for k = 1,4 do
			local systemSkillId = hero["skill0" .. k]
            if systemSkillId > 0 then
				local bgSprite = self.panel:getChildByName("img_skill_"..k)
				local size = bgSprite:getContentSize()
                local heroSkill = DataManager.getSystemHeroSkillId(systemSkillId,1)
                local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
                local skillSprite = CreateCCSprite(IconPath.jineng.. systemSkill.imgId .. ".png")
                skillSprite:setPosition(cc.p(size.width / 2, size.height / 2+2))
                bgSprite:addChild(skillSprite)
				
				IconUtil.addCommonTouchEvent(skillSprite,GameField.heroSkill,systemSkill)
				skillArray[k] = skillSprite
            end
        end
    end

    local function OnItemShowCallback(scroll_view, item, data, idx)
        if idx == 1 then-- 默认选中第一个
            showHeroInfo(item, data)
        end
		
        if integral < data.needIntegral or data.alreadyExist or
		   userBO.level < data.needLevel or 
		   userBO.vipLevel < data.needVipLevel then
        else
            self.panel:setItemNodeVisible(item, "img_allowExchange", true)
        end
		
		self.panel:setItemLabelText(item, "lab_heroName", data.heroName)
        self.panel:setItemBitmapText(item, "lab_heroCareer", GameString.careerId1ToStr[data.careerId])
        self.panel:setItemImageTexture(item, "img_headColor", IconPath.pinzhiYaun .. data.heroColor .. ".png")
        self.panel:setItemImageTexture(item, "img_heroHead", IconPath.yingxiong.. data.imgId .. ".png")
    end

    local function OnItemClickCallback(item, data, idx)
        showHeroInfo(item, data)
    end

    local function refreshListInfo()
		self.panel:setBtnEnabled("btn_exchange",false)
		
        local data = DataManager.getSystemExploreExchangeHero()
        self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback)
    end
    refreshListInfo()

	local function btnCallBack(sender,tag)
        if tag == 0 then
            LayerManager.show("ExploreUIPanel")
        elseif tag == 1 then
            local exchangeReq = ExploreAction_exchangeReq:New()
            exchangeReq:setInt_systemHeroId(selectHero.systemHeroId)
            NetReqLua(exchangeReq, true)
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

    function ExploreExchangeUIPanel_ExploreAction_exchange(msgObj)
        integral = msgObj.body.integral
        refreshListInfo()
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
    end

    return self.panel
end

--退出
function ExploreExchangeUIPanel:Release()
    self.panel:unscheduleScriptEntry(self.frameHandler)
	self.panel:Release()
end

--隐藏
function ExploreExchangeUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ExploreExchangeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end