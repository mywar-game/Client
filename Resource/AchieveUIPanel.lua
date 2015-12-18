-------------------------------------------------------------------------
--
-- 文 件 名 : AchieveUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-19
-- 功能描述 ：成就系统
--
-------------------------------------------------------------------------

AchieveUIPanel = {}

function AchieveUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function AchieveUIPanel:Create(para)
	local p_name = "AchieveUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

    local achievement = DataManager.getSystemAchievement()
    local cacheTopStatus--最上层成就状态
    local userAchievementList = {}
    local currentType = 1
    local rewardTip = ""
    local personAchievement = {}
    local equipAchievement = {}
    local carbonAchievement = {}
    local lifeAchievement = {}

    local function getAchieveByType()
        for k,v in pairs(DeepCopy(achievement)) do
            if v.type == 1 then
                table.insert(personAchievement, v)
            elseif v.type == 2 then
                table.insert(equipAchievement, v)
            elseif v.type == 3 then
                table.insert(carbonAchievement, v)
            elseif v.type == 4 then
                table.insert(lifeAchievement, v)
            end
        end
    end
    getAchieveByType()

    local function OnItemShowCallback(scroll_view, item, data, idx)
        --cclogtable(data)
        --成就ID
        local achievementId = data.achievementId
        --成就名称
        local name = data.name
        --描述
        local desc = data.description
        --类型
        local achieveType = data.type
        --奖励
        local reward = data.rewards
        --需要完成次数
        local times = data.times
        --icon图标ID
        local iconId = data.imgId
        --状态
        local status = data.status
        --完成时间
        local completeTime = data.time
        --完成次数
        local finishTimes = data.finishTimes
        --颜色品质
        local color = data.color

        self.panel:setItemLabelText(item, "lab_name", name)
        self.panel:setItemLabelText(item, "lab_need", desc)
        local completeDate = Utils.remainTimeToDates(completeTime/1000)
        self.panel:setItemLabelText(item, "lab_status", finishTimes .. "/" .. times)

        local iconImgPath = ""
        local iconType = -1
        if achieveType == 1 then   --人物成就
            iconImgPath = IconPath.jineng .. iconId .. ".png"
            iconType = GameField.hero
        elseif achieveType == 2 then   --装备成就
            iconImgPath = IconPath.jineng .. iconId .. ".png"
            iconType = GameField.equip
        elseif achieveType == 3 then   --副本成就
            iconImgPath = IconPath.jineng .. iconId .. ".png"
            iconType = GameField.equip
        elseif achieveType == 4 then   --生活成就 
            iconImgPath = IconPath.jineng .. iconId .. ".png"
            iconType = GameField.equip
        end
        local imgAchieve = self.panel:getItemChildByName(item, "img_achieve")
        local iconSprite = createIconSprite(iconImgPath, color)
        iconSprite:setPosition(cc.p(imgAchieve:getContentSize().width/2, imgAchieve:getContentSize().height/2))
        imgAchieve:addChild(iconSprite)

        local imgReward = self.panel:getItemChildByName(item, "img_reward")
        local rewardTab = Split(reward,",")
        local toolSprite = createToolSprite(rewardTab)
        toolSprite:setPosition(cc.p(imgReward:getContentSize().width/2, imgReward:getContentSize().height/2))
        imgReward:addChild(toolSprite)

        if status == 0 then   --0未完成
            self.panel:setItemBtnEnabled(item, "btn_receive", false)
            --self.panel:setItemLabelText(item, "lab_date", completeDate)
            self.panel:setItemNodeVisible(item,"lab_date",false)
        elseif status == 1 then   --1已完成
            self.panel:setItemBtnEnabled(item, "btn_receive", true)
            self.panel:setItemNodeVisible(item,"lab_date",true)
            self.panel:setItemLabelText(item, "lab_date", completeDate)
        elseif status == 2 then   --2已领取
            self.panel:setItemBtnEnabled(item, "btn_receive", false)
            self.panel:setItemNodeVisible(item,"img_reward",false)
            self.panel:setItemNodeVisible(item,"lab_date",true)
            self.panel:setItemLabelText(item, "lab_date", completeDate)
            self.panel:setItemBitmapText(item,"lab_receive","已领取")
        end

        --成就领取
        local function btnReceiveCallback(sender, tag)
            rewardTip = data.description
            local achieveInRewardReq = AchievementAction_receiveAchievementRewardReq:New()
            achieveInRewardReq:setInt_achievementId(data.achievementId)
            NetReqLua(achieveInRewardReq, true)
        end
        self.panel:addItemNodeTouchEventListener(item, "btn_receive", btnReceiveCallback)
    end

    --成就领取回调
    function AchieveUIPanel_AchievementAction_receiveAchievementReward(msgObj)
        cclogtable(msgObj)
        Tips(rewardTip)
        requestAchieveInfo()
    end

    --更新成就信息
    local function updateAchievementList(updateList, currentAchievemt)
        local updateAchievementId = updateList.achievementId
        local updateStatus = updateList.status
        local updateTime = updateList.time
        local updateFinishTimes = updateList.finishTimes

        for k,v in pairs(currentAchievemt) do
            if updateAchievementId == v.achievementId then
                local dic = {}
                v.status = updateStatus
                v.time = updateTime
                v.finishTimes = updateFinishTimes
                -- dic = v
                -- table.remove(currentAchievemt, k)
                -- table.insert(currentAchievemt, dic)
                -- cclogtable(currentAchievemt)
                break
            end
        end
    end

    --成就系统信息变更推送
    function AchieveUIPanel_Achievement_update(msgObj)
        local achievementList = msgObj.body.updateUserAchievementList
        if currentType == 1 then
            updateAchievementList(achievementList, personAchievement)
            refreshAchievementListView(personAchievement)
        elseif currentType == 2 then
            updateAchievementList(achievementList, equipAchievement)
            refreshAchievementListView(equipAchievement)
        elseif currentType == 3 then
            updateAchievementList(achievementList, carbonAchievement)
            refreshAchievementListView(carbonAchievement)
        elseif currentType == 4 then
            updateAchievementList(achievementList, lifeAchievement)
            refreshAchievementListView(lifeAchievement)
        end
    end

    local function OnItemClickCallback(item, data, idx)
        
    end

    function refreshAchievementListView(data)
        cacheTopStatus = 0
        table.sort(data, function(a, b)
            return a.times < b.times
        end)
        -- table.sort(data, function(a, b)--状态越大越前
        --     --获取当前最大状态
        --     if a.status < cacheTopStatus then
        --         cacheTopStatus = a.status
        --     end

        --     if b.status < cacheTopStatus then
        --         cacheTopStatus = b.status
        --     end
        --     return a.status < b.status
        -- end)
        self.panel:InitListView(data, OnItemShowCallback, OnItemClickCallback, "ListView", "ListItem", nil, nil, 1)
        --self.panel:getChildByName("ListView"):jumpToTop()
    end

    --请求成就系统信息
    local function requestAchieveInfo()
        local reqAchieveInfo = AchievementAction_getUserAchievementInfoReq:New()
        NetReqLua(reqAchieveInfo, true)
    end
    requestAchieveInfo()

    --创建Icon
    function createIconSprite(iconPath, colorPath)
        local qualityColor = colorPath

        local iconSprite = CreateCCSprite(iconPath)
        local size = iconSprite:getContentSize()

        --颜色品质(暂定方格)
        if qualityColor then
            local colorSprite = CreateCCSprite(IconPath.pinzhiKuang..qualityColor..".png")
            colorSprite:setPosition(cc.p(size.width/2, size.height/2))
            iconSprite:addChild(colorSprite)
        end

        return iconSprite
    end

    --创建道具
    function createToolSprite(reward)
        local toolType = reward[1]
        local toolId = reward[2]
        local toolNum = reward[3]

        local toolPath = ""
        if tonumber(toolType) == 3 then
            toolPath = IconPath.daoju .. toolId ..".png"
        end
        local iconSprite = CreateCCSprite(toolPath)
        local size = iconSprite:getContentSize()

        local colorSprite = CreateCCSprite(IconPath.pinzhiKuang.."1"..".png")
        colorSprite:setPosition(cc.p(size.width/2, size.height/2))
        iconSprite:addChild(colorSprite)

        if toolNum then 
            local numLabel = CreateLabel("x"..toolNum)
            numLabel:setAnchorPoint(cc.p(1,0))
            numLabel:setPosition(cc.p(size.width,0))
            iconSprite:addChild(numLabel)
        end

        return iconSprite
    end

    --把状态等信息插入本地表中
    local function insertStatusIntoAchievement(tab)
        for k,v in pairs(userAchievementList) do
            local userAchievementId = v.achievementId
            local userStatus = v.status
            local userTime = v.time
            local userFinishTimes = v.finishTimes
            for k,v in pairs(tab) do
                local achievementId = v.achievementId
                if achievementId == userAchievementId then
                    v.status = userStatus
                    v.time = userTime
                    v.finishTimes = userFinishTimes
                end
            end
        end
    end

    --成就系统信息回调
    function AchieveUIPanel_AchievementAction_getUserAchievementInfo(msgObj)
        userAchievementList = msgObj.body.userAchievementList
        if currentType == 1 then
            insertStatusIntoAchievement(personAchievement)
            refreshAchievementListView(personAchievement)
        elseif currentType == 2 then
            insertStatusIntoAchievement(equipAchievement)
            refreshAchievementListView(equipAchievement)
        elseif currentType == 3 then
            insertStatusIntoAchievement(carbonAchievement)
            refreshAchievementListView(carbonAchievement)
        elseif currentType == 4 then
            insertStatusIntoAchievement(lifeAchievement)
            refreshAchievementListView(lifeAchievement)
        end
    end

    local function btnCallBack(sender,tag)
        if tag == 0 then   --关闭
            self:Release() 
        elseif tag == 1 then   --人物成就
            currentType = tag
            insertStatusIntoAchievement(personAchievement)
            refreshAchievementListView(personAchievement)
        elseif tag == 2 then   --装备成就
            currentType = tag
            insertStatusIntoAchievement(equipAchievement)
            refreshAchievementListView(equipAchievement)
        elseif tag == 3 then   --副本成就
            currentType = tag
            insertStatusIntoAchievement(carbonAchievement)
            refreshAchievementListView(carbonAchievement)
        elseif tag == 4 then   --生活成就
            currentType = tag
            insertStatusIntoAchievement(lifeAchievement)
            refreshAchievementListView(lifeAchievement)
        end
        --还原
        self.panel:setBtnEnabled("btn_1", true)
        self.panel:setBtnEnabled("btn_2", true)
        self.panel:setBtnEnabled("btn_3", true)
        self.panel:setBtnEnabled("btn_4", true)
        --选定
        self.panel:setBtnEnabled("btn_"..tag, false)
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_1",btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_2",btnCallBack,2)
    self.panel:addNodeTouchEventListener("btn_3",btnCallBack,3)
    self.panel:addNodeTouchEventListener("btn_4",btnCallBack,4)
    self.panel:setBtnEnabled("btn_"..currentType, false)

    return self.panel
end

--退出
function AchieveUIPanel:Release()
	self.panel:Release()
end

--隐藏
function AchieveUIPanel:Hide()
	self.panel:Hide()
end

--显示
function AchieveUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end