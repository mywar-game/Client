-------------------------------------------------------------------------
--
-- 文 件 名 : ProfessionUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-23
-- 功能描述 ：职业系统
--
-------------------------------------------------------------------------

ProfessionUIPanel = {}

function ProfessionUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ProfessionUIPanel:Create(para)
	local p_name = "ProfessionUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

    local userBo = DataManager.getUserBO()
    local teamLevel = userBo.level   --团队等级
    local userCamp = userBo.camp   --1联盟，2部落
    local allLeftBtn = {}
    local selectBtn
    local currentType = 1
    local curCareerClearInfoList = {}
    local curCareerId = 7008
    local curCareerLevel = 0

    local careerClearConfig = DataManager.getSystemCareerClearConfig()
    local leftBtnInfo = {}
    local function createLeftBtnInfo()
        if teamLevel >= careerClearConfig[1].level and teamLevel < careerClearConfig[4].level then   --解锁【战士】【牧师】【法师】
            leftBtnInfo = {
                {btnName = "战士", btnType = 1},
                {btnName = "牧师", btnType = 2},
                {btnName = "法师", btnType = 3},
            }
        elseif teamLevel >= careerClearConfig[4].level and teamLevel < careerClearConfig[5].level then   --解锁【战士】【牧师】【法师】【盗贼】
            leftBtnInfo = {
                {btnName = "战士", btnType = 1}, 
                {btnName = "牧师", btnType = 2}, 
                {btnName = "法师", btnType = 3}, 
                {btnName = "盗贼", btnType = 4},
            }
        elseif teamLevel >= careerClearConfig[5].level and teamLevel < careerClearConfig[6].level then   --解锁【战士】【牧师】【法师】【盗贼】【猎人】
            leftBtnInfo = {
                {btnName = "战士", btnType = 1}, 
                {btnName = "牧师", btnType = 2}, 
                {btnName = "法师", btnType = 3}, 
                {btnName = "盗贼", btnType = 4},
                {btnName = "猎人", btnType = 5},
            }
        elseif teamLevel >= careerClearConfig[6].level and teamLevel < careerClearConfig[7].level then   --解锁【战士】【牧师】【法师】【盗贼】【猎人】【德鲁伊】
            leftBtnInfo = {
                {btnName = "战士", btnType = 1}, 
                {btnName = "牧师", btnType = 2}, 
                {btnName = "法师", btnType = 3}, 
                {btnName = "盗贼", btnType = 4},
                {btnName = "猎人", btnType = 5},
                {btnName = "德鲁伊", btnType = 6},
            }
        elseif teamLevel >= careerClearConfig[7].level then
            if userCamp == 1 then   --联盟   解锁【战士】【牧师】【法师】【盗贼】【猎人】【德鲁伊】【骑士】
                leftBtnInfo = {
                    {btnName = "战士", btnType = 1}, 
                    {btnName = "牧师", btnType = 2}, 
                    {btnName = "法师", btnType = 3}, 
                    {btnName = "盗贼", btnType = 4},
                    {btnName = "猎人", btnType = 5},
                    {btnName = "德鲁伊", btnType = 6},
                    {btnName = "骑士", btnType = 7},
                }
            else   --部落   解锁【战士】【牧师】【法师】【盗贼】【猎人】【德鲁伊】【萨满】
                leftBtnInfo = {
                    {btnName = "战士", btnType = 1}, 
                    {btnName = "牧师", btnType = 2}, 
                    {btnName = "法师", btnType = 3}, 
                    {btnName = "盗贼", btnType = 4},
                    {btnName = "猎人", btnType = 5},
                    {btnName = "德鲁伊", btnType = 6},
                    {btnName = "萨满", btnType = 8},
                }
            end
        end
    end
    createLeftBtnInfo()
    
    --列表
    local function OnItemShowCallback(scroll_view, item, data, idx)
        local btnLeft = self.panel:getItemChildByName(item, "btn_left")
        btnLeft:setTag(data.btnType)
        table.insert(allLeftBtn, btnLeft)

        self.panel:setItemBitmapText(item, "lab_left", data.btnName)

        if idx == 1 then
            local selectSprite = CreateCCSprite("NewUi/xinqietu/paihangbang/i_zhiyebgg02.png")
            selectSprite:setPosition(cc.p(btnLeft:getContentSize().width/2, btnLeft:getContentSize().height/2))
            btnLeft:addChild(selectSprite)
            selectBtn = selectSprite

            --选定
            self.panel:setItemBtnEnabled(item, "btn_left",false)
        end

        --按钮点击回调
        local function btnCallback(sender, tag)
            currentType = sender:getTag()

            local selectSprite = CreateCCSprite("NewUi/xinqietu/paihangbang/i_zhiyebgg02.png")
            selectSprite:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
            sender:addChild(selectSprite)
            if selectBtn then selectBtn:removeFromParent() end
            selectBtn = selectSprite

            --还原
            for k,v in pairs(allLeftBtn) do
                local node = v
                node:setEnabled(true)
            end
            --选定
            self.panel:setItemBtnEnabled(item, "btn_left",false)

            refreshRightView()
        end
        self.panel:addItemNodeTouchEventListener(item, "btn_left", btnCallback)
    end

    local function OnItemClickCallback(item, data, idx)
        
    end

    --刷新列表
    function refreshListView(data)
        self.panel:InitListView(data, OnItemShowCallback, OnItemClickCallback, "ListView", "ListItem", nil, nil, 1)
        self.panel:getChildByName("ListView"):jumpToTop()
    end
    refreshListView(leftBtnInfo)

    --设置光晕
    local function setLight(imgName)
        --激活光晕
        local light = self.panel:getChildByName(imgName)
        light:setVisible(true)

        local blink = cc.Blink:create(3, 2)
        light:runAction(cc.RepeatForever:create(blink))
    end

    --团队等级达到，激活光晕
    local function activityLight()
        if teamLevel < 10 then

        elseif teamLevel >= 10 and teamLevel < 30 then
            for i=2,2 do
                setLight("img_light_" .. i)
            end
        elseif teamLevel >= 30 and teamLevel < 50 then
            for i=2,4 do
                setLight("img_light_" .. i)
            end
        elseif teamLevel >= 50 then
            for i=2,8 do
                setLight("img_light_" .. i)
            end
        end
    end

    --该职业是否已经解锁
    local function isCareerUnlock(curCareerId)
        if #curCareerClearInfoList == 0 then
            return false
        end

        local bUnlock = false
        for k,v in pairs(curCareerClearInfoList) do
            local careerId = v.detailedCareerId
            local level = v.level
            if curCareerId == careerId then
                if level == 10 then
                    bUnlock = true
                else
                    bUnlock = false
                end
            end
        end
        return bUnlock
    end

    --刷新徽章按钮、锁、光晕、icon和底图
    local function refreshCareerBtn()
        for i=2,8 do
            local btnTag = tonumber(currentType .. "000") + i
            --按钮
            self.panel:setNodeTag("btn_badge_" .. i,btnTag)

            if isCareerUnlock(btnTag) then
                --锁
                self.panel:setNodeVisible("img_lock_" .. i,false)

                --光晕
                local light = self.panel:getChildByName("img_light_" .. i,false)
                light:stopAllActions()
                light:setVisible(false)

                --icon
            else
                --锁
                self.panel:setNodeVisible("img_lock_" .. i,true)
            end
        end
        --self.panel:setImageTexture("img_bg_right","path" .. currentType)
    end

    --刷新
    function refreshRightView()
        activityLight()
        refreshCareerBtn()
    end

    --请求职业系统详细信息
    local function requestProfessionInfo()
        local reqProfessionInfo = HeroAction_getUserCareerClearInfoReq:New()
        NetReqLua(reqProfessionInfo, true)
    end
    requestProfessionInfo()

    --职业系统详细信息回调
    function ProfessionUIPanel_HeroAction_getUserCareerClearInfo(msgObj)
        curCareerClearInfoList = msgObj.body.userCareerInfoList
        refreshRightView()
    end

    --获得上一层职业的ID
    local function getUpperId(tag)
        if tag == 3 or tag == 4 then
            return tonumber(currentType .. "002")
        elseif tag == 5 or tag == 6 then
            return tonumber(currentType .. "003")
        elseif tag == 7 or tag == 8 then
            return tonumber(currentType .. "004")
        end
    end

    --是否达到团队等级
    local function isToTeamLevel(tag)
        if tag == 1 then
            return true
        elseif tag == 2 then
            if teamLevel >= 10 then
                return true
            else
                return false
            end
        elseif tag == 3 or tag == 4 then
            if teamLevel >= 30 then
                return true
            else
                return false
            end
        elseif tag == 5 or tag == 6 or tag == 7 or tag == 8 then
            if teamLevel >= 50  then
                return true
            else
                return false
            end
        end
    end

    --获得该职业的解锁层数
    local function getCareerLevelById(curCareerId)
        if #curCareerClearInfoList == 0 then
            return 0
        end

        local iLevel = 0
        for k,v in pairs(curCareerClearInfoList) do
            local careerId = v.detailedCareerId
            local level = v.level
            if curCareerId == careerId then
                iLevel = level
            end
        end
        return iLevel
    end

    local function btnCallBack(sender, tag)
        if tag == 0 then   --关闭
            self:Release()
        elseif tag == 1 then   --基础职业
            curCareerId = sender:getTag()
            curCareerLevel = 10
            if isToTeamLevel(tag) then
                Tips("此为基础等级，已经开放")
            end
        elseif tag == 2 then   --2阶
            curCareerId = sender:getTag()
            curCareerLevel = getCareerLevelById(curCareerId)
            if isToTeamLevel(tag) then
                self:Release()
                LayerManager.show("ProfessionDetailUIPanel", {careerId = curCareerId, careerLevel = curCareerLevel})
            else
                Tips("需要团队等级10级")
            end
        elseif tag == 3 or tag == 4 then   --3阶
            curCareerId = sender:getTag()
            curCareerLevel = getCareerLevelById(curCareerId)
            if isToTeamLevel(tag) then
                if isCareerUnlock(getUpperId(tag)) then
                    self:Release()
                    LayerManager.show("ProfessionDetailUIPanel", {careerId = curCareerId, careerLevel = curCareerLevel})
                else
                    Tips("上一层职业没有解锁")
                end
            else
                Tips("需要团队等级30级")
            end
        elseif tag == 5 or tag == 6 or tag == 7 or tag == 8 then   --4阶
            curCareerId = sender:getTag()
            curCareerLevel = getCareerLevelById(curCareerId)
            if isToTeamLevel(tag) then
                if isCareerUnlock(getUpperId(tag)) then
                    self:Release()
                    LayerManager.show("ProfessionDetailUIPanel", {careerId = curCareerId, careerLevel = curCareerLevel})
                else
                    Tips("上一层职业没有解锁")
                end
            else
                Tips("需要团队等级50级")
            end
        end
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_badge_1",btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_badge_2",btnCallBack,2)
    self.panel:addNodeTouchEventListener("btn_badge_3",btnCallBack,3)
    self.panel:addNodeTouchEventListener("btn_badge_4",btnCallBack,4)
    self.panel:addNodeTouchEventListener("btn_badge_5",btnCallBack,5)
    self.panel:addNodeTouchEventListener("btn_badge_6",btnCallBack,6)
    self.panel:addNodeTouchEventListener("btn_badge_7",btnCallBack,7)
    self.panel:addNodeTouchEventListener("btn_badge_8",btnCallBack,8)

    return self.panel
end

--退出
function ProfessionUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ProfessionUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ProfessionUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end