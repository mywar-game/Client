EquipDetailUtil={}

function EquipDetailUtil.showAttrInfo(panel,systemEquip,spriteList,nodeName,dimensions,offset)
	--获取所有属性
	local mx,my = panel:getChildByName(nodeName):getPosition()
	mx = mx + offset.x
	my = my + offset.y
	local function addNewItemLabel(txt,txtColor)
		local addLab = CreateLabel(txt, nil, 18, txtColor, 1,dimensions, 1)
		local size = addLab:getContentSize()
		addLab:setPosition(cc.p(mx,my))
		table.insert(spriteList,addLab)
		panel:getChildByName("img_equipContent"):addChild(addLab)
		my = my - size.height
	end
	
	local function addNewItemSprite(type,toolId,attr)
		my = my - 4
		
		local bgSprite = CreateCCSprite(IconPath.baoshibeijing.."i_wupingkx.png")
		local size = bgSprite:getContentSize()
		bgSprite:setPosition(cc.p(mx,my))
		bgSprite:setAnchorPoint(cc.p(0,1))
		bgSprite:setScale(0.45)
		table.insert(spriteList,bgSprite)
		panel:getChildByName("img_equipContent"):addChild(bgSprite)
		my = my - size.height*0.45
		
		if toolId then
			local attrStr = ""
			local attrList = json.decode(attr)
			for k,v in pairs(attrList)do
				local str = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
				attrStr = attrStr.."+"..v.value..str.."   "
			end
			
			local addLab = CreateLabel(attrStr, nil,36)
			addLab:setPosition(cc.p(size.width+5,size.height/2))
			addLab:setAnchorPoint(cc.p(0,0.5))
			bgSprite:addChild(addLab)
			
			local addSprite = IconUtil.GetIconByIdType(type,toolId)
			addSprite:setPosition(cc.p(size.width/2,size.height/2))
			bgSprite:addChild(addSprite)
		end
	end
	
	--唯一性
	if #systemEquip.equippos <= 1 then
		addNewItemLabel(LabelChineseStr.ToolDetailUIPanel_1)
	end
	
	--属于什么武器
	addNewItemLabel(LabelChineseStr["ToolDetailUIPanel_2_"..systemEquip.equipType])
	
	--属性添加
	local function addEquipAttr(attrCell, color)
		local showStr = ""
		if attrCell.name == "damage" then
			showStr = attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
		else
			showStr = "+"..attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
		end
		addNewItemLabel(showStr,color)
	end
	
	local minDamage = nil
	local maxDamage = nil
	for k,v in pairs(systemEquip.uniqueAttr) do
		if v.name == "miniDamage" then
			minDamage = v.value
		elseif v.name == "maxDamage" then
			maxDamage = v.value
		end
	end
	
	--伤害
	if minDamage and maxDamage then
		addEquipAttr({name="damage",value=minDamage.." - "..maxDamage})
	end
	
	--独有属性展示
	for k,v in pairs(systemEquip.uniqueAttr) do
		if v.name ~= "miniDamage" and v.name ~= "maxDamage" then
			addEquipAttr(v)
		end
	end
	
	--主属性展示
	for k,v in pairs(systemEquip.equipMainAttr) do
		addEquipAttr(v)
	end
	
	--副属性展示
	for k,v in pairs(systemEquip.equipSecondaryAttr) do
		addEquipAttr(v, cc.c3b(0,255,0))
	end
		
	--附魔
	local magicAttr = json.decode(systemEquip.magicEquipAttr) or {}
	for k, v in pairs(magicAttr) do
		local str = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
		addNewItemLabel(LabelChineseStr.magicName ..  ": + " .. v.value .. " " .. str,cc.c3b(0, 255, 0))
	end
	
	--宝石孔
	if nil ~= systemEquip.holeNum then
		local gemstone = DataManager.getEquipGemstoneList(systemEquip.userEquipId)
		for k=1,systemEquip.holeNum do
			local gem = gemstone[k] or {}
			addNewItemSprite(gem.type,gem.toolId,gem.attr)
		end
	end
	
	--职业
	local careerStr = LabelChineseStr.ToolDetailUIPanel_4
	for k,v in pairs(systemEquip.needCareer) do
		careerStr = careerStr..LabelChineseStr["ToolDetailUIPanel_4_"..v]
		if k ~= #systemEquip.needCareer then
			careerStr = careerStr..","
		end
	end
	
	addNewItemLabel(careerStr)
	--需要等级
	addNewItemLabel(LabelChineseStr.ToolDetailUIPanel_5..systemEquip.needLevel)
	--描述
	addNewItemLabel(systemEquip.description, cc.c3b(0xff,0xd7,0))
	
	panel:setLabelText("lab_equipName", systemEquip.name)
	panel:getChildByName("lab_equipName"):setColor(GetQualityColor(systemEquip.quality))
	panel:setLabelText("lab_equipLevel", systemEquip.level)
end

