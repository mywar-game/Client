SkillDefineFormula = {}
require("HeroSkillPlayer")

--���ܹ�����״̬
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
	local bDodge = tonumber(string.sub(checkValue,6,-1)) --����
	local bParry = tonumber(string.sub(checkValue,5,-2)) --��
	local bCrit = tonumber(string.sub(checkValue,4,-3))--����
	
	local standardRate = DataManager.getSystemFightStandardRate()
	local standardValue1 = DataManager.getSystemFightStandardValue(aLevel)
	local standardValue2 = DataManager.getSystemFightStandardValue(bLevel)
	
	if bDodge == 1 then --����
		local paras = DataManager.getSystemFormulaParaId(StaticField.formula2)
		local dodgeNum = Formula.dodge(bAttr.dodge,bAttr.dodgeOdds,standardValue2,standardRate,paras)*maxBaseNum
		if critRD <= dodgeNum then
			bDodge = GameField.checkValue
		end
	end
	
	if bParry == 1 then --��
		local equipParry = 0
		local paras = DataManager.getSystemFormulaParaId(StaticField.formula5)
		local parryNum = Formula.parry(equipParry,bAttr.parry,bAttr.parryOdds,standardValue2,standardRate,paras)*maxBaseNum
		if parryRD <= parryNum then
			bParry = GameField.checkValue
		end
	end
	
	if bCrit == 1 then --����
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

--���ֵ
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

