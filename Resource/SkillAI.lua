require("Json")

SkillAI = {}


function SkillAI.hideHeroBuffEffect(defender)
	SkillEffect.hideHeroBuffEffect(defender)
end

function SkillAI.clearHeroBuffEffect(defender)
	SkillEffect.clearHeroBuffEffect(defender)
end

function SkillAI.clearCanSkillEffect(defender)
	SkillEffect.clearCanSkillEffect(defender)
end

function SkillAI.clearSkillEffectIndex(bIndex)
	SkillEffect.clearSkillEffectIndex(bIndex)
end

function SkillAI.selectTargetRange(attacker,heroList,monsterList)
	local function getshortestDistanceHero(list)
		local hero = list[1]
		local minPosId1 = math.abs(list[1].heroInfo.posId) --最大位置
		local minPosId2 = math.abs(attacker.heroInfo.posId)
		
		if minPosId1 % 3 == 1 then --第1，7，11号位有英雄
			return hero
		end
	
		for k,v in pairs(list)do
			if math.ceil(math.abs(v.heroInfo.posId) / 3) == math.ceil(minPosId1 / 3) then --同一列的英雄
				if math.abs(v.heroInfo.posId) % 3 == minPosId2 % 3 then --对应的位有英雄
					return v
				end
			end
		end
		
		for k,v in pairs(list)do
			if math.ceil(math.abs(v.heroInfo.posId) / 3) == math.ceil(minPosId1 / 3) then --同一列的英雄
				return v
			end
		end
	end
	
	--手动选择
	local function getManualTargetHero()
		local hero = nil
		for k,v in pairs(monsterList)do
			if v.heroInfo.posId == attacker.heroInfo.attackPosId then
				hero = v
			end
		end
		
		local rowNum = 4 --最大四排
		local minPosId = attacker.heroInfo.posId
		if hero == nil and attacker.heroInfo.standId == 2 then --被聚火英雄死亡
			for k,v in pairs(monsterList)do
				if v.heroInfo.posId % 3 == minPosId % 3 then
					local ceil1 = math.ceil(v.heroInfo.posId / 3)
					local ceil2 = math.ceil(attacker.heroInfo.attackPosId / 3)
					local row = math.abs(ceil1 - ceil2)
					if row < rowNum then
						hero = v
						rowNum = row
					end
				end
			end
		end
		
		if hero then --更改聚火指令
			attacker.heroInfo.attackPosId = hero.heroInfo.posId
		end
		
		return hero
	end	

	local selectHero = nil
	if attacker.heroInfo.actMode == GameField.actMode1 then
		if attacker.heroInfo.attackPosId > 0 then --有集火
			selectHero = getManualTargetHero()
		end
	else
		if attacker.heroInfo.battleType == GameField.battleType2 then --boss打仇恨最高的英雄
			selectHero = heroList[1] 
			for k,v in pairs(heroList) do
				if selectHero.heroHateNum < v.heroHateNum then
					selectHero = v
				end
			end
		end
	end
	
	
	local function getshortestDistanceHeroxxxx(list)
		local len = 0
		local hero = nil
		local ax,ay = attacker.heroBg:getPosition()
		for k,v in pairs(list)do
			local bx,by = v.heroBg:getPosition()
			local dis = math.sqrt((ax-bx)*(ax-bx)+(ay-by)*(ay-by))
			if len == 0 then
				len = dis
				hero = v
			end
			if dis < len then
				len = dis
				hero = v
			end
		end
		return hero
	end
	
	if selectHero == nil then
		if attacker.heroInfo.actMode == GameField.actMode1 then
			selectHero = getshortestDistanceHero(monsterList)
		else
			selectHero = getshortestDistanceHero(heroList)
		end
	end
	return selectHero
end

