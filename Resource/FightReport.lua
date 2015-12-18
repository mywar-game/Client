FightReport={}

local function transFightHeroSkill(systemHero,heroLevel,actMode)
	local level = 1
	local activeSkillList = {}
	local passiveSkillList = {}

	if actMode == GameField.actMode2 then --全部开放技能
		heroLevel = GameField.openLevel[4]
	end
	
	local aIdx = 1
	local pIdx = 1
	for k=4,1,-1 do
		local skillId = systemHero["skill0"..k]
		if skillId > 0 and GameField.openLevel[k] <= heroLevel then
			local heroSkill = DataManager.getSystemHeroSkillId(skillId,level)	
			local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
			if k == 1 then
				systemSkill.nextPlayerTime = math.random(5)/10 --下次播放时间
			else
				systemSkill.nextPlayerTime = systemSkill.cdTime + math.random(5)/10  --下次播放时间
			end
			systemSkill.isNotStack = true
			if systemSkill.triggerType == StaticField.triggerType1 then
				systemSkill.skillPos = pIdx --播放的技能
				table.insert(passiveSkillList,systemSkill)
				pIdx = pIdx + 1
			else
				systemSkill.skillPos = aIdx --播放的技能
				table.insert(activeSkillList,systemSkill)
				aIdx = aIdx + 1
			end
		end
	end
	
	--[[
	for k=4,1,-1 do 
		local skillId = systemHero["skill0"..k]
		if skillId > 0 and GameField.openLevel[k] <= heroLevel then
			local heroSkill = DataManager.getSystemHeroSkillId(skillId,level)	
			local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
			if k == 1 then
				systemSkill.nextPlayerTime = math.random(5)/10 --下次播放时间
			else
				systemSkill.nextPlayerTime = systemSkill.cdTime + math.random(5)/10  --下次播放时间
			end
			systemSkill.isNotStack = true
			systemSkill.skillPos = k --播放的技能
			table.insert(activeSkillList,systemSkill)
		end
	end
	
	
	for k=4,1,-1 do
		local skillId = systemHero["objectSkill0"..k]
		if skillId > 0 and GameField.openLevel[k] <= heroLevel then
			local heroSkill = DataManager.getSystemHeroSkillId(skillId,level)
			local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
			if k == 1 then
				systemSkill.nextPlayerTime = 0 --下次播放时间
			else
				systemSkill.nextPlayerTime = systemSkill.cdTime --下次播放时间
			end
			systemSkill.skillPos = k --播放的技能
			table.insert(passiveSkillList,systemSkill)
		end
	end]]
	
	return activeSkillList,passiveSkillList
end

local function transFightHeroSite(hero)
	local posId = 0
	local standId = 0
	local posTab = {}
	for k=1,12 do
		posTab[k] = 0
	end
	
	for k,v in pairs(hero)do
		if v.systemHero.standId == standId or
		   v.systemHero.standId == StaticField.standId1 or
		   v.systemHero.standId == StaticField.standId2 then
			posId = posId + 1
		else
			posId = (v.systemHero.standId-1) * 3 + 1
			standId = v.systemHero.standId
		end
		local idx = 0
		if v.systemHero.standId == StaticField.standId1 and posId > 3 then
			idx = 6
		elseif v.systemHero.standId == StaticField.standId2 and posId > 6 then
			idx = 3
		elseif v.systemHero.standId == StaticField.standId3 and posId > 9 then
			idx = 12
		elseif v.systemHero.standId == StaticField.standId4 and posId > 12 then
			idx = 9
		end
		
		for k=idx,idx-2,-1 do
			if posTab[k] == 0 then
				posId = k
			end
		end		
		
		posTab[posId] = 1
		if v.petType == StaticField.petType1 then
			v.posId = posId
		elseif v.petType == StaticField.petType2 then
			if v.bornPosId <= 6 then
				v.posId = -posId
			else
				v.posId = -v.bornPosId
			end
		else
			v.posId = posId
		end
	end
end

--站位排序
local function transFightHeroStandSort(a,b)
	return a.systemHero.standId < b.systemHero.standId
end

