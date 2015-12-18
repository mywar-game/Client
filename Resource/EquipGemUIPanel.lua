require("EquipDetailUtil")

EquipGemUIPanel = {
panel = nil,
}
function EquipGemUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function EquipGemUIPanel:Create(para)
    local p_name = "EquipGemUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local isPopEquip = false
	local userEquipId = nil
	local selectGem = nil
	local selectEquip = nil
	local selectSprite = nil
	local equipGenStone = nil
	local netStatus = 1 --请求状态
	local upgradeGenstoneId = -1
	local gemSpriteList = {} --镶嵌的精灵
	local toolSpriteList = {} --精炼的精灵
	local resolveDataList = {{},{},{},{},{},} --分解的宝石数据
	local resolveSprietList = {} --分解宝石的精灵
	local userHeroId = DataManager.getSceneHero().userHeroId
	--镶嵌请求数据
	local function netEquipFillInGemstoneReq(pos,userGemstoneId)
		local equipFillInGemstoneReq = EquipAction_equipFillInGemstoneReq:New()
		equipFillInGemstoneReq:setString_userEquipId(selectEquip.userEquipId)
		equipFillInGemstoneReq:setString_userGemstoneId(userGemstoneId)
		equipFillInGemstoneReq:setInt_pos(pos)
		NetReqLua(equipFillInGemstoneReq,true)
	end
	
	--精炼请求数据
	local function netGemstoneUpgradeReq(status)
		if selectGem then
			netStatus = status
			local gemstoneUpgradeReq = GemstoneAction_gemstoneUpgradeReq:New()
			gemstoneUpgradeReq:setString_userGemstoneId(selectGem.userGemstoneId)
			gemstoneUpgradeReq:setInt_status(netStatus)
			NetReqLua(gemstoneUpgradeReq,true)
		end
	end
	
	--分解请求数据
	local function netGemstoneResolveReq(status)
		local idList = {}
		for k,v in pairs(resolveDataList)do
			if v.userGemstoneId then
				table.insert(idList,v.userGemstoneId)
			end
		end
		
		if #idList > 0 then
			netStatus = status
			local gemstoneResolveReq = GemstoneAction_gemstoneResolveReq:New()
			gemstoneResolveReq:setList_userGemstoneIdList(idList)
			gemstoneResolveReq:setInt_status(netStatus)
			NetReqLua(gemstoneResolveReq,true)
		end
	end
	
	local function isContainNode(name,touchPos)
		local listView = self.panel:getChildByName(name)
		local location = listView:convertToNodeSpace(touchPos)
		local size = listView:getContentSize()
		local rect = cc.rect(0,0,size.width,size.height)
		if cc.rectContainsPoint(rect,location) then
			return true
		end
		return false
	end
	
	local moveSprite = nil
	local function iconTouchEvent(iconSprite,data,types,touchPos,callBack)	
		if types == GameField.Event_Move then--处理拖动
			if not moveSprite then
				moveSprite = IconUtil.GetIconByIdType(data.type,data.toolId,nil)
				self.panel.layer:addChild(moveSprite,0xffff)
			end
			moveSprite:setPosition(self.panel.layer:convertToNodeSpace(touchPos))
			iconSprite:setVisible(false)
		elseif types == GameField.Event_End then--处理按下起立
			if moveSprite then
				iconSprite:setVisible(true)
				moveSprite:removeFromParent(true)
				moveSprite = nil
				callBack(1)
			end
		elseif types == GameField.Event_DoubleClick then
			callBack(2)
		end
	end
	
	--刷新装备
	local function refreshEquipUI(data)
		selectEquip = data
		equipGenStone = DataManager.getEquipGemstoneList(data.userEquipId)
		
		for k,v in pairs(gemSpriteList)do
			v:removeFromParent(true)
		end
		gemSpriteList = {}
		
		local equipBgSprite = self.panel:getChildByName("img_equip")
		local size = equipBgSprite:getContentSize()
		local eqiupSprite = IconUtil.GetIconByIdType(data.type,data.toolId,nil,{data=data})
		eqiupSprite:setPosition(cc.p(size.width/2,size.height/2))
		equipBgSprite:addChild(eqiupSprite)
		table.insert(gemSpriteList,eqiupSprite)
		
		EquipDetailUtil.showAttrInfo(self.panel,selectEquip,gemSpriteList,"lab_equipFlag",cc.size(200,0),cc.p(0,-20))
		
		for k=1,3 do
			self.panel:setNodeVisible("img_gem"..k,false)
		end
		
		for k=1,data.holeNum do
			local stoneData = equipGenStone[k]
			local gemBgSprite = self.panel:getChildByName("img_gem"..k)
			local gemSize = gemBgSprite:getContentSize()
			gemBgSprite:setVisible(true)
			
			if stoneData then
				local iconSprite = nil
				local function touchCallBack(type,touchPos)
					iconTouchEvent(iconSprite,stoneData,type,touchPos,function(index)
						if (index == 1 and isContainNode("ListView_gem",touchPos)) or index == 2 then
							netEquipFillInGemstoneReq(0,stoneData.userGemstoneId)
						end
					end)
				end
				iconSprite = IconUtil.GetIconByIdType(stoneData.type,stoneData.toolId,nil,{data=stoneData,touchCallBack=touchCallBack})
				iconSprite:setPosition(cc.p(gemSize.width/2,gemSize.height/2))
				gemBgSprite:addChild(iconSprite)
				table.insert(gemSpriteList,iconSprite)
			end
		end
	end

	--宝石列表
	local function showCanMosaicGemList()
		local function OnItemShowCallback(scroll_view,item,data,idx)
			local iconSprite = nil
			local size = item:getContentSize()
			local function touchCallBack(type,touchPos)
				if selectEquip == nil then
					return
				end
				
				iconTouchEvent(iconSprite,data,type,touchPos,function(index)
					if index == 1 then
						for k=1,selectEquip.holeNum do
							if isContainNode("img_gem"..k,touchPos) then
								netEquipFillInGemstoneReq(k,data.userGemstoneId)
								break
							end
						end
					else
						for k=1,selectEquip.holeNum do
							if equipGenStone[k] == nil then
								netEquipFillInGemstoneReq(k,data.userGemstoneId)
								break
							end
						end
					end
				end)
			end
			iconSprite = IconUtil.GetIconByIdType(data.type,data.toolId,nil,{data=data,touchCallBack=touchCallBack})
			iconSprite:setPosition(cc.p(size.width/2,size.height/2))
			item:addChild(iconSprite,1001)
		end
		
		local function OnItemClickCallback(item,data,idx)
		
		end
		
		local gemstoneList = DataManager.getCanMosaicGemstoneList()
		self.panel:InitListView(gemstoneList,OnItemShowCallback,OnItemClickCallback,"ListView_gem","ListItem_gem",3)
	end
					
	--装备列表
	local function showEquipList()
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
					refreshEquipUI(data.info)
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
				refreshEquipUI(data.info)
				userEquipId = data.info.userEquipId
			end
		end
		selectSprite = nil
		
		local heroList = DataManager.getEquipGemList(userHeroId,userEquipId,isPopEquip)
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,"ListView_equip","ListItem_equip")
	end
	
	--宝石精炼
	local function shwoGemstoneRefin(data)
		for k,v in pairs(toolSpriteList)do
			v:removeFromParent(true)
		end
		selectGem = data
		toolSpriteList = {}
		
		local bgGemSprite = self.panel:getChildByName("img_gemstoneBg")
		local size = bgGemSprite:getContentSize()
		local gemSprite = IconUtil.GetIconByIdType(GameField.gemstone,data.gemstoneId,nil,{data=data})
		gemSprite:setPosition(cc.p(size.width/2,size.height/2))
		bgGemSprite:addChild(gemSprite)
		self.panel:setLabelText("lab_equipName1",data.name)
		self.panel:setLabelText("lab_gemLevel1","Lv."..data.level)
		table.insert(toolSpriteList,gemSprite)
		
		local x1,y1 = self.panel:getChildByName("lab_gemLevel1"):getPosition()
		local x2,y2 = self.panel:getChildByName("lab_gemLevel2"):getPosition()
		local x3,y3 = self.panel:getChildByName("img_add"):getPosition()
		
		local attrList = json.decode(data.attr)
		for k,v in pairs(attrList)do
			local attrStr = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
			local attrLabel = CreateLabel(attrStr..":"..v.value)
			attrLabel:setPosition(cc.p(x1,y1-k*25))
			attrLabel:setAnchorPoint(cc.p(0,0.5))
			bgGemSprite:addChild(attrLabel)
			table.insert(toolSpriteList,attrLabel)
		end
		
		local gemstoneUpgrade = DataManager.getSystemGemstoneUpgrade(data.gemstoneId)
		if gemstoneUpgrade == nil then
			self.panel:setLabelText("lab_gemLevel2","")
			self.panel:setNodeVisible("img_add",false)
			self.panel:setBtnEnabled("btn_refin",false)
			return
		end
		
		local bgSprite = self.panel:getChildByName("img_refinBg")
		local materialList = Split(gemstoneUpgrade.needMaterial,"|")
		for k,v in pairs(materialList)do
			local material = Split(v,",")
			local toolSprite = IconUtil.GetIconByIdType(tonumber(material[1]),tonumber(material[2]),nil,{})
			local size = toolSprite:getContentSize()
			toolSprite:setPosition(cc.p(130+60*k,95))
			bgSprite:addChild(toolSprite)
			
			local num = DataManager.getUserToolNum(tonumber(material[2])) or 0
			local numLabel = CreateLabel(num.."/"..material[3])
			numLabel:setPosition(cc.p(size.width/2,-20))
			toolSprite:addChild(numLabel)
			table.insert(toolSpriteList,toolSprite)
		end
		
		local upgradeData = DataManager.getSystemGemstone(gemstoneUpgrade.upgradeGemstoneId)
		upgradeGenstoneId = gemstoneUpgrade.gemstoneId
		
		self.panel:setBtnEnabled("btn_refin",true)
		self.panel:setNodeVisible("img_add",true)
		self.panel:setLabelText("lab_gemLevel2","Lv."..upgradeData.level)
		
		local userBo = DataManager.getUserBO()
		local const = DataManager.getSystemConfig().gemstone_upgrade_cost
		local gold = data.quality * data.level * const
		self.panel:setLabelText("lab_refinGold",gold)
		
		local systemAttr = DataManager.getSystemGemstoneAttr(data.gemstoneId)
		for k,v in pairs(systemAttr)do
			local value = 0
			local addValue = ""
			for m,n in pairs(attrList)do
				if n.attr == v.attr then
					value = n.value
				end
			end
			
			if v.lowerNum == v.upperNum then
				addValue = v.upperNum
			else
				addValue = "("..v.lowerNum.."~"..v.upperNum..")"
			end
			local attrStr = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
			local attrLabel = CreateLabel(attrStr..":"..value.."+"..addValue)
			attrLabel:setPosition(cc.p(x2,y2-k*25))
			attrLabel:setAnchorPoint(cc.p(0,0.5))
			bgGemSprite:addChild(attrLabel)
			table.insert(toolSpriteList,attrLabel)
			
			local addSprite = CreateCCSprite(IconPath.yingxiongshenxing.."i_suxingbhjd.png")
			addSprite:setPosition(cc.p(x3,y3-k*25))
			bgGemSprite:addChild(addSprite)
			table.insert(toolSpriteList,addSprite)
		end
	end
		
		--宝石分解
	local function showGemstoneResolve(data)
		local idx = 0
		for k,v in pairs(resolveDataList)do
			if v.userGemstoneId == nil then	
				idx = k
				resolveDataList[k] = data
				break
			end
		end
		
		if idx > 0 then
			local iconSprite = nil
			local function touchCallBack(type,touchPos)
				iconTouchEvent(iconSprite,data,type,touchPos,function(index)
					if (index == 1 and isContainNode("ListView_equip",touchPos)) or index == 2 then
						resolveSprietList[idx]:removeFromParent(true)
						resolveSprietList[idx] = nil
						resolveDataList[idx] = {}
					end
				end)
			end
			local bgSprite = self.panel:getChildByName("img_resolve"..idx)
			local size = bgSprite:getContentSize()
			iconSprite = IconUtil.GetIconByIdType(GameField.gemstone,data.gemstoneId,nil,{data=data,touchCallBack=touchCallBack})
			iconSprite:setPosition(cc.p(size.width/2,size.height/2))
			bgSprite:addChild(iconSprite)
			resolveSprietList[idx] = iconSprite
		end
		
		local gold = 0
		local userBo = DataManager.getUserBO()
		local const = DataManager.getSystemConfig().gemstone_resolve_cost
		for k,v in pairs(resolveDataList)do
			if v.userGemstoneId then
				gold = gold + v.quality * v.level * const
			end
		end
		self.panel:setLabelText("lab_resolveGold",gold)
	end
		
	--自动选择宝石
	local function atuoSelectGemstone()
		local data = DataManager.getCanMosaicGemstoneList()
		for k,v in pairs(data)do
			local num = 0
			local flag = true
			for n,m in pairs(resolveDataList)do
				if m.userGemstoneId == nil then
					num = num + 1
				end
				
				if v.userGemstoneId == m.userGemstoneId then
					flag = false
				end
			end
			
			if flag and num > 0 then
				showGemstoneResolve(v)
			end
		end
	end
		
	local function showUserGemstoneList(flag,isClean)
		local function OnItemShowCallback(scroll_view,item,data,idx)
			if upgradeGenstoneId == data.gemstoneId then
				shwoGemstoneRefin(data)
				selectSprite = self.panel:getItemChildByName(item,"img_select")
				selectSprite:setVisible(true)
			end
			
			local size = item:getContentSize()
			local iconSprite = IconUtil.GetIconByIdType(data.type,data.toolId)
			iconSprite:setScale(0.7)
			iconSprite:setPosition(cc.p(35,38))
			item:addChild(iconSprite,1001)
			
			self.panel:setItemLabelText(item,"lab_heroName",data.name)
		end
		
		local function OnItemClickCallback(item,data,idx)
			if selectSprite then
				selectSprite:setVisible(false)
			end
			
			selectSprite = self.panel:getItemChildByName(item,"img_select")
			selectSprite:setVisible(true)
			if flag then
				shwoGemstoneRefin(data)
			else
				showGemstoneResolve(data)
			end
		end
		selectSprite = nil
		
		local data
		if flag then
			data = DataManager.getUserGemstoneList()
		else
			data = DataManager.getCanMosaicGemstoneList()
		end
		for k,v in pairs(resolveSprietList)do
			v:removeFromParent(true)
		end
		
		if isClean then
			upgradeGenstoneId = -1
		end
		resolveSprietList = {}
		autoGemstoneList = {}
		resolveDataList = {{},{},{},{},{},}
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback,"ListView_equip","ListItem_equip")
	end
	
	function EquipGemUIPanel_EquipAction_equipFillInGemstone(msgObj)
		refreshEquipUI(selectEquip)
		showCanMosaicGemList()
	end
	
	local function upgradeCallBack(state)
		if state then
			netGemstoneUpgradeReq(3)
		else
			netGemstoneUpgradeReq(2)
		end
	end
	
	function EquipGemUIPanel_GemstoneAction_gemstoneUpgrade(msgObj)
		if netStatus == 1 then
			local secTim = DataManager.getSystemConfig().equip_stone_operation_cd_time
			LayerManager.show("CollectionUIPanel",{secTim=tonumber(secTim),callBack=upgradeCallBack})
		elseif netStatus == 2 then
			netStatus = 1
		elseif netStatus == 3 then
			netStatus = 1
			showUserGemstoneList(true,true)
		end
	end
	
	local function resolveCallBack(state)
		if state then
			netGemstoneResolveReq(3)
		else
			netGemstoneResolveReq(2)
		end
	end
	
	function EquipGemUIPanel_GemstoneAction_gemstoneResolve(msgObj)
		if netStatus == 1 then
			local secTim = DataManager.getSystemConfig().equip_stone_operation_cd_time
			LayerManager.show("CollectionUIPanel",{secTim=tonumber(secTim),callBack=resolveCallBack})
		elseif netStatus == 2 then
			netStatus = 1
		elseif netStatus == 3 then
			netStatus = 1
			showUserGemstoneList(false,false)
		end
	end
	
	--显示信息
	local function showRightUI(idx)
		self.panel:setBtnEnabled("btn_xq",idx ~= 1)
		self.panel:setBtnEnabled("btn_jl",idx ~= 2)
		self.panel:setBtnEnabled("btn_fj",idx ~= 3)
		self.panel:setNodeVisible("Panel_xq",idx == 1)
		self.panel:setNodeVisible("Panel_jl",idx == 2)
		self.panel:setNodeVisible("Panel_fj",idx == 3)
		
		if idx == 1 then
			showEquipList()
			showCanMosaicGemList()
		elseif idx == 2 then
			showUserGemstoneList(true,true)
		elseif idx == 3 then
			showUserGemstoneList(false,true)
		end
		
		local imgRes = (idx == 1) and "t_haoyoulbb.png" or "t_baoshilieb.png"
		self.panel:setImageTexture("img_leftTitle",IconPath.baoshibeijing..imgRes)
		self.panel:setBitmapText("imb_title",GameString["gemTitle"..idx])
	end
	showRightUI(1)
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			showRightUI(1)
		elseif tag == 2 then
			showRightUI(2)
		elseif tag == 3 then
			showRightUI(3)
		elseif tag == 4 then
			netGemstoneUpgradeReq(1)
		elseif tag == 5 then
			atuoSelectGemstone()
		elseif tag == 6 then
			netGemstoneResolveReq(1)
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_xq",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_jl",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_fj",btnCallBack,3)	
	self.panel:addNodeTouchEventListener("btn_refin",btnCallBack,4)	
	self.panel:addNodeTouchEventListener("btn_auto",btnCallBack,5)	
	self.panel:addNodeTouchEventListener("btn_resolve",btnCallBack,6)	
	return panel
end

--退出
function EquipGemUIPanel:Release()
	self.panel:Release()
end

--隐藏
function EquipGemUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EquipGemUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
