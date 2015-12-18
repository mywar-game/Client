--数据解析
--作用：对接口返回数据进行加工，整合本地静态数据
DataTranslater = {}

function DataTranslater.tranHeroList(heroList)
	local tempHero = {}
    local tempDismissHero = {}
	for k,v in pairs(heroList)do
        local hero = DataTranslater.tranHero(v)
        if hero.status == 0 then
		    tempDismissHero[v.userHeroId] = hero
        else
			tempHero[v.userHeroId] = hero
        end
	end
	return tempHero, tempDismissHero
end

function DataTranslater.tranFriendHero(hero)
	local systemHero = StaticDataManager.getSystemHeroId(hero.systemHeroId)
	systemHero.userId = hero.userId
	systemHero.name = hero.name
	systemHero.effective = hero.effective
	systemHero.systemHeroId = hero.systemHeroId
	systemHero.isFriend = hero.isFriend
    systemHero.level = hero.level
	return systemHero
end

function DataTranslater.tranHero(hero)
	local systemHero = StaticDataManager.getSystemHeroId(hero.systemHeroId)
	systemHero.userId = hero.userId
	systemHero.userHeroId = hero.userHeroId
	systemHero.level = hero.level
	systemHero.exp = hero.exp
	systemHero.isScene = hero.isScene
    systemHero.isTeamLeader = hero.isTeamLeader
    systemHero.effective = hero.effective
	systemHero.pos = hero.pos
    systemHero.status = hero.status
	systemHero.star = hero.star
	systemHero.heroName = hero.heroName
	return systemHero
end

function DataTranslater.tranHeroAttr(systemHeroId,level,heroAttr)
	level = 1
	local hero = StaticDataManager.getSystemHeroId(systemHeroId)
	local heroGrowBase = StaticDataManager.getSystemHeroGrowBase(level)
	heroAttr = heroAttr or StaticDataManager.getSystemHeroAttributeId(systemHeroId)
	heroAttr.strength = heroAttr.strength + heroAttr.strengthUp * heroGrowBase.baseValue
	heroAttr.agile = heroAttr.agile + heroAttr.agileUp * heroGrowBase.baseValue
	heroAttr.stamina = heroAttr.stamina + heroAttr.staminaUp * heroGrowBase.baseValue
	heroAttr.intelligence = heroAttr.intelligence + heroAttr.intelligenceUp * heroGrowBase.baseValue
	
	local function addNewProperty(mainPropertyId,propertyProfit)
		local value = 0
		if mainPropertyId == StaticField.mainPropertyId1 then
			value = heroAttr.strength
		elseif mainPropertyId == StaticField.mainPropertyId2 then
			value = heroAttr.agile
		elseif mainPropertyId == StaticField.mainPropertyId3 then
			value = heroAttr.stamina
		elseif mainPropertyId == StaticField.mainPropertyId4 then
			value = heroAttr.intelligence
		end
		
		heroAttr.attackPower = heroAttr.attackPower + propertyProfit.attackPower*value
		heroAttr.magicPower = heroAttr.magicPower + propertyProfit.magicPower*value
		heroAttr.hp = heroAttr.hp + propertyProfit.hp*value
		heroAttr.armor = heroAttr.armor + propertyProfit.armor*value
		heroAttr.resistance = heroAttr.resistance + propertyProfit.resistance*value
		heroAttr.phyCrit = heroAttr.phyCrit + propertyProfit.crit*value
		heroAttr.dodge = heroAttr.dodge + propertyProfit.dodge*value
		heroAttr.damageIncrease = heroAttr.damageIncrease + propertyProfit.weaponDamage*value
		heroAttr.speedUp = heroAttr.speedUp + propertyProfit.speedUp*value
	end
	
	for k = 1, 4 do
		local propertyProfit		
		if k == hero.mainPropertyId then
			propertyProfit = StaticDataManager.getSystemMainPropertyProfit(k)
		else
			propertyProfit = StaticDataManager.getSystemSecondPropertyProfit(k)
		end
		addNewProperty(k,propertyProfit)
	end

	heroAttr.level = level
	heroAttr.maxHp = heroAttr.hp
	heroAttr.maxEnergy = heroAttr.energy
	
	return heroAttr
end

function DataTranslater.tranTask(task)
	local systemTask = DataManager.getSystemTaskId(task.systemTaskId)
	systemTask.finishTimes = task.finishTimes
	systemTask.status = task.status
    systemTask.star = task.star
	return systemTask
end

function DataTranslater.tranTaskList(taskList)
	local tempTask = {}
	for k,v in pairs(taskList)do
		tempTask[k] = DataTranslater.tranTask(v)
	end
	return tempTask
end

function DataTranslater.tranTool(tool)
	local systemTool = StaticDataManager.getSystemTool(tool.toolId)
	systemTool.toolNum = tool.toolNum
	return systemTool
end

function DataTranslater.tranRepertoryTool(tool)
	local systemTool = StaticDataManager.getSystemTool(tool.toolId)
	systemTool.toolNum = tool.storehouseNum
	return systemTool
end

function DataTranslater.tranToolList(toolList)
	local packageTool = {}
	local repertoryTool = {}
	for k,v in pairs(toolList)do
		if 0 < v.toolNum then									--在背包里有
			table.insert(packageTool, DataTranslater.tranTool(v))
		end
		if 0 < 	tonumber(v.storehouseNum) then					--在仓库里有
			table.insert(repertoryTool, DataTranslater.tranRepertoryTool(v))
		end
	end
	return packageTool, repertoryTool