--选择目标
function SkillAI.selectTargetType(attacker,heroList,monsterList,selectType,systemSkill)
	--职业的人
	local function getCareerHero(hero,sctType)
		local heroList = {}
		for k,v in pairs(hero)do
			if v.heroInfo.systemHero.careerId == sctType then
				table.insert(heroList,v)
			end
		end
		return heroList
	end
	--最大仇恨的人
	local function getMaxHateHero(hero)	
		local hateHero = hero[1]
		for k,v in pairs(hero) do
			if hateHero.heroHateNum < v.heroHateNum then
				hateHero = v
			end
		end
		return hateHero
	end
	
	--最低生命比
	local function getLowLifeHero(hero)	
		local lifeHero = hero[1]
		local hp1 = lifeHero.heroInfo.systemHeroAttr.hp
		local maxHp1 = lifeHero.heroInfo.systemHeroAttr.maxHp
		for k,v in pairs(hero) do
			local hp2 = v.heroInfo.systemHeroAttr.hp
			local maxHp2 = v.heroInfo.systemHeroAttr.maxHp
			if hp1/maxHp1 > hp2/maxHp2 then
				lifeHero = v
			end
		end
		return lifeHero
	end
	
	--随机一个人
	local function getRandomHero(hero)	
		local rd = math.random(#hero)
		return hero[rd]
	end
	
	--获取第几排
	local function getRowHero(hero,rowIndex)
		local function sortPosId(a,b)
			return a.heroInfo.posId < b.heroInfo.posId
		end
		table.sort(hero,sortPosId)
		
		local heroList = {}
		local poor = math.ceil(math.abs(hero[1].heroInfo.posId)/GameField.columnNum) - 1
		for k,v in pairs(hero) do
			local row = math.ceil(math.abs(hero[1].heroInfo.posId)/GameField.columnNum)
			if row - poor == rowIndex then
				table.insert(heroList,v)
			end
		end
		return heroList
	end
	
	--获取整列
	local function getEntireColumnHero(hero)
		local function sortPosId(a,b)
			return math.abs(a.heroInfo.posId) < math.abs(b.heroInfo.posId)
		end
		table.sort(hero,sortPosId)
		
		local function getColumn(posId)
			local column = posId % GameField.columnNum
			column = column == 0 and column or GameField.columnNum
			return column
		end
		
		local function getHero(hero,index)
			local heroList = {}
			for k,v in pairs(hero)do
				local col = getColumn(math.abs(v.heroInfo.posId))
				if col == index then
					table.insert(heroList,v)
				end
			end
			return heroList
		end
		
		local column = getColumn(math.abs(attacker.heroInfo.posId))
		local heroList = {}
		for k=1,GameField.columnNum do
			heroList[k] = getHero(hero,k)
			if k == column and #heroList[k] > 0 then
				return heroList[k]
			end
		end
		
		for k=1,GameField.columnNum do
			if #heroList[k] > 0 then
				return heroList[k]
			end
		end
		
		return heroList
	end
	
	--获取整排
	local function getEntireRowHero(hero)
		local function sortPosId(a,b)
			return math.abs(a.heroInfo.posId) < math.abs(b.heroInfo.posId)
		end
		table.sort(hero,sortPosId)
			
		local function getHero(hero,index)
			local heroList = {}
			for k,v in pairs(hero)do
				local row = math.ceil(math.abs(v.heroInfo.posId) / GameField.columnNum)
				if row == index then
					table.insert(heroList,v)
				end
			end
			return heroList
		end
		
		local heroList = {}
		for k=1,GameField.rowNum do
			heroList = getHero(hero,k)
			if #heroList > 0 then
				break
			end
		end
		
		return heroList
	end
	
	--以圆为中心
	local function getCircleHero(hero)
		local heroList = {}
		for k,v in pairs(hero)do
			local x1,y1 = attacker.heroBg:getPosition()
			local x2,y2 = v.heroBg:getPosition()
			local x = math.abs(x1-x2)
			local y = math.abs(y1-y2)
			local t = math.sqrt(x*x+y*y)
			if t < systemSkill.skillScope then
				table.insert(heroList,v)
			end
		end
		return heroList
	end
	
	--以圆为中心
	local function getClosestDistance(hero)
		local mt = 10000
		local selHero = nil
		local heroList = {}
		for k,v in pairs(hero)do
			local x1,y1 = attacker.heroBg:getPosition()
			local x2,y2 = v.heroBg:getPosition()
			local x = math.abs(x1-x2)
			local y = math.abs(y1-y2)
			local t = math.sqrt(x*x+y*y)
			if mt > t then
				mt = t
				selHero = v
			end
		end
		table.insert(heroList,selHero)
		return heroList
	end
	
	local function getAutoTargetHero(target,sctType)
		local hero = {}
		if sctType <= StaticField.seleteType18 * 2 then
			local newType = sctType % StaticField.seleteType18
			newType = newType == 0 and StaticField.seleteType18 or newType
			if newType <= StaticField.seleteType16 then --职业
				hero = getCareerHero(target,newType)
			elseif newType == StaticField.seleteType17 then--生命百分比最低单位
				table.insert(hero,getLowLifeHero(target))
			elseif newType == StaticField.seleteType18 then --全体目标
				for k,v in pairs(target)do
					table.insert(hero,v)
				end
			end
		elseif sctType == StaticField.seleteType37 or --仇恨最高
		       sctType == StaticField.seleteType38 then
			table.insert(hero,getMaxHateHero(target))
		elseif sctType == StaticField.seleteType39 then --buff携带者
			table.insert(hero,attacker)
		elseif sctType == StaticField.seleteType40 or 
			   sctType == StaticField.seleteType45 then --随机一个单位
			table.insert(hero,getRandomHero(target))
		elseif sctType == StaticField.seleteType41 or
			   sctType == StaticField.seleteType46 then --第一排单位
			hero = getRowHero(target,1)
		elseif sctType == StaticField.seleteType42 or
			   sctType == StaticField.seleteType47 then --第二排单位
			hero = getRowHero(target,2)
		elseif sctType == StaticField.seleteType43 or
			   sctType == StaticField.seleteType48 then --第三排单位
			hero = getRowHero(target,3)
		elseif sctType == StaticField.seleteType44 or
			   sctType == StaticField.seleteType49 then --第四排单位
			hero = getRowHero(target,4)
		elseif sctType == StaticField.seleteType50 then --敌方一列
			hero = getEntireColumnHero(target)
		elseif sctType == StaticField.seleteType51 then --敌方一排
			hero = getEntireRowHero(target)
		elseif sctType == StaticField.seleteType52 or 
		       sctType == StaticField.seleteType55 then --范围（圆形）
			hero = getCircleHero(target)
		elseif sctType == StaticField.seleteType53 or
			   sctType == StaticField.seleteType54 then--以己方圆形
			hero = getClosestDistance(target)
		end
		return hero
	end
	
	local state = 0
	local selectHero = {}
	local selTypeList = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,37,39,40,41,42,43,44,54,55},
						 {19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,38,45,46,47,48,49,50,51,52,53}} --选择的模式
	for k,v in pairs(selTypeList)do
		for m,n in pairs(v)do
			if n == selectType then
				state = k
				break
			end
		end
	end
	
	if attacker.heroInfo.actMode == GameField.actMode1 then
		if state == 1 then
			selectHero = getAutoTargetHero(heroList,selectType)
		else
			selectHero = getAutoTargetHero(monsterList,selectType)
		end
	else
		if state == 1 then
			selectHero = getAutoTargetHero(monsterList,selectType)
		else
			selectHero = getAutoTargetHero(heroList,selectType)
		end
	end	
	return selectHero