local function copyHeroAttr(heroAttr)
	local attr = DeepCopy(heroAttr)
	for k,v in pairs(attr)do
		attr[k] = 0
	end
	return attr
end

local function transHero(userId,userHeroId,systemHeroId,equips,level,monsterType,actMode,petType,bornPosId,perentHeroId,fightHeroId)
	local systemHero = DataManager.getStaticSystemHeroId(systemHeroId)
	local systemHeroAttr = EquipDetailUtil.refreshHeroAttr(systemHeroId,level,equips)
	local systemHerohate = DataManager.getSystemHeroHateId(systemHero.careerId)
	local activeSkillList,passiveSkillList = transFightHeroSkill(systemHero,level,actMode)
	local speedOddsParas = DataManager.getSystemFormulaParaId(StaticField.formula10)
	
	local info = {}
	info.systemMonster = {monsterType=monsterType}
	info.systemHerohate = systemHerohate
	info.systemHero = systemHero
	info.systemHeroAttr = systemHeroAttr
	info.speedOddsParas = speedOddsParas
	info.activeSkillList = activeSkillList
	info.passiveSkillList = passiveSkillList
	info.battleType = GameField.battleType1
	info.heroState = StaticField.heroState0
	info.actMode = actMode
	info.petType = petType
	info.posId = 0
	info.userId = userId
	info.userHeroId = userHeroId
	info.bornPosId = bornPosId
	info.attackPosId = 0
	info.playSlayCD = 3
	info.perentHeroId = perentHeroId or 0 --主人英雄ID
	info.fightHeroId = fightHeroId or DataManager.getFightHeroId() --战斗Id
	return info
end

local function addInEquipAttr(heroAttrs,equipAttrs,careerId)
	local miniDamage = 0
	local maxDamage = 0
	local agile = heroAttrs.agile
	local stamina = heroAttrs.stamina
	local strength = heroAttrs.strength
	local intelligence = heroAttrs.intelligence
	
    local function addInAttrs(attrs)
        for k,v in pairs(attrs) do
            heroAttrs[v.name] = heroAttrs[v.name] + v.value
        end
    end
	
    if equipAttrs then
        for k,v in pairs(equipAttrs) do
            addInAttrs(v.uniqueAttr)
            addInAttrs(v.equipMainAttr)
            addInAttrs(v.equipSecondaryAttr)
			miniDamage = miniDamage + (v.uniqueAttr["miniDamage"] or 0)
			maxDamage = maxDamage + (v.uniqueAttr["maxDamage"] or 0)
			
			local gemstone = DataManager.getEquipGemstoneList(v.userEquipId) --宝石
			for k,v in pairs(gemstone)do
				local attrList = json.decode(v.attr) 
				for k,v in pairs(attrList) do
					if heroAttrs[v.attr] then
						heroAttrs[v.attr] = heroAttrs[v.attr]+v.value
					end
				end
			end
			
			local magicAttr = json.decode(v.magicEquipAttr) or {} --附魔
			for k, v in pairs(magicAttr) do
				if heroAttrs[v.attr] then
					heroAttrs[v.attr] = heroAttrs[v.attr]+v.value
				end
			end
        end
    end
	
	local heroProfit = StaticDataManager.getSystemHeroProfit(careerId)
	heroAttrs.hp = heroAttrs.hp + (heroAttrs.stamina-stamina) * heroProfit.stamina
	heroAttrs.magicPower = heroAttrs.magicPower + (heroAttrs.intelligence-intelligence) * heroProfit.intelligence
	heroAttrs.attackPower = heroAttrs.attackPower + (heroAttrs.strength - strength) * heroProfit.strength + (heroAttrs.agile-agile) * heroProfit.agile
	heroAttrs.maxHp = heroAttrs.hp 
	heroAttrs.miniDamage = heroAttrs.miniDamage+miniDamage
	heroAttrs.maxDamage = heroAttrs.maxDamage+maxDamage
end

