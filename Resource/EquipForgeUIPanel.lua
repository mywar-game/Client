require("PackageUIPanel")
EquipForgeUIPanel = {
panel = nil,
}

function EquipForgeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function EquipForgeUIPanel:Create(para)
    local p_name = "EquipForgeUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local packagePanel
	local forgeData = para.data
	netData = {}
	self.materiaSp = {}
	showItemForgeIsEnable = true   -- 判断当前是否能够切换锻造/回收物品
	costBase = DataManager.getSystemConfig().equip_forge_cost
	sliderTime = DataManager.getSystemConfig().equip_stone_operation_cd_time or 10
	
	local materialUI = {}
	local materiaSp	= {}
	for i = 1, 4 do
		materialUI[i] = self.panel:getChildByName("img_sxwpbg_" .. i)
		materialUI[i]:setVisible(false)
	end
	
	--根据operateType来设置ui 1表示是锻造    2 表示是回收
	self.panel:setBitmapText("lab_name", LabelChineseStr["ForgeUIButtonName_" .. GameField.equipForge])
	self.panel:setImageTexture("Image_sm", IconPath.duanzao .. "t_dzsxcl_0.png")
	self.panel:setLabelText("lab_dzfy", "")
	
	local function sendNetReq()
		local para = netData
		if nil ~= para then
			para.Callback(para.arugments)
		end
	end
	
	-- para   { item, Callback, arugments}  arugments is table, which is Callback's arugment
	local function showThinkingSlider(para)
		local cancel_btn = self.panel:getChildByName("btn_canceldz")
		cancel_btn:setVisible(true)
		self.panel:setBitmapText("lab_qxname", LabelChineseStr["ForgeUIButtonName_3"])
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
		
		local labelTTFPercent = cc.LabelTTF:create(LabelChineseStr["ForgeUISliderName_1"], "Arial",20, {width = 0, height = 0})
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
		self.panel:addNodeTouchEventListener("btn_canceldz", btnCallBack, 0)
		local times = sliderTime / 100.0
		self.scheduler = Director.getScheduler():scheduleScriptFunc(updateSlider, times, false)
	end
	
	local function updateCost(equipData)
		cclog(equipData.level .. "===========================" .. equipData.quality)
		local cost = (equipData.level * 5 + equipData.quality * 5 ) * costBase
		self.panel:setLabelText("lab_dzfy", tostring(cost))
	end
	
	
	local function showWeapenAttribute(paradata)
		local data = DataTranslater.tranEquip({equipId=paradata.toolId})
		self.panel:setNodeVisible("lab_dj",true)
		self.panel:setNodeVisible("lab_zbdj",true)
		self.panel:setNodeVisible("lab_wpname",true)
		self.panel:setLabelText("lab_dj", data.level)
		self.panel:setLabelText("lab_wpname", data.name)
		
		local function setStringValue(labelStr, txt, color)
			self.panel:setNodeVisible(labelStr,true)
			self.panel:setLabelText(labelStr, txt, color)
		end
		
		--唯一性
		if #data.equippos <= 1 then  
			setStringValue("lab_tx", LabelChineseStr.ToolDetailUIPanel_1)
		end
		--属于什么武器
		setStringValue("lab_tx", LabelChineseStr["ToolDetailUIPanel_2_"..data.equipType])
		--属性添加
		local i = 1
		local function addEquipAttr(i, attrCell, color)
			local showStr = ""
			if attrCell.name == "damage" then
				showStr = attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
			else
				showStr = "+"..attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
			end
			setStringValue("lab_tx_" .. i, showStr)
		end
		
		local minDamage = nil
		local maxDamage = nil
		for k,v in pairs(data.uniqueAttr) do
			if v.name == "miniDamage" then
				minDamage = v.value
			elseif v.name == "maxDamage" then
				maxDamage = v.value
			end
		end
		--伤害
		if minDamage and maxDamage then
			addEquipAttr(i, {name="damage",value=minDamage.." - "..maxDamage})
			i = i + 1
		end		
		--独有属性展示
		for k,v in pairs(data.uniqueAttr) do
			if v.name ~= "miniDamage" and v.name ~= "maxDamage" then
				addEquipAttr(i, v)
				i = i + 1
			end
		end
		--主属性展示
		for k,v in pairs(data.equipMainAttr) do
			addEquipAttr(i, v)
			i = i + 1
		end		
		--副属性展示
		for k,v in pairs(data.equipSecondaryAttr) do
			addEquipAttr(i, v, cc.c3b(0,255,0))
			i = i + 1
		end
		
		for u = i, 7 do
			self.panel:getChildByName("lab_tx_" .. u):setVisible(false)
		end
	end

	local function showWeapenForgeMaterial(data)
		if nil ~= self.materiaSp then
			for k,v in pairs(self.materiaSp) do
				v:removeFromParent(true)
			end
		end
		self.materiaSp = {}
		local metterial = DataManager.getSystemToolForgeByToolIdAndType(data.toolId, GameField.equipForge)
		if nil == metterial then
			self.panel:setBtnEnabled("btn_dz", false)
			return
		end
		self.panel:setBtnEnabled("btn_dz", true)
		cclogtable(metterial)
		local materialList = Split(metterial.material, "|")
		for k,v in pairs(materialList) do
			local materialInfo = Split(v, ",")
			local material
			local num
			if GameField.tool == tonumber(materialInfo[1]) then		-- 道具
				material = DataManager.getSystemTool(tonumber(materialInfo[2]))
				num = DataManager.getUserToolNum(tonumber(materialInfo[2])) or 0
			elseif GameField.equip == tonumber(materialInfo[1]) then  -- 武器
				material = DataManager.getSystemEquip(tonumber(materialInfo[2]))
				num = DataManager.getUserEquipNum(tonumber(materialInfo[2])) or 0
			end

			cclogtable(materialInfo)
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
	
	
	--设置锻造内容
	function EquipForgeUIPanel_EquipAction_equipForge(msgObj)
		if 1 ==  netData.arugments.status then
			showThinkingSlider(netData)
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
		elseif 2 == netData.arugments.status then
			return
		else
			cclog("锻造成功")
			--LayerManager.show("DialogRewardsUIPanel", msgObj.body.drop)--展示获得东西
			Tips(LabelChineseStr.ForgeUITip_1)
			--特效 音效
			SoundEffect.playSoundEffect("recovery")
			local tx = CreateEffectSkeleton("t29")
			local targetNode = self.panel:getChildByName("img_weapen")
			local size = targetNode:getContentSize()
			tx:setPosition(cc.p(size.width/2, size.height/2))
			targetNode:addChild(tx, 200)
			tx:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.RemoveSelf:create()))
			
			for k, v in pairs(msgObj.body.userEquipIdList) do
				DataManager.removeUserEquip(v)
			end
			for k, v in pairs(msgObj.body.goodsList) do
				DataManager.reduceUserTool(v.goodsId, v.goodsNum)
			end
			packagePanel:reFreshPackage()
			showWeapenForgeMaterial(forgeData)
		end
	end
	
	local function reqForge(para)
		local toolType = para.toolType
		local toolId = para.toolId
		local status = para.status
        local req = EquipAction_equipForgeReq:New()
        req:setInt_toolType(toolType)
        req:setInt_toolId(toolId)
		req:setInt_status(status)
		req:setInt_forgeType(GameField.equipForge)
		--------------------------
		--默认参数
		req:setString_material("")
		req:setInt_num(1)
		--------------------------
        NetReqLua(req, true)
    end
	
	
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
		local equipData = {}
		local systemEquip = data
		equipData.quality = systemEquip.quality
		equipData.level = systemEquip.level
		local qhSprite = IconUtil.GetIconByIdType(data.type , data.toolId)
		local weapen = self.panel:getChildByName("img_wp")
		local x, y  = weapen:getPosition()
		qhSprite:setPosition(cc.p(x, y))
		self.panel:getChildByName("img_weapen"):addChild(qhSprite, 1)
		showWeapenAttribute(data)
		showWeapenForgeMaterial(data)
		updateCost(equipData)
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
	
	
	--------------------------------
	local function btnCallBack(sender,tag)
		if tag == 0 then
		    self:Release()
		elseif 1 == tag then
			showItemForgeIsEnable = false
			data = para.data
			local item = self.panel:getChildByName("img_bottom")
			netData = {item = item, Callback = reqForge, arugments = {toolType = data.type, toolId = data.toolId, status = 1}}
			sendNetReq()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack, 0)
	self.panel:addNodeTouchEventListener("btn_dz",btnCallBack, 1)

    return panel
end

--退出
function EquipForgeUIPanel:Release()
	if nil ~= self.scheduler then
		self.doCallback(nil, 0)
	end
	DataManager.clearLastGetGoods()
	self.panel:Release()
	--LayerManager.show("EquipForgeLookUIPanel")	
end

--隐藏
function EquipForgeUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EquipForgeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