--����Ч������ϵ��
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
	--��Χ�����Ĳ����乥����52�Ƿ�Χ����
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
	local attribute = effect.attribute --��������	
	local aHeroAttr = attacker.heroInfo.systemHeroAttr --����Ӣ��
	local dHeroAttr = defender.heroInfo.systemHeroAttr --����Ӣ��
	local weaponHurt = math.random(aHeroAttr.miniDamage,aHeroAttr.maxDamage)--��������˺�
		
	local msgObj = transformEffectParams(effect.params)	--ת��Ч��
	local bDodge,bParry,bCrit = skillAttackedState(effect,attacker,defender) --�ǳ���Ҫ
	--local modulus = skillSuperValue(bDodge,bParry,bCrit)
	
	local define = DataManager.getSystemSkillEffectDefineId(effect.effectId)
	if define.effectId == StaticField.attackFormula1 then --��������˺�
		CLEAR_CONTINUED_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula2 then --����		
		STUN_AIM1(defender,value,true)
	elseif define.effectId == StaticField.attackFormula3 then --ѣ��
		STUN_AIM2(defender,value,true)
	elseif define.effectId == StaticField.attackFormula4 then --����ѣ��
		IMMUNE_STUN_AIM2(defender,value,true)
	elseif define.effectId == StaticField.attackFormula5 then --���߻���
		IMMUNE_STUN_AIM1(defender,value,true)
	elseif define.effectId == StaticField.attackFormula6 then --����
		STUN_AIM3(defender,value,true)
	elseif define.effectId == StaticField.attackFormula7 then --���߶���
		IMMUNE_STUN_AIM3(defender,value,true)
	elseif define.effectId == StaticField.attackFormula8 then --�־�
		STUN_AIM4(defender,value,true)
	elseif define.effectId == StaticField.attackFormula9 then --���߿־�
		IMMUNE_STUN_AIM4(defender,value,true)
	elseif define.effectId == StaticField.attackFormula10 then --��������Ч��
		value = Formula.reducetreatment(aHeroAttr.treatmentIncrease,msgObj)
		REDUCE_TREATMENT(defender,value,true)
	elseif define.effectId == StaticField.attackFormula11 then --��������Ч��
		value = Formula.addtreatment(aHeroAttr.treatmentIncrease,msgObj)
		ADD_TREATMENT(defender,value,true)
	elseif define.effectId == StaticField.attackFormula12 then --������������
		value = Formula.addcritodds(dHeroAttr.critOdds,msgObj)
		ADD_CRIT_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula13 then --�������ʽ���
		value = Formula.reducecritodds(dHeroAttr.critOdds,msgObj)
		REDUCE_CRIT_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula14 then --��������
		value = Formula.addstrength(dHeroAttr.strength,msgObj)
		ADD_STRENGTH(defender,value,true)
	elseif define.effectId == StaticField.attackFormula15 then --��������
		value = Formula.addagile(dHeroAttr.agile,msgObj)
		ADD_AGILE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula16 then --��������
		value = Formula.addintelligence(dHeroAttr.intelligence,msgObj)
		ADD_INTELLIGENCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula17 then --��������
		value = Formula.addstamina(dHeroAttr.stamina,msgObj)
		ADD_STAMINA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula18 then --HP��������
		value = Formula.addhp(dHeroAttr.maxHp,msgObj)
		ADD_HP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula19 then --MP��������
		value = Formula.addmp(dHeroAttr.maxEnergy,msgObj)
		ADD_MP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula20 then --����ǿ������
		value = Formula.addattack(dHeroAttr.attackPower,msgObj)
		ADD_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula21 then --����ǿ������
		value = Formula.addmana(dHeroAttr.magicPower,msgObj)
		ADD_MANA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula22 then --��������
		value = Formula.addarmor(dHeroAttr.armor,msgObj)
		ADD_ARMOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula23 then --��������
		value = Formula.addresistance()
		ADD_RESISTANCE()
	elseif define.effectId == StaticField.attackFormula24 then --��͸����
		value = Formula.addpenetrate()
		ADD_PENETRATE()
	elseif define.effectId == StaticField.attackFormula25 then --��������
		value = Formula.addhit()
		ADD_HIT()
	elseif define.effectId == StaticField.attackFormula26 then --������
		value = Formula.addParry(dHeroAttr.parry,msgObj)
		ADD_PARRY(defender,value,true)
	elseif define.effectId == StaticField.attackFormula27 then --��������
		value = Formula.adddodgevalue(dHeroAttr.dodge,msgObj)
		ADD_DODGE_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula28 then --�����ٶ�����
		value = Formula.addAttackSpeed(dHeroAttr.speedOdds,msgObj)
		ADD_ATTACK_SPEED(defender,value,true)
	elseif define.effectId == StaticField.attackFormula29 then --��������
		value = Formula.reducestrength(dHeroAttr.strength,msgObj)
		REDUCE_STRENGTH(defender,value,true)
	elseif define.effectId == StaticField.attackFormula30 then --���ݼ���
		value = Formula.reduceagile(dHeroAttr.agile,msgObj)
		REDUCE_AGILE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula31 then --��������
		value = Formula.reduceintelligence(dHeroAttr.intelligence,msgObj)
		REDUCE_INTELLIGENCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula32 then --��������
		value = Formula.reducestamina(dHeroAttr.stamina,msgObj)
		REDUCE_STAMINA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula33 then --HP���޼���
		value = Formula.reducehp(dHeroAttr.maxHp,msgObj)
		REDUCE_HP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula34 then --MP���޼���
		value = Formula.reducemp(dHeroAttr.maxEnergy,msgObj)
		REDUCE_MP(defender,value,true)
	elseif define.effectId == StaticField.attackFormula35 then --����ǿ�ȼ���
		value = Formula.reduceattack(dHeroAttr.attackPower,msgObj)
		REDUCE_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula36 then --����ǿ�ȼ���
		value = Formula.reducemana(dHeroAttr.magicPower,msgObj)
		REDUCE_MANA(defender,value,true)
	elseif define.effectId == StaticField.attackFormula37 then --���׼���
		value = Formula.reducearmor(dHeroAttr.armor,msgObj)
		REDUCE_ARMOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula38 then --���Լ���
		value = Formula.reduceresistance()
		REDUCE_RESISTANCE()
	elseif define.effectId == StaticField.attackFormula39 then --��͸����
		value = Formula.reducepenetrate()
		REDUCE_PENETRATE()
	elseif define.effectId == StaticField.attackFormula40 then --���м���
		value = Formula.reducehit()
		REDUCE_HIT()
	elseif define.effectId == StaticField.attackFormula41 then --�񵲼���
		value = Formula.reduceparry(dHeroAttr.parry,msgObj)
		REDUCE_PARRY(defender,value,true)
	elseif define.effectId == StaticField.attackFormula42 then --���ܼ���
		value = Formula.reducedodgevalue(dHeroAttr.dodge,msgObj)
		REDUCE_DODGE_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula43 then --�����ٶȼ���				
		value = Formula.reduceattackspeed(dHeroAttr.speedOdds,msgObj)
		REDUCE_ATTACK_SPEED(defender,value,true)
	elseif define.effectId == StaticField.attackFormula44 then --����
		value = Formula.taunt()
		TAUNT()
	elseif define.effectId == StaticField.attackFormula45 then --�����˺�����
		value = Formula.reducedamage(dHeroAttr.damageIncrease,msgObj)
		REDUCE_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula46 then --�����˺�����
		value = Formula.reducedamegeweapon(weaponHurt,msgObj)
		REDUCE_DAMEGE_WEAPON(defender,value,true)
	elseif define.effectId == StaticField.attackFormula47 then --�����˺�����
		value = Formula.reducedamegephysics(dHeroAttr.physicsTough,msgObj)
		REDUCE_DAMEGE_PHYSICS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula48 then --�����˺�����
		value = Formula.reducedamegemagic(dHeroAttr.magicTouch,msgObj)
		REDUCE_DAMEGE_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula49 then --������һ�ι���
		REFLECT_NEXT_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula50 then --���ֵ����
		value = Formula.reducehatevalue()
		REDUCE_HATE_VALUE()
	elseif define.effectId == StaticField.attackFormula51 then --�����˺�����
		value = Formula.adddamage(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMAGE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula52 then --�����˺�����
		value = Formula.adddamegeweapon(weaponHurt,msgObj)
		ADD_DAMEGE_WEAPON(defender,value,true)
	elseif define.effectId == StaticField.attackFormula53 then --�����˺�����
		value = Formula.adddamegephysics(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMEGE_PHYSICS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula54 then --�����˺�����
		value = Formula.adddamegemagic(dHeroAttr.damageIncrease,msgObj)
		ADD_DAMEGE_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula55 then --���ֵ����
		value = Formula.addhatevalue()
		ADD_HATE_VALUE()
	elseif define.effectId == StaticField.attackFormula56 then --���ʩ��
		value = Formula.stunconjure()
		STUN_CONJURE()
	elseif define.effectId == StaticField.attackFormula57 then --��ĬĿ��
		SILENT_AIM(defender,value,true)
	elseif define.effectId == StaticField.attackFormula58 then --����ʱ������
		value = Formula.addconjuretime()
		ADD_CONJURE_TIME()
	elseif define.effectId == StaticField.attackFormula59 then --����ʱ�����
		value = Formula.reduceconjuretime()
		REDUCE_CONJURE_TIME()
	elseif define.effectId == StaticField.attackFormula60 then --��������
		value = Formula.addrapid(dHeroAttr.speedUp,paras)
		ADD_RAPID(defender,value,true)
	elseif define.effectId == StaticField.attackFormula61 then --���ټ���
		value = Formula.reducerapid(dHeroAttr.speedUp,paras)
		REDUCE_RAPID(defender,value,true)
	elseif define.effectId == StaticField.attackFormula62 then --�ָ�ħ��ֵ
		value = Formula.recovermagic(dHeroAttr.energy,paras)
		RECOVER_MAGIC(defender,value,true)
	elseif define.effectId == StaticField.attackFormula63 then --����ħ��ֵ
		value = Formula.reducemagicvalue(dHeroAttr.energy,paras)
		REDUCE_MAGIC_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula64 then --�����ָ��ٶ�����
		value = Formula.addenergyrecover(dHeroAttr.energyRecover,paras)
		ADD_ENERGY_RECOVER(defender,value,true)
	elseif define.effectId == StaticField.attackFormula65 then --�����ָ��ٶȽ���
		value = Formula.reduceenergyrecover(dHeroAttr.energyRecover,paras)
		REDUCE_ENERGY_RECOVER(defender,value,true)
	elseif define.effectId == StaticField.attackFormula66 then --ħ�����ļ���
		local mp = 0 --zjc ������
		value = Formula.reducemagicexpend(mp,paras)
		REDUCE_MAGIC_EXPEND(defender,value,true)
	elseif define.effectId == StaticField.attackFormula67 then --ħ����������
		local mp = 0 --zjc ������
		value = Formula.addmagicexpend(mp,paras)
		ADD_MAGIC_EXPEND(defender,value,true)
	elseif define.effectId == StaticField.attackFormula68 then --������һ�ι���
		IMMUNE_NEXT_ATTACK(defender,value,true)
	elseif define.effectId == StaticField.attackFormula69 then --�޵�
	
	elseif define.effectId == StaticField.attackFormula70 then --�ƶ�
	
	elseif define.effectId == StaticField.attackFormula71 then --������Ѫ
	
	elseif define.effectId == StaticField.attackFormula72 then --����ֵ����
		value = Formula.addcritvalue(dHeroAttr.phyCrit,paras)
		ADD_CRIT_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula73 then --����ֵ����
		value = Formula.reducecritvalue(dHeroAttr.phyCrit,paras)
		REDUCE_CRIT_VALUE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula74 then --���ܼ�������
		value = Formula.adddodgeodds(paras)
		ADD_DODGE_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula75 then --���ܼ��ʽ���
		value = Formula.reducedodgeodds(paras)
		REDUCE_DODGE_ODDS(defender,value,true)
	elseif define.effectId == StaticField.attackFormula76 then --����
		ANCHOR(defender,value,true)
	elseif define.effectId == StaticField.attackFormula77 then --�ٻ�Ӣ��
		value,num = Formula.callHero(msgObj)
		for k=1,num do
			table.insert(callHeroId,DataManager.getFightHeroId())
		end
		CALL_HERO(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula78 then --��������
		value = Formula.reduce_damage_add(dHeroAttr.toughIncrease,msgObj)
		REDUCE_DAMAGE_ADD(defender,value,true)
	elseif define.effectId == StaticField.attackFormula79 then --���˼���
		value = Formula.reduce_damage_reduce(dHeroAttr.toughIncrease,msgObj)
		REDUCE_DAMAGE_REDUCE(defender,value,true)
	elseif define.effectId == StaticField.attackFormula80 then --����
		value = Formula.add_hero_shield(aHeroAttr.magicPower,msgObj)
		ADD_HERO_SHIELD(defender,value,bIndex,true)
	elseif define.effectId == StaticField.attackFormula81 then --�ٻ�Ӣ�ۼ���
		value = Formula.call_hero_skill_effect(msgObj)
		table.insert(callHeroId,DataManager.getFightHeroId())
		CALL_HERO_SKILL_EFFECT(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula82 then --����
		value = Formula.call_hero_sheep(msgObj)
		table.insert(callHeroId,DataManager.getFightHeroId())
		CALL_HERO_SHEEP(defender,value,callHeroId,true)
	elseif define.effectId == StaticField.attackFormula85 then --��ѪBuff
		value = Formula.vampire_buff(msgObj)
		VAMPIRE_BUFF(defender,value,true)
	elseif define.effectId == StaticField.attackFormula84 or  --������Ѫ
	       define.effectId == StaticField.attackFormula10001 then --��������
		bDodge = 0
		bParry = 0
		isBlood = true
		value = Formula.reducelife2(dHeroAttr.magicTough,aHeroAttr.magicPower,
									dHeroAttr.resistance,dHeroAttr.resistanceOdds,dHeroAttr.level,
								    dHeroAttr.toughIncrease,aHeroAttr.damageIncrease,
									bCrit,bDodge,isTeamSkill,msgObj)
	elseif define.effectId == StaticField.attackFormula10002 then --����
		bDodge = 0
		bParry = 0
		isBlood = true
		value = Formula.addlife1(aHeroAttr.maxHp,aHeroAttr.magicPower,
							     aHeroAttr.treatmentIncrease,bCrit,isTeamSkill,msgObj)
	elseif define.effectId == StaticField.attackFormula83 or --������Ѫ
		   define.effectId == StaticField.attackFormula10000 then --������
		isBlood = true
		value = Formula.reducelife1(dHeroAttr.physicsTough,aHeroAttr.attackPower,weaponHurt,
									dHeroAttr.armor,dHeroAttr.armorOdds,dHeroAttr.level,dHeroAttr.toughIncrease,
									aHeroAttr.damageIncrease,bParry,bCrit,bDodge,isTeamSkill,msgObj)
	end
	
	--���
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
	
	--��������
	if resultObj.beingAttackState ==  StaticField.beingAttackState2 then
		attacker = eAttacker
		defender = eAttacker
	else
		attacker = eAttacker
		defender = eDefender
	end
	if defender.heroInfo == nil or effect.round == StaticField.roundType then --˲�����账��
		return
	end

	if define.effectId == StaticField.attackFormula1 then --��������˺�
		CLEAR_CONTINUED_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula2 then --����
		STUN_AIM1(defender,value,false)
	elseif define.effectId == StaticField.attackFormula3 then --ѣ��
		STUN_AIM2(defender,value,false)
	elseif define.effectId == StaticField.attackFormula4 then --����ѣ��
		IMMUNE_STUN_AIM2(defender,value,false)
	elseif define.effectId == StaticField.attackFormula5 then --���߻���
		IMMUNE_STUN_AIM1(defender,value,false)
	elseif define.effectId == StaticField.attackFormula6 then --����
		STUN_AIM3(defender,value,false)
	elseif define.effectId == StaticField.attackFormula7 then --���߶���
		IMMUNE_STUN_AIM3(defender,value,false)
	elseif define.effectId == StaticField.attackFormula8 then --�־�
		STUN_AIM4(defender,value,false)
	elseif define.effectId == StaticField.attackFormula9 then --���߿־�
		IMMUNE_STUN_AIM4(defender,value,false)
	elseif define.effectId == StaticField.attackFormula10 then --��������Ч��
		REDUCE_TREATMENT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula11 then --��������Ч��
		ADD_TREATMENT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula12 then --������������
		ADD_CRIT_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula13 then --�������ʽ���
		REDUCE_CRIT_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula14 then --��������
		ADD_STRENGTH(defender,value,false)
	elseif define.effectId == StaticField.attackFormula15 then --��������
		ADD_AGILE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula16 then --��������
		ADD_INTELLIGENCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula17 then --��������
		ADD_STAMINA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula18 then --HP��������
		ADD_HP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula19 then --MP��������
		ADD_MP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula20 then --����ǿ������
		ADD_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula21 then --����ǿ������
		ADD_MANA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula22 then --��������
		ADD_ARMOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula23 then --��������
		ADD_RESISTANCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula24 then --��͸����
		ADD_PENETRATE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula25 then --��������
		ADD_HIT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula26 then --������
		ADD_PARRY(defender,value,false)
	elseif define.effectId == StaticField.attackFormula27 then --��������
		ADD_DODGE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula28 then --�����ٶ�����
		ADD_ATTACK_SPEED(defender,value,false)
	elseif define.effectId == StaticField.attackFormula29 then --��������
		REDUCE_STRENGTH(defender,value,false)
	elseif define.effectId == StaticField.attackFormula30 then --���ݼ���
		REDUCE_AGILE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula31 then --��������
		REDUCE_INTELLIGENCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula32 then --��������
		REDUCE_STAMINA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula33 then --HP���޼���
		REDUCE_HP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula34 then --MP���޼���
		REDUCE_MP(defender,value,false)
	elseif define.effectId == StaticField.attackFormula35 then --����ǿ�ȼ���
		REDUCE_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula36 then --����ǿ�ȼ���
		REDUCE_MANA(defender,value,false)
	elseif define.effectId == StaticField.attackFormula37 then --���׼���
		REDUCE_ARMOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula38 then --���Լ���
		REDUCE_RESISTANCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula39 then --��͸����
		REDUCE_PENETRATE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula40 then --���м���
		REDUCE_HIT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula41 then --�񵲼���
		REDUCE_PARRY(defender,value,false)
	elseif define.effectId == StaticField.attackFormula42 then --���ܼ���
		REDUCE_DODGE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula43 then --�����ٶȼ���
		REDUCE_ATTACK_SPEED(defender,value,false)
	elseif define.effectId == StaticField.attackFormula44 then --����
		TAUNT(defender,value,false)
	elseif define.effectId == StaticField.attackFormula45 then --�����˺�����
		REDUCE_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula46 then --�����˺�����
		REDUCE_DAMEGE_WEAPON(defender,value,false)
	elseif define.effectId == StaticField.attackFormula47 then --�����˺�����
		REDUCE_DAMEGE_PHYSICS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula48 then --�����˺�����
		REDUCE_DAMEGE_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula49 then --������һ�ι���
		REFLECT_NEXT_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula50 then --���ֵ����
		REDUCE_HATE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula51 then --�����˺�����
		ADD_DAMAGE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula52 then --�����˺�����
		ADD_DAMEGE_WEAPON(defender,value,false)
	elseif define.effectId == StaticField.attackFormula53 then --�����˺�����
		ADD_DAMEGE_PHYSICS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula54 then --�����˺�����
		ADD_DAMEGE_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula55 then --���ֵ����
		ADD_HATE_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula56 then --���ʩ��
		STUN_CONJURE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula57 then --��ĬĿ��
		SILENT_AIM(defender,value,false)
	elseif define.effectId == StaticField.attackFormula58 then --����ʱ������
		ADD_CONJURE_TIME(defender,value,false)
	elseif define.effectId == StaticField.attackFormula59 then --����ʱ�����
		REDUCE_CONJURE_TIME(defender,value,false)
	elseif define.effectId == StaticField.attackFormula60 then --��������
		ADD_RAPID(defender,value,false)
	elseif define.effectId == StaticField.attackFormula61 then --���ټ���
		REDUCE_RAPID(defender,value,false)
	elseif define.effectId == StaticField.attackFormula62 then --�ָ�ħ��ֵ
		RECOVER_MAGIC(defender,value,false)
	elseif define.effectId == StaticField.attackFormula63 then --����ħ��ֵ
		REDUCE_MAGIC_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula64 then --�����ָ��ٶ�����
		ADD_ENERGY_RECOVER(defender,value,false)
	elseif define.effectId == StaticField.attackFormula65 then --�����ָ��ٶȽ���
		REDUCE_ENERGY_RECOVER(defender,value,false)
	elseif define.effectId == StaticField.attackFormula66 then --ħ�����ļ���
		REDUCE_MAGIC_EXPEND(defender,value,false)
	elseif define.effectId == StaticField.attackFormula67 then --ħ����������
		ADD_MAGIC_EXPEND(defender,value,false)
	elseif define.effectId == StaticField.attackFormula68 then --������һ�ι���
		IMMUNE_NEXT_ATTACK(defender,value,false)
	elseif define.effectId == StaticField.attackFormula72 then --����ֵ����
		ADD_CRIT_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula73 then --����ֵ����
		REDUCE_CRIT_VALUE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula74 then --���ܼ�������
		ADD_DODGE_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula75 then --���ܼ��ʽ���
		REDUCE_DODGE_ODDS(defender,value,false)
	elseif define.effectId == StaticField.attackFormula76 then --����
		ANCHOR(defender,value,false)
	elseif define.effectId == StaticField.attackFormula77 then --�ٻ�Ӣ��
		CALL_HERO(defender,value,resultObj.callHeroId,false)
	elseif define.effectId == StaticField.attackFormula78 then --��������
		REDUCE_DAMAGE_ADD(defender,value,false)
	elseif define.effectId == StaticField.attackFormula79 then --���˼���
		REDUCE_DAMAGE_REDUCE(defender,value,false)
	elseif define.effectId == StaticField.attackFormula80 then --����	
		ADD_HERO_SHIELD(defender,0,0,false)
	elseif define.effectId == StaticField.attackFormula81 then --�ٻ�Ӣ�ۼ���
		CALL_HERO_SKILL_EFFECT(defender,value,resultObj.callHeroId,false)
	elseif define.effectId ==  StaticField.attackFormula82 then --����
		CALL_HERO_SHEEP(defender,value,resultObj.callHeroId,false)
	elseif define.effectId == StaticField.attackFormula83 then --������Ѫ
	
	elseif define.effectId == StaticField.attackFormula84 then --������Ѫ
	
	elseif define.effectId == StaticField.attackFormula85 then --��ѪBuff
		VAMPIRE_BUFF(defender,value,false)
	elseif define.effectId == StaticField.attackFormula10001 then --��������
	
	elseif define.effectId == StaticField.attackFormula10002 then --����
	
	elseif define.effectId == StaticField.attackFormula10000 then --������
	
	end
end

--�������ı���
function SkillDefineFormula.skillPlayHeroAppear(buff,flag)
	local effect = buff.effect
	if effect.appearType == 0 then
		return 
	end
	
	local defender = buff.toGetHero()
	if defender == nil then
		return
	end
	
	if effect.appearType == 1 then --���
		if flag then
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1.2))
		else
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1))
		end
	elseif effect.appearType == 2 then --��С
		if flag then
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,0.8))
		else
			defender.heroBg:runAction(cc.ScaleTo:create(0.4,1))
		end
	elseif effect.appearType == 3 then --��ɫ
		if flag then
			defender.skeleton:setColor(cc.c3b(250,0,0))
		else
			defender.skeleton:setColor(cc.c3b(255,255,255))
		end
	elseif effect.appearType == 4 then --����
	
	end
end