require("PackageUIPanel")
EquipRecoveryUIPanel = {
panel = nil,
}

function EquipRecoveryUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function EquipRecoveryUIPanel:Create(para)
    local p_name = "EquipRecoveryUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	self.netData = {}
	self.materiaSp = {}
	self.showItemForgeIsEnable = true   -- 判断当前是否能够切换锻造/回收物品
	self.costBase = DataManager.getSystemConfig().equip_forge_cost
	self.sliderTime = DataManager.getSystemConfig().equip_stone_operation_cd_time or 10
	
	--根据operateType来设置ui 1表示是锻造    2 表示是回收
	self.panel:setBitmapText("lab_name", LabelChineseStr["ForgeUIButtonName_" .. GameField.equipResolve])
	self.panel:setImageTexture("Image_sm", IconPath.duanzao .. "t_dzsxcl_1.png")
	self.panel:setLabelText("lab_dzfy", "")
	
	
	local function sendNetReq()
		local para = self.netData
		if nil ~= para then
			para.Callback(para.arugments)
		end
	end
	
	-- para   { item, Callback, arugments}  arugments is table, which is Callback's arugment
	local function showThinkingSlider(para)
		local cancel_btn = self.panel:getChildByName("btn_canceldz")
		cancel_btn:setVisible(true)
		self.panel:setBitmapText("lab_qxname", LabelChineseStr["ForgeUIButtonName_4"])
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
		
		local labelTTFPercent = cc.LabelTTF:create(LabelChineseStr["ForgeUISliderName_2"], "Arial",20, {width = 0, height = 0})
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
				sendNetReq()
			else
				loading:setPercentage(percent + 1)
			end		
		end
		
		local function btnCallBack(sender,tag)
			if 0 == tag then
				self.netData.arugments.status = 2
				sendNetReq()
				self.showItemForgeIsEnable = true
				if nil ~= self.scheduler then
					Director.getScheduler():unscheduleScriptEntry(self.scheduler)
					self.scheduler = nil
				end
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
		local cost = (equipData.level * 5 + equipData.quality * 5 ) * self.costBase
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
		for k,v in pairs(self.materiaSp) do
			v:removeFromParent(true)
		end
		self.materiaSp = {}
		
		local metterial = DataManager.getSystemToolForgeByToolIdAndType(data.toolId, GameField.equipResolve)
		if nil == metterial then
			self.panel:setBtnEnabled("btn_dz", false)
			return
		end
		self.panel:setBtnEnabled("btn_dz", true)
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
			self.panel:setLabelText("lab_wpnum" .. k, materialInfo[3])
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

	local reqData = nil
	local cacheMoveSprite = nil
	
	local currentForge = nil			-- 当前回收的物品  在背包格子中
	local currentForgeInForce = nil		-- 当前回收的物品  在回收格子中

	local materialUI = {}
	local materiaSp	= {}
	local packagePanel
	
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
	
	function EquipRecoveryUIPanel_EquipAction_equipRecycle(msgObj)
		if 1 ==  self.netData.arugments.status then
			showThinkingSlider(self.netData)
			return		
		elseif 2 == self.netData.arugments.status then
			return
		else
			--特效 音效
			SoundEffect.playSoundEffect("enchantsuccess")
			local tx = CreateEffectSkeleton("t33")
			local targetNode = self.panel:getChildByName("img_weapen")
			local size = targetNode:getContentSize()
			tx:setPosition(cc.p(size.width/2, size.height/2))
			targetNode:addChild(tx, 200)
			tx:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),
			cc.CallFunc:create(function()
				local parentNode = self.panel:getChildByName("left_box")
				local srcNode = self.panel:getChildByName("img_weapen")
				local srcPosX, srcPosY = srcNode:getPosition()
				for k, v in pairs(materialUI) do
					if not v:isVisible() then
						break
					end
					local px, py = v:getPosition()
					local txo = cc.ParticleSystemQuad:create("res/effect/t30/t30fumolizi.plist")
					txo:setPosition(cc.p(srcPosX, srcPosY))
					parentNode:addChild(txo, 100)
					txo:runAction(cc.Sequence:create(cc.MoveTo:create(1, cc.p(px, py)), cc.CallFunc:create(function() hideUI()
					LayerManager.show("DialogRewardsUIPanel", msgObj.body.drop)--展示获得东西
					end) ,cc.RemoveSelf:create()))
				end
			end),
			cc.RemoveSelf:create()))
			
			DataManager.removeUserEquip(msgObj.body.userEquipId)					
			if nil ~= currentForge then
				currentForge = nil
			end
			if nil ~= currentForgeInForce then
				currentForgeInForce:removeFromParent()
				currentForgeInForce = nil
			end
			if nil ~= currentForgeInForce then
				currentForgeInForce:removeFromParent()
				currentForgeInForce = nil
			end
			packagePanel:reFreshPackage()
		end
	end
	
	local function reqRecovery(para)
		local toolType = para.toolType
		local toolId = para.toolId
		local userEquipId = para.userEquipId
		local status = para.status
        local req = EquipAction_equipRecycleReq:New()
		req:setInt_toolType(toolType)
        req:setInt_toolId(toolId)
		req:setInt_status(status)
		if userEquipId then req:setString_userEquipId(userEquipId) end
        NetReqLua(req, true)
    end
	
	for i = 1, 4 do
		materialUI[i] = self.panel:getChildByName("img_sxwpbg_" .. i)
		materialUI[i]:setVisible(false)
	end
	
	hideUI()
	local function forgeWeapenCallback(type, touchPos)
		if type == GameField.Event_DoubleClick then
			currentForgeInForce:removeFromParent()
			currentForgeInForce = nil
			currentForge:setVisible(true)
			currentForge = nil
			reqData = nil
			hideUI()	
		end
	end

	local function showItemForge(item, data)
		hideUI()
		if nil ~= currentForge then
			currentForge:setVisible(true)
			currentForge = item
		end
		currentForge = item
		reqData = data
		local equipData = {}
		local systemEquip = DataManager.getSystemEquip(data.equipId)
		equipData.quality = systemEquip.quality
		equipData.level = systemEquip.level
		local qhSprite = IconUtil.GetIconByIdType(data.type , data.toolId, data.toolNum, {data=data,touchCallBack=forgeWeapenCallback})
		local weapen = self.panel:getChildByName("img_wp")
		local x, y  = weapen:getPosition()
		qhSprite:setPosition(cc.p(x, y))
		self.panel:getChildByName("img_weapen"):addChild(qhSprite, 1)
		showWeapenAttribute(data)
		showWeapenForgeMaterial(data)
		updateCost(equipData)
		if nil ~= currentForgeInForce then
			currentForgeInForce:removeFromParent()
			currentForgeInForce = nil
		end
		currentForgeInForce = qhSprite
	end
	
	local function checkContain(isFromMall, touchPos)--检查是否进入回收
        local areaSprite = self.panel:getChildByName("img_weapen")
        local location = areaSprite:convertToNodeSpace(touchPos)
        local s = areaSprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end
	
	local function equipTouchCallBack(para)
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
                if checkContain(mallData, para.touchPos) and self.showItemForgeIsEnable then
					showItemForge(para.sprite, data)
				else
					para.sprite:setVisible(true) 
				end   
				cacheMoveSprite = nil 
            end
        elseif para.type == GameField.Event_DoubleClick and self.showItemForgeIsEnable then
            --快速锻造
			showItemForge(para.sprite, data)
			para.sprite:setVisible(false)
        end
	end
	
	local function toolTouchCallBack()
	end
	
	local function getPageckeToolList(cacheSelectPackage, packageSize)
		local tempTool = {}
		local function insertTools(toolList)
			for k=1,#toolList do
				local metterial = DataManager.getSystemToolForgeByToolIdAndType(toolList[k].toolId, GameField.equipResolve)
				if nil ~= metterial then
					table.insert(tempTool,toolList[k])
				end
			end
		end
		
		insertTools(DataManager.getUserPackageEquipList())
		
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
	local package = packagePanel:Create({x=545,y=3,equipTouchCallBack=equipTouchCallBack,  toolTouchCallBack=toolTouchCallBack, getPageckeToolList = getPageckeToolList, disEnable = true})
	lineSprite:addChild(package.layer)


	--------------------------------	
	local function btnCallBack(sender,tag)
		if tag == 0 then
		    self:Release()
		elseif 1 == tag then
			--TODO  锻造内容 ，   如像服务器发送锻造指令
			if nil ~= reqData then
				self.showItemForgeIsEnable = false
				local item = self.panel:getChildByName("img_bottom")
				self.netData = {item = item, Callback = reqRecovery, arugments = {toolType = reqData.type, toolId = reqData.toolId, userEquipId = reqData.userEquipId, status = 1}}
				sendNetReq()
			end
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack, 0)
	self.panel:addNodeTouchEventListener("btn_dz",btnCallBack, 1)
	
    return panel
end

--退出
function EquipRecoveryUIPanel:Release()
	if nil ~= self.scheduler then
		self.doCallback(nil, 0)
	end
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function EquipRecoveryUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EquipRecoveryUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
