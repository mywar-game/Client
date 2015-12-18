FightResultUIPanel = {
panel = nil,
}
function FightResultUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function FightResultUIPanel:Create(para)
    local p_name = "FightResultUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local clickIdx = 0
	local dropNum = 0
	local skeleton2 = nil
	local dropSprite = nil 
	local fightResult = para.fightResult
	local tileMapInfo = DataManager.getUserTileMapInfo()
	local systemConfig = DataManager.getSystemConfig()
	
	self.panel:setNodeVisible("img_pk", false)
	self.panel:setNodeVisible("img_failed", false)
	self.panel:setNodeVisible("img_successful", false)
	self.panel:setLabelText("lab_tips",systemConfig.battle_open_box_cost)
	self.panel:setLabelText("lab_teamLevel","Lv."..DataManager.getUserBO().level)
	
	local function showForceDrop()
		local toolList = {}
		local dropData = {}
		local drop = para.body.drop
		local heroList = drop.heroList or {}
		local equipList = drop.equipList or {}
		local heroSkillList = drop.heroSkillList or {}
		local gemstoneList = drop.gemstoneList or {}
		for k,v in pairs(drop.goodsList)do
			if v.goodsType == GameField.gold then--金币
				self.panel:setLabelText("lab_moneyNum","+"..v.goodsNum)
			elseif v.goodsType == GameField.exp then--经验
				self.panel:setLabelText("lab_teamExp", "+"..v.goodsNum)
			elseif v.goodsType == GameField.chest then--宝箱
				self.panel:setLabelText("lab_boxNum","+"..v.goodsNum)
			elseif v.goodsType == GameField.tool then
				table.insert(toolList,v)
			end
		end
	
		--装备
		for k,v in pairs(equipList)do
			table.insert(dropData,{goodsId=v.equipId,goodsType=GameField.equip,goodsNum=1})
		end
		
		--技能书
		for k,v in pairs(heroSkillList)do
			table.insert(dropData,{goodsId=v.systemHeroSkillId,goodsType=GameField.skillBook,goodsNum=1})
		end
		
		--道具
		for k,v in pairs(toolList)do
			table.insert(dropData,{goodsId=v.goodsId,goodsType=v.goodsType,goodsNum=v.goodsNum})
		end
		
		--宝石
		for k,v in pairs(gemstoneList)do
			table.insert(dropData,{goodsId=v.gemstoneId,goodsType=GameField.gemstone,goodsNum=1})
		end
		
		for k,v in pairs(dropData)do
			dropNum = k
			local sprite = IconUtil.GetIconByIdType(v.goodsType,v.goodsId,v.goodsNum,{})
			sprite:setPosition(cc.p(90*k,80))
			dropSprite:addChild(sprite)
		end
		
		local heroCopy = self.panel:getChildByName("img_heroCopy")
		for k,v in pairs(drop.heroList)do
			local systemHero = StaticDataManager.getSystemHeroId(v.systemHeroId)
			local heroExp1 = DataManager.getSystemHeroLevel(systemHero.heroColor,v.level)
			local heroExp2 = DataManager.getSystemHeroLevel(systemHero.heroColor,v.level+1)
			local newHero = heroCopy:clone()
			newHero:setVisible(true)
			newHero:setPosition(cc.p(k*90,300))
			self.panel:getChildByName("img_successful"):addChild(newHero)
			self.panel:setItemLabelText(newHero,"lab_heroLevel","Lv."..v.level)
			self.panel:setItemLabelText(newHero,"lab_heroExp",(v.exp-heroExp1).."/"..(heroExp2-heroExp1))
			self.panel:setItemImageTexture(newHero,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
			self.panel:setItemImageTexture(newHero,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
			self.panel:setItemProgressBarPercent(newHero,"pro_heroExp",(v.exp-heroExp1)/(heroExp2-heroExp1)*100)
		end
		
		--刷新一下副本(仅仅大关卡处理)
	    if fightResult.forces.bigForcesId ~= 0 then	   
			DataManager.setNextForcesId(fightResult.forces.bigForcesId,fightResult.forces.forcesId,fightResult.forcesDifficulty)
		end
	end
	
	if para.battleReslut == GameField.fightSuccess then
		if fightResult.fightType == GameField.fightType3 then
			for k,v in pairs(para.body.drop.goodsList)do
				if v.goodsType == GameField.honour then--金币
					self.panel:setLabelText("lab_honour","+"..v.goodsNum)
					break
				end
			end
			dropSprite = self.panel:getChildByName("img_pk")
			local rankLab = self.panel:getChildByName("lab_rank")
			local action = ActionHelper.createDataStepAction(rankLab,para.body.oldRank,para.body.rank)
			rankLab:runAction(action)
			
		elseif fightResult.fightType == GameField.fightType2 then
			dropSprite = self.panel:getChildByName("img_successful")
			showForceDrop()
		elseif fightResult.fightType == GameField.fightType1 then
			local boxBtn = self.panel:getChildByName("btn_box")
			local boxSize = boxBtn:getContentSize()
			skeleton2 = CreateSkillSkeleton("t22")
			skeleton2:setScale(1.3)
			skeleton2:getAnimation():play("jiesuan01")
			skeleton2:setPosition(cc.p(boxSize.width/2,boxSize.height/2+10))
			boxBtn:addChild(skeleton2,-1)
			local num = 0
			local function movementEventCallFunc(armature, movementType, movementID)
				if movementType == 2 and movementID == "jiesuan01" then
					num = num + 1
					if num == 5 then
						local arr = {}
						arr[1] = cc.DelayTime:create(0.5)
						arr[2] = cc.CallFunc:create(function()
							num = 0
							skeleton2:getAnimation():resume()
						end)
						local sq = cc.Sequence:create(arr)
						self.panel.layer:runAction(sq)
						skeleton2:getAnimation():pause()
					end
				elseif movementType == 2 and movementID == "jiesuan02" then
					skeleton2:getAnimation():stop()
				end
			end
			skeleton2:getAnimation():setMovementEventCallFunc(movementEventCallFunc)
			self.panel:setNodeVisible("btn_box", true)
			dropSprite = self.panel:getChildByName("img_successful")
			showForceDrop()
		end
		
		local skeleton1 = CreateEffectSkeleton("t13")
		local size = dropSprite:getContentSize()
		skeleton1:setPosition(cc.p(size.width/2,430))
		dropSprite:setVisible(true)
		dropSprite:addChild(skeleton1)
	else	
		if fightResult.fightType == GameField.fightType3 then
			self.panel:setNodeVisible("btn_restart", false)
		end
		self.panel:setNodeVisible("img_failed",true)
	end
	
	function FightResultUIPanel_ForcesAction_attack()
		LayerManager.show("FightUIPanel",{fightResult=fightResult})
		self:Release()
	end
		
	local function netAttackReq()
		local attackReq = ForcesAction_attackReq:New()
		attackReq:setInt_mapId(fightResult.forces.mapId)
		attackReq:setInt_forcesId(fightResult.forces.forcesId)
		attackReq:setInt_forcesType(fightResult.forcesDifficulty)
		NetReqLua(attackReq)
	end
	
	function FightResultUIPanel_ForcesAction_openBattleBox(msgObj)
		if clickIdx == 0 then
			self:Release()
			LayerManager.show("TileMapUIPanel",tileMapInfo)
			if fightResult.fightType == GameField.fightType3 then
				MainMenuUIPanel_openArena()
			end
		elseif clickIdx == 1 then
			netAttackReq()
		elseif clickIdx == 2 then--招募
			self:Release()
			LayerManager.show("TileMapUIPanel",tileMapInfo)
            MainMenuUIPanel_openPrestige()
		elseif clickIdx == 3 then--强化装备
		
		elseif clickIdx == 4 then--升级技能
			self:Release()
            LayerManager.show("TileMapUIPanel",tileMapInfo)
            MainMenuUIPanel_openTeamSkill()
		elseif clickIdx == 5 then
			LayerManager.show("FightStatisticsUIPanel",{fightType=fightResult.fightType})
		elseif clickIdx == 6 then
			self.panel:setBtnEnabled("btn_box", false)
			
			local x,y = self.panel:getChildByName("btn_box"):getPosition()							
			local dropData = EquipDetailUtil.showDropData(msgObj.body.drop)
			for k,v in pairs(dropData)do
				local sprite = IconUtil.GetIconByIdType(v.goodsType,v.goodsId,v.goodsNum)
				sprite:setScale(0.5)
				sprite:setPosition(cc.p(x,y+40))
				dropSprite:addChild(sprite,20-k)
				
				local arr1 = {}
				arr1[1] = cc.DelayTime:create(0.5*k)
				arr1[2] = cc.MoveTo:create(0.8,cc.p(90*(dropNum+k),80))
				local sq1 = cc.Sequence:create(arr1)
				
				local arr2 = {}
				arr2[1] = cc.DelayTime:create(0.5*k)
				arr2[2] = cc.ScaleTo:create(0.8,1)
				local sq2 = cc.Sequence:create(arr2)
		
				sprite:runAction(sq1)
				sprite:runAction(sq2)
			end
		end
	end
	
	local function netOpenBattleBoxReq()
		local status = 1
		if clickIdx == 6 then
			status = 2
		end
		local openBattleBoxReq = ForcesAction_openBattleBoxReq:New()
		openBattleBoxReq:setInt_status(status)
		NetReqLua(openBattleBoxReq)
	end
    --
	
	local function btnCallBack(sender,tag)
		if clickIdx > 0 and tag == 0 then
			self:Release()
			LayerManager.show("TileMapUIPanel",tileMapInfo)
			if fightResult.fightType == GameField.fightType3 then
				MainMenuUIPanel_openArena()
			end
		elseif tag == 5 then
			LayerManager.show("FightStatisticsUIPanel",{fightType=fightResult.fightType})
		else
			clickIdx = tag
			netOpenBattleBoxReq()
			if clickIdx == 6 then
				skeleton2:getAnimation():play("jiesuan02")
			end
		end		
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_continue",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_restart",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_recruitment",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_intensify",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_equipLevelUp",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_statistics",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_box",btnCallBack,6)

	return panel
end
--退出
function FightResultUIPanel:Release()
	DataManager.initFightData() --重置伤害
	self.panel:Release()
end
--隐藏
function FightResultUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function FightResultUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end