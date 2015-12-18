HeroStarUIPanel = {
panel = nil,
}
function HeroStarUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroStarUIPanel:Create(para)
    local p_name = "HeroStarUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

	local selectHero = nil
	local clickType = 1
	local successNum = 100
	local selectHeroIdx = -1
	local selectUsertool = nil
	local skeletonHero = nil
	local starSpriteList = {}
	local toolSpriteList = {}
		
	--更新英雄
	local function refreshHero()
		local shodowSprite = self.panel:getChildByName("img_shodow")
		local size = shodowSprite:getContentSize()
		for k,v in pairs(starSpriteList)do
			v:removeFromParent(true)
		end
		starSpriteList = {}
		
		for k=1,selectHero.star do
			local starSprite = CreateCCSprite(IconPath.yingxiongshenxing.."i_xingx.png")
			local starSize = starSprite:getContentSize()
			local x = (size.width - selectHero.star * 15)/2 + 15*k - starSize.width/2
			starSprite:setPosition(cc.p(x,310))
			shodowSprite:addChild(starSprite)
			table.insert(starSpriteList,starSprite)
		end
		
		if skeletonHero then
			skeletonHero:Release()
		end
		
		skeletonHero = SkeletonAction:New()
		skeleton = skeletonHero:Create(selectHero.resId)
		skeleton:setPosition(cc.p(size.width/2-20,size.height/3))
		skeleton:getAnimation():play(ACTION_HOLD)
		shodowSprite:addChild(skeleton)
		
		self.panel:setLabelText("lab_heroName",selectHero.heroName)
		self.panel:setLabelText("lab_heroLevel","Lv."..selectHero.level)
		self.panel:setImageTexture("img_heroCareer",IconPath.zhiye..selectHero.careerId..".png")
		self.panel:setNodeVisible("img_maxStar",selectHero.star >= 10)
	end
	
	--更新装备
    local function refreshEquip(idx)
		local userEquips = DataManager.getUserHeroEquipList(hero.userHeroId)
		local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId,hero.level,userEquips)
		
        self.panel:setLabelText("lab_strength"..idx,math.ceil(showAttr.strength))
	    self.panel:setLabelText("lab_agile"..idx,math.ceil(showAttr.agile))
	    self.panel:setLabelText("lab_stamina"..idx,math.ceil(showAttr.stamina))
	    self.panel:setLabelText("lab_intelligence"..idx,math.ceil(showAttr.intelligence))
		
		if not isView then
			self.panel:setLabelText("lab_attackPower",math.ceil(showAttr.attackPower))
			self.panel:setLabelText("lab_magicPower",math.ceil(showAttr.magicPower))
			self.panel:setLabelText("lab_phyCrit",showAttr.phyCrit)
			self.panel:setLabelText("lab_armor",showAttr.armor)
			self.panel:setLabelText("lab_dodge",showAttr.dodge)
			self.panel:setLabelText("lab_parry",showAttr.parry)
		end
    end
	
	--刷新材料
	local function refreshMaterial()
		local tempList = {}
		local promoteStar = DataManager.getSystemHeroPromoteStar(selectHero.star,clickType)
		local materialList = Split(promoteStar.needMaterial,"|")
		for k,v in pairs(materialList)do
			tempList[k] = Split(v,",")
		end
	
		for k=1,2 do
			self.panel:setLabelText("lab_toolNum"..k,"")
			if toolSpriteList[k] then
				toolSpriteList[k]:removeFromParent(true)
			end
		end
		toolSpriteList = {}
		selectUsertool = nil
		
		for k,v in pairs(tempList)do
			local systemTool = DataManager.getSystemTool(tonumber(v[2]))
			if systemTool then
				local toolNum = DataManager.getUserToolNum(systemTool.toolId) or 0
				self.panel:setLabelText("lab_toolNum"..k,toolNum.."/"..v[3])
				
				local bgSprite = self.panel:getChildByName("img_bg"..k)
				if bgSprite then
					local size = bgSprite:getContentSize()
					local iconSprite = IconUtil.GetIconByIdType(tonumber(v[1]),tonumber(v[2]),nil,{})
					iconSprite:setPosition(cc.p(size.width/2,size.height/2))
					bgSprite:addChild(iconSprite)
					table.insert(toolSpriteList,iconSprite)
				end
			end
		end
		
		local userBo = DataManager.getUserBO()
		local const = DataManager.getSystemConfig().hero_promote_star_cost
		local gold = selectHero.star * selectHero.heroColor * userBo.level * const
		
		if clickType == 1 then
			successNum = 10000
		else
			successNum = promoteStar.upperNum
		end
		self.panel:setLabelText("lab_success",(successNum/100).."%")
		self.panel:setLabelText("lab_gold",gold)
	end
	
	--点击幸运石
	local function callBack(userTool)
		local bgSprite = self.panel:getChildByName("img_bg2")
		local size = bgSprite:getContentSize()
		local iconSprite = IconUtil.GetIconByIdType(userTool.type,userTool.toolId)
		iconSprite:setPosition(cc.p(size.width/2,size.height/2))
		bgSprite:addChild(iconSprite)
		table.insert(toolSpriteList,iconSprite)
		
		successNum = userTool.num + successNum
		successNum = successNum > 10000 and 10000 or successNum
		self.panel:setLabelText("lab_success",(successNum/100).."%")
		self.panel:setNodeVisible("img_toolBg",false)
		self.panel:setLabelText("lab_toolNum2",1)
		selectUsertool = userTool
	end

	--选择人物
	local function autoCurrentShowHero()
		local tempIdx = 0
		local heroList = DataManager.getUserHeroMap()
		for k,v in pairs(heroList)do
			tempIdx = tempIdx + 1
			if selectHeroIdx == -1 then
				if v.isTeamLeader == 1 then
					selectHero = v
					selectHeroIdx = tempIdx
				end
			else
				if selectHeroIdx == tempIdx then
					selectHero = v
				end
			end
		end
		self.panel:setNodeVisible("btn_left",selectHeroIdx > 1)
		self.panel:setNodeVisible("btn_right",selectHeroIdx < tempIdx)
		refreshHero()
		refreshEquip(1)
		refreshEquip(2)
		refreshMaterial()
	end
	autoCurrentShowHero()
	
	local function refreshStarUI(idx)
		clickType = idx
		refreshMaterial()
		self.panel:setBtnEnabled("btn_cl",idx ~= 1)
		self.panel:setBtnEnabled("btn_dj",idx ~= 2)
		self.panel:setNodeVisible("btn_add",idx == 2)
	end
	refreshStarUI(1)
	
	function HeroStarUIPanel_HeroAction_promoteHeroStar(msgObj)
		autoCurrentShowHero()
	end
	
	local function netPromoteHeroStarReq()
		local toolId = 0
		local toolNum = 0
		local toolType = 0
		local promoteHeroStarReq = HeroAction_promoteHeroStarReq:New()
		promoteHeroStarReq:setInt_type(clickType)
		promoteHeroStarReq:setString_userHeroId(selectHero.userHeroId)
		if selectUsertool and clickType == 2 then
			toolNum = 1
			toolId = selectUsertool.toolId
			toolType = selectUsertool.type
		end
		local goodsBeanBO = GoodsBeanBO:New()
		goodsBeanBO:setInt_goodsType(toolType)
		goodsBeanBO:setInt_goodsId(toolId)
		goodsBeanBO:setInt_goodsNum(toolNum)
		promoteHeroStarReq:setGoodsBeanBO_tool(goodsBeanBO)
		NetReqLua(promoteHeroStarReq,true)
	end
	
	--业务逻辑编写处
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			refreshStarUI(1)
		elseif tag == 2 then
			refreshStarUI(2)
		elseif tag == 3 then
			netPromoteHeroStarReq()
		elseif tag == 4 then
			LayerManager.show("HeroInheritUIPanel",{hero=selectHero})
		elseif tag == 5 then
			selectHeroIdx = selectHeroIdx - 1
			autoCurrentShowHero()
		elseif tag == 6 then
			selectHeroIdx = selectHeroIdx + 1
			autoCurrentShowHero()
		elseif tag == 7 then
			LayerManager.show("HeroStoneUIPanel",{callBack=callBack})
		end
	end	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_cl",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_dj",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_star",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_inherit",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_left",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_right",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_add",btnCallBack,7)
	
	return panel
end

--退出
function HeroStarUIPanel:Release()
	self.panel:Release()
end

--隐藏
function HeroStarUIPanel:Hide()
	self.panel:Hide()
end

--显示
function HeroStarUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
