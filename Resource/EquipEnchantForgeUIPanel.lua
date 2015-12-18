require("PackageUIPanel")
EquipEnchantForgeUIPanel = {
panel = nil,
}

function EquipEnchantForgeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function EquipEnchantForgeUIPanel:Create(para)
    local p_name = "EquipEnchantForgeUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local showItemForgeIsEnable = true
	local currentForgeInForce = nil
	local currentForge = nil
	local currentForgeProduct = nil
	local otherBgSprite = self.panel:getChildByName("bg_qita")
	--otherBgSprite:setVisible(false)
	local costBase = DataManager.getSystemConfig().equip_forge_cost
	local sliderTime = DataManager.getSystemConfig().equip_stone_operation_cd_time or 10
	local materilsToProduct = DataManager.getSystemToolAllOreMaterialByType(GameField.HerbsForge)
	local packagePanel
	
	local reqData = {}
	local myMaterial
	local netData = nil

	
	local function initToolInfo()
		self.panel:setLabelText("lab_wpname1", "")
		self.panel:setLabelText("lab_wpnum1", "")
		self.panel:setLabelText("lab_wpname2", "")
		self.panel:setLabelText("lab_wpnum2", "")
		self.panel:setLabelText("lab_dzfy", "")
	end
	initToolInfo()
	
	local function forgeWeapenCallback(type, touchPos)
		if type == GameField.Event_Click then
			currentForgeInForce:removeFromParent()
			currentForgeInForce = nil
			if nil ~= currentForge then
				currentForge:setVisible(true)
				currentForge = nil
			end			
			if nil ~= currentForgeProduct then
				currentForgeProduct:removeFromParent()
			end
			initToolInfo()
			reqData = {}
		end
	end

	local function updateCost(args)
		local tool = args.data
		local num = args.num
		local cost = (tool.level * 5 + tool.color * 5 ) * costBase * num
		self.panel:setLabelText("lab_dzfy", tostring(cost))
	end
	
	--获取矿石和容值锭的比， 1个矿石能够转换成多少个容值锭
	local function getChangeNum(data)
		myMaterial = materilsToProduct[data.toolId].material
		return materilsToProduct[data.toolId].num
	end
	
	--显示矿石熔炼后的产品
	local function showProduct(productId)
		reqData.productId = productId
		local data = DataManager.getSystemTool(productId)
		local qhSprite = IconUtil.GetIconByIdType(data.type, data.toolId)
		local size = self.panel:getChildByName("img_sxwpbg2"):getContentSize()
		qhSprite:setPosition(cc.p(size.width/2, size.height/2))
		currentForgeProduct = qhSprite
		self.panel:getChildByName("img_sxwpbg2"):addChild(qhSprite)
		self.panel:setLabelText("lab_wpname2", data.name)
	end
	
	local function showItemForge(item, data)
		if nil ~= currentForge then
			currentForge:setVisible(true)
			currentForge = item
		end
		if nil == materilsToProduct[data.toolId] then
			return
		end
		showProduct(materilsToProduct[data.toolId].toolId)
		reqData.material =  materilsToProduct[data.toolId].material
		self.panel:setLabelText("lab_wpname1", data.name)
		local qhSprite = IconUtil.GetIconByIdType(data.type , data.toolId, nil, {data=data,touchCallBack=forgeWeapenCallback})
		local weapen = self.panel:getChildByName("Image_tool")
		local x, y  = weapen:getPosition()
		qhSprite:setPosition(cc.p(x, y))
		self.panel:getChildByName("img_sxwpbg1"):addChild(qhSprite, 1)
		
		if nil ~= currentForgeInForce then
			currentForgeInForce:removeFromParent()
		end
		currentForgeInForce = qhSprite		
	end
	
	local function doCallback(args)
		showItemForge(args.item, args.data)
		local num = args.num or 1
		self.panel:setLabelText("lab_wpnum1", args.num)
		self.panel:setLabelText("lab_wpnum2", args.num * args.baseNum)
		reqData.num = num
		updateCost(args)
	end
	
	local function checkContain(isFromMall, touchPos)--检查是否进入回收
        local areaSprite = self.panel:getChildByName("img_sxwpbg1")
        local location = areaSprite:convertToNodeSpace(touchPos)
        local s = areaSprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end
	
	local function touchResponse(sprite, data)
		local num = DataManager.getUserToolNum(data.toolId) or 0
		local baseNum = materilsToProduct[data.toolId].num
		reqData = data
		if num < 1 then
			Tips("upLimit < lowLimit")
		else
			LayerManager.show("InputCountUIPanel", {callBack = doCallback, arguments = {item = sprite, data = data, baseNum = baseNum}, upLimit = num, lowLimit = 1}, true)
		end
	end
	
	local function equipTouchCallBack(para)
		if nil == materilsToProduct[para.data.toolId]  then
			return
		end
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
                if checkContain(mallData, para.touchPos) and showItemForgeIsEnable then
					touchResponse(para.sprite, data)
					para.sprite:setVisible(true) 
				else
					para.sprite:setVisible(true) 
				end   
				cacheMoveSprite = nil 
            end
        elseif para.type == GameField.Event_DoubleClick and showItemForgeIsEnable then
			--快速锻造
			touchResponse(para.sprite, data)
		end
	end
	
		--对道具做整理 超出限制的将分为多个格子显示
	local function showUserToolList()
		local showToolList = {}
		local userToolList = DataManager.getUserToolList()

		for k,v in pairs(userToolList) do
			if nil ~= materilsToProduct[v.toolId] then
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
		end
		return showToolList
	end
	
	local function getPageckeToolList(cacheSelectPackage, packageSize)
		local tempTool = {}
		local function insertTools(toolList)
			for k=1,#toolList do
				table.insert(tempTool,toolList[k])
			end
		end
		
		insertTools(showUserToolList())
		
		local sortTool = {}
		local sIdx = (cacheSelectPackage-1)*packageSize
		local eIdx = cacheSelectPackage*packageSize
		for k=sIdx+1,eIdx do
			table.insert(sortTool,{index=k,tool=tempTool[k]})
		end
		
		return sortTool,#tempTool
	end
	
	packagePanel = PackageUIPanel:New()
	local lineSprite = self.panel:getChildByName("img_line1")
	local package = packagePanel:Create({x=545,y=3,equipTouchCallBack = nil, toolTouchCallBack = equipTouchCallBack, getPageckeToolList = getPageckeToolList, disEnable = true})
	lineSprite:addChild(package.layer)
	
	local function reqSmelt(para)
		local toolType = 1
		local toolId = para.productId
		local num = para.num
		local userEquipId = para.userEquipId
		local status = para.status
		local material = para.material
        local req = EquipAction_equipForgeReq:New()
		req:setInt_toolType(toolType)
        req:setInt_toolId(toolId)
		req:setInt_status(status)
		req:setInt_num(num)
		req:setInt_forgeType(GameField.HerbsForge)
		if userEquipId then req:setString_userEquipId(userEquipId) end
		if material then req:setString_material(material) end
        NetReqLua(req, true)
    end
	
	local function sendNetReq()
		local para = netData
		if nil ~= para then
			para.Callback(para.arugments)
		end
	end
	
	-- para   { item, Callback, arugments}  arugments is table, which is Callback's arugment
	local function showThinkingSlider(para)
		local cancel_btn = self.panel:getChildByName("btn_qxlook")
		cancel_btn:setVisible(true)
		local posx, posy = cancel_btn:getPosition()
		local item = para.item
		local loadingbg  = cc.Sprite:create(IconPath.xuanqu .. "i_jiazdi.png")
		loadingbg:setPosition(cc.p(posx, posy + 100))
		item:addChild(loadingbg, 99)

		local load_img = cc.Sprite:create(IconPath.xuanqu .. "i_jiazaitiao.png")
		local loading = cc.ProgressTimer:create(load_img)--loading条
		loading:setType(1)
		loading:setMidpoint({ x = 0, y = 1 })
		loading:setBarChangeRate({ x = 1, y = 0 })
		loading:setPosition(cc.p(posx, posy + 100))
		loading:setPercentage(0)
		item:addChild(loading, 100)
		
		local labelTTFPercent = cc.LabelTTF:create(LabelChineseStr.ForgeLookUISliderName_1, "Arial",20, {width = 0, height = 0})
		labelTTFPercent:setPosition(cc.p(posx, posy + 100))
		item:addChild(labelTTFPercent, 120)
		
		local function updateSlider()
			local percent = loading:getPercentage()
			if 100 == percent then
				showItemForgeIsEnable = true
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)
				netData.arugments.status = 3
				sendNetReq()
			else
				loading:setPercentage(percent + 1)
			end		
		end
		
		local function btnCallBack(sender,tag)
			if 0 == tag then
				netData.arugments.status = 2
				sendNetReq()
				showItemForgeIsEnable = true
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)
			end
		end
		self.doCallback = btnCallBack
		self.panel:addNodeTouchEventListener("btn_qxlook", btnCallBack, 0)
		local times = sliderTime / 100.0
		self.scheduler = Director.getScheduler():scheduleScriptFunc(updateSlider, times, false)
	end
	
	
		-- 网络消息
	function EquipEnchantForgeUIPanel_EquipAction_equipForge(msgObj)
		if 1 ==  netData.arugments.status then
			showThinkingSlider(netData)
			return		
		elseif 2 == netData.arugments.status then
			return
		else
			LayerManager.show("DialogRewardsUIPanel", msgObj.body.drop, true)--展示获得东西
			Tips(LabelChineseStr.ForgeLookUITip_1)
			for k, v in pairs(msgObj.body.userEquipIdList) do
				DataManager.removeUserEquip(v)
			end
			for k, v in pairs(msgObj.body.goodsList) do
				DataManager.reduceUserTool(v.goodsId, v.goodsNum)
			end
			packagePanel:reFreshPackage()
		end
	end

	
	local function btnCallBack(sender,tag)
		if tag == 0 then
		    self:Release()
		elseif tag == 1 then
			if nil ~= reqData then
				showItemForgeIsEnable = false
				local item = self.panel:getChildByName("buttom_bg")
				netData = {item = item, Callback = reqSmelt, arugments = {productId = reqData.productId, material = reqData.material, toolType = reqData.type, toolId = reqData.toolId, num = reqData.num, userEquipId = reqData.userEquipId, status = 1}}
				sendNetReq()
			end
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack, 0)
	self.panel:addNodeTouchEventListener("btn_look",btnCallBack, 1)
    return panel
end

--退出
function EquipEnchantForgeUIPanel:Release()
	if nil ~= self.scheduler then
		self.doCallback(nil, 0)
	end
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function EquipEnchantForgeUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EquipEnchantForgeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
