require("PackageUIPanel")
--杂货铺
GroceryUIPanel = {}
function GroceryUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function GroceryUIPanel:Create(para)
	local p_name = "GroceryUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

	local curTab = 1
    local cacheData--缓存的道具
    local packagePanel = nil
  
	local selectData--选中的物品
    local selectItem--选中的那一项
	local cacheMoveSprite = nil
	
    local function formatNum(num)
        if num > 9999999 then
            num = math.floor(num/1000000)..'M'
        elseif num > 99999 then 
            num = math.floor(num/1000)..'K'
        end
        return num
    end
	
	local userBo = DataManager.getUserBO()		
	self.panel:setLabelText("lab_dialogNum",formatNum(userBo.money))
	self.panel:setLabelText("lab_goldNum",formatNum(userBo.gold))

    local function reqBuyIn(mallId)
        local req = MallAction_buyInReq:New()
        req:setInt_mallId(mallId)
        NetReqLua(req, true)
    end

    local function reqSell(toolType, toolId, toolNum, userEquipId)
        local req = MallAction_sellReq:New()
        if userEquipId then req:setString_userEquipId(userEquipId) end
        req:setInt_toolType(toolType)
        req:setInt_toolId(toolId)
        req:setInt_toolNum(toolNum or 1)
        NetReqLua(req, true)
    end

    local function reqGetBuyBackList()
        if curTab == 2 then
            local req = MallAction_getBuyBackListReq:New()
            NetReqLua(req, true)
        end
    end
    
    local function reqBuyBack(buyBackId)
        local req = MallAction_buyBackReq:New()
        req:setString_buyBackId(buyBackId)
        NetReqLua(req, true)
    end

    local function checkContain(isFromMall,touchPos)--检查是否进入商店
        local areaSprite
        if isFromMall then
            areaSprite = packagePanel.panel:getChildByName("ListView")
        else
            areaSprite = self.panel:getChildByName("ListView")
        end
        local location = areaSprite:convertToNodeSpace(touchPos)
        local s = areaSprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end

    local function touchCallBack(para)
        cacheData = para.data
        local data = para.data
        local mallData = para.data.mallData
		if para.type == GameField.Event_Back then
		    self:Release()
        elseif para.type == GameField.Event_Move then--处理拖动
            if not cacheMoveSprite then
                cacheMoveSprite = IconUtil.GetIconByIdType(data.type , data.toolId, data.toolNum)
                self.panel.layer:addChild(cacheMoveSprite,0xffff)
            end
            cacheMoveSprite:setPosition(self.panel.layer:convertToNodeSpace(para.touchPos))
            if not mallData then para.sprite:setVisible(false) end
        elseif para.type == GameField.Event_End then--处理按下起立
            if cacheMoveSprite then
                cacheMoveSprite:removeFromParent()
                if checkContain(mallData, para.touchPos) then
                    --拖动购买,回购
                    if not mallData then --出售
                        reqSell(data.type , data.toolId, data.toolNum, data.userEquipId)
                    else
                        if curTab == 1 then--购买
                            reqBuyIn(mallData.mallId)
                        else--回购
                            reqBuyBack(mallData.buyBackId)
                        end
                    end
                end
                para.sprite:setVisible(true)
                cacheMoveSprite = nil
            end
        elseif para.type == GameField.Event_DoubleClick then
            --快速购买,快速出售,快速回购
            if curTab == 1 then--快速购买
                if mallData then
                    reqBuyIn(mallData.mallId)
                else--出售
                    reqSell(data.type , data.toolId, data.toolNum, data.userEquipId)
                end
            else--回购
                 if mallData then 
                    reqBuyBack(mallData.buyBackId)
                 else
                    reqSell(data.type , data.toolId, data.toolNum, data.userEquipId)
                 end
            end
        end
	end
	
	packagePanel = PackageUIPanel:New()
	local lineSprite = self.panel:getChildByName("img_line1")
	local package = packagePanel:Create({x=545,y=3,equipTouchCallBack=touchCallBack,toolTouchCallBack=touchCallBack,})
	lineSprite:addChild(package.layer)

    local function OnItemShowCallback(scroll_view, item, data, idx)
	
        local headBkg = self.panel:getItemChildByName(item,"img_headBkg")
	    local size = headBkg:getContentSize()
        local iconSprite
        local showData = data
        if data.toolType == GameField.equip then
            showData.equipId = showData.toolId
            showData = DataTranslater.tranEquip(showData)
        else
            showData = DataManager.getSystemTool(data.toolId)
        end
        showData.mallData = data
        self.panel:setItemLabelText(item, "lab_name", showData.name)
        if curTab == 1 then
            self.panel:setItemLabelText(item, "lab_num", showData.price*data.toolNum)
        else
            self.panel:setItemLabelText(item, "lab_num", Utils.round(showData.price*data.toolNum/4))
        end
        local function iconTouchEvent(type, touchPos)
            touchCallBack({type=type, sprite=iconSprite, data=showData, touchPos=touchPos})
        end
        iconSprite = IconUtil.GetIconByIdType(data.toolType , data.toolId, data.toolNum, {touchCallBack=iconTouchEvent})
        iconSprite:setPosition(cc.p(size.width/2,size.height/2))
		headBkg:addChild(iconSprite)
    end

    local function OnItemClickCallback(item, data, idx)
		if nil ~= selectItem then
			self.panel:setItemNodeVisible(selectItem, "img_select", false)
		end
        --selectData.select = false
        selectItem = item
        --交换状态
        --selectData = data
        --selectData.select = true
        self.panel:setItemNodeVisible(selectItem, "img_select", true)
	end
        
    local function InitUI()
        self.panel:setBtnEnabled("btn_1", false)
        self.panel:setBtnEnabled("btn_2", false)
        if curTab == 1 then
            self.panel:setBtnEnabled("btn_2", true)
            local data = DataManager.getStaticEquipToolMall()
            self.panel:InitListView(data, OnItemShowCallback, OnItemClickCallback, nil, nil, 2)
        else
            self.panel:setBtnEnabled("btn_1", true)
            reqGetBuyBackList()
        end
    end
    InitUI()

	local function btnCallBack(sender,tag)
		
        if tag == 0 then
		    self:Release() 
        elseif tag == 1 then
            curTab = 1
            InitUI()
        elseif tag == 2 then
            curTab = 2
            InitUI()
        end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_1",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_2",btnCallBack,2)

    function GroceryUIPanel_MallAction_buyIn(msgObj)
        Tips(LabelChineseStr.GroceryUIPanel_1..(cacheData.price*cacheData.mallData.toolNum))
        DataManager.addGold(-cacheData.price*cacheData.mallData.toolNum)
        packagePanel:reFreshPackage()
    end

	
    function GroceryUIPanel_MallAction_sell(msgObj)
	  --  cclog("186 卖出的内容在此：");
		if   msgObj  ~= nil then
		     if  msgObj.body.drop.goodsList ~= nil then  --在这里只掉落金币。所以我只要goodsNum就可以了
				 local total_gn =  0 
				 for _,v in pairs(msgObj.body.drop.goodsList) do 
                     if  v.goodsNum and (v.goodsNum > 0) then--过滤掉道具负数(仅道具)
                         total_gn = total_gn +v.goodsNum
                    end
                 end
				 Tips	(LabelChineseStr.GroceryUIPanel_2 .. total_gn)  --提示得到的金币
			 end
        end
    ---    LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
        --删除装备如果有的话
        if cacheData.type == GameField.equip then
            DataManager.removeUserEquip(cacheData.userEquipId)
        end
        --
        packagePanel:reFreshPackage()
        reqGetBuyBackList()--刷新回购
    end

    function GroceryUIPanel_MallAction_getBuyBackList(msgObj)
        self.panel:InitListView(msgObj.body.userBuyBackInfoList, OnItemShowCallback, OnItemClickCallback, nil, nil, 2)
    end

    function GroceryUIPanel_MallAction_buyBack(msgObj)
        Tips(LabelChineseStr.GroceryUIPanel_1..Utils.round(cacheData.price*cacheData.mallData.toolNum/4))
        DataManager.addGold(-Utils.round(cacheData.price*cacheData.mallData.toolNum/4))
        packagePanel:reFreshPackage()
        reqGetBuyBackList()--刷新回购
    end

    return self.panel
end

--退出
function GroceryUIPanel:Release()
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function GroceryUIPanel:Hide()
	self.panel:Hide()
end

--显示
function GroceryUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end