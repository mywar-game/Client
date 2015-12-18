--当铺
PawnShopUIPanel = {}
function PawnShopUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function PawnShopUIPanel:Create(para)
	local p_name = "PawnShopUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	local userInfo = DataManager.getUserBO()
    local cacheData = {}
    local cacheSelectIndex = nil--初始必须为空
    local cacheFloatWin--缓存弹出框
    local selectData--选中的物品
    local selectItem--选中的那一项
    local spendGold = 0

    local function OnItemShowCallback(scroll_view, item, data, idx)
        if data.select then
            self.panel:setItemNodeVisible(item, "img_select", true)
            selectData = data
            selectItem = item
            data.select = true
        else
            self.panel:setItemNodeVisible(item, "img_select", false)
        end
        local icon = IconUtil.GetIconByIdType(data.toolType,data.toolId,nil,{data=data})
        icon:setPosition(self.panel:getItemChildByName(item,"img_icon"):getPosition())
        item:addChild(icon, 1001)
        --
        local systemTools = DataManager.getSystemTool(data.toolId)
        data.name = systemTools.name--临时加入的(方便后续弹出窗)
        self.panel:setItemLabelText(item, "lab_name", systemTools.name)
        self.panel:setItemLabelText(item, "lab_price", data.price)
        self.panel:setItemLabelText(item, "lab_count", data.num)
        self.panel:setItemLabelText(item, "lab_float", data.floatValue/100)
    end
    local function OnItemClickCallback(item, data, idx)
        self.panel:setItemNodeVisible(selectItem, "img_select", false)
        selectData.select = false
        selectItem = item
        --交换状态
        selectData = data
        selectData.select = true
        self.panel:setItemNodeVisible(selectItem, "img_select", true)
    end
    local function switchTab(selectIndex)
        if selectIndex == nil then  selectIndex = 1 end
        --还原
        self.panel:setBtnEnabled("btn_1", true)
        self.panel:setBtnEnabled("btn_2", true)
        self.panel:setBtnEnabled("btn_3", true)
        --选定
        self.panel:setBtnEnabled("btn_"..selectIndex, false)
        --重新更新列表
        local listData = {}
        for _,v in pairs(cacheData) do
            if v.category == selectIndex then
                table.insert(listData, v)
                if selectData and selectData.mallId == v.mallId then
                    v.select = true
                    selectData = v
                end
            end
        end
        if #listData <= 0 then
            self.panel:setNodeVisible("lab_nothing", true)
            selectData = nil
        else
            self.panel:setNodeVisible("lab_nothing", false)
            if cacheSelectIndex ~= selectIndex then
                 if selectData then
                    selectData.select = false
                    selectData = nil
                 end
                 listData[1].select = true
            end
        end
        --初始化物品列表
        self.panel:InitListView(listData, OnItemShowCallback, OnItemClickCallback)
        if cacheSelectIndex ~= selectIndex then
            self.panel:getChildByName("ListView"):jumpToTop()
        end
        cacheSelectIndex = selectIndex
    end

    local function cacheBuyMoney(extraData)
        spendGold = extraData.price
    end
    
	local function btnCallBack(sender,tag)
		
        if tag == "btn_close" then
		    self:Release()
        elseif tag == "btn_1" then
            switchTab(1)
        elseif tag == "btn_2" then
            switchTab(2)
        elseif tag == "btn_3" then
            switchTab(3)
        elseif tag == "btn_buy" then
             if not selectData then
                Tips(LabelChineseStr.PawnShopUIPanel_3)
             elseif userInfo.gold < selectData.price then
                Tips(LabelChineseStr.PawnShopUIPanel_2)
             elseif selectData.num <= 0 then
                Tips(LabelChineseStr.PawnNumSelectUIPanel_9)
             else
                cacheFloatWin = LayerManager.show("PawnNumSelectUIPanel", {callBack = cacheBuyMoney, type = 1, data=selectData})
             end
        elseif tag == "btn_sell" then
            if not selectData then
                Tips(LabelChineseStr.PawnShopUIPanel_3)
            elseif DataManager.getUserToolNum(selectData.toolId) then
                cacheFloatWin = LayerManager.show("PawnNumSelectUIPanel", {type = 2, data=selectData})
            else
                Tips(LabelChineseStr.PawnShopUIPanel_1)
            end
        end
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_1",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_2",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_3",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_buy",btnCallBack)
    self.panel:addNodeTouchEventListener("btn_sell",btnCallBack)
    
    --请求获取当铺信息
    local function requestPawnShopInfo()
        local getInfoReq = PawnshopAction_getPawnshopInfoReq:New()
        getInfoReq:setInt_camp(userInfo.camp)
	    NetReqLua(getInfoReq, true)
    end
    requestPawnShopInfo()
    function PawnShopUIPanel_PawnshopAction_getPawnshopInfo(msgObj)
        --规整数据
        cacheData = msgObj.body.userPawnshopList
        DataManager.fillPawnShopInfo(cacheData)
        switchTab(cacheSelectIndex)
    end

    function PawnShopUIPanel_PawnshopAction_buyIn(msgObj)
        cacheFloatWin:Release()
        cacheFloatWin = nil
        requestPawnShopInfo()--刷新数据
        --刷新钱
        DataManager.replaceGold(userInfo.gold-spendGold)
        UserInfoUIPanel_refresh()
        --
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
    end

    function PawnShopUIPanel_PawnshopAction_sell(msgObj)
        cacheFloatWin:Release()
        cacheFloatWin = nil
        requestPawnShopInfo()--刷新数据
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
    end

    return self.panel
end

--退出
function PawnShopUIPanel:Release()
	self.panel:Release()
end

--隐藏
function PawnShopUIPanel:Hide()
	self.panel:Hide()
end

--显示
function PawnShopUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end