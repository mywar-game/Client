require("PackageUIPanel")
--杂货铺
RepertoryStoreUIPanel = {}
function RepertoryStoreUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function RepertoryStoreUIPanel:Create(para)
	local p_name = "RepertoryStoreUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

	local config = DataManager.getSystemConfig()
	
	local curTab = 1
    local cacheData--缓存的道具
    local packagePanel = nil
  
	local selectData--选中的物品
    local selectItem--选中的那一项
	local cacheMoveSprite = nil
	
	local nowMaxNum = 0
    local packageSize = 30
	local allPackageSize = config.storehouse_max_num
	local cacheSelectMenu = 1
	local cacheSelectPackage = 1	
	
	--网络请求
	--扩展背包
    local function reqExtend(extendNum)
        local req = PackAction_extendStorehouseReq:New()
        req:setInt_extendNum(extendNum)
        NetReqLua(req, true)
    end

	--存入取出
    local function reqInOrOut(data)
        local req = PackAction_storehouseInOrOutReq:New()
		req:setInt_type(data.operateType)
        req:setInt_toolType(data.type)
		req:setInt_toolNum(data.toolNum or 1)
		if data.toolId then req:setInt_toolId(data.toolId) end
		if data.userEquipId then req:setString_userEquipId(data.userEquipId) end
		if data.userGemstoneId then req:setString_userGemstoneId(data.userGemstoneId) end
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

    local function packageTouchCallBack(para)
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
                if checkContain(para.operateType, para.touchPos) then
					data.operateType = para.operateType or GameField.StoreOperateTypeIn
					reqInOrOut(data)
				else
					para.sprite:setVisible(true) 
				end   
				cacheMoveSprite = nil 
            end
        elseif para.type == GameField.Event_DoubleClick then
            --快速存入仓库
			data.operateType = para.operateType or GameField.StoreOperateTypeIn
			reqInOrOut(data)
			para.sprite:setVisible(true)
        end
	end
	
	packagePanel = PackageUIPanel:New()
	local lineSprite = self.panel:getChildByName("img_line1")
	local package = packagePanel:Create({x=545,y=3,equipTouchCallBack=packageTouchCallBack,toolTouchCallBack=packageTouchCallBack,})
	lineSprite:addChild(package.layer)

	local function OnItemShowCallback(scroll_view,item,data,idx)
		local tool = data.tool
		if tool then
			local iconSprite
			local size = item:getContentSize()
			local function iconTouchEvent(type,touchPos)
				if tool.type == GameField.equip then--装备
					packageTouchCallBack({operateType = GameField.StoreOperateTypeOut, type=type,touchPos=touchPos,data=tool,sprite=iconSprite}) 
				else--道具
					packageTouchCallBack({operateType = GameField.StoreOperateTypeOut, type=type,touchPos=touchPos,data=tool,sprite=iconSprite})
				end
			end
			iconSprite = IconUtil.GetIconByIdType(tool.type,tool.toolId,tool.toolNum,{data=tool,touchCallBack=iconTouchEvent})
			iconSprite:setPosition(cc.p(size.width/2,size.height/2))
			item:addChild(iconSprite,1000)
		end
		
		local num = (cacheSelectPackage-1)*packageSize + idx
		if num <= nowMaxNum then
			self.panel:setItemNodeVisible(item,"img_clock",false)
		else
			if 1 ~= cacheSelectMenu then
				item:setVisible(false)
			end
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		--打开格子数量
		local num = (cacheSelectPackage-1)*packageSize + idx - nowMaxNum
		if data.tool == nil and num > 0 then
			--local temp = nowMaxNum - config.pack_init_num + num
			local temp = (nowMaxNum - 10) * num + (num * num + num) * 0.5			--等差求和(X+1,  X+2, .. X+num)  X 为 （nowMaxNum）
			local str1 = LabelChineseStr.PackageUIPanel_1
			local str2 = LabelChineseStr.PackageUIPanel_2
			local str3 = LabelChineseStr.common_zuanshi
			local str4 = str1..str2..(10*temp)..str3
			local function extendPackNet()
				reqExtend(num)
			end
			LayerManager.showDialog(str4,extendPackNet)
		end
	end
	
	--对道具做整理 超出限制的将分为多个格子显示
	local function showUserToolList()
		local showToolList = {}
		local userToolList = DataManager.getRepertoryStoreTool()
		for k,v in pairs(userToolList) do
			local nowToolNum = v.toolNum
			while true do
				local showTool = DeepCopy(v)
				if nowToolNum > v.overlapMax then
					showTool.toolNum = v.overlapMax
					nowToolNum = nowToolNum - v.overlapMax
					table.insert(showToolList, showTool)
				else
					showTool.toolNum = nowToolNum
					table.insert(showToolList, showTool)
					break
				end
			end
		end
		return showToolList
	end
	
	local function getRepertoryToolList()
		local tempTool = {}
		local function insertTools(toolList)
			for k, v in pairs(toolList) do
				table.insert(tempTool, v)
			end
		end
		
		if cacheSelectMenu ~= 3 then --不等于道具
			insertTools(DataManager.getRepertoryStoreEquip())
		end
		
		if cacheSelectMenu ~= 2 then --不等于武器
			insertTools(showUserToolList())
			insertTools(DataManager.getRepertoryStoreStone())
		end
		
		local sortTool = {}
		local sIdx = (cacheSelectPackage-1)*packageSize
		local eIdx = cacheSelectPackage*packageSize
		for k=sIdx+1,eIdx do
			table.insert(sortTool,{index=k,tool=tempTool[k]})
		end
		return sortTool,#tempTool
	end
	
	
	local function refreshEquipToolInfo()
		local userInfo = DataManager.getUserBO()
		local data,num = getRepertoryToolList()
		local selectSprite = self.panel:getChildByName("img_store_select")
		local packagetBtn = self.panel:getChildByName("btn_package_"..cacheSelectPackage)
		selectSprite:setPosition(packagetBtn:getPosition())
		for i = 1, 7 do
			self.panel:setBtnEnabled("btn_package_" .. i, true)
		end
		
		if cacheSelectMenu == 1 then
			nowMaxNum = config.storehouse_init_free_num + userInfo.storehouseExtendTimes	--当前可放置的物品个格子
		else
			nowMaxNum = num												--如果不是“总览” 当前可放置的物品格子数 就是物品的格子数
			local maxPackge = math.ceil(nowMaxNum / 20.0)
			for i = maxPackge, 7 do
				local k = i + 1
				self.panel:setBtnEnabled("btn_package_" .. k, false)
			end
			if 0 == maxPackge then
				self.panel:setBtnEnabled("btn_package_1" , true)
			end
		end
		self.panel:setBtnEnabled("btn_weapen1",cacheSelectMenu ~= 1)
		self.panel:setBtnEnabled("btn_weapen2",cacheSelectMenu ~= 2)
		self.panel:setBtnEnabled("btn_weapen3",cacheSelectMenu ~= 3)
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback,"ListView","ListItem", 6)
	end
	refreshEquipToolInfo()

	local function btnCallBack(sender,tag)
        if tag == 0 then
		    self:Release() 
		elseif tag <= 7 then
			cacheSelectPackage = tag
			refreshEquipToolInfo()
		elseif tag <= 10 then
			cacheSelectMenu = tag - 7
			cacheSelectPackage = 1
			refreshEquipToolInfo()
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_package_1",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_package_2",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_package_3",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_package_4",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_package_5",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_package_6",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_package_7",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_weapen1",btnCallBack,8)
	self.panel:addNodeTouchEventListener("btn_weapen2",btnCallBack,9)
	self.panel:addNodeTouchEventListener("btn_weapen3",btnCallBack,10)


	--网络响应
    function RepertoryStoreUIPanel_PackAction_storehouseInOrOut(msgObj)
        if GameField.StoreOperateTypeIn == msgObj.body.type then
			Tips(LabelChineseStr.RepertoryStoreUIPanelTips_1)
		elseif GameField.StoreOperateTypeOut == msgObj.body.type then
			Tips(LabelChineseStr.RepertoryStoreUIPanelTips_2)
		end
		refreshEquipToolInfo()
		packagePanel:reFreshPackage()
    end

    function RepertoryStoreUIPanel_PackAction_extendStorehouse(msgObj)
        Tips(LabelChineseStr.RepertoryStoreUIPanelTips_3)
		UserInfoUIPanel_refresh()
        refreshEquipToolInfo()
		packagePanel:reFreshPackage()
    end

    return self.panel
end

--退出
function RepertoryStoreUIPanel:Release()
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function RepertoryStoreUIPanel:Hide()
	self.panel:Hide()
end

--显示
function RepertoryStoreUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end