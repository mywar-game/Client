require("PackageUIPanel")
FriendLineupUIPanel = {
panel = nil,
}
function FriendLineupUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function FriendLineupUIPanel:Create(para)
    local p_name = "FriendLineupUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--业务逻辑编写处
	local friendUserId = para.friendId
	local userData = {}
	
	--网络请求
	local function reqFriend(userId)
		local req = HeroAction_getUserBattleInfoReq:New()
		req:setString_userId(userId)
		NetReqLua(req, true)
	end
	reqFriend(friendUserId)
	
	
	local heroList = {}
	local equipListIndexHeroId = {}
	local stoneListIndexEquipId = {}
	
	local hero
	local skeleton = nil
	local skeletonHero = nil
	local packagePanel = nil
	local selectHeroIdx = -1
	local effectList = {}
	local starSpriteList = {}
	local heroListViewData = {}
	local shodowSprite = self.panel:getChildByName("img_shodow")
	local borderSprite = self.panel:getChildByName("img_border")
	--local bagX,bagY = self.panel:getChildByName("Panel_bag"):getPosition()
	
	local function reFreshHero()
		local size = shodowSprite:getContentSize()
		for k,v in pairs(starSpriteList)do
			v:removeFromParent(true)
		end
		
		if skeletonHero then
			skeletonHero:Release()
		end
		skeletonHero = SkeletonAction:New()
		skeleton = skeletonHero:Create(hero.resId)
		skeleton:setPosition(cc.p(size.width/2,size.height/3))
		skeleton:getAnimation():play(ACTION_HOLD)
		shodowSprite:addChild(skeleton)
	
		self.panel:setLabelText("lab_heroName",hero.heroName)
		self.panel:setLabelText("lab_levelNum","Lv."..hero.level)
		self.panel:setLabelText("lab_heroequipLevel", hero.effective)
		self.panel:setBitmapText("lab_heroCareer", GameString.careerId1ToStr[hero.careerId])
	end
	
    --更新装备
    local function reFreshEquip()
        local userEquips = equipListIndexHeroId[hero.userHeroId]
        for i=1,8 do--清空当前装备
            local equipIcon = self.panel:getChildByName("img_equip_"..i)
            equipIcon:removeAllChildren()
        end 
		if nil == userEquips then
			return
		end
		--插入装备
        for k,v in pairs(userEquips) do
            local iconSprite = nil
			local equipIcon = self.panel:getChildByName("img_equip_"..v.pos)
			local iconSize = equipIcon:getContentSize()
			local gemstone = stoneListIndexEquipId[userEquipId] --宝石
			
            iconSprite = IconUtil.GetIconByIdType(GameField.equip, v.equipId, nil, {data=v,touchCallBack=nil})
            iconSprite:setPosition(cc.p(iconSize.width/2,iconSize.height/2))
            equipIcon:addChild(iconSprite)
        end
    end
	
	--英雄技能
	local function heroSkillUI()
		local skillList = {}
		for k=1,4 do
			local skill = hero["skill0"..k]
			if skill > 0 then
				local heroSkill = DataManager.getSystemHeroSkillId(skill,1)
				local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
				table.insert(skillList,systemSkill)
			end
		end
	
		local clickSprite = nil
		local function clickItemInfo(item,data,idx)
			--[[if clickSprite then
				clickSprite:setVisible(false)
			end
			if data.singTime == 0 then
				self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime1)
			else
				self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime2..data.singTime.."S")
			end
			self.panel:setLabelText("lab_heroSkillname",data.name)
			self.panel:setLabelText("lab_skillTime",data.cdTime.."S")
			self.panel:setLabelText("lab_skillDesc",data.remark)]]
			--self.panel:setLabelText("lab_skillAdvanced",GameString["heroSkillDesc"..idx])
		end
		
		local function OnItemShowCallback(scroll_view,item,data,idx)
			if clickSprite == nil then
				clickItemInfo(item,data,idx)
			end
			
			if hero.level <= GameField.openLevel[idx] then
				self.panel:setItemNodeVisible(item,"img_lock",true)
				self.panel:setItemLabelText(item,"lab_skillname",GameString["heroSkillLock"..idx])
			else
				self.panel:setItemNodeVisible(item,"img_skillHead",true)
				self.panel:setItemLabelText(item,"lab_skillname",GameString["heroSkillDesc"..idx])
			end
			self.panel:setItemLabelText(item,"lab_skillname",data.name)
			self.panel:setItemImageTexture(item,"img_skillHead",IconPath.jineng..data.imgId..".png")
		end
		
		local function OnItemClickCallback(item,data,idx)
			clickItemInfo(item,data,idx)
		end
		self.panel:InitListView(skillList,OnItemShowCallback,OnItemClickCallback,"ListView_skill","ListItem_skill")
	end
	
	--显示当前英雄的属性
	local function reFreshHeroAttrUI()
		local userEquips = equipListIndexHeroId[hero.userHeroId] or {}
		local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId,hero.level,userEquips)
		local attrToName = LabelChineseStr.FriendLineupUIPanel_Attr
		local count = 1
		for k, v in pairs(attrToName) do
			--table.insert(atrtList, {name = v, value = math.ceil(showAttr[k])})
			local item = self.panel:getChildByName("ListItem_attr_" .. count)
			self.panel:setItemLabelText(item, "lab_attrvalue", math.ceil(showAttr[k]))
			count = count + 1
		end
	end
	
	--英雄
	local clickHeroSprite = nil
	local function clickHero(item,data,idx)
		if hero.systemHeroId ~= data.systemHeroId then
			if clickHeroSprite then
				clickHeroSprite:setVisible(false)
			end
			clickHeroSprite = self.panel:getItemChildByName(item,"img_select")
			clickHeroSprite:setVisible(true)
			
			hero = data
			reFreshHero()
			reFreshHeroAttrUI()
			reFreshEquip()
			heroSkillUI()
		end
	end
	
	local function heroViewUI()
		local function OnItemShowCallback(scroll_view,item,data,idx)
			if data.systemHeroId == hero.systemHeroId then
				selectHeroIdx = idx
				clickHeroSprite = self.panel:getItemChildByName(item,"img_select")
				clickHeroSprite:setVisible(true)
			end
		
			if data.isTeamLeader == 1 then
				local size = item:getContentSize()
				local sprite = CreateCCSprite(IconPath.duiwupeizhi.."i_huangguang.png")
				sprite:setPosition(cc.p(size.width/2,80))
				item:addChild(sprite,10)
			end
			table.insert(heroListViewData,{item=item,data=data,idx=idx})
			
			self.panel:setItemImageTexture(item,"img_head",IconPath.yingxiong..data.imgId..".png")
			self.panel:setItemImageTexture(item,"img_color",IconPath.pinzhiYaun..data.heroColor..".png")
		end
		
		local function OnItemClickCallback(item,data,idx)
			if nil ~= nodeVisibleIdx then
				nodeVisibleIdx(2)
			end
			clickHero(item,data,idx)
		end
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,"ListView_hero","ListItem_hero")
	end
	
	local function analysisData(data)
		-- heroList
		for k, v in pairs(data.userHeroList) do
			local friendhero = DataTranslater.tranFriendHero(v)
			friendhero.userHeroId = v.userHeroId
			friendhero.isTeamLeader = v.isTeamLeader
			if 1 == v.isTeamLeader then
				hero = friendhero
				table.insert(heroList, 1 ,friendhero)
			else
				table.insert(heroList, friendhero)
			end
		end
		-- equipListIndexHeroId
		for k , v in pairs(data.userEquipList) do
			if nil == equipListIndexHeroId[v.userHeroId] then
				equipListIndexHeroId[v.userHeroId] = {}
			end
			local newEquip = DataTranslater.tranEquip(v)
			table.insert(equipListIndexHeroId[v.userHeroId], newEquip)
		end
		-- stoneListIndexEquipId
		for k, v in pairs(data.userGemstoneList) do
			if nil == stoneListIndexEquipId[v.userEquipId] then
				stoneListIndexEquipId[v.userEquipId] = {}
			end
			table.insert(stoneListIndexEquipId[v.userEquipId], v)
		end
	end
	
	local function initUserUI()
		local function formatNum(num)
			if num > 9999999 then
				num = math.floor(num/1000000)..'M'
			elseif num > 99999 then 
				num = math.floor(num/1000)..'K'
			end
			return num
		end
		local userBo = userData.user
		local teamEpx1,teamEpx2 = DataManager.getSystemTeamExp(userBo.level)
		local baseExp = teamEpx2.exp-teamEpx1.exp
		local curExp = userBo.exp-teamEpx1.exp
		local expBar = curExp / baseExp
		
		self.panel:setBitmapText("lab_level",userBo.level)
		self.panel:setLabelText("lab_name", userBo.roleName)
        self.panel:setBitmapText("lab_vip", userBo.vipLevel)
		self.panel:setLabelText("lab_heroExp",curExp.."/"..baseExp)
		self.panel:setProgressBarPercent("pro_exp",expBar*100)
		self.panel:setBitmapText("lab_effective", userBo.effective)
		
		self.panel:setImageTexture("img_heroHead",IconPath.yingxiong..hero.imgId..".png")
		self.panel:setImageTexture("img_heroColor",IconPath.pinzhiYaun..hero.heroColor..".png")
	end
	--网络响应
	--收到网络响应后  初始化ui界面
	function FriendLineupUIPanel_HeroAction_getUserBattleInfo(msgObj)
		userData = DeepCopy(msgObj.body)
		analysisData(userData)
		initUserUI()
		reFreshHeroAttrUI()
		reFreshHero()
		reFreshEquip()
		heroSkillUI()
		heroViewUI()
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		end
	end	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    self.panel.layer:setTouchEnabled(true)
	--self.panel.layer:registerScriptTouchHandler(FriendLineupUIPanel_Ontouch,false,0,true)
	
	return panel
end

--退出
function FriendLineupUIPanel:Release()
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function FriendLineupUIPanel:Hide()
	self.panel:Hide()
end

--显示
function FriendLineupUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
