FightDropUIPanel = {
panel = nil,
}
function FightDropUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function FightDropUIPanel:Create(para)
    local p_name = "FightDropUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--业务逻辑编写处
	local selectForces = nil
	local selectSprite = nil
	local dropSprite = {}
	local bigForcesId = para.forces.bigForcesId
	local difficulty = GameField.forcesDifficulty1
	local bgSprite = self.panel:getChildByName("big_box")
	local isLowLevel = para.forces.limitLevel <= DataManager.getUserBO().level
	self.panel:setImageTexture("big_boxtop",IconPath.fubenbeijing..para.forces.imgId)
	self.panel:setLabelText("lab_openLevel",para.forces.limitLevel)
	
	local function refreshForcesUI(item,forces)
		selectForces = forces
		for k,v in pairs(dropSprite)do
			v:removeFromParent(true)
		end
		dropSprite = {}
		
		local normalBg = nil
		local selectBg = nil
		if difficulty == GameField.forcesDifficulty1 then
			normalBg = "i_kaiqizt.png"
			selectBg = "i_xuanzkuang.png"
		elseif difficulty == GameField.forcesDifficulty2 then
			normalBg = "i_kaiqizt.png"
			selectBg = "i_xuanzkuang.png"
		elseif difficulty == GameField.forcesDifficulty3 then
			normalBg = "i_bosskaiq.png"
			selectBg = "i_boss02.png"
		end
		
		if selectSprite then
			selectSprite:loadTexture(IconPath.fuben..normalBg,ccui.TextureResType.localType)
		end
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:loadTexture(IconPath.fuben..selectBg,ccui.TextureResType.localType)
		
		local monsterList = {}
		local dropTool = DataManager.getSystemForcesDropTool(forces.forcesId)
		local forcesMonster = DataManager.getSystemForcesMonster(forces.forcesId,difficulty)
		local tempList = Split(forcesMonster.monsterId,"|")
		for k,v in pairs(tempList)do
			local idList = Split(v,",")
			for i,j in pairs(idList) do
				local flag = true
				for n,m in pairs(monsterList)do
					if m == tonumber(j) then
						flag = false
						break
					end
				end
				if flag then
					table.insert(monsterList,tonumber(j))
				end
			end
		end
		
		for k,v in pairs(monsterList)do
			local blackSprite = CreateCCSprite(IconPath.tongyong.."i_black.png")
			local size = blackSprite:getContentSize()
			blackSprite:setPosition(cc.p(70+90*(k-1),130))
			bgSprite:addChild(blackSprite)
			
			local systemMonster = DataManager.getSystemMonsterId(v)
			local systemHero = DataManager.getStaticSystemHeroId(systemMonster.systemHeroId)
			local headSprite = CreateCCSprite(IconPath.yingxiong..systemHero.imgId..".png")
			headSprite:setPosition(cc.p(size.width/2,size.height/2))
			blackSprite:addChild(headSprite)
			
			local colorSprite = CreateCCSprite(IconPath.pinzhiYaun..systemHero.heroColor..".png")
			colorSprite:setPosition(cc.p(size.width/2,size.height/2))
			blackSprite:addChild(colorSprite)
			
			if systemMonster.monsterType == StaticField.monsterType3 then
				blackSprite:setScale(1.2)
			end
			table.insert(dropSprite,blackSprite)
		end
		
		--拆分不同的奖励
		local dropTools = {}
		for k,v in pairs(dropTool) do
			if v.toolType == GameField.gold
			   or v.toolType == GameField.jobExp 
			   or v.toolType == GameField.exp
			   or v.toolType == GameField.heroExp then
			else
				table.insert(dropTools, v)
			end
		end
		
		--道具奖励
		for k,v in pairs(dropTools) do
			local iconSprite = IconUtil.GetIconByIdType(v.toolType,v.toolId,v.toolNum,{})
			iconSprite:setPosition(cc.p(100+90*k,50))
			bgSprite:addChild(iconSprite)
			table.insert(dropSprite,iconSprite)
		end
		self.panel:setLabelText("lab_bossName",forces.forcesName)
		self.panel:setLabelText("lab_skillNum",forces.times.."/"..forcesMonster.attackLimitTimes)
		self.panel:setBitmapText("lab_titleName",para.forces.bigForcesName)
	end
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		local itemBg = nil
		local selectBg = nil
		if data.isPass == 1 and isLowLevel then --状态0未通关1通过
			self.panel:setItemNodeVisible(item,"img_gray",true)
			self.panel:setItemNodeVisible(item,"img_clock",false)
			if difficulty == GameField.forcesDifficulty1 then
				itemBg = "i_xiaojiekaiq.png"
				selectBg = "i_kaiqizt.png"
			elseif difficulty == GameField.forcesDifficulty2 then
				itemBg = "i_xiaojie02.png"
				selectBg = "i_kaiqizt.png"
			elseif difficulty == GameField.forcesDifficulty3 then
				itemBg = "i_boss01.png"
				selectBg = "i_bosskaiq.png"
			end
			self.panel:setItemVisable(item,"img_select",true)
			self.panel:setItemLabelText(item,"lab_forceName",data.forcesName)
		else
			if difficulty == GameField.forcesDifficulty1 then
				itemBg = "i_xiaojiehse.png"
				selectBg = "i_kaiqizt.png"
			elseif difficulty == GameField.forcesDifficulty2 then
				itemBg = "i_xiaojie02huise.png"
				selectBg = "i_kaiqizt.png"
			elseif difficulty == GameField.forcesDifficulty3 then
				itemBg = "i_boss03.png"
				selectBg = "i_bosskaiq.png"
			end
		end
		self.panel:setItemImageTexture(item,"img_itemBg",IconPath.fuben..itemBg)
		self.panel:setItemImageTexture(item,"img_select",IconPath.fuben..selectBg)
		
		if data.isShow == 1 then
			refreshForcesUI(item,data)
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		if data.isPass == 1 then
			refreshForcesUI(item,data)
		end
	end
	
	local function refreshDropUI(diff)
		difficulty = diff
		self.panel:setBtnEnabled("btn_pt", difficulty ~= GameField.forcesDifficulty1)
		self.panel:setBtnEnabled("btn_yx", difficulty ~= GameField.forcesDifficulty2)
		self.panel:setBtnEnabled("btn_ss", difficulty ~= GameField.forcesDifficulty3)
		local systemForces = DataManager.getSystemDuplicateForcesList(bigForcesId,difficulty)
		self.panel:InitListView(systemForces,OnItemShowCallback,OnItemClickCallback)
	end
		
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			UserGuideUIPanel.stepClick("btn_goto")
			LayerManager.show("FightDeployUIPanel",{forces=selectForces,forcesDifficulty=difficulty})
		elseif tag == 2 then
			refreshDropUI(GameField.forcesDifficulty1)
		elseif tag == 3 then
			refreshDropUI(GameField.forcesDifficulty2)
		elseif tag == 4 then
			refreshDropUI(GameField.forcesDifficulty3)
		elseif tag == 5 then
		
		elseif tag == 6 then
		
		elseif tag == 7 then
			
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_goto",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_pt",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_yx",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_ss",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_awd1",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_awd2",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_awd3",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_speed_one",btnCallBack,8)
	self.panel:addNodeTouchEventListener("btn_speed_ten",btnCallBack,9)
	
	function FightDropUIPanel_ForcesAction_getCopyForcesInfo(msgObj)
		refreshDropUI(GameField.forcesDifficulty1)
	end
	
	if isLowLevel then
		if #DataManager.getUserBigForceBo(bigForcesId,difficulty) > 0 then
			refreshDropUI(GameField.forcesDifficulty1)
		else
			local getCopyForcesReq = ForcesAction_getCopyForcesInfoReq:New()
			getCopyForcesReq:setInt_mapId(para.forces.mapId)
			getCopyForcesReq:setInt_bigForcesId(bigForcesId)
			NetReqLua(getCopyForcesReq,true)
		end
	else
		refreshDropUI(difficulty)
		self.panel:setBtnEnabled("btn_goto",false)
	end
	
	return panel
end
--退出
function FightDropUIPanel:Release()
	self.panel:Release()
end
--隐藏
function FightDropUIPanel:Hide()
	self.panel:Hide()
end
--显示
function FightDropUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