--更新装备
function EquipDetailUtil.refreshHeroAttr(systemHeroId,level,userEquips)

	local miniDamage = 0
	local maxDamage = 0
	
	--人物属性
	local showAttr = StaticDataManager.getSystemHeroAttributeId(systemHeroId)
	
	--插入装备
	for k,v in pairs(userEquips) do
		local gemstone = DataManager.getEquipGemstoneList(v.userEquipId) --宝石
		for k,v in pairs(gemstone)do
			local attrList = json.decode(v.attr) 
			for k,v in pairs(attrList) do
				if showAttr[v.attr] then
					showAttr[v.attr] = showAttr[v.attr]+v.value
				end
			end
		end
		
		local magicAttr = json.decode(v.magicEquipAttr) or {} --附魔
		for k, v in pairs(magicAttr) do
			if showAttr[v.attr] then
				showAttr[v.attr] = showAttr[v.attr]+v.value
			end
		end
		
		local function addAttr(attrList)
			for k,v in pairs(attrList) do
				if showAttr[v.name] then
					showAttr[v.name] = showAttr[v.name]+v.value
				end
			end
		end
		addAttr(v.uniqueAttr)
		addAttr(v.equipMainAttr)
		addAttr(v.equipSecondaryAttr)
		
		if v.uniqueAttr["miniDamage"] then
			showAttr.miniDamage = showAttr.miniDamage + v.uniqueAttr["miniDamage"]
		end
		
		if v.uniqueAttr["maxDamage"] then
			showAttr.maxDamage = showAttr.maxDamage + v.uniqueAttr["maxDamage"]
		end
	end
	local heroAttribute = DataManager.getSystemHeroAttributeId(systemHeroId,level,showAttr)
	
	return heroAttribute
end

function EquipDetailUtil.showDropData(data)
	local dropData = {}
	local heroList = data.heroList or {}
	local equipList = data.equipList or {}
	local heroSkillList = data.heroSkillList or {}
	local goodsList = data.goodsList or {}
	local gemstoneList = data.gemstoneList or {}
	
	--英雄
	for k,v in pairs(heroList)do
		if not DataManager.getUserHeroId(v.userHeroId) then
			table.insert(dropData,{systemHeroId=v.systemHeroId,goodsType=GameField.hero,goodsNum=1})
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
	local teamExp = {goodsId=0,goodsType=GameField.exp,goodsNum=0}
	local heroExp = {goodsId=0,goodsType=GameField.heroExp,goodsNum=0}
	for k,v in pairs(goodsList)do
		if v.goodsType == GameField.heroExp then
			heroExp.goodsNum = heroExp.goodsNum + v.goodsNum
		elseif v.goodsType == GameField.exp then
			teamExp.goodsNum = teamExp.goodsNum + v.goodsNum
		else
			table.insert(dropData,{goodsId=v.goodsId,goodsType=v.goodsType,goodsNum=v.goodsNum})
		end
	end
	if teamExp.goodsNum > 0 then
		table.insert(dropData,teamExp)
	end
	
	if heroExp.goodsNum > 0 then
		table.insert(dropData,heroExp)
	end
	
	--宝石
	for k,v in pairs(gemstoneList)do
		table.insert(dropData,{goodsId=v.gemstoneId,goodsType=GameField.hero,goodsNum=1})
	end
	return dropData
end

--技能的伤害
function EquipDetailUtil.showSkillData(heroAttr,skill)
	local value1 = 0
	local value2 = 0
	local effect = DataManager.getSystemSkillEffectId(skill.skillId)
	for k,v in pairs(effect) do
		local msgObj = transformEffectParams(v.params)	--转换效果
		local define = DataManager.getSystemSkillEffectDefineId(v.effectId)
		if define.effectId == StaticField.attackFormula10000 then --物理攻击
			value1 = value1 + math.abs(Formula.reducelife1(0,heroAttr.attackPower,heroAttr.maxDamage,0,0,heroAttr.level,0,heroAttr.damageIncrease,0,0,0,false,msgObj))
		elseif define.effectId == StaticField.attackFormula10001 then --法术攻击
			value1 = value1 + math.abs(Formula.reducelife2(0,heroAttr.magicPower,0,0,heroAttr.level,0,heroAttr.damageIncrease,0,0,false,msgObj))
		elseif define.effectId == StaticField.attackFormula10002 then
			value2 = value2 + math.abs(Formula.addlife1(heroAttr.maxHp,heroAttr.magicPower,heroAttr.treatmentIncrease,0,false,msgObj))
		end
	end

	local stringTab = {}
	local NNList = Split(skill.remark,"NN")
	for k,v in pairs(NNList)do
		local DDList = Split(v,"DD")
		if #DDList > 1 then
			for m,n in pairs(DDList)do
				if m > 1 and m <= #DDList then
					table.insert(stringTab,{str=value2,color=cc.c3b(0,255,0)})
				end
				table.insert(stringTab,{str=n,color=cc.c3b(255,255,255)})
			end
		else
			if k > 1 and k <= #NNList then
				table.insert(stringTab,{str=value1,color=cc.c3b(0,255,0)})
			end
			table.insert(stringTab,{str=v,color=cc.c3b(255,255,255)})
		end
	end

	return stringTab
end