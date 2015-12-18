require("PackageUIPanel")
HeroDescUIPanel = {
panel = nil,
}
function HeroDescUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroDescUIPanel:Create(para)
    local p_name = "HeroDescUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--业务逻辑编写处
	local hero = para.hero
	local skeleton = nil
	local selectSkill = nil
	local skeletonHero = nil
	local packagePanel = nil
	local skillDescLab = nil
	local selectHeroIdx = -1
	local isCanPromote = false
	local effectList = {}
	local starSpriteList = {}
	local heroListViewData = {}
	
	self.rightLog = self.panel:getChildByName("img_right")
	self.leftLog = self.panel:getChildByName("img_left")
	
	local actionArr = {}
	actionArr[1] = cc.FadeOut:create(1)
	actionArr[2] = cc.FadeIn:create(1)
	local seq = cc.Sequence:create(actionArr)
	local repe = cc.RepeatForever:create(seq)
	self.rightLog:runAction(repe:clone())
	self.leftLog:runAction(repe)
	
	local shodowSprite = self.panel:getChildByName("img_shodow")
	local borderSprite = self.panel:getChildByName("img_border")
	local bagX,bagY = self.panel:getChildByName("Panel_bag"):getPosition()
	local function reFreshHero()
		local size = shodowSprite:getContentSize()
		for k,v in pairs(starSpriteList)do
			v:removeFromParent(true)
		end
		starSpriteList = {}
		--[[for k=1,hero.star do
			local starSprite = CreateCCSprite(IconPath.yingxiongshenxing.."i_xingx.png")
			local starSize = starSprite:getContentSize()
			local x = (size.width - hero.star * 15)/2 + 15*k - starSize.width/2
			starSprite:setPosition(cc.p(x,310))
			shodowSprite:addChild(starSprite)
			table.insert(starSpriteList,starSprite)
		end]]
		
		if skeletonHero then
			skeletonHero:Release()
		end
		
		skeletonHero = SkeletonAction:New()
		skeleton = skeletonHero:Create(hero.resId)
		skeleton:setPosition(cc.p(size.width/2,size.height/3))
		skeleton:getAnimation():play(ACTION_HOLD)
		shodowSprite:addChild(skeleton)
		
		local heroExp1 = DataManager.getSystemHeroLevel(hero.heroColor,hero.level)
		local heroExp2 = DataManager.getSystemHeroLevel(hero.heroColor,hero.level+1)

		isCanPromote = DataManager.isSystemHeroCanPromote(hero.systemHeroId)
		self.panel:setBtnEnabled("btn_advanced",isCanPromote)

	
		self.panel:setLabelText("lab_heroName",hero.heroName)
		self.panel:setBitmapText("lab_levelNum","Lv."..hero.level)
		self.panel:setBitmapText("lab_effective", hero.effective)
		self.panel:setLabelText("lab_expNum",(hero.exp-heroExp1).."/"..(heroExp2-heroExp1))
		self.panel:setBitmapText("lab_heroCareer", GameString.careerId1ToStr[hero.careerId])
		self.panel:setProgressBarPercent("pro_exp",(hero.exp-heroExp1)/(heroExp2-heroExp1)*100)
		--self.panel:setBtnEnabled("btn_advanced",hero.isTeamLeader ~= 1)
	end
	reFreshHero()
	
    --更新装备
    local function reFreshEquip()
        local userEquips = DataManager.getUserHeroEquipList(hero.userHeroId)
		local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId,hero.level,userEquips)
		
        for i=1,8 do--清空当前装备
            local equipIcon = self.panel:getChildByName("img_equip_"..i)
            equipIcon:removeAllChildren()
        end 
        
		local moveSprite = nil
		local function equipWearCallBack(para)
			if para.type == GameField.Event_Move then--处理拖动
				if not moveSprite then
					moveSprite = IconUtil.GetIconByIdType(para.data.type,para.data.equipId,nil)
					self.panel.layer:addChild(moveSprite,0xffff)
				end
				moveSprite:setPosition(self.panel.layer:convertToNodeSpace(para.touchPos))
				para.sprite:setVisible(false)
			elseif para.type == GameField.Event_End then--处理按下起立
				if moveSprite then
					para.sprite:setVisible(true)
					moveSprite:removeFromParent(true)
					moveSprite = nil
				
					local bagPanel = self.panel:getChildByName("Panel_bag")
					if bagPanel:isVisible() then		
						local bagListView = packagePanel.panel:getChildByName("ListView")
						local location = bagListView:convertToNodeSpace(para.touchPos)
						local size = bagListView:getContentSize()
						local rect = cc.rect(0,0,size.width,size.height)
						if cc.rectContainsPoint(rect,location) then
							local unWearEquipReq = EquipAction_unWearEquipReq:New()
							unWearEquipReq:setString_userEquipId(para.data.userEquipId)
							NetReqLua(unWearEquipReq,true)
						end
					end
				end
			elseif para.type == GameField.Event_DoubleClick then
				--卸下装备请求
				local unWearEquipReq = EquipAction_unWearEquipReq:New()
				unWearEquipReq:setString_userEquipId(para.data.userEquipId)
				NetReqLua(unWearEquipReq, true)
			end
		end
		
		--插入装备
        for k,v in pairs(userEquips) do
            local iconSprite = nil
			local equipIcon = self.panel:getChildByName("img_equip_"..v.pos)
			local iconSize = equipIcon:getContentSize()
			local gemstone = DataManager.getEquipGemstoneList(v.userEquipId) --宝石
			
            local function iconTouchEvent(type,touchPos)
				equipWearCallBack({type=type,touchPos=touchPos,data=v,sprite=iconSprite})
            end
            iconSprite = IconUtil.GetIconByIdType(GameField.equip,v.equipId,nil,{data=v,touchCallBack=iconTouchEvent})
            iconSprite:setPosition(cc.p(iconSize.width/2,iconSize.height/2))
            equipIcon:addChild(iconSprite)
        end
		
        --界面数据更新(涉及到装备的)
		local s1 = ""
		local s2 = ""
		local s3 = ""
		local s4 = ""
		local c1 = cc.c3b(255,255,255)
		local c2 = cc.c3b(255,255,255)
		local c3 = cc.c3b(255,255,255)
		local c4 = cc.c3b(255,255,255)
					
		if hero.mainPropertyId == StaticField.mainPropertyId1 then
			c1 = cc.c3b(255,0,0)
			s1 = GameString.mainAttr
		elseif hero.mainPropertyId == StaticField.mainPropertyId2 then
			c2 = cc.c3b(255,0,0)
			s2 = GameString.mainAttr
		elseif hero.mainPropertyId == StaticField.mainPropertyId3 then
			c3 = cc.c3b(255,0,0)
			s3 = GameString.mainAttr
		elseif hero.mainPropertyId == StaticField.mainPropertyId4 then
			c4 = cc.c3b(255,0,0)
			s4 = GameString.mainAttr
		end
		self.panel:setLabelText("lab_strength",math.ceil(showAttr.strength)..s1,c1)
		self.panel:setLabelText("lab_agile",math.ceil(showAttr.agile)..s2,c2)
		self.panel:setLabelText("lab_intelligence",math.ceil(showAttr.intelligence)..s3,c3)
		self.panel:setLabelText("lab_stamina",math.ceil(showAttr.stamina)..s4,c4)

		self.panel:setLabelText("lab_hp",math.ceil(showAttr.hp))
	    self.panel:setLabelText("lab_attackPower",math.ceil(showAttr.attackPower))
	    self.panel:setLabelText("lab_magicPower",math.ceil(showAttr.magicPower))
	    self.panel:setLabelText("lab_phyCrit",math.ceil(showAttr.phyCrit))
	    self.panel:setLabelText("lab_armor",math.ceil(showAttr.armor))
	    self.panel:setLabelText("lab_resistance",math.ceil(showAttr.resistance))
	    self.panel:setLabelText("lab_dodge",math.ceil(showAttr.dodge))
	    self.panel:setLabelText("lab_parry",math.ceil(showAttr.parry))
	    self.panel:setLabelText("lab_speedUp",math.ceil(showAttr.speedUp))
		
		local paras1 = DataManager.getSystemFormulaParaId(StaticField.formula5)
		local paras2 = DataManager.getSystemFormulaParaId(StaticField.formula10)
		
		local standardRate = DataManager.getSystemFightStandardRate()
		local standardValue = DataManager.getSystemFightStandardValue(hero.level)
		
		local armorNum = Formula.conversionRate(showAttr.armor,standardValue.armorValue,standardRate.armorRate)
		local resistanceNum = Formula.conversionRate(showAttr.resistance,standardValue.resistanceValue,standardRate.resistanceRate)
		local critNum = Formula.conversionRate(showAttr.phyCrit,standardValue.critValue,standardRate.critRate)+showAttr.critOdds
		local dodgeNum = Formula.conversionRate(showAttr.dodge,standardValue.dodgeValue,standardRate.dodgeRate)+showAttr.dodgeOdds
		local parryNum = Formula.parry(0,showAttr.parry,showAttr.parryOdds,standardValue,standardRate,paras1) --属性中已经添加装备格挡
		local speedOdds = Formula.speedOdds(showAttr.speedUp,hero.level,paras2)+showAttr.speedOdds
		
	    self.panel:setLabelText("lab_armorEx",string.format(GameString.armorDesc,armorNum*100))
	    self.panel:setLabelText("lab_resistanceEx",string.format(GameString.resistanceDesc,resistanceNum*100))
	    self.panel:setLabelText("lab_phyCritEx",string.format(GameString.phyCritDesc,critNum*100))
	    self.panel:setLabelText("lab_dodgeEx",string.format(GameString.dodgeDesc,dodgeNum*100))
	    self.panel:setLabelText("lab_parryEx",string.format(GameString.parryDesc,parryNum*100))
	    self.panel:setLabelText("lab_speedUpEx",string.format(GameString.speedUpDesc,speedOdds*100))
    end
	reFreshEquip()
	
	--英雄技能
	local function showSkillHurt()
		local userEquips = DataManager.getUserHeroEquipList(hero.userHeroId)
		local showAttr = EquipDetailUtil.refreshHeroAttr(hero.systemHeroId,hero.level,userEquips)
		local stringTab = EquipDetailUtil.showSkillData(showAttr,selectSkill)
		local descLab = self.panel:getChildByName("lab_skillDesc")
		local x,y = descLab:getPosition()
		local size = descLab:getContentSize()
		
		if skillDescLab then
			skillDescLab:removeFromParent(true)
		end
		
		skillDescLab = createRichColorLabel(stringTab,18,size)
		skillDescLab:setPosition(x+size.width/2,y-150)
		skillDescLab:getAnchorPoint(cc.p(0,1))
		self.panel:getChildByName("img_skillleft"):addChild(skillDescLab)
	end
	
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
			if clickSprite then
				clickSprite:setVisible(false)
			end
			if data.singTime == 0 then
				self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime1)
			else
				self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime2..data.singTime.."S")
			end
			
			self.panel:setLabelText("lab_heroSkillname",data.name)
			self.panel:setLabelText("lab_skillTime",data.cdTime.."S")
			self.panel:setLabelText("lab_skillAdvanced",GameString["heroSkillDesc"..idx])
			clickSprite = self.panel:getItemChildByName(item,"img_select")
			clickSprite:setVisible(true)
		end
		
		local function OnItemShowCallback(scroll_view,item,data,idx)
			if clickSprite == nil then
				selectSkill = data
				showSkillHurt()
				clickItemInfo(item,data,idx)
			end
			
			if hero.level <= GameField.openLevel[idx] then
				self.panel:setItemNodeVisible(item,"img_lock",true)
				self.panel:setItemLabelText(item,"lab_levelDesc",GameString["heroSkillLock"..idx])
			else
				self.panel:setItemNodeVisible(item,"img_skillHead",true)
				self.panel:setItemLabelText(item,"lab_levelDesc",GameString["heroSkillDesc"..idx])
			end
			self.panel:setItemLabelText(item,"lab_skillName",data.name)
			self.panel:setItemImageTexture(item,"img_skillHead",IconPath.jineng..data.imgId..".png")
		end
		
		local function OnItemClickCallback(item,data,idx)
			selectSkill = data
			showSkillHurt()
			clickItemInfo(item,data,idx)
		end
		self.panel:InitListView(skillList,OnItemShowCallback,OnItemClickCallback,"ListView_skill","ListItem_skill")
	end
	heroSkillUI()
	
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
			reFreshEquip()
			heroSkillUI()
		end
	end
	
	local nodeVisibleIdx = nil
	local function heroViewUI()
		local heroList = DataManager.getUserHeroList()
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
			
			self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..data.imgId..".png")
			self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..data.heroColor..".png")
		end
		
		local function OnItemClickCallback(item,data,idx)
			if nil ~= nodeVisibleIdx then
				nodeVisibleIdx(2)
			end
			clickHero(item,data,idx)
		end
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,"ListView_hero","ListItem_hero",3)
	end
	heroViewUI()
	
	
	local cacheMoveSprite = nil
	local function checkPos(pos,posList)--检查位置是否正确
        for i=1,#posList do
            if tonumber(posList[i]) == pos then
                return true
            end
        end
        return false
    end
	
	local function checkCareer(careerId,careerList)--检查职业是否正确
        for i=1,#careerList do
            local numCareer = tonumber(careerList[i])
            if numCareer == 0 or numCareer == careerId then
                return true
            end
        end
        return false
    end
	
	local function requestWear(pos,data)--请求穿戴 pos传0为快速穿戴
		--请求穿戴(可以 本地先做一下筛选)
		local systemEquip = DataManager.getSystemEquip(data.equipId)
		if not checkCareer(hero.careerId,systemEquip.needCareer) then
			Tips(LabelChineseStr.HeroInfoUIPanel_3)
		elseif pos ~= 0 and not checkPos(pos,systemEquip.equippos) then
			Tips(LabelChineseStr.HeroInfoUIPanel_4)
		elseif hero.level < systemEquip.needLevel then
			Tips(LabelChineseStr.HeroInfoUIPanel_2)
		else--请求穿戴
			local wearEquipReq = EquipAction_wearEquipReq:New()
			wearEquipReq:setString_userHeroId(hero.userHeroId)
			wearEquipReq:setString_userEquipId(data.userEquipId)
			wearEquipReq:setInt_pos(pos)
			NetReqLua(wearEquipReq, true)
		end
    end
	
	local function checkContain(touchPos)--检查是否进入指定装备位置
        for i=1,8 do
            local equipIcon = self.panel:getChildByName("img_equip_"..i)
            local location = equipIcon:convertToNodeSpace(touchPos)
            local s = equipIcon:getContentSize()
            local rect = cc.rect(0,0,s.width,s.height)
            if cc.rectContainsPoint(rect,location) then
                return i
            end
        end
        return nil
    end
	
	--添加装备提示
	local function addEquipTips(equipId)
		local systemEquip = DataManager.getSystemEquip(equipId)
		if checkCareer(hero.careerId,systemEquip.needCareer) and hero.level >= systemEquip.needLevel then --判断职业和等级
			for k,v in pairs(systemEquip.equippos)do
				for i=1,8 do 
					if i == tonumber(v) then
						local equipIcon = self.panel:getChildByName("img_equip_"..i)
						local size = equipIcon:getContentSize()
						local skeleton = CreateEffectSkeleton("t17")
						skeleton:setPosition(cc.p(size.width/2,size.height/2))
						equipIcon:addChild(skeleton,10)
						table.insert(effectList,skeleton)
					end
				end
			end
		end
	end
	
	local function equipTouchCallBack(para)
		if para.type == GameField.Event_Back then
		    self:Release()
        elseif para.type == GameField.Event_Move then--处理拖动
            if not cacheMoveSprite then
				addEquipTips(para.data.equipId)
                cacheMoveSprite = IconUtil.GetIconByIdType(para.data.type,para.data.equipId, nil)
                self.panel.layer:addChild(cacheMoveSprite,0xffff)
            end
            cacheMoveSprite:setPosition(self.panel.layer:convertToNodeSpace(para.touchPos))
            para.sprite:setVisible(false)
        elseif para.type == GameField.Event_End then--处理按下起立
            if cacheMoveSprite then
                cacheMoveSprite:removeFromParent()
                local index=checkContain(para.touchPos)
                if index then
                    requestWear(index,para.data) 
                end
				
				for k,v in pairs(effectList)do
					v:removeFromParent(true)
				end
                para.sprite:setVisible(true)
                cacheMoveSprite = nil
				effectList = {}
            end
        elseif para.type == GameField.Event_DoubleClick then	
		    UserGuideUIPanel.stepClick( "image_item_guide" )
            requestWear(0,para.data)
        end
	end
	
	--背包
	local function heroPackageUI()
		if packagePanel then
			packagePanel:reFreshPackage()
		else
			local panelBag = self.panel:getChildByName("Panel_bag")
			packagePanel = PackageUIPanel:New()
			local package = packagePanel:Create({x=170,y=-13,equipTouchCallBack=equipTouchCallBack,toolTouchCallBack=toolTouchCallBack})
			panelBag:addChild(package.layer)
		end
	end
	heroPackageUI()
	
	local currentIdx = 0
	nodeVisibleIdx = function(idx)
		currentIdx = idx
		local x = 0
		local title = ""
		if idx == 1 then
			x = 1500
			title = GameString.heroSkill
		elseif idx == 2 then
			title = GameString.heroPackage
		elseif idx == 3 then
			x = 1500
			title = GameString.heroList
		end
		self.panel:setBitmapText("bitmap_title",title)
		
		if idx ~= 3 then
			self.panel:setNodeVisible("btn_skill",idx == 2)
			self.panel:setNodeVisible("btn_package",idx == 1)
		end
		
		self.panel:setNodeVisible("img_line2",idx ~= 2)
		self.panel:setNodeVisible("img_heroDeac",idx ~= 1)
		self.panel:setNodeVisible("Panel_bag",idx == 2)
		self.panel:setNodeVisible("Panel_skill",idx == 1)
		self.panel:setNodeVisible("Panel_swtich",idx == 3)
		
		self.panel:getChildByName("Panel_bag"):setPosition(bagX+x,bagY)
	end
	nodeVisibleIdx(para.idx)
	
	local function changeHero(mx)
			selectHeroIdx = selectHeroIdx + mx
		if selectHeroIdx < 1 then
			selectHeroIdx = #heroListViewData
		end
		if selectHeroIdx > #heroListViewData then
			selectHeroIdx = 1
		end
		local viewData = heroListViewData[selectHeroIdx]
		clickHero(viewData.item,viewData.data,viewData.idx)
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
			UserGuideUIPanel.stepClick( "btn_back" ) -- 新手引导监听触发
		elseif tag == 1 then
			nodeVisibleIdx(1)
		elseif tag == 2 then
			local level = DataManager.getUserBO().level
			if GameField.heroPackgeLevel > level then
				Tips(LabelChineseStr.common_null)
			else
				nodeVisibleIdx(2)
			end
		elseif tag == 3 then
			if 3 == currentIdx then
				nodeVisibleIdx(1)
			else
				nodeVisibleIdx(3)
			end
		elseif tag == 4 then
			LayerManager.show("ProfessionAdvancedUIPanel", {hero = hero})
            -- local req = HeroAction_disbandReq:New()
            -- req:setString_userHeroId(hero.userHeroId)
            -- NetReqLua(req, true)
		end
	end	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_skill",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_package",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_switch",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_advanced",btnCallBack,4)
	
	function HeroInfoUIPanel_ToolAction_openBox()
		reFreshEquip()
	end
	
	--穿戴装备
	function HeroDescUIPanel_EquipAction_wearEquip(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_1)
        reFreshEquip()
		showSkillHurt()
		heroPackageUI()
    end
	
	--卸下装备
	function HeroDescUIPanel_EquipAction_unWearEquip(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_5)
        reFreshEquip()
		showSkillHurt()
		heroPackageUI()
    end
	
	--遣散英雄 后重新进入本界面
    function HeroDescUIPanel_HeroAction_disband(msgObj)
        Tips(LabelChineseStr.HeroInfoUIPanel_6)
        DataManager.dismissHero(hero.systemHeroId)
		
		local heroListAll = DataManager.getUserHeroList()
		hero = heroListAll[1]
		reFreshHero()
		reFreshEquip()
		heroViewUI()
		heroSkillUI()
		heroPackageUI()
    end
	
	local isContain = false
	local move = {x=0,y=0}
	local touch = {x=0,y=0}
	local size = shodowSprite:getContentSize()
	local function isTouchHero(x,y)
		local boxRect = skeleton:getBoundingBox()
		local location = shodowSprite:convertToNodeSpace(cc.p(x,y))
		if location.x > boxRect.x and location.x < boxRect.x+boxRect.width and 
		   location.y > boxRect.y and location.y < boxRect.y+boxRect.height then
			return true
		end
		return false
	end
	
	local function moveHero(mx)
		if touch.x-mx > 10 then
			selectHeroIdx = selectHeroIdx - 1
		elseif touch.x-mx < -10 then
			selectHeroIdx = selectHeroIdx + 1
		end
		if selectHeroIdx < 1 then
			selectHeroIdx = #heroListViewData
		end
		if selectHeroIdx > #heroListViewData then
			selectHeroIdx = 1
		end
		local viewData = heroListViewData[selectHeroIdx]
		clickHero(viewData.item,viewData.data,viewData.idx)
	end
	
	local function heroDescUIPanel_Ontouch(e,x,y)
		local tx = shodowSprite:convertToNodeSpace(cc.p(x,y)).x
		local ty = shodowSprite:convertToNodeSpace(cc.p(x,y)).y
		local mx = self.panel.layer:convertToNodeSpace(cc.p(x,y)).x
		local my = self.panel.layer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then	
			move.x = tx
			move.y = ty
			touch.x = mx
			touch.y = my
			isContain = isTouchHero(x,y)
		elseif e=="moved" then
			if isContain then
				self.panel:setNodeVisible("img_left", false)
				self.panel:setNodeVisible("img_right", false)
				if math.abs(tx-move.x) < 60 then
					skeleton:setPosition(cc.p(size.width/2+tx-move.x,size.height/3))
				else
					moveHero(mx)
					self.panel:setNodeVisible("img_left", true)
					self.panel:setNodeVisible("img_right", true)
					isContain = false
				end
			end
		else
			if(not isAbsoluteSprite(borderSprite,x,y)) and 
			  (math.abs(touch.x-mx) < 5 and math.abs(touch.y-my) < 5) then
				local arr = {}
				arr[1] = cc.DelayTime:create(0.01)
				arr[2] = cc.CallFunc:create(function() 
					SoundEffect.playSoundEffect("button")
					if callback and callback() == true then
                        --donothing
					else
					    self:Release()
					end
				end)
				local sq = cc.Sequence:create(arr)
				self.panel.layer:runAction(sq)
			end
			
			if isContain and isTouchHero(x,y) then
				moveHero(mx)
				self.panel:setNodeVisible("img_left", true)
				self.panel:setNodeVisible("img_right", true)
			end
		end
		return true
	end
    self.panel.layer:setTouchEnabled(true)
	self.panel.layer:registerScriptTouchHandler(heroDescUIPanel_Ontouch,false,0,true)
	
	return panel
end

--退出
function HeroDescUIPanel:Release()
	DataManager.clearLastGetGoods()
	if nil ~= self.rightLog then
		self.rightLog:stopAllActions()
	end
	if nil ~= self.leftLog then
		self.leftLog:stopAllActions()
	end
	self.panel:Release()
end

--隐藏
function HeroDescUIPanel:Hide()
	self.panel:Hide()
end

--显示
function HeroDescUIPanel:Show()
	self.panel:Show()
end
