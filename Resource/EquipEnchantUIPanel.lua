require("PackageUIPanel")
EquipEnchantUIPanel = {
panel = nil,
}

function EquipEnchantUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function EquipEnchantUIPanel:Create(para)
    local p_name = "EquipEnchantUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local isPopEquip = false
	local userHeroId = nil
	local userEquipId = nil
	local selectWeapenItem = {}
	local selectBookItem = {}
	local isEnchantIng = false
	
	--控制当前界面中 物品列表是否可以点击
	local showItemForgeIsEnable = true
	selectWeapenItem.item = nil
	selectWeapenItem.data = nil
	selectBookItem.item = nil
	selectBookItem.data = nil
	self.netData = {}
	
	local curEnchantWeapenData = nil
	local costBase = DataManager.getSystemConfig().equip_forge_cost
	local sliderTime = DataManager.getSystemConfig().equip_stone_operation_cd_time or 10
	self.panel:setLabelText("lab_dzfy", "0")
	
	local cutEnchantWP  = nil
	local enchantCost = 0
	local function updateCost(weapenData, bookData)
		if nil == weapenData or nil == bookData then
			self.panel:setLabelText("lab_dzfy", "0")
			return
		end
		enchantCost = weapenData.level * bookData.color * bookData.level * costBase
		self.panel:setLabelText("lab_dzfy", enchantCost)
	end
	
	local function clearChild(type, touchPos)
		if nil == type or type == GameField.Event_DoubleClick then
			if nil ~= cutEnchantWP then
				cutEnchantWP:removeFromParent()
				cutEnchantWP = nil
				curEnchantWeapenData = nil
				self.panel:getChildByName("btn_addweapen"):runAction(cc.Sequence:create(
					cc.DelayTime:create(0.5),
					cc.CallFunc:create(function()
						self.panel:setBtnEnabled("btn_addweapen", true)
				end)))
			end
			self.panel:setLabelText("lab_dzfy", "0")
		end
	end
	
	
	local function addWeapenToEnchant(data)
		clearChild()
		curEnchantWeapenData = data
		local equip = data
		local imgBg= self.panel:getChildByName("img_magicweapen")
		local posx, posy = self.panel:getChildByName("btn_addweapen"):getPosition()
		local iconSprite = IconUtil.GetIconByIdType(equip.type, equip.toolId, nil ,{data=data, touchCallBack= clearChild})
		iconSprite:setPosition(cc.p(posx-1, posy))
		imgBg:addChild(iconSprite,100)
		if nil ~= cutEnchantWP then
			cutEnchantWP:removeFromParent()
			cutEnchantWP = nil
		end
		cutEnchantWP = iconSprite
		self.panel:setBtnEnabled("btn_addweapen", false)
		updateCost(curEnchantWeapenData, selectBookItem.data)
	end
	
		--装备列表
	local function showEquipList()
		if not showItemForgeIsEnable then
			return
		end
		local function OnItemShowCallback(scroll_view,item,data,idx)
			if data.showType == GameField.hero then
				self.panel:setItemNodeVisible(item,"img_headBg",true)
				self.panel:setItemLabelText(item,"lab_heroName",data.info.heroName)
				self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..data.info.imgId..".png")
				self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..data.info.heroColor..".png")
			elseif data.showType == GameField.tool then
				self.panel:setItemNodeVisible(item,"img_headBg",true)
				self.panel:setItemNodeVisible(item,"img_heroHead",false)
				self.panel:setItemNodeVisible(item,"img_headColor",false)
				self.panel:setItemImageTexture(item,"img_headBg",IconPath.caidan.."beibao.png")
				self.panel:setItemLabelText(item,"lab_heroName",GameString.beibao)
			else
				self.panel:setItemNodeVisible(item,"img_equipBg1",false)
				self.panel:setItemNodeVisible(item,"img_equipBg2",true)
				self.panel:setItemLabelText(item,"lab_heroName",data.info.name)
				
				local size = item:getContentSize()
				local iconSprite = IconUtil.GetIconByIdType(data.info.type,data.info.toolId)
				iconSprite:setScale(0.7)
				iconSprite:setPosition(cc.p(35,38))
				item:addChild(iconSprite,1001)
			end
			
			if data.isSelect then
				if data.isChild then
					self.panel:setItemNodeVisible(item,"img_equipBg2",false)
					selectSprite = self.panel:getItemChildByName(item,"img_equipBg3")
					selectSprite:setVisible(true)
				else
					self.panel:setItemNodeVisible(item,"img_select",true)
				end
			
				if data.showType == GameField.equip then
					selectWeapenItem.data = data.info
					addWeapenToEnchant(data.info)
				end
			end
		end
		
		local function OnItemClickCallback(item,data,idx)
			if data.showType == GameField.hero or 
			   data.showType == GameField.tool then
				if userHeroId == data.info.userHeroId then
					isPopEquip = not isPopEquip
				else
					isPopEquip = true
				end
				userHeroId = data.info.userHeroId
				showEquipList()
			else
				if selectSprite then
					selectSprite:setVisible(false)
				end
				selectSprite = self.panel:getItemChildByName(item,"img_equipBg3")
				selectSprite:setVisible(true)
				addWeapenToEnchant(data.info)
				selectWeapenItem.data = data.info
				userEquipId = data.info.userEquipId
			end
		end
		selectSprite = nil
		local heroList = DataManager.getEquipGemList(userHeroId,userEquipId,isPopEquip)
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,"ListView_equip","ListItem_equip")
	end
	
	local function refreshMagicEquipTable()
		userHeroId = DataManager.getSceneHero().userHeroId
		showEquipList()
	end
	refreshMagicEquipTable()
	
	---------------------------------------------------------
	
	local uiTable = {}
	local spriteTable = {}
	function hideUI()
		for k, v in pairs(uiTable) do
			v:setVisible(false)
		end
		for k, v in pairs(spriteTable) do
			v:removeFromParent()
			v = nil
		end
	end
	
	function initUI()
		for i = 1, 4 do
			local data = self.panel:getChildByName("img_bsbg_" .. i)
			table.insert(uiTable, data)
		end
	end
	initUI()
	hideUI()
	
	local function onBookItemTouchCallback(item, data)
		hideUI()
		if nil ~= selectBookItem.item then
			self.panel:setItemNodeVisible(selectBookItem.item, "img_select", false)
		end
		self.panel:setItemNodeVisible(item, "img_select", true)
		
		selectBookItem.item = item
		selectBookItem.data = data 
		local materials = DataManager.getSystemMagicMaterialByMagicId(data.toolId)
		local materialList = Split(materials.material, "|")
		for k, v in pairs(materialList) do
			uiTable[k]:setVisible(true)
			local materialInfo = Split(v, ",")
			local material = DataManager.getSystemTool(tonumber(materialInfo[2]))
			local num = DataManager.getUserToolNum(tonumber(materialInfo[2])) or 0
			
			self.panel:setLabelText("lab_num" .. k, num .. "/" .. materialInfo[3], num >=  tonumber(materialInfo[3]) and cc.c3b(0, 255, 0) or cc.c3b(255, 0, 0))
			self.panel:setLabelText("lab_name" .. k, material.name)
			local posx, posy = self.panel:getChildByName("img_bs" .. k):getPosition()
			iconSprite = IconUtil.GetIconByIdType(material.type , material.toolId, nil , {})
			iconSprite:setPosition(cc.p(posx, posy))
			uiTable[k]:addChild(iconSprite, 5)
			table.insert(uiTable, iconSprite)
		end
		updateCost(curEnchantWeapenData, data)
	end
	
	local function OnBookItemShowCallback(scroll_view,item,data)
		local imgBg = self.panel:getItemChildByName(item, "img_book")
		local size = imgBg:getContentSize()
		--local function iconTouchEvent(type,touchPos)
		--	if type == GameField.Event_DoubleClick then
		--		onBookItemTouchCallback(item, data)
		--		updateCost(curEnchantWeapenData, data)
		--	end
		--end
		iconSprite = IconUtil.GetIconByIdType(data.type,data.toolId, data.toolNum, {data = data, touchCallBack = nil})
		iconSprite:setPosition(cc.p(size.width/2, size.height/2))
		imgBg:addChild(iconSprite)
	end
	
	local function OnItemClickCallback(item,data,idx)
		if showItemForgeIsEnable then
			onBookItemTouchCallback(item, data)
		end
	end
	

	local function refreshMagicBookTable()
		local showToolList = {}
		local userToolList = DataManager.getUserToolList()
		for k,v in pairs(userToolList) do
			if v.toolId >= GameField.magicToolType1141 and v.toolId <= GameField.magicToolType1170 then
				table.insert(showToolList, v)
			end
		end
		if 0 == #showToolList then
			self.panel:setNodeVisible("lab_nothing1", true)
		else
			self.panel:setNodeVisible("lab_nothing1", false)
		end
        self.panel:InitListView(showToolList, OnBookItemShowCallback, OnItemClickCallback, "ListView_book", "ListItem_book", 2)
	end
	
	refreshMagicBookTable()
	
	
	local function refreshUserInfo()
		--local userInfo = DataManager.getUserBO()	
		--self.panel:setLabelText("lab_money",userInfo.money)
	end
	
	local function reqEnchant(para)
		local userEquipId = para.arugments.userEquipId
		local reelId = para.arugments.reelId
		local status = para.arugments.status
        local req = EquipAction_equipMagicReq:New()
		if userEquipId then req:setString_userEquipId(userEquipId) end
        req:setInt_reelId(reelId)
		req:setInt_status(status)
        NetReqLua(req, true)
    end
	
	-- para   { item, Callback, arugments}  arugments is table, which is Callback's arugment
	local function showThinkingSlider(para)
		isEnchantIng = true
		local cancel_btn = self.panel:getChildByName("btn_qxzbmagic")
		cancel_btn:setVisible(true)
		local posx, posy = cancel_btn:getPosition()
		local item = para.item
		local loadingbg  = cc.Sprite:create(IconPath.xuanqu .. "i_jiazdi.png")
		loadingbg:setPosition(cc.p(posx, posy + 120))
		item:addChild(loadingbg, 99)

		local load_img = cc.Sprite:create(IconPath.xuanqu .. "i_jiazaitiao.png")
		local loading = cc.ProgressTimer:create(load_img)--loading条
		loading:setType(1)
		loading:setMidpoint({ x = 0, y = 1 })
		loading:setBarChangeRate({ x = 1, y = 0 })
		loading:setPosition(cc.p(posx, posy + 120))
		loading:setPercentage(0)
		item:addChild(loading, 100)
		
		local labelTTFPercent = cc.LabelTTF:create(LabelChineseStr.EnchantUISliderName_0, "Arial",20, {width = 0, height = 0})
		labelTTFPercent:setPosition(cc.p(posx, posy + 120))
		item:addChild(labelTTFPercent, 120)
		
		local function updateSlider()
			local percent = loading:getPercentage()
			if 100 == percent then
				showItemForgeIsEnable = true
				self.netData.arugments.status = 3
				reqEnchant(self.netData)
				isEnchantIng = false
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)				
			else
				loading:setPercentage(percent + 1)
			end		
		end
		
		local function btnCallBack(sender,tag)
			if 0 == tag then
				showItemForgeIsEnable = true
				self.netData.arugments.status = 2
				reqEnchant(self.netData)
				isEnchantIng = false
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)
			end
		end
		self.doCallback = btnCallBack
		self.panel:addNodeTouchEventListener("btn_qxzbmagic", btnCallBack, 0)
		local times = sliderTime / 100.0
		self.scheduler = Director.getScheduler():scheduleScriptFunc(updateSlider, times, false)
	end
	
	function EquipEnchantUIPanel_EquipAction_equipMagic(msgObj)
		if 1 ==  self.netData.arugments.status then
			showThinkingSlider(self.netData)
			--特效 音效
			SoundEffect.playSoundEffect("enchant")
			local parentNode = self.panel:getChildByName("img_magic")
			local targetNode = self.panel:getChildByName("img_magicweapen")
			local desPosX, desPosY = targetNode:getPosition()
			local targetPoint = cc.p(desPosX, desPosY)
			for k, v in pairs(uiTable) do
				if not v:isVisible() then
					break
				end
				local px, py = v:getPosition()
				local tx = cc.ParticleSystemQuad:create("res/effect/t30/t30fumolizi.plist")
				tx:setPosition(cc.p(px, py))
				parentNode:addChild(tx, 100)
				tx:runAction(cc.Sequence:create(cc.MoveTo:create(1, targetPoint), cc.RemoveSelf:create()))
			end
			return		
		elseif 2 == self.netData.arugments.status then
			return
		else
			Tips( LabelChineseStr.EnchantUITip_0 .. "\n" .. msgObj.body.userEquipBO.magicEquipAttr)
			SoundEffect.playSoundEffect("enchantsuccess")
			local tx = CreateEffectSkeleton("t29")
			local targetNode = self.panel:getChildByName("img_magicweapen")
			local size = targetNode:getContentSize()
			tx:setPosition(cc.p(size.width/2, size.height/2))
			targetNode:addChild(tx, 200)
			tx:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.RemoveSelf:create()))
			for k, v in pairs(msgObj.body.goodsList) do
				DataManager.reduceUserTool(v.goodsId, v.goodsNum)
			end
			DataManager.updateUserEquipMagicAttr(msgObj.body.userEquipBO.userEquipId, msgObj.body.userEquipBO.magicEquipAttr)
			if nil ~= selectBookItem.data then
				onBookItemTouchCallback(selectBookItem.item, selectBookItem.data)
			end
			refreshMagicBookTable()
			addWeapenToEnchant(selectWeapenItem.data)
		end
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()	    
		elseif tag == 1 then
			--TODO 	请求附魔
			if nil == selectBookItem.data or nil == curEnchantWeapenData then
				return
			end	
			
			showItemForgeIsEnable = false
			local item = self.panel:getChildByName("img_dashbordbg")
			local data  = {reelId = selectBookItem.data.toolId, userEquipId = curEnchantWeapenData.userEquipId, status = 1}
			self.netData = {item = item, Callback = reqEnchant, arugments = data}
			reqEnchant(self.netData)
		
		elseif 2 == tag then
			--添加物品到附魔框
			if nil == selectWeapenItem.data or nil ~= cutEnchantWP then
				return
			end
			addWeapenToEnchant(selectWeapenItem.data)
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack, 0)
	self.panel:addNodeTouchEventListener("btn_zbmagic",btnCallBack, 1)
	self.panel:addNodeTouchEventListener("btn_addweapen",btnCallBack, 2)

    return panel
end

--退出
function EquipEnchantUIPanel:Release()
	if nil ~= self.scheduler then
		self.doCallback(nil, 0)
	end
	self.panel:Release()
end

--隐藏
function EquipEnchantUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EquipEnchantUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
