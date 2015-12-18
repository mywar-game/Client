-------------------------------------------------------------------------
--
-- 文 件 名 : ProfessionAdvancedUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-23
-- 功能描述 ：职业进阶系统
--
-------------------------------------------------------------------------

ProfessionAdvancedUIPanel = {}

function ProfessionAdvancedUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ProfessionAdvancedUIPanel:Create(para)
	local p_name = "ProfessionAdvancedUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

    local hero = para.hero
    cclog("26:>>>>>>>>>>>>>>>>>>>>>>>>")
    cclogtable(hero)

    local userEquips = DataManager.getUserHeroEquipList(hero.userHeroId)
    local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId, hero.level, userEquips)   --职业属性

    local heroPromote = DataManager.getSystemHeroPromoteInfo(hero.systemHeroId)   --职业进阶信息
    cclog("heroPromote:>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    cclogtable(heroPromote)

    local careerDesc = DataManager.getSystemHeroDescInfo(heroPromote)   --职业描述信息
    cclog("careerDesc:>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    cclogtable(careerDesc)

    local skeletonHero = nil
    local skeleton = nil
    local currentType = 1
    local userHeroBO = {}
    local userEquipIdList = {}
    local userGemstoneIdList = {}
    local toolList = {}

    --判断职业
    local function getProfession(careerId)
        local careerName = ""
        if careerId == 1 then
            careerName = "战士"
        elseif careerId == 2 then
            careerName = "法师"
        elseif careerId == 3 then
            careerName = "牧师"
        elseif careerId == 4 then
            careerName = "盗贼"
        elseif careerId == 5 then
            careerName = "猎人"
        elseif careerId == 6 then
            careerName = "德鲁伊"
        elseif careerId == 7 then
            careerName = "骑士"
        elseif careerId == 8 then
            careerName = "萨满"
        end
        return careerName
    end

    --刷新左上角
    local function refreshTopLeftView()
        self.panel:setLabelText("lab_left_name", hero.heroName)   --英雄名称
        self.panel:setBitmapText("lab_left_level", "LV." .. hero.level)   --英雄等级
        self.panel:setBitmapText("lab_left_profession", getProfession(hero.careerId))   --职业名称

        local bgImg = self.panel:getChildByName("img_left_bg")
        local size = bgImg:getContentSize()

        --显示英雄
        skeletonHero = SkeletonAction:New()
        skeleton = skeletonHero:Create(hero.resId)
        skeleton:setPosition(cc.p(size.width/2, size.height/4.5))
        skeleton:getAnimation():play(ACTION_HOLD)
        bgImg:addChild(skeleton)
    end
    refreshTopLeftView()

    --刷新左下角
    local function refreshBottomLeftView()
        self.panel:setLabelText("lab_left_title_1", "力量："..math.ceil(showAttr.strength))   --力量
        self.panel:setLabelText("lab_left_title_2", "敏捷："..math.ceil(showAttr.agile))   --敏捷
        self.panel:setLabelText("lab_left_title_3", "耐力："..math.ceil(showAttr.stamina))   --耐力
        self.panel:setLabelText("lab_left_title_4", "智慧："..math.ceil(showAttr.intelligence))   --智慧
    end
    refreshBottomLeftView()

    --刷新右下角
    local function refreshBottomRightView()
        --原来的属性
        self.panel:setLabelText("lab_right_title_1", "力量："..math.ceil(showAttr.strength))   --力量
        self.panel:setLabelText("lab_right_title_2", "敏捷："..math.ceil(showAttr.agile))   --敏捷
        self.panel:setLabelText("lab_right_title_3", "耐力："..math.ceil(showAttr.stamina))   --耐力
        self.panel:setLabelText("lab_right_title_4", "智慧："..math.ceil(showAttr.intelligence))   --智慧

        --加成后的属性
        -- self.panel:setLabelText("lab_right_value_1", showAttr.strength)   --力量
        -- self.panel:setLabelText("lab_right_value_2", showAttr.agile)   --敏捷
        -- self.panel:setLabelText("lab_right_value_3", showAttr.stamina)   --耐力
        -- self.panel:setLabelText("lab_right_value_4", showAttr.intelligence)   --智慧
    end
    refreshBottomRightView()

    --刷新进阶职业(右上角)
    local function refreshCareerPromote()
        self.panel:setLabelText("lab_right_name", hero.heroName)   --英雄名称careerDesc[currentType].heroName
        self.panel:setBitmapText("lab_right_level", "LV." .. hero.level)   --英雄等级careerDesc[currentType].level
        self.panel:setBitmapText("lab_right_profession", careerDesc[currentType].heroName)   --职业名称

        local bgImg = self.panel:getChildByName("img_right_bg")
        local skeletonSprite = bgImg:getChildByTag(100)
        if skeletonSprite then skeletonSprite:removeFromParent() end
        local size = bgImg:getContentSize()

        --显示英雄
        skeletonHero = SkeletonAction:New()
        skeleton = skeletonHero:Create(careerDesc[currentType].resId)
        skeleton:setPosition(cc.p(size.width/2, size.height/4.5))
        skeleton:getAnimation():play(ACTION_HOLD)
        bgImg:addChild(skeleton, 1, 100)
    end

    --列表
    local function OnItemShowCallback(scroll_view, item, data, idx)
        --按钮
        local btn = self.panel:getItemChildByName(item, "btn_badge")
        btn:setTag(idx)

        --职业描述
        self.panel:setItemLabelText(item,"lab_badge",data.heroDesc)

        --按钮点击回调
        local function btnCallback(sender, tag)
            currentType = sender:getTag()

            self.panel:setNodeVisible("img_list_bg", false)
            self.panel:setNodeVisible("img_right_bg", true)

            refreshCareerPromote()
        end
        self.panel:addItemNodeTouchEventListener(item, "btn_badge", btnCallback)
    end

    local function OnItemClickCallback(item, data, idx)
        
    end

    --刷新列表
    function refreshListView(data)
        self.panel:InitListView(data, OnItemShowCallback, OnItemClickCallback, "ListView", "ListItem", nil, nil, 1)
        self.panel:getChildByName("ListView"):jumpToTop()
    end
	refreshListView(careerDesc)

    --请求职业进阶
    local function careerPromoteReq()
        local reqcareerPromote = HeroAction_heroPromoteReq:New()
        reqcareerPromote:setString_userHeroId(hero.userHeroId)
        reqcareerPromote:setInt_proSystemHeroId(heroPromote[currentType].proSystemHeroId)

        NetReqLua(reqcareerPromote, true)
    end

    --请求职业进阶回调
    function ProfessionAdvancedUIPanel_HeroAction_heroPromote(msgObj)
        userHeroBO = msgObj.body.userHeroBO   --用户英雄对象
        userEquipIdList = msgObj.body.userEquipIdList   --消耗的用户装备id列表
        userGemstoneIdList = msgObj.body.userGemstoneIdList   --消耗的用户宝石id列表
        toolList = msgObj.body.toolList   --消耗的道具列表

        DataManager.setUserHeroId(userHeroBO.userHeroId, userHeroBO)
        Tips("职业进阶成功")
    end

    --触摸回调
    local function touchBegan(touch, event)  
        return true  
    end  
  
    local function touchMoved(touch, event)  
    end  
  
    local function touchEnded(touch, event)  
        local node = event:getCurrentTarget()

        local locationInNode = node:convertToNodeSpace(touch:getLocation())
        local rect = cc.rect(0, 0, node:getContentSize().width, node:getContentSize().height)
        if cc.rectContainsPoint(rect, locationInNode) then
            local listBg = self.panel:getChildByName("img_list_bg")
            local bVisible = listBg:isVisible()
            if not bVisible then
                self.panel:setNodeVisible("img_list_bg", true)
                self.panel:setNodeVisible("img_right_bg", false)

                refreshCareerPromote()
            end
        end  
    end  
  
    local function touchCancelled(touch, event)  
    end  
  
    local listener = cc.EventListenerTouchOneByOne:create()  
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)  
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
    listener:registerScriptHandler(touchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)

    local bgImg = self.panel:getChildByName("img_right_bg")
    self.panel.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, bgImg)  


    local function btnCallBack(sender, tag)
        if tag == 0 then   --关闭
            self:Release()
		elseif tag == 1 then

        elseif tag == 2 then
            local listBg = self.panel:getChildByName("img_list_bg")
            local bVisible = listBg:isVisible()
            if bVisible then
                Tips("请选择进阶职业")
            else
                careerPromoteReq()
            end
        end
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_select_badge",btnCallBack,1)
    self.panel:addNodeTouchEventListener("bgn_advanced",btnCallBack,2)

    return self.panel
end

--退出
function ProfessionAdvancedUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ProfessionAdvancedUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ProfessionAdvancedUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end