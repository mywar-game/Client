HeroInheritUIPanel = {
panel = nil,
}
function HeroInheritUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroInheritUIPanel:Create(para)
    local p_name = "HeroInheritUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

	local selectHero = nil
	local currentHero = para.hero
	local skeletonList = {}
	local toolSpriteList = {}
	local starSpriteList = {{},{}}
	
	local function refreshTool()
		local tempList = {}
		local heroInherit =  DataManager.getSystemHeroInherit(currentHero.star)
		local materialList = Split(heroInherit.needMaterial,"|")
		for k,v in pairs(materialList)do
			tempList[k] = Split(v,",")
		end
		
		for k,v in pairs(toolSpriteList) do
			toolSpriteList[k]:removeFromParent(true)
		end
		toolSpriteList = {}
		
		for k,v in pairs(tempList)do
			local systemTool = DataManager.getSystemTool(tonumber(v[2]))
			if systemTool then
				local toolNum = DataManager.getUserToolNum(systemTool.toolId) or 0
				self.panel:setLabelText("lab_toolNum"..k,toolNum.."/"..v[3])
			
				local bgSprite = self.panel:getChildByName("img_bg"..k)
				if bgSprite then
					local size = bgSprite:getContentSize()
					local iconSprite = IconUtil.GetIconByIdType(systemTool.type,systemTool.toolId,nil,{})
					iconSprite:setPosition(cc.p(size.width/2,size.height/2))
					bgSprite:addChild(iconSprite)
					table.insert(toolSpriteList,iconSprite)
				end
			end
		end
	end
	refreshTool()
	
	--更新英雄
	local function refreshHero(idx,hero)
		local shodowSprite = self.panel:getChildByName("img_shodow"..idx)
		local size = shodowSprite:getContentSize()
		for k,v in pairs(starSpriteList[idx])do
			v:removeFromParent(true)
		end
		starSpriteList[idx] = {}
		
		for k=1,hero.star do
			local starSprite = CreateCCSprite(IconPath.yingxiongshenxing.."i_xingx.png")
			local starSize = starSprite:getContentSize()
			local x = (size.width - hero.star * 15)/2 + 15*k - starSize.width/2
			starSprite:setPosition(cc.p(x,240))
			shodowSprite:addChild(starSprite)
			table.insert(starSpriteList[idx],starSprite)
		end
		
		if skeletonList[idx] then
			skeletonList[idx]:Release()
		end
		
		local skeletonHero = SkeletonAction:New()
		skeleton = skeletonHero:Create(hero.resId)
		skeleton:setPosition(cc.p(size.width/2-20,50))
		skeleton:getAnimation():play(ACTION_HOLD)
		shodowSprite:addChild(skeleton)
		skeletonList[idx] = skeletonHero 
		
		self.panel:setLabelText("lab_heroName"..idx,hero.heroName)
		self.panel:setLabelText("lab_heroLevel"..idx,"Lv."..hero.level)
		self.panel:setImageTexture("img_heroCareer"..idx,IconPath.zhiye..hero.careerId..".png")
		self.panel:setNodeVisible("img_maxStar"..idx,hero.star >= 10)
	end
	
	
	--更新装备
    local function refreshEquip(idx,hero,star)
        local userEquips = DataManager.getUserHeroEquipList(hero.userHeroId)
		local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId,hero.level,userEquips)
		
        self.panel:setLabelText("lab_strength"..idx,math.ceil(showAttr.strength))
	    self.panel:setLabelText("lab_agile"..idx,math.ceil(showAttr.agile))
	    self.panel:setLabelText("lab_stamina"..idx,math.ceil(showAttr.stamina))
	    self.panel:setLabelText("lab_intelligence"..idx,math.ceil(showAttr.intelligence))
    end
	refreshHero(1,currentHero)
	refreshEquip(1,currentHero,currentHero.star)
	refreshEquip(2,currentHero,1)
	
	
	--类别选择
	local function OnItemShowCallback(scroll_view,item,data,idx)
		self.panel:setItemLabelText(item,"lab_starNum",data.star)
		self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..data.imgId..".png")
		self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..data.heroColor..".png")
	end
	
	local function OnItemClickCallback(item,data,idx)
		if currentHero.star <= data.star then
			Tips(GameString.inheritLowStar)
		else
			selectHero = data
			refreshHero(2,selectHero)
			refreshEquip(3,selectHero,selectHero.star)
			refreshEquip(4,selectHero,currentHero.star)
			self.panel:setNodeVisible("ListView",false)
			self.panel:setNodeVisible("img_title",true)
			self.panel:setNodeVisible("img_heroCareer2",true)
			self.panel:setNodeVisible("lab_heroLevel2",true)
		end
	end
	
	local function refreshSelectHero()
		self.panel:setNodeVisible("btn_addHero",false)
		self.panel:setNodeVisible("ListView",true)
		local heroList = DataManager.getUserHeroList()
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,nil,nil,3)
	end
	
	function HeroInheritUIPanel_HeroAction_heroInherit(msgObj)
		currentHero = DataManager.getUserHeroId(currentHero.userHeroId)
		selectHero = DataManager.getUserHeroId(selectHero.userHeroId)
		
		refreshHero(1,currentHero)
		refreshEquip(1,currentHero,currentHero.star)
		refreshEquip(2,currentHero,currentHero.star)
		
		refreshHero(2,selectHero)
		refreshEquip(3,selectHero,selectHero.star)
		refreshEquip(4,selectHero,selectHero.star)
		self.panel:setBtnEnabled("btn_inherit",false)
	end
	
	local function netHeroAction_heroInheritReq()
		if selectHero then
			local heroInheritReq = HeroAction_heroInheritReq:New()
			heroInheritReq:setString_userHeroId(currentHero.userHeroId)
			heroInheritReq:setString_targetUserHeroId(selectHero.userHeroId)
			NetReqLua(heroInheritReq,true)
		else
			Tips(GameString.selectInheritHero)
		end
	end
	
	--业务逻辑编写处
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			netHeroAction_heroInheritReq()
		elseif tag == 2 then
			refreshSelectHero()
		end
	end	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_inherit",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_addHero",btnCallBack,2)
	
	return panel
end

--退出
function HeroInheritUIPanel:Release()
	self.panel:Release()
end

--隐藏
function HeroInheritUIPanel:Hide()
	self.panel:Hide()
end

--显示
function HeroInheritUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
