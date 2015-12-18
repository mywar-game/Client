require("PackageUIPanel")
GemSynthesisUIPanel = {
panel = nil,
}

function GemSynthesisUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function GemSynthesisUIPanel:Create(para)
    local p_name = "GemSynthesisUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local packagePanel
	local gemCost = 0
	self.materiaSp = {}
	self.costBase = DataManager.getSystemConfig().equip_forge_cost
	self.sliderTime = DataManager.getSystemConfig().equip_stone_operation_cd_time or 10
	self.showItemForgeIsEnable = true   -- 判断当前是否能够切换物品
	self.panel:setBitmapText("BitmapLabel_10", LabelChineseStr.EnchantUITitle_0)
	self.panel:setBitmapText("lab_name", LabelChineseStr.EnchantUIButtonName_0)
	self.panel:setBitmapText("lab_qxname", LabelChineseStr.EnchantUIButtonName_1)
	self.panel:setLabelText("lab_dzfy", "")
	self.netData = {}
	
	local materialUI = {}
	local materiaSp	= {}
	for i = 1, 4 do
		materialUI[i] = self.panel:getChildByName("img_sxwpbg_" .. i)
		materialUI[i]:setVisible(false)
	end

	
	local function reqGemSynthesis(para)
		local toolType = para.arugments.toolType
		local toolId = para.arugments.toolId
		local status = para.arugments.status
        local req = GemstoneAction_gemstoneForgeReq:New()
        req:setInt_toolType(toolType)
        req:setInt_toolId(toolId)
		req:setInt_status(status)
		
		-----------------------------
		--固定参数
		req:setInt_forgeType(GameField.GemSynthesisForge)
		-----------------------------
		--------------------------
		--默认参数
		req:setString_material("")
		req:setInt_num(1)
		--------------------------
        NetReqLua(req, true)
	end
	
	-- para   { item, Callback, arugments}  arugments is table, which is Callback's arugment
	local function showThinkingSlider(para)
		local cancel_btn = self.panel:getChildByName("btn_canceldz")
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
		
		local labelTTFPercent = cc.LabelTTF:create(LabelChineseStr.GemSynthesisUISliderName_0, "Arial",20, {width = 0, height = 0})
		labelTTFPercent:setPosition(cc.p(posx, posy + 100))
		item:addChild(labelTTFPercent, 120)
		
		local function updateSlider()
			local percent = loading:getPercentage()
			if 100 == percent then
				self.showItemForgeIsEnable = true
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)
				self.netData.arugments.status = 3
				reqGemSynthesis(self.netData)
			else
				loading:setPercentage(percent + 1)
			end		
		end
		
		local function btnCallBack(sender,tag)
			if 0 == tag then
				self.netData.arugments.status = 2
				reqGemSynthesis(self.netData)
				self.showItemForgeIsEnable = true
				Director.getScheduler():unscheduleScriptEntry(self.scheduler)
				self.scheduler = nil
				loadingbg:removeFromParent()
				loading:removeFromParent()
				labelTTFPercent:removeFromParent()
				cancel_btn:setVisible(false)
			end
		end
		self.doCallback = btnCallBack
		self.panel:addNodeTouchEventListener("btn_canceldz", btnCallBack, 0)
		local times = self.sliderTime / 100.0
		self.scheduler = Director.getScheduler():scheduleScriptFunc(updateSlider, times, false)
	end

	local function updateCost(equipData)
		gemCost = (equipData.level * 5 + equipData.quality * 5 ) * self.costBase
		self.panel:setLabelText("lab_dzfy", tostring(gemCost))
	end

	local function showWeapenAttribute(paradata)
		for u = 1, 7 do
			self.panel:getChildByName("lab_tx_" .. u):setVisible(false)
		end
        self.panel:setLabelText("lab_wpname", paradata.name)
		self.panel:getChildByName("lab_wpname"):setVisible(true)
		--self.panel:setLabelText("lab_dj", systemEquip.level)
		self.panel:setLabelText("lab_dj", 1)
		self.panel:getChildByName("lab_zbdj"):setVisible(true)
		self.panel:getChildByName("lab_dj"):setVisible(true)
		
		local x2, y2 = self.panel:getChildByName("lab_tx"):getPosition()
		local gemAttr = DataManager.getSystemGemstoneAttr(paradata.gemstoneId)
		for k,v in pairs(gemAttr)do
			local value = 0
			local addValue = ""			
			if v.lowerNum == v.upperNum then
				addValue = v.upperNum
			else
				addValue = v.lowerNum .. "~" .. v.upperNum
			end
			local attrStr = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
			self.panel:getChildByName("lab_tx_" .. k):setVisible(true)
			self.panel:setLabelText("lab_tx_" .. k, attrStr..": "..addValue)
		end
	end

	local function showWeapenForgeMaterial(data)
		for k,v in pairs(self.materiaSp) do
			v:removeFromParent(true)
		end
		self.materiaSp = {}
		
		local metterial = DataManager.getSystemGemstoneForgeByIdAndTyep(data.gemstoneId, GameField.GemSynthesisForge)
		if nil == metterial then
			self.panel:setBtnEnabled("btn_dz", false)
			return
		end
		self.panel:setBtnEnabled("btn_dz", true)
		local materialList = Split(metterial.material, "|")
		for k,v in pairs(materialList) do
			local materialInfo = Split(v, ",")
			local material = DataManager.getSystemTool(tonumber(materialInfo[2]))
			local num = DataManager.getUserToolNum(tonumber(materialInfo[2])) or 0
			self.panel:setLabelText("lab_wpnum" .. k, num .. "/" .. materialInfo[3], num >=  tonumber(materialInfo[3]) and cc.c3b(0, 255, 0) or cc.c3b(255, 0, 0))
			self.panel:setLabelText( "lab_wpname" .. k, material.name)
			
			local imgSprite = self.panel:getChildByName("img_sxwpbg_" .. k)
			local size = imgSprite:getContentSize()
			local materalSprite = IconUtil.GetIconByIdType(materialInfo[1] , materialInfo[2])
			materalSprite:setPosition(cc.p(size.width/2,size.height/2))
			imgSprite:addChild(materalSprite)
			imgSprite:setVisible(true)
			self.materiaSp[k] = materalSprite
		end
	end
	
	
	--网络模块
	function GemSynthesisUIPanel_GemstoneAction_gemstoneForge(msgObj)
		if 1 ==  self.netData.arugments.status then
			showThinkingSlider(self.netData)
			--音效 特效
			SoundEffect.playSoundEffect("enchant")
			local parentNode = self.panel:getChildByName("left_box")
			local targetNode = self.panel:getChildByName("img_weapen")
			local desPosX, desPosY = targetNode:getPosition()
			local targetPoint = cc.p(desPosX, desPosY)
			for k, v in pairs(materialUI) do
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
			cclog("锻造成功")
			Tips(LabelChineseStr.ForgeUITip_1)
			
			SoundEffect.playSoundEffect("enchantsuccess")
			local tx = CreateEffectSkeleton("t29")
			local targetNode = self.panel:getChildByName("img_weapen")
			local size = targetNode:getContentSize()
			tx:setPosition(cc.p(size.width/2, size.height/2))
			targetNode:addChild(tx, 200)
			tx:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.RemoveSelf:create()))
			
			for k, v in pairs(msgObj.body.userGemstoneIdList) do
				DataManager.removeGemstoneId(v)
			end
			for k, v in pairs(msgObj.body.goodsList) do
				DataManager.reduceUserTool(v.goodsId, v.goodsNum)
			end
			showWeapenForgeMaterial({gemstoneId = self.netData.arugments.toolId})
			packagePanel:reFreshPackage()
		end
	end

	
	--------------------------------
	
	
	local function hideMattrial()
		for i = 1, 4 do
			materialUI[i]:setVisible(false)
			if nil ~= materiaSp[i] then
				materiaSp[i]:removeFromParent()
				materiaSp[i] = nil
			end
		end
	end
	local function hideUI()
		self.panel:getChildByName("lab_wpname"):setVisible(false)
		self.panel:getChildByName("lab_dj"):setVisible(false)
		self.panel:getChildByName("lab_zbdj"):setVisible(false)
		self.panel:getChildByName("lab_tx"):setVisible(false)
		for u = 1, 7 do
			self.panel:getChildByName("lab_tx_" .. u):setVisible(false)
		end
		hideMattrial()
	end
	hideUI()
	
	local function showItemForge(data)
		local qhSprite = IconUtil.GetIconByIdType(GameField.gemstone, data.gemstoneId)
		local weapen = self.panel:getChildByName("img_wp")
		local x, y  = weapen:getPosition()
		qhSprite:setPosition(cc.p(x, y))
		self.panel:getChildByName("img_weapen"):addChild(qhSprite, 1)
		showWeapenAttribute(data)
		showWeapenForgeMaterial(data)
		updateCost(data)
	end
	showItemForge(para.data)
	
	local function equipTouchCallBack()
	end
	
	local function toolTouchCallBack()
	end
	packagePanel = PackageUIPanel:New()
	local lineSprite = self.panel:getChildByName("img_line1")
	local package = packagePanel:Create({x=545,y=3,equipTouchCallBack=equipTouchCallBack,  toolTouchCallBack=toolTouchCallBack,})
	lineSprite:addChild(package.layer)
	
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
		    self:Release()
		elseif 1 == tag then
			local userBo = DataManager.getUserBO()
			if  userBo.gold  < gemCost then
				Tips(LabelChineseStr.PawnShopUIPanel_2)
				return
			end
			--TODO  锻造内容 ，   如像服务器发送锻造指令
			self.showItemForgeIsEnable = false
			data = para.data
			local item = self.panel:getChildByName("img_bottom")
			local data = {item = item, Callback = nil, arugments = {toolType = GameField.gemstone, toolId = data.gemstoneId, status = 1}}
			self.netData = data
			reqGemSynthesis(self.netData)
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack, 0)
	self.panel:addNodeTouchEventListener("btn_dz",btnCallBack, 1)

    return panel
end


--退出
function GemSynthesisUIPanel:Release()
	if nil ~= self.scheduler then
		self.doCallback(nil, 0)
	end
	DataManager.clearLastGetGoods()
	self.panel:Release()
	LayerManager.show("GemSynthesisLookUIPanel")
end

--隐藏
function GemSynthesisUIPanel:Hide()
	self.panel:Hide()
end

--显示
function GemSynthesisUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