end

function DataTranslater.tranHeroSkill(skill)
	local systemSkill = DataManager.getSystemHeroSkillId(skill.systemHeroSkillId,skill.skillLevel)
	systemSkill.nextPlayerTime = 0
	systemSkill.userId = skill.userId --用户编号
	systemSkill.userHeroSkillId = skill.userHeroSkillId --用户英雄技能唯一id
	systemSkill.systemHeroSkillId = skill.systemHeroSkillId --系统英雄技能唯一编号
	systemSkill.skillLevel = skill.skillLevel --技能等级
	systemSkill.skillExp = skill.skillExp --技能经验
	systemSkill.userHeroId = skill.userHeroId  --技能所在英雄id,如果为空则表示没有被配置到英雄身上
	systemSkill.pos = skill.pos -- 技能所在英雄的位置
	return systemSkill
end

function DataTranslater.tranHeroSkillList(skillList)
	local tempSkill = {}
	for k,v in pairs(skillList)do
		tempSkill[k] = DataTranslater.tranHeroSkill(v)
	end
	return tempSkill
end

function DataTranslater.tranEquip(equip)
    local systemEquip = DataManager.getSystemEquip(equip.equipId)
    local systemEquipAttr = DataManager.getSystemEquipAttr(equip.equipId)
    local retEquip = systemEquip
    retEquip.toolId = equip.equipId
    retEquip.type = GameField.equip
    retEquip.userId = equip.userId
    retEquip.userEquipId = equip.userEquipId
    retEquip.userHeroId = equip.userHeroId
    retEquip.equipId = equip.equipId
    retEquip.pos = equip.pos
	retEquip.holeNum = equip.holeNum
	retEquip.magicEquipAttr = equip.magicEquipAttr
	
    --独有属性
    retEquip.uniqueAttr = {}
    -- 特殊独有属性
    if systemEquip.equipType <= 10 then
        -- 武器读伤害
        table.insert(retEquip.uniqueAttr, { name = "miniDamage", value = systemEquipAttr.miniDamage })
        table.insert(retEquip.uniqueAttr, { name = "maxDamage", value = systemEquipAttr.maxDamage })
	elseif systemEquip.equipType == 11 then
        -- 盾读防御和格挡
        table.insert(retEquip.uniqueAttr, { name = "armor", value = systemEquipAttr.armor })
        table.insert(retEquip.uniqueAttr, { name = "parry", value = systemEquipAttr.parry })
    else
        -- 防具读防御
        table.insert(retEquip.uniqueAttr, { name = "armor", value = systemEquipAttr.armor })
    end
	
	if retEquip.userId == nil then
		table.insert(retEquip.uniqueAttr, { name = "stamina", value = systemEquipAttr.stamina})
		local fixedAttr = DataManager.getSystemEquipFixedAttr(equip.equipId)
		if fixedAttr then --固定属性
			table.insert(retEquip.uniqueAttr, { name = fixedAttr.mainAttr, value = systemEquipAttr[fixedAttr.mainAttr]})
		end
		table.insert(retEquip.uniqueAttr, { name = "random", value = GameString.randomAttr})
	end
    
	-- 主属性
    retEquip.equipMainAttr = {}
    local mainAttrStr = Split(equip.equipMainAttr, ",")
    for k, v in pairs(mainAttrStr) do
        table.insert(retEquip.equipMainAttr, { name = v, value = systemEquipAttr[v] })
    end
	
    -- 副属性
    retEquip.equipSecondaryAttr = {}
    local secondAttrStr = Split(equip.equipSecondaryAttr, ",")
    for k, v in pairs(secondAttrStr) do
       table.insert(retEquip.equipSecondaryAttr, { name = v, value = systemEquipAttr[v] })
    end
    return retEquip
end

function DataTranslater.tranEquipList(equipList)
    local retEquipList = {}
	local retRepertoryEquip = {}
    for k,v in pairs(equipList) do
		if 0 == v.storehouseNum then  				--装备在背包里
			retEquipList[v.userEquipId] = DataTranslater.tranEquip(v)
		else										--装备在仓库里
			retRepertoryEquip[v.userEquipId] = DataTranslater.tranEquip(v)
		end
    end
    return retEquipList, retRepertoryEquip
end

function DataTranslater.tranOpenMap(openMaps)
    local numMaps = {} 
    local strMaps = Split(openMaps, ",")
    for k,v in pairs(strMaps) do
        table.insert(numMaps, tonumber(v))
    end
    return numMaps
end

function DataTranslater.tranGemstoneList(gemstoneList)
    local retGemstoneList = {}
	local retRepertoryStone = {}
    for k,v in pairs(gemstoneList) do
		if 0 == v.storehouseNum then
			retGemstoneList[v.userGemstoneId] = DataTranslater.tranGemstone(v)
		else
			retRepertoryStone[v.userGemstoneId] = DataTranslater.tranGemstone(v)
		end
    end
    return retGemstoneList, retRepertoryStone
end

function DataTranslater.tranGemstone(gemstone)
	local systemGemstone = DataManager.getSystemGemstone(gemstone.gemstoneId)
	systemGemstone.toolId = gemstone.gemstoneId
	systemGemstone.type = GameField.gemstone
	systemGemstone.attr = gemstone.attr
	systemGemstone.userEquipId = gemstone.userEquipId
	systemGemstone.userGemstoneId = gemstone.userGemstoneId
	systemGemstone.pos = gemstone.pos
    return systemGemstone
end
--file end