end

function SkillAI.getLen1(aHero,dHero)
	local line  = 0 
	local rect1 = aHero.rect
	local rect2 = dHero.rect
	
	local attactPos = aHero.attackInfo.curHero.attactPos
	local distance = aHero.heroInfo.systemHeroAttr.attackRange
	local world1 = aHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p1world = aHero.fightPlayer.rootLayer:convertToWorldSpace(world1)
	
	local world2 = dHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p2world = dHero.fightPlayer.rootLayer:convertToWorldSpace(world2)
	
	local world3 = dHero.heroBg:convertToWorldSpace(cc.p(0,0))
	local p3world = dHero.fightPlayer.rootLayer:convertToWorldSpace(world2)
	
	if aHero.skeleton:getScaleX() > 0 then
		line =  math.abs(p1world.x + rect1.width - p2world.x)
		if attactPos == 1 or attactPos == 2 or attactPos == 5 then
			distance = distance + rect2.width
		else
			distance = -distance
		end
	else
		line = math.abs(p1world.x - p2world.x - rect2.width)
		if attactPos == 1 or attactPos == 2 or attactPos == 5 then
			distance = distance
		else
			distance = -distance - rect2.width
		end
	end
	
	local x1 = p1world.x - p3world.x
	local y1 = p1world.y - p3world.y
	
	local x2 = p2world.x + distance
	local y2 = p2world.y
	
	return line,x2+x1,y2+y1