--解析宠物
local function transFightPetInfo(hero)
	local heroInfo = {}
	for k,v in pairs(hero) do
		if v.systemHero.petId > 0 then
			local heroId = v.systemHero.petId
			local info = transHero(0,heroId,{},v.systemHeroAttr.level,v.systemMonster.monsterType,v.actMode,StaticField.petType2,v.posId,v.fightHeroId)
			table.insert(heroInfo,info)
		end
	end
	table.sort(heroInfo,transFightHeroStandSort)
	transFightHeroSite(heroInfo)
	
	for k,v in pairs(heroInfo) do
		table.insert(hero,v)
	end
end

--解析英雄
local function transFightHeroInfo(hero)
	local heroInfo = {}
	for k,v in pairs(hero)do
		local info = transHero(v.userId,v.userHeroId,v.systemHeroId,v.equips,v.level,StaticField.monsterType4,GameField.actMode1,StaticField.petType1,0)
		info.posX = v.posX
		info.posY = v.posY
		table.insert(heroInfo,info)
	end
	table.sort(heroInfo,transFightHeroStandSort)
	transFightHeroSite(heroInfo)
	transFightPetInfo(heroInfo) --解析宠物
	return heroInfo
end

--解析PK英雄
local function transPkHeroInfo(hero)
	local heroInfo = {}
	local monInfo = {}
	for k,v in pairs(hero)do
		local info = transHero(v.userId,v.userHeroId,v.systemHeroId,v.equips,v.level,StaticField.monsterType1,GameField.actMode2,StaticField.petType1,0)
		table.insert(monInfo,info)
	end
	table.sort(monInfo,transFightHeroStandSort)
	transFightHeroSite(monInfo)
	transFightPetInfo(monInfo) --解析宠物
	
	table.insert(heroInfo,monInfo)
	return heroInfo
end

--解析野怪
local function transFightMonsterInfo(monster)
	local heroInfo = {}
	local monsterList = Split(monster.monsterId,"|")
	for k,v in pairs(monsterList)do
		local monInfo = {}
		local monsterHero = Split(v,",")
		for m,n in pairs(monsterHero) do
			local systemMonster = DataManager.getSystemMonsterId(tonumber(n))
			local info = transHero(tostring(0),0,systemMonster.systemHeroId,{},systemMonster.level,systemMonster.monsterType,GameField.actMode2,StaticField.petType1,0)
			info.systemMonster = systemMonster
			table.insert(monInfo,info)
		end
		table.sort(monInfo,transFightHeroStandSort)
		transFightHeroSite(monInfo)
		transFightPetInfo(monInfo) --解析宠物
		table.insert(heroInfo,monInfo)		
	end
	return heroInfo
end

--QTE
local function transmonsterQTE(monster)
	local qteList = {}
	local monsterList = Split(monster.monsterId,"|")
	for k,v in pairs(monsterList)do
		local qte = DataManager.getSystemMonsterQte(Split(v,","))
		table.insert(qteList,qte)
	end
	return qteList
end

local function transBackground(forces)
	return Split(forces.resId,",")
end

function FightReport.parseFightReport(fightResult)
	local t = {}
	if fightResult.fightType == GameField.fightType1 or
       fightResult.fightType == GameField.fightType2 then
		t.qte = transmonsterQTE(fightResult.monster)
		t.defs = transFightMonsterInfo(fightResult.monster)
		t.background = transBackground(fightResult.forces)
	elseif fightResult.fightType == GameField.fightType3 then
		t.qte = {}
		t.defs = transPkHeroInfo(fightResult.monster)
		t.background = {"1001"}
	elseif fightResult.fightType == GameField.fightType4 then
		t.qte = {}
		t.defs = transFightMonsterInfo(fightResult.monster)
		t.background = {"1001"}
	end
	t.atks = transFightHeroInfo(fightResult.hero)
	t.forces = fightResult.forces
	t.headSkill = fightResult.headSkill
	t.fightType = fightResult.fightType
	t.forcesDifficulty = fightResult.forcesDifficulty
	return t
end

function FightReport.parseHero(userId,heroUserId,systemHeroId,equips,level,actMode,posId,petType,perentHeroId,fightHeroId)
	return transHero(userId,heroUserId,systemHeroId,equips,level,StaticField.monsterType4,actMode,petType,posId,perentHeroId,fightHeroId)
end