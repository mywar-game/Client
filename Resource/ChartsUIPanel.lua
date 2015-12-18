-------------------------------------------------------------------------
--
-- 文 件 名 : ChartsUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-22
-- 功能描述 ：排行榜系统
--
-------------------------------------------------------------------------

ChartsUIPanel = {}

function ChartsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ChartsUIPanel:Create(para)
	local p_name = "ChartsUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

    local cacheTopStatus--最上层成就状态
    local leftBtnInfo = {{name = "团队等级", type = 1}, {name = "战斗力", type = 2}, {name = "土豪榜", type = 3}}
    local allBtn = {}
    local selectBtn
    local allChartsList = {}
    local userChartsList = {}
    local currentType = 1

    --请求排行榜系统信息
    local function requestChartsInfo()
        local reqChartsInfo = RankAction_getUserRankInfoReq:New()
        reqChartsInfo:setInt_type(currentType)
        NetReqLua(reqChartsInfo, true)
    end
    requestChartsInfo()

    --左边列表
    local function OnItemLeftShowCallback(scroll_view, item, data, idx)
        local btnName = data.name
        local btnType = data.type
        local btn = self.panel:getItemChildByName(item, "btn_left")
        btn:setTag(btnType)
        table.insert(allBtn, btn)
        self.panel:setItemBitmapText(item, "lab_left", btnName)

        if idx == 1 then
            local selectSprite = CreateCCSprite("NewUi/xinqietu/paihangbang/i_zhiyebgg02.png")
            selectSprite:setPosition(cc.p(btn:getContentSize().width/2, btn:getContentSize().height/2))
            btn:addChild(selectSprite)
            selectBtn = selectSprite

            --选定
            self.panel:setItemBtnEnabled(item, "btn_left",false)
        end

        --左边按钮点击回调
        local function btnCallback(sender, tag)
            currentType = sender:getTag()
            requestChartsInfo()

            local selectSprite = CreateCCSprite("NewUi/xinqietu/paihangbang/i_zhiyebgg02.png")
            selectSprite:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
            sender:addChild(selectSprite)
            selectBtn:removeFromParent()
            selectBtn = selectSprite

            if currentType == 1 then
                self.panel:setBitmapText("lab_top_rank", "团队等级")
            elseif currentType == 2 then
                self.panel:setBitmapText("lab_top_rank", "总战斗力")
            elseif currentType == 3 then
                self.panel:setBitmapText("lab_top_rank", "持有金币")
            end

            --还原
            for k,v in pairs(allBtn) do
                local node = v
                node:setEnabled(true)
            end
            --选定
            self.panel:setItemBtnEnabled(item, "btn_left",false)
        end
        self.panel:addItemNodeTouchEventListener(item, "btn_left", btnCallback)
    end

    local function OnItemLeftClickCallback(item, data, idx)
        
    end

    --右边列表
    local function OnItemRightShowCallback(scroll_view, item, data, idx)
        cclog("96:>>>>>>>>>>>>>>>>>>>>>>>")
        cclogtable(data)
        --用户ID
        local userId = data.userId
        --排名
        local rank = data.rank
        --用户名
        local userName = data.userName
        --队长头像
        local systemHeroId = data.systemHeroId
		-- 队长INFo
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
        --排行榜的值
        local value = data.value
        --军团名称
        local leginName = data.leginName

		self.panel:setItemNodeVisible(item, "lab_ranking", false)
        self.panel:setItemNodeVisible(item, "img_ranking", true)
        if rank == 1 then
            self.panel:setItemImageTexture(item, "img_ranking", IconPath.huangguan .. "i_st01.png")
            self.panel:setItemImageTexture(item, "img_title", createTitle(rank))
        elseif rank == 2 then
            self.panel:setItemImageTexture(item, "img_ranking", IconPath.huangguan .. "i_st02.png")
            self.panel:setItemImageTexture(item, "img_title", createTitle(rank))
        elseif rank == 3 then
            self.panel:setItemImageTexture(item, "img_ranking", IconPath.huangguan .. "i_st03.png")
            self.panel:setItemImageTexture(item, "img_title", createTitle(rank))
        else
            self.panel:setItemNodeVisible(item, "lab_ranking", true)
            self.panel:setItemNodeVisible(item, "img_ranking", false)
            self.panel:setItemNodeVisible(item, "img_title", false)
            self.panel:setItemBitmapText(item, "lab_ranking", rank)
        end

        self.panel:setItemLabelText(item, "lab_name", userName)
        self.panel:setItemBitmapText(item, "lab_level", "LV."..value)
        self.panel:setItemLabelText(item, "lab_sociaty", leginName ~= "" and leginName or "无")
		
		self.panel:setItemImageTexture(item, "img_heroHead", IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemImageTexture(item, "img_headColor", IconPath.pinzhiYaun..systemHero.heroColor..".png")
    end

    local function OnItemRightClickCallback(item, data, idx)
        
    end

    --排行榜系统信息回调
    function ChartsUIPanel_RankAction_getUserRankInfo(msgObj)
        allChartsList = msgObj.body.rankList
        userChartsList = msgObj.body.selfRankBO
        refreshRightListView(allChartsList)
        refreshUserCharts(userChartsList)
    end

    --刷新左列表
    function refreshLeftListView(data)
        cacheTopStatus = 0
        self.panel:InitListView(data, OnItemLeftShowCallback, OnItemLeftClickCallback, "ListView_left", "ListItem_left", nil, nil, 1)
        self.panel:getChildByName("ListView_left"):jumpToTop()
    end
    refreshLeftListView(leftBtnInfo)

    --刷新右列表
    function refreshRightListView(data)
        cacheTopStatus = 0
        table.sort(data, function(a, b)
            return a.rank < b.rank
        end)
        self.panel:InitListView(data, OnItemRightShowCallback, OnItemRightClickCallback, "ListView_right", "ListItem_right", nil, nil, 1)
        self.panel:getChildByName("ListView_right"):jumpToTop()
    end

    --刷新用户自己的排行榜信息
    function refreshUserCharts(data)
        --用户ID
        local userId = data.userId
        --排名
        local rank = data.rank
        --用户名
        local userName = data.userName
        --队长头像
        local systemHeroId = data.systemHeroId
		--队长INFo
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
        --排行榜的值
        local value = data.value
        --军团名称
        local leginName = data.leginName

		self.panel:setNodeVisible("lab_user_ranking", false)
		self.panel:setNodeVisible("img_my_rank", true)
        if rank == 1 then
            self.panel:setImageTexture("img_user_title", createTitle(rank))
			self.panel:setImageTexture("img_my_rank", IconPath.huangguan .. "i_st01.png")
        elseif rank == 2 then
            self.panel:setImageTexture("img_user_title", createTitle(rank))
			self.panel:setImageTexture("img_my_rank", IconPath.huangguan .. "i_st02.png")
        elseif rank == 3 then
            self.panel:setImageTexture("img_user_title", createTitle(rank))
			self.panel:setImageTexture("img_my_rank", IconPath.huangguan .. "i_st03.png")
        else			
			self.panel:setNodeVisible("lab_user_ranking", true)
			self.panel:setNodeVisible("img_my_rank", false)
            self.panel:setNodeVisible("img_user_title", false)
        end	

        self.panel:setBitmapText("lab_user_ranking", rank)
        self.panel:setLabelText("lab_user_name", userName)
        self.panel:setBitmapText("lab_user_level", value)
        self.panel:setLabelText("lab_user_sociaty", leginName ~= "" and leginName or "无")

		self.panel:setImageTexture("img_heroHead", IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setImageTexture("img_headColor", IconPath.pinzhiYaun..systemHero.heroColor..".png")
    end

    --创建英雄头像
    function createHeroSprite(heroId)
        local iconSprite = CreateCCSprite(IconPath.yingxiong .. heroId .. ".png")
        return iconSprite
    end

    --创建称号
    function createTitle(rank)
        local path = ""
        if currentType == 1 then
            if rank == 1 then
                path = "NewUi/xinqietu/paihangbang/t_zuiqzhandui.png"
            elseif rank == 2 then
                path = "NewUi/xinqietu/paihangbang/t_chongjidaren.png"
            elseif rank == 3 then
                path = "NewUi/xinqietu/paihangbang/t_xiwangzhixing.png"
            end
        elseif currentType == 2 then
            if rank == 1 then
                path = "NewUi/xinqietu/paihangbang/t_zuiqzhandli.png"
            elseif rank == 2 then
                path = "NewUi/xinqietu/paihangbang/t_zuiqiangyongs.png"
            elseif rank == 3 then
                path = "NewUi/xinqietu/paihangbang/t_zhandgren.png"
            end
        elseif currentType == 3 then
            if rank == 1 then
                path = "NewUi/xinqietu/paihangbang/t_datuhao.png"
            elseif rank == 2 then
                path = "NewUi/xinqietu/paihangbang/t_fujiayifang.png"
            elseif rank == 3 then
                path = "NewUi/xinqietu/paihangbang/t_youqianrx.png"
            end
        end
        return path
    end

    local function btnCallBack(sender,tag)
        if tag == 0 then   --关闭
            self:Release() 
        end
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)

    return self.panel
end

--退出
function ChartsUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ChartsUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ChartsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end