end
--[[
function SkillAI.getLen(aHero,dHero)
	local x1,y1 = aHero.heroBg:getPosition()
	local x2,y2 = dHero.heroBg:getPosition()
	local x = math.abs(x1-x2)
	local y = math.abs(y1-y2)
	local t = math.sqrt(x*x+y*y)
	return t

	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0
	local x3 = 0
	
	local rect1 = aHero.rect
	local rect2 = dHero.rect
	
	local world1 = aHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p1world = aHero.fightPlayer.rootLayer:convertToWorldSpace(world1)
	
	local world2 = dHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p2world = dHero.fightPlayer.rootLayer:convertToWorldSpace(world2)
	
	x1 = p1world.x
	y1 = p1world.y
	x2 = p2world.x
	y2 = p2world.y
	
	y1 = p1world.y + rect1.height/2
	
	if p2world.y > y1 then --上段
		y2 = p2world.y + rect2.height/3
	elseif p2world.y + rect2.height < y1 then --下段
		y2 = p2world.y + rect2.height/3
	else --中段
		y2 = p1world.y + rect1.height/2
	end
						
	if aHero.skeleton:getScaleX() > 0 then
		x1= x1 + rect1.width
		x3 = p2world.x+rect2.width-p1world.x
	else
		x2 = x2 + rect2.width
		x3 = p1world.x+rect1.width-p2world.x
	end
	
	local line = 0
	local offx = x2-x1
	local offy = y2-y1
	if x3 > rect1.width+rect2.width then
		line = math.floor(math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2)))
	end
	return line,offx,offy
end
]]
function SkillAI.getBattleHero(systemSkill,attacker)
	local curHero = nil
	local isSelf = true
	local trackPos = 1
	local attackType = 1
	local selectHero = attacker.selectHero
	local targetSelect = systemSkill.targetSelect
	local fightHeroId = attacker.heroInfo.fightHeroId
	local heroStandId = attacker.heroInfo.systemHero.standId
	local heroList = attacker.fightPlayer.atk_hero_list
	local monsterList = attacker.fightPlayer.def_cards_list
	if #heroList == 0 or #monsterList == 0 then
		return nil
	end

	local selectList = SkillAI.selectTargetType(attacker,heroList,monsterList,targetSelect,systemSkill)
	if #selectList == 0 then
		return nil
	end
	
	local tempList = {}
	if targetSelect == StaticField.seleteType52 or
	   targetSelect == StaticField.seleteType53 or
	   targetSelect == StaticField.seleteType54 or
	   targetSelect == StaticField.seleteType55 then
		if selectHero.heroBg and selectHero.isDead == false and 
		   selectHero.heroInfo.fightHeroId ~= fightHeroId then --需要弄清楚为什么这样做
			curHero = selectHero
			table.insert(tempList,selectHero)
		else
			tempList = selectList
		end
	else
		tempList = selectList
	end
	
	if curHero == nil then
		local minLine = 10000
		for k,v in pairs(tempList)do			
			local x1,y1 = v.heroBg:getPosition()
			local x2,y2 = attacker.heroBg:getPosition()
			local x = math.abs(x1-x2)
			local y = math.abs(y1-y2)
			local line = math.sqrt(x*x+y*y)
			if minLine > line then
				curHero = v
				minLine = line
			end
		end
	end
	
	if fightHeroId ~= curHero.heroInfo.fightHeroId then
		local posList = {}
		local sx = attacker:doAttackScale(curHero)
		if sx > 0 then
			posList = {1,2,3,4,5,6}
		else
			posList = {3,4,1,2,6,5}
		end
		
		if heroStandId == StaticField.standId1 or 
		   heroStandId == StaticField.standId2 then --近战	
			for k,v in pairs(posList)do
				if curHero.attackPos[v] == 0 then
					trackPos = v
					curHero.attackPos[v] = fightHeroId
					break
				end
			end
		elseif heroStandId == StaticField.standId3 or 
		       heroStandId == StaticField.standId4 then --远程
			trackPos = posList[1]
		end
		if attacker.heroInfo.actMode == GameField.actMode1 and attacker.heroInfo.posId <= 2 then
			--cclog(attacker.heroInfo.posId.."================="..trackPos)
		end
		isSelf = false
	end
	
	local attackInfo = {}
	attackInfo.isSelf = isSelf
	attackInfo.curHero = curHero
	attackInfo.trackPos = trackPos
	attackInfo.selectList = tempList
	attackInfo.systemSkill = systemSkill
	return attackInfo
end

--添加技能BUff
function SkillAI.addSkillBuff(skillBuff,buffHero,heroList,monsterList)
	if buffHero.heroInfo.actMode == GameField.actMode1 then
		for k,v in pairs(heroList)do
			if v.heroInfo.posId == buffHero.heroInfo.posId then
				v:toAddSkillBuff(skillBuff)
				break
			end
		end
	else
		for k,v in pairs(monsterList)do
			if v.heroInfo.posId == buffHero.heroInfo.posId then
				v:toAddSkillBuff(skillBuff)
				break
			end
		end
	end
