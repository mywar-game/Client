SkillDefineFormula = {}
require("HeroSkillPlayer")

--技能攻击的状态
local function skillAttackedState(effect,attacker,defender)
	local maxBaseNum = 10000
	local dodgeRD = math.random(maxBaseNum)
	local parryRD = math.random(maxBaseNum)
	local critRD = math.random(maxBaseNum)
	
	local aAttr = attacker.heroInfo.systemHeroAttr
	local bAttr = defender.heroInfo.systemHeroAttr
	local aLevel = aAttr.level
	local bLevel = bAttr.level
	
	local checkValue = effect.checkValue --q00000
	local bDodge = tonumber(string.sub(checkValue,6,-1)) --躲闪
	local bParry = tonumber(string.sub(checkValue,5,-2)) --格挡
	local bCrit = tonumber(string.sub(checkValue,4,-3))--暴击
	
	local standardRate = DataManager.getSystemFightStandardRate()
	local standardValue1 = DataManager.getSystemFightStandardValue(aLevel)
	local standardValue2 = DataManager.getSystemFightStandardValue(bLevel)
	
	if bDodge == 1 then --躲闪
		local paras = DataManager.getSystemFormulaParaId(StaticField.formula2)
		local dodgeNum = Formula.dodge(bAttr.dodge,bAttr.dodgeOdds,standardValue2,standardRate,paras)*maxBaseNum
		if critRD <= dodgeNum then
			bDodge = GameField.checkValue
		end
	end
	
	if bParry == 1 then --格挡
		local equipParry = 0
		local paras = DataManager.getSystemFormulaParaId(StaticField.formula5)
		local parryNum = Formula.parry(equipParry,bAttr.parry,bAttr.parryOdds,standardValue2,standardRate,paras)*maxBaseNum
		if parryRD <= parryNum then
			bParry = GameField.checkValue
		end
	end
	
	if bCrit == 1 then --暴击
		local paras = DataManager.getSystemFormulaParaId(StaticField.formula4)
		local cirtNum = Formula.crit(aAttr.phyCrit,aAttr.critOdds,standardValue1,standardRate,paras)*maxBaseNum
		if critRD <= cirtNum then
			bCrit = GameField.checkValue
		end
	else
		bCrit = GameField.checkValue
	end
	
	return bDodge,bParry,bCrit
end

--仇恨值
local function skillHateValue(attacker,effect,value,bDodge,bParry,bCrit)
	local num = 0 
	local hate = attacker.heroInfo.systemHerohate
	if hate == nil then
		return num
	end

	if bDodge == GameField.checkValue then		
		num = Formula.hateDefenderNum(hate.dodgeHateValue1,hate.dodgeHateValue2,hate.dodgeHateValue3,value)
	end
	
	if bParry == GameField.checkValue then
		num = Formula.hateDefenderNum(hate.parryHateValue1,hate.parryHateValue2,hate.parryHateValue3,value)
	end

	if bCrit == GameField.checkValue then
		num = Formula.hateDefenderNum(hate.hitParryHateValue1,hate.hitParryHateValue2,hate.hitParryHateValue3,value)
	end

	num = num + Formula.hateAttackerNum(value,effect.hateValue1,effect.hateValue2,effect.hateValue3)

	return num
end

--技能效果叠加系数
local function skillSuperValue(bDodge,bParry,bCrit)
	local modulus = 1
	if bDodge == GameField.checkValue then
		modulus = 0
	else
		if bCrit == GameField.checkValue then
			modulus = GameField.critValue
		end
		if bParry == GameField.checkValue then
			modulus = modulus * GameField.parryValue
		end
	end
	return modulus
end

function SkillDefineFormula.skillDefineBlood(buff)
	if buff.resultObj.isBlood then
		REDUCE_LIFE1(buff)
	end
end

function SkillDefineFormula.skillDefineEffect(skill,effect,eAttacker,eDefender,bIndex,beingAttackState,isTeamSkill)
	local attacker = nil
	local defender = nil
	--范围攻击的不反射攻击，52是范围攻击
	if beingAttackState == StaticField.beingAttackState2 then
		attacker = eAttacker
		defender = eAttacker
	else
		attacker = eAttacker
		defender = eDefender
	end
	
	local value = 0
	local isBlood = false
	local callHeroId = {}
	local attribute = effect.attribute --技能属性	
	local aHeroAttr = attacker.heroInfo.systemHeroAttr --攻击英雄
	local dHeroAttr = defender.heroInfo.systemHeroAttr --防御英雄
	local weaponHurt = math.random(aHeroAttr.miniDamage,aHeroAttr.maxDamage)--随机武器伤害
		
	local msgObj = transformEffectParams(effect.params)	--转换效果
	local bDodge,bParry,bCrit = skillAttackedState(effect,attacker,defender) --非常重要
	--local modulus = skillSuperValue(bDodge,bParry,bCrit)
	
	local define = DataManager.getSystemSkillEffectDefineId(effect.effectId)
	if define.effectId == StaticField.attackFormula1 then --清除持续伤害
		CLEAR_CONTINUED_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula2 then --昏迷		
		STUN_AIM1(defender,value,true)
	elseif define.effectId == StaticField.attackFormula3 then --眩晕
		STUN_AIM2(defender,value,true)
	elseif define.effectId == StaticField.attackFormula4 then --免疫眩晕
		IMMUNE_STUN_AIM2(defender,value,true)
	elseif define.effectId == StaticField.attackFormula5 then --免疫昏迷
		IMMUNE_STUN_AIM1(defender,value,true)
	elseif define.effectId == StaticField.attackFormula6 then --冻结
		STUN_AIM3(defender,value,true)
	elseif define.effectId == StaticField.attackFormula7 then --免疫冻结
		IMMUNE_STUN_AIM3(defender,value,true)
	elseif define.effectId == StaticField.attackFormula8 then --恐惧
		STUN_AIM4(defender,value,true)
	elseif define.effectId == StaticField.attackFormula9 then --免疫恐惧
		IMMUNE_STUN_AIM4(defender,value,true)
	elseif define.effectId == StaticField.attackFormula10 then --降低治疗效果
		value = Formula.reducetreatment(aHeroAttr.treatmentIncrease,msgObj)
		REDUCE_TREATMENT(defender,value,true)
	elseif define.effectId == StaticField.attackFormula11 then --提升治疗效果
		value = Formula.addtreatment(aHeroAttr.treatmentIncrease,msgObj)
		ADD_TREATMENT(defender,value,true)
	elseif define.effectId == StaticField.attackFormula12 then --暴击几率提升
		value = Formula.addcritodds(dHeroAttr.critOdds,msgObj)
		ADD_CRIT_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula13 then --暴击几率降低
		value = Formula.reducecritodds(dHeroAttr.critOdds,msgObj)
		REDUCE_CRIT_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula14 then --力量增加
		value = Formula.addstrength(dHeroAttr.strength,msgObj)
		ADD_STRENGTH(defender,value,true)
	elseif define.effectId == StaticField.attackFormula15 then --敏捷增加
		value = Formula.addagile(dHeroAttr.agile,msgObj)
		ADD_AGILE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula16 then --智力增加
		value = Formula.addintelligence(dHeroAttr.intelligence,msgObj)
		ADD_INTELLIGENCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula17 then --耐力增加
		value = Formula.addstamina(dHeroAttr.stamina,msgObj)
		ADD_STAMINA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula18 then --HP上限增加
		value = Formula.addhp(dHeroAttr.maxHp,msgObj)
		ADD_HP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula19 then --MP上限增加
		value = Formula.addmp(dHeroAttr.maxEnergy,msgObj)
		ADD_MP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula20 then --攻击强度增加
		value = Formula.addattack(dHeroAttr.attackPower,msgObj)
		ADD_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula21 then --法术强度增加
		value = Formula.addmana(dHeroAttr.magicPower,msgObj)
		ADD_MANA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula22 then --护甲增加
		value = Formula.addarmor(dHeroAttr.armor,msgObj)
		ADD_ARMOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula23 then --抗性增加
		value = Formula.addresistance()
		ADD_RESISTANCE()
	elseif define.effectId == StaticField.attackFormula24 then --穿透增加
		value = Formula.addpenetrate()
		ADD_PENETRATE()
	elseif define.effectId == StaticField.attackFormula25 then --命中增加
		value = Formula.addhit()
		ADD_HIT()
	elseif define.effectId == StaticField.attackFormula26 then --格挡增加
		value = Formula.addParry(dHeroAttr.parry,msgObj)
		ADD_PARRY(defender,value,true)
	elseif define.effectId == StaticField.attackFormula27 then --闪避增加
		value = Formula.adddodgevalue(dHeroAttr.dodge,msgObj)
		ADD_DODGE_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula28 then --攻击速度增加
		value = Formula.addAttackSpeed(dHeroAttr.speedOdds,msgObj)
		ADD_ATTACK_SPEED(defender,value,true)
	elseif define.effectId == StaticField.attackFormula29 then --力量减少
		value = Formula.reducestrength(dHeroAttr.strength,msgObj)
		REDUCE_STRENGTH(defender,value,true)
	elseif define.effectId == StaticField.attackFormula30 then --敏捷减少
		value = Formula.reduceagile(dHeroAttr.agile,msgObj)
		REDUCE_AGILE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula31 then --智力减少
		value = Formula.reduceintelligence(dHeroAttr.intelligence,msgObj)
		REDUCE_INTELLIGENCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula32 then --耐力减少
		value = Formula.reducestamina(dHeroAttr.stamina,msgObj)
		REDUCE_STAMINA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula33 then --HP上限减少
		value = Formula.reducehp(dHeroAttr.maxHp,msgObj)
		REDUCE_HP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula34 then --MP上限减少
		value = Formula.reducemp(dHeroAttr.maxEnergy,msgObj)
		REDUCE_MP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula35 then --攻击强度减少
		value = Formula.reduceattack(dHeroAttr.attackPower,msgObj)
		REDUCE_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula36 then --法术强度减少
		value = Formula.reducemana(dHeroAttr.magicPower,msgObj)
		REDUCE_MANA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula37 then --护甲减少
		value = Formula.reducearmor(dHeroAttr.armor,msgObj)
		REDUCE_ARMOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula38 then --抗性减少
		value = Formula.reduceresistance()
		REDUCE_RESISTANCE()
	elseif define.effectId == StaticField.attackFormula39 then --穿透减少
		value = Formula.reducepenetrate()
		REDUCE_PENETRATE()
	elseif define.effectId == StaticField.attackFormula40 then --命中减少
		value = Formula.reducehit()
		REDUCE_HIT()
	elseif define.effectId == StaticField.attackFormula41 then --格挡减少
		value = Formula.reduceparry(dHeroAttr.parry,msgObj)
		REDUCE_PARRY(defender,value,true)
	elseif define.effectId == StaticField.attackFormula42 then --闪避减少
		value = Formula.reducedodgevalue(dHeroAttr.dodge,msgObj)
		REDUCE_DODGE_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula43 then --攻击速度减少				
		value = Formula.reduceattackspeed(dHeroAttr.speedOdds,msgObj)
		REDUCE_ATTACK_SPEED(defender,value,true)
	elseif define.effectId == StaticField.attackFormula44 then --嘲讽
		value = Formula.taunt()
		TAUNT()
	elseif define.effectId == StaticField.attackFormula45 then --所有伤害减少
		value = Formula.reducedamage(dHeroAttr.damageIncrease,msgObj)
		REDUCE_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula46 then --武器伤害减少
		value = Formula.reducedamegeweapon(weaponHurt,msgObj)
		REDUCE_DAMEGE_WEAPON(defender,value,true)
	elseif define.effectId == StaticField.attackFormula47 then --物理伤害减少
		value = Formula.reducedamegephysics(dHeroAttr.physicsTough,msgObj)
		REDUCE_DAMEGE_PHYSICS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula48 then --法术伤害减少
		value = Formula.reducedamegemagic(dHeroAttr.magicTouch,msgObj)
		REDUCE_DAMEGE_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula49 then --反射下一次攻击
		REFLECT_NEXT_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula50 then --仇恨值减少
		value = Formula.reducehatevalue()
		REDUCE_HATE_VALUE()
	elseif define.effectId == StaticField.attackFormula51 then --所有伤害增加
		value = Formula.adddamage(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula52 then --武器伤害增加
		value = Formula.adddamegeweapon(weaponHurt,msgObj)
		ADD_DAMEGE_WEAPON(defender,value,true)
	elseif define.effectId == StaticField.attackFormula53 then --物理伤害增加
		value = Formula.adddamegephysics(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMEGE_PHYSICS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula54 then --法术伤害增加
		value = Formula.adddamegemagic(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMEGE_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula55 then --仇恨值增加
		value = Formula.addhatevalue()
		ADD_HATE_VALUE()
	elseif define.effectId == StaticField.attackFormula56 then --打断施法
		value = Formula.stunconjure()
		STUN_CONJURE()
	elseif define.effectId == StaticField.attackFormula57 then --沉默目标
		SILENT_AIM(defender,value,true)
	elseif define.effectId == StaticField.attackFormula58 then --吟唱时间增加
		value = Formula.addconjuretime()
		ADD_CONJURE_TIME()
	elseif define.effectId == StaticField.attackFormula59 then --吟唱时间减少
		value = Formula.reduceconjuretime()
		REDUCE_CONJURE_TIME()
	elseif define.effectId == StaticField.attackFormula60 then --急速增加
		value = Formula.addrapid(dHeroAttr.speedUp,paras)
		ADD_RAPID(defender,value,true)
	elseif define.effectId == StaticField.attackFormula61 then --急速减少
		value = Formula.reducerapid(dHeroAttr.speedUp,paras)
		REDUCE_RAPID(defender,value,true)
	elseif define.effectId == StaticField.attackFormula62 then --恢复魔法值
		value = Formula.recovermagic(dHeroAttr.energy,paras)
		RECOVER_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula63 then --减少魔法值
		value = Formula.reducemagicvalue(dHeroAttr.energy,paras)
		REDUCE_MAGIC_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula64 then --能量恢复速度提升
		value = Formula.addenergyrecover(dHeroAttr.energyRecover,paras)
		ADD_ENERGY_RECOVER(defender,value,true)
	elseif define.effectId == StaticField.attackFormula65 then --能量恢复速度降低
		value = Formula.reduceenergyrecover(dHeroAttr.energyRecover,paras)
		REDUCE_ENERGY_RECOVER(defender,value,true)
	elseif define.effectId == StaticField.attackFormula66 then --魔法消耗减少
		local mp = 0 --zjc 待完善
		value = Formula.reducemagicexpend(mp,paras)
		REDUCE_MAGIC_EXPEND(defender,value,true)
	elseif define.effectId == StaticField.attackFormula67 then --魔法消耗增加
		local mp = 0 --zjc 待完善
		value = Formula.addmagicexpend(mp,paras)
		ADD_MAGIC_EXPEND(defender,value,true)
	elseif define.effectId == StaticField.attackFormula68 then --无视下一次攻击
		IMMUNE_NEXT_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula69 then --无敌
	
	elseif define.effectId == StaticField.attackFormula70 then --移动
	
	elseif define.effectId == StaticField.attackFormula71 then --持续掉血
	
	elseif define.effectId == StaticField.attackFormula72 then --暴击值提升
		value = Formula.addcritvalue(dHeroAttr.phyCrit,paras)
		ADD_CRIT_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula73 then --暴击值降低
		value = Formula.reducecritvalue(dHeroAttr.phyCrit,paras)
		REDUCE_CRIT_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula74 then --闪避几率提升
		value = Formula.adddodgeodds(paras)
		ADD_DODGE_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula75 then --闪避几率降低
		value = Formula.reducedodgeodds(paras)
		REDUCE_DODGE_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula76 then --定身
		ANCHOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula77 then --召唤英雄
		value,num = Formula.callHero(msgObj)
		for k=1,num do
			table.insert(callHeroId,DataManager.getFightHeroId())
		end
		CALL_HERO(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula78 then --免伤增加
		value = Formula.reduce_damage_add(dHeroAttr.toughIncrease,msgObj)
		REDUCE_DAMAGE_ADD(defender,value,true)
	elseif define.effectId == StaticField.attackFormula79 then --免伤减少
		value = Formula.reduce_damage_reduce(dHeroAttr.toughIncrease,msgObj)
		REDUCE_DAMAGE_REDUCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula80 then --护盾
		value = Formula.add_hero_shield(aHeroAttr.magicPower,msgObj)
		ADD_HERO_SHIELD(defender,value,bIndex,true)
	elseif define.effectId == StaticField.attackFormula81 then --召唤英雄技能
		value = Formula.call_hero_skill_effect(msgObj)
		table.insert(callHeroId,DataManager.getFightHeroId())
		CALL_HERO_SKILL_EFFECT(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula82 then --变身
		value = Formula.call_hero_sheep(msgObj)
		table.insert(callHeroId,DataManager.getFightHeroId())
		CALL_HERO_SHEEP(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula85 then --吸血Buff
		value = Formula.vampire_buff(msgObj)
		VAMPIRE_BUFF(defender,value,true)
	elseif define.effectId == StaticField.attackFormula84 or  --法术吸血
	       define.effectId == StaticField.attackFormula10001 then --法术攻击
		bDodge = 0
		bParry = 0
		isBlood = true
		value = Formula.reducelife2(dHeroAttr.magicTough,aHeroAttr.magicPower,
									dHeroAttr.resistance,dHeroAttr.resistanceOdds,dHeroAttr.level,
								    dHeroAttr.toughIncrease,aHeroAttr.damageIncrease,
									bCrit,bDodge,isTeamSkill,msgObj)
	elseif define.effectId == StaticField.attackFormula10002 then --治疗
		bDodge = 0
		bParry = 0
		isBlood = true
		value = Formula.addlife1(aHeroAttr.maxHp,aHeroAttr.magicPower,
							     aHeroAttr.treatmentIncrease,bCrit,isTeamSkill,msgObj)
	elseif define.effectId == StaticField.attackFormula83 or --物理吸血
		   define.effectId == StaticField.attackFormula10000 then --物理攻击
		isBlood = true
		value = Formula.reducelife1(dHeroAttr.physicsTough,aHeroAttr.attackPower,weaponHurt,
									dHeroAttr.armor,dHeroAttr.armorOdds,dHeroAttr.level,dHeroAttr.toughIncrease,
									aHeroAttr.damageIncrease,bParry,bCrit,bDodge,isTeamSkill,msgObj)
	end
	
	--仇恨
	local hateNum = skillHateValue(attacker,effect,value,bDodge,bParry,bCrit)
	REDUCE_HATE(attacker,hateNum)
	
	local resultObj = {}
	resultObj.value = value
	resultObj.isBlood = isBlood
	resultObj.bDodge = bDodge
	resultObj.bParry = bParry
	resultObj.bCrit = bCrit
	resultObj.define = define
	resultObj.bIndex = bIndex
	resultObj.resId = skill.resId
	resultObj.callHeroId = callHeroId
	resultObj.beingAttackState = beingAttackState
	resultObj.userId = eDefender.heroInfo.userId
	return resultObj
end

function SkillDefineFormula.skillRecoveryFeature(buff)
	local attacker = nil
	local defender = nil
	local effect = buff.effect	
	local resultObj = buff.resultObj
	local value = resultObj.value
	local define = resultObj.define
	
	local eAttacker = buff.attacker
	local eDefender = buff.toGetHero(resultObj.defHeroId)
	if eDefender == nil then
		return
	end
	
	--法术反射
	if resultObj.beingAttackState ==  StaticField.beingAttackState2 then
		attacker = eAttacker
		defender = eAttacker
	else
		attacker = eAttacker
		defender = eDefender
	end
	if defender.heroInfo == nil or effect.round == StaticField.roundType then --瞬发无需处理
		return
	end

	if define.effectId == StaticField.attackFormula1 then --清除持续伤害
		CLEAR_CONTINUED_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula2 then --昏迷
		STUN_AIM1(defender,value,false)
	elseif define.effectId == StaticField.attackFormula3 then --眩晕
		STUN_AIM2(defender,value,false)
	elseif define.effectId == StaticField.attackFormula4 then --免疫眩晕
		IMMUNE_STUN_AIM2(defender,value,false)
	elseif define.effectId == StaticField.attackFormula5 then --免疫昏迷
		IMMUNE_STUN_AIM1(defender,value,false)
	elseif define.effectId == StaticField.attackFormula6 then --冻结
		STUN_AIM3(defender,value,false)
	elseif define.effectId == StaticField.attackFormula7 then --免疫冻结
		IMMUNE_STUN_AIM3(defender,value,false)
	elseif define.effectId == StaticField.attackFormula8 then --恐惧
		STUN_AIM4(defender,value,false)
	elseif define.effectId == StaticField.attackFormula9 then --免疫恐惧
		IMMUNE_STUN_AIM4(defender,value,false)
	elseif define.effectId == StaticField.attackFormula10 then --降低治疗效果
		REDUCE_TREATMENT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula11 then --提升治疗效果
		ADD_TREATMENT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula12 then --暴击几率提升
		ADD_CRIT_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula13 then --暴击几率降低
		REDUCE_CRIT_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula14 then --力量增加
		ADD_STRENGTH(defender,value,false)
	elseif define.effectId == StaticField.attackFormula15 then --敏捷增加
		ADD_AGILE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula16 then --智力增加
		ADD_INTELLIGENCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula17 then --耐力增加
		ADD_STAMINA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula18 then --HP上限增加
		ADD_HP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula19 then --MP上限增加
		ADD_MP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula20 then --攻击强度增加
		ADD_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula21 then --法术强度增加
		ADD_MANA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula22 then --护甲增加
		ADD_ARMOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula23 then --抗性增加
		ADD_RESISTANCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula24 then --穿透增加
		ADD_PENETRATE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula25 then --命中增加
		ADD_HIT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula26 then --格挡增加
		ADD_PARRY(defender,value,false)
	elseif define.effectId == StaticField.attackFormula27 then --闪避增加
		ADD_DODGE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula28 then --攻击速度增加
		ADD_ATTACK_SPEED(defender,value,false)
	elseif define.effectId == StaticField.attackFormula29 then --力量减少
		REDUCE_STRENGTH(defender,value,false)
	elseif define.effectId == StaticField.attackFormula30 then --敏捷减少
		REDUCE_AGILE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula31 then --智力减少
		REDUCE_INTELLIGENCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula32 then --耐力减少
		REDUCE_STAMINA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula33 then --HP上限减少
		REDUCE_HP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula34 then --MP上限减少
		REDUCE_MP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula35 then --攻击强度减少
		REDUCE_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula36 then --法术强度减少
		REDUCE_MANA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula37 then --护甲减少
		REDUCE_ARMOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula38 then --抗性减少
		REDUCE_RESISTANCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula39 then --穿透减少
		REDUCE_PENETRATE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula40 then --命中减少
		REDUCE_HIT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula41 then --格挡减少
		REDUCE_PARRY(defender,value,false)
	elseif define.effectId == StaticField.attackFormula42 then --闪避减少
		REDUCE_DODGE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula43 then --攻击速度减少
		REDUCE_ATTACK_SPEED(defender,value,false)
	elseif define.effectId == StaticField.attackFormula44 then --嘲讽
		TAUNT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula45 then --所有伤害减少
		REDUCE_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula46 then --武器伤害减少
		REDUCE_DAMEGE_WEAPON(defender,value,false)
	elseif define.effectId == StaticField.attackFormula47 then --物理伤害减少
		REDUCE_DAMEGE_PHYSICS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula48 then --法术伤害减少
		REDUCE_DAMEGE_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula49 then --反射下一次攻击
		REFLECT_NEXT_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula50 then --仇恨值减少
		REDUCE_HATE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula51 then --所有伤害增加
		ADD_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula52 then --武器伤害增加
		ADD_DAMEGE_WEAPON(defender,value,false)
	elseif define.effectId == StaticField.attackFormula53 then --物理伤害增加
		ADD_DAMEGE_PHYSICS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula54 then --法术伤害增加
		ADD_DAMEGE_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula55 then --仇恨值增加
		ADD_HATE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula56 then --打断施法
		STUN_CONJURE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula57 then --沉默目标
		SILENT_AIM(defender,value,false)
	elseif define.effectId == StaticField.attackFormula58 then --吟唱时间增加
		ADD_CONJURE_TIME(defender,value,false)
	elseif define.effectId == StaticField.attackFormula59 then --吟唱时间减少
		REDUCE_CONJURE_TIME(defender,value,false)
	elseif define.effectId == StaticField.attackFormula60 then --急速增加
		ADD_RAPID(defender,value,false)
	elseif define.effectId == StaticField.attackFormula61 then --急速减少
		REDUCE_RAPID(defender,value,false)
	elseif define.effectId == StaticField.attackFormula62 then --恢复魔法值
		RECOVER_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula63 then --减少魔法值
		REDUCE_MAGIC_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula64 then --能量恢复速度提升
		ADD_ENERGY_RECOVER(defender,value,false)
	elseif define.effectId == StaticField.attackFormula65 then --能量恢复速度降低
		REDUCE_ENERGY_RECOVER(defender,value,false)
	elseif define.effectId == StaticField.attackFormula66 then --魔法消耗减少
		REDUCE_MAGIC_EXPEND(defender,value,false)
	elseif define.effectId == StaticField.attackFormula67 then --魔法消耗增加
		ADD_MAGIC_EXPEND(defender,value,false)
	elseif define.effectId == StaticField.attackFormula68 then --无视下一次攻击
		IMMUNE_NEXT_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula72 then --暴击值提升
		ADD_CRIT_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula73 then --暴击值降低
		REDUCE_CRIT_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula74 then --闪避几率提升
		ADD_DODGE_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula75 then --闪避几率降低
		REDUCE_DODGE_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula76 then --定身
		ANCHOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula77 then --召唤英雄
		CALL_HERO(defender,value,resultObj.callHeroId,false)
	elseif define.effectId == StaticField.attackFormula78 then --免伤增加
		REDUCE_DAMAGE_ADD(defender,value,false)
	elseif define.effectId == StaticField.attackFormula79 then --免伤减少
		REDUCE_DAMAGE_REDUCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula80 then --护盾	
		ADD_HERO_SHIELD(defender,0,0,false)
	elseif define.effectId == StaticField.attackFormula81 then --召唤英雄技能
		CALL_HERO_SKILL_EFFECT(defender,value,resultObj.callHeroId,false)
	elseif define.effectId ==  StaticField.attackFormula82 then --变身
		CALL_HERO_SHEEP(defender,value,resultObj.callHeroId,false)
	elseif define.effectId == StaticField.attackFormula83 then --物理吸血
	
	elseif define.effectId == StaticField.attackFormula84 then --法术吸血
	
	elseif define.effectId == StaticField.attackFormula85 then --吸血Buff
		VAMPIRE_BUFF(defender,value,false)
	elseif define.effectId == StaticField.attackFormula10001 then --法术攻击
	
	elseif define.effectId == StaticField.attackFormula10002 then --治疗
	
	elseif define.effectId == StaticField.attackFormula10000 then --物理攻击
	
	end
end

--被攻击的表现
function SkillDefineFormula.skillPlayHeroAppear(buff,flag)
	local effect = buff.effect
	if effect.appearType == 0 then
		return 
	end
	
	local defender = buff.toGetHero()
	if defender == nil then
		return
	end
	
	if effect.appearType == 1 then --变大
		if flag then
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1.2))
		else
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1))
		end
	elseif effect.appearType == 2 then --变小
		if flag then
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,0.8))
		else
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1))
		end
	elseif effect.appearType == 3 then --变色
		if flag then
			defender.skeleton:setColor(cc.c3b(250,0,0))
		else
			defender.skeleton:setColor(cc.c3b(255,255,255))
		end
	elseif effect.appearType == 4 then --冻结
	
	end
end