end

--执行技能效果
function SkillAI.runSkillBuff(skillBuff,buffHero,heroList,monsterList,isNowPlay)
	for m=1,#buffHero do
		local hero = buffHero[m]
		local effect = skillBuff.effect
		if hero.heroBg then --获取攻击英雄时候比执行要早，所以中间有间隔，会导致死亡。
			if isNowPlay == StaticField.nowRunBuff1 or 
			   effect.immediately == StaticField.immediately1 then --技能立即处理
				local skill = skillBuff.systemSkill
				local targetSelect = skill.targetSelect
				local isTeamSkill = skillBuff.isTeamSkill
				local player = hero.fightPlayer:toGetHero(skillBuff.actHeroId)--最初的攻击者
				if player then
					local hurtList = {}
					local targetList = SkillAI.selectTargetType(hero,heroList,monsterList,effect.selectType,skillBuff.systemSkill)--最终目标对象
					for k,v in pairs(targetList)do
						local resultObj = SkillEffect.playSkillAttack(k,skill,effect,hero,player,targetList[k],targetSelect,isTeamSkill)
						table.insert(hurtList,resultObj)
					end
					player:toAddAttackHurtData(hurtList,buffHero)
				end
			else
				SkillAI.addSkillBuff(skillBuff,hero,heroList,monsterList)
			end
		end
	end
end

--技能AI
function SkillAI.autoAI1(attacker,systemSkill,heroList,monsterList,isTeamSkill)
	local buffHero = attacker.hurtHeroList
	local actHeroId = attacker.heroInfo.fightHeroId
	local systemeffect = DataManager.getSystemSkillEffectId(systemSkill.skillId)
	for k,v in pairs(systemeffect)do
		local skillBuff = {effect=v,systemSkill=systemSkill,actHeroId=actHeroId,isTeamSkill=isTeamSkill}--定义技能BUFF
		SkillAI.runSkillBuff(skillBuff,buffHero,heroList,monsterList,StaticField.nowRunBuff2)
	end
	attacker:toSendAttackHurtData(systemSkill)
end

--技能AI
function SkillAI.autoAI(attacker,systemSkill,heroList,monsterList,isTeamSkill)
	if #heroList == 0 or #monsterList == 0 then
		return
	end
	
	local buffHero = {}
	local actHeroId = attacker.heroInfo.fightHeroId
	local systemeffect = DataManager.getSystemSkillEffectId(systemSkill.skillId)
	local targetSelect = systemSkill.targetSelect
	if targetSelect == 0 then
		local selectHero = SkillAI.selectTargetRange(attacker,heroList,monsterList)
		table.insert(buffHero,selectHero)
	else
		buffHero = SkillAI.selectTargetType(attacker,heroList,monsterList,targetSelect,systemSkill)--最终目标对象
	end
	
	for k,v in pairs(systemeffect)do
		local skillBuff = {effect=v,systemSkill=systemSkill,actHeroId=actHeroId,isTeamSkill=isTeamSkill}--定义技能BUFF
		SkillAI.runSkillBuff(skillBuff,buffHero,heroList,monsterList,StaticField.nowRunBuff2)
	end
end

--技能AI
function SkillAI.specialAI(attacker,skillId)
	local standId = attacker.heroInfo.systemHero.standId
	if standId == StaticField.careerId1 or 
	   standId == StaticField.careerId2 then
		return
	end
	
	local isPlay = true
	local systemSkill = DataManager.getSystemSkillId(skillId)
	if systemSkill.isFar ~= StaticField.isFar2 then
		isPlay = false
	end
	
	if isPlay then
		SkillEffect.playSpecialSkill("t106",attacker.heroBg)
	end
end

function SkillAI.TestSkill(v,heroAttr,activeSkillList)
	if v.heroInfo.systemHero.systemHeroId == 10118 then
		for m,n in pairs(activeSkillList) do
			if (n.nextPlayerTime <= 0 and n.expend <= heroAttr.energy) and m == 2 then 
				heroAttr.energy = heroAttr.energy - n.expend
				n.nextPlayerTime = 4
				v:toSkillBattle(n.skillId,n.skillPos,n.cdTime/v.speedOdds)
				v:toChangeProgress(GameField.proType2)
				break
			end
		end
	end
end