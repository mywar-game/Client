Formula = {}

--8000（（1-p）*（1-p）+（1-p）+1） p:血量的百分比
function Formula.dropEnergyBall(p)
	return math.floor(8000*((1-p)*(1-p)+(1-p)+1))
end

function Formula.conversionRate(value,standardValue,standardRate)
	return value/(value+standardValue*(1-standardRate)/standardRate)
end

--[[
躲闪转换几率=被攻击方躲闪值 /（系数a*被攻击方当前等级+系数b）
躲闪上限值50%，躲闪下限值5%
等级差修正系数规则
关联“被攻击方等级-攻击方等级”
修正系数=(攻击方-被攻击方)*2%   -10%<=修正系数<=10%
躲闪上限值50%，躲闪下限值5%
]]
function Formula.dodge(bDodge,dodgeOdds,standardValue,standardRate,paras)
	local a = paras.fightParaA or 0
	local b = paras.fightParaB or 0
	local c = paras.fightParaC or 0
	local vmin = paras.fightParaD or 0
	local vmax = paras.fightParaE or 0	
	
	local dodge = Formula.conversionRate(bDodge,standardValue.dodgeValue,standardRate.dodgeRate)+dodgeOdds
	dodge = dodge < vmin and vmin or dodge
	dodge = dodge > vmax and vmax or dodge
	
	return dodge
end

--暴击几率=攻击方暴击值/（系数a*攻击方当前等级+系数b+技能效用值)，5%<=暴击几率<=50%
function Formula.crit(aCrit,critOdds,standardValue,standardRate,paras)
	local a = paras.fightParaA or 0
	local b = paras.fightParaB or 0
	local c = paras.fightParaC or 0
	local vmin = paras.fightParaD or 0
	local vmax = paras.fightParaE or 0

	local crit = Formula.conversionRate(aCrit,standardValue.critValue,standardRate.critRate) + critOdds
	crit = crit < vmin and vmin or crit
	crit = crit > vmax and vmax or crit

	return crit
end

--格挡几率=装备格挡率+技能效用格挡率，5%<=格挡几率<=50%
function Formula.parry(equipParry,parry,parryOdds,standardValue,standardRate,paras)
	local a = paras.fightParaA or 0
	local b = paras.fightParaB or 0
	local c = paras.fightParaC or 0
	local vmin = paras.fightParaD or 0
	local vmax = paras.fightParaE or 0
		
	local parry = Formula.conversionRate(parry,standardValue.parryValue,standardRate.parryRate) + equipParry + parryOdds
	parry = parry < vmin and vmin or parry
	parry = parry > vmax and vmax or parry
	return parry
end

--急速转换几率
function Formula.speedOdds(speedUp,level,paras)
	local a = paras.fightParaA or 0
	local b = paras.fightParaB or 0
	local num = speedUp / (a*level+b)
	local vmin = paras.fightParaD or 0
	local vmax = paras.fightParaE or 0
	num = num < vmin and vmin or num
	num = num > vmax and vmax or num
	if num <= 0 then
		num = 0.001
	end
	return num
end

--当前单位当前仇恨值=((当前技能效果值*该技能仇恨系数1)^2  +（当前技能效果值*该技能仇恨系数2） +技能仇恨系数3）                                  +
function Formula.hateAttackerNum(num,hateValue1,hateValue2,hateValue3)
	num = math.abs(num)
	hateValue1 = hateValue1 / StaticField.hateModulus
	hateValue2 = hateValue2 / StaticField.hateModulus
	hateValue3 = hateValue3 / StaticField.hateModulus
	return (num*hateValue1)*(num*hateValue1) + num*hateValue2 + hateValue3
end

--（闪避减少伤害值*闪避权重系数1）^2+闪避减少伤害值*闪避权重系数2+闪避权重系数3+
--（格挡减少伤害值*格挡权重系数1）^2+格挡减少伤害值*格挡权重系数2+格挡权重系数3+
--（招架减少伤害值*招架权重系数1）^2+招架减少伤害值*招架权重系数2+招架权重系数3
function Formula.hateDefenderNum(a,b,c,num)
	a = a / StaticField.hateModulus
	b = b / StaticField.hateModulus
	c = c / StaticField.hateModulus
	return (a*num)*(a*num) + b*num + c
end

--原来攻击速度*a+b，a>=1，b是整型
function Formula.addAttackSpeed(speedOdds,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = a
	return num
end

--格挡增加,原来格挡*a+b，a>=1，b是整型
function Formula.addParry(parry,paras)
	local a = paras.a or 1
	local b = paras.b or 0
	local num = parry * a + b
	return num
end


--清除持续伤害
function Formula.clearcontinueddamage()

end
--昏迷
function Formula.stunaim1()

end
--眩晕
function Formula.stunaim2()

end
--免疫眩晕
function Formula.immunestunaim2()

end
--免疫昏迷
function Formula.immunestunaim1()

end
--冻结
function Formula.stunaim3()

end
--免疫冻结
function Formula.immunestunaim3()

end
--恐惧
function Formula.stunaim4()

end
--免疫恐惧
function Formula.immunestunaim4()

end

function Formula.reducetreatment(treatmentIncrease,msgObj)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = a
	return num
end
--提升治疗效果
function Formula.addtreatment(treatmentIncrease,msgObj)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - a
	return num
end


--暴击几率提升
function Formula.addcritodds(critOdds,paras)
	local a = paras.a or 0
	local num =  a
	return num
end
--暴击几率降低
function Formula.reducecritodds(critOdds,paras)
	local a = paras.a or 0
	local num = - a
	return num
end
--力量增加
function Formula.addstrength(strength,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = strength * a + b
	return num
end

--敏捷增加
function Formula.addagile()

end

--智力增加
function Formula.addintelligence()

end

--耐力增加
function Formula.addstamina(stamina,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = stamina * a + b
	return num
end

--HP上限增加
function Formula.addhp(maxHp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = maxHp + maxHp * a + b
	return num/maxHp
end

--MP上限增加
function Formula.addmp(maxMp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = maxMp + maxMp * a + b
	return num/maxMp
end

--攻击强度增加
function Formula.addattack(attackPower,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = attackPower * a + b
	return num
end
--法术强度增加
function Formula.addmana(magicPower,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = magicPower * a + b
	return num
end
--护甲增加
function Formula.addarmor(armor,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = armor * a + b
	return num
end

--抗性增加
function Formula.addresistance()
	
end

--穿透增加
function Formula.addpenetrate()

end

--命中增加
function Formula.addhit()

end

--闪避增加
function Formula.adddodgevalue(dodge,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = dodge * a + b
	return num
end

--力量减少
function Formula.reducestrength(strength,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - strength * a - b
	return num
end
--敏捷减少
function Formula.reduceagile(agile,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - agile * a - b
	return num
end
--智力减少
function Formula.reduceintelligence(intelligence,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - intelligence * a - b
	return num
end
--耐力减少
function Formula.reducestamina(stamina,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - stamina * a - b
	return num
end
--HP上限减少
function Formula.reducehp(maxHp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = maxHp - maxHp * a - b
	return num/maxHp
end
--MP上限减少
function Formula.reducemp(maxEnergy,paras)
	local a = paras.a or 1
	local b = paras.b or 0
	local num = maxEnergy - maxEnergy * a - b
	return num/maxEnergy
end
--攻击强度减少
function Formula.reduceattack(attackPower,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = attackPower * a + b
	return num
end
--法术强度减少
function Formula.reducemana(magicPower,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = magicPower * a + b
	return num
end
--护甲减少
function Formula.reducearmor(armor,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = armor * a + b
	return num
end
--抗性减少
function Formula.reduceresistance()
	
end
--穿透减少
function Formula.reducepenetrate()

end
--命中减少
function Formula.reducehit()

end
--格挡减少
function Formula.reduceparry(parry,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - parry * a - b
	return num
end
--闪避减少
function Formula.reducedodgevalue(dodge,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = dodge * a + b
	return num
end

--攻击速度减少
function Formula.reduceattackspeed(speedOdds,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num =  - a
	return num
end

--嘲讽
function Formula.taunt()
	return 0
end

--所有伤害减少
function Formula.reducedamage(toughIncrease,paras)
	local a = paras.a or 0
	local num = a
	return num
end
--武器伤害减少
function Formula.reducedamegeweapon(weaponHurt,paras)
	local a = paras.a or 0
	local num = - a
	return num
end
--物理伤害减少
function Formula.reducedamegephysics(physicsTough,paras)
	local a = paras.a or 0
	local num = - a
	return num
end
--法术伤害减少
function Formula.reducedamegemagic(magicTouch,paras)
	local a = paras.a or 0
	local num = - a
	return num
end

--反射下一次攻击
function Formula.reflectnextattack()

end

--仇恨值减少
function Formula.reducehatevalue()

end
--所有伤害增加
function Formula.adddamage(damageIncrease,paras)
	local a = paras.a or 0
	local num = a
	return num
end
--武器伤害增加
function Formula.adddamegeweapon(weaponHurt,paras)
	local a = paras.a or 0
	local num = a
	return num
end
--物理伤害增加
function Formula.adddamegephysics(damageIncrease,paras)
	local a = paras.a or 0
	local num = a
	return num
end
--法术伤害增加
function Formula.adddamegemagic(damageIncrease,paras)
	local a = paras.a or 0
	local num = a
	return num
end
--仇恨值增加
function Formula.addhatevalue()

end
--打断施法
function Formula.stunconjure()

end
--沉默目标
function Formula.silentaim()

end
--吟唱时间增加
function Formula.addconjuretime()

end
--吟唱时间减少
function Formula.reduceconjuretime()

end
--急速增加
function Formula.addrapid(speedUp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = speedUp * a + b
	return num
end
--急速减少
function Formula.reducerapid(speedUp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - speedUp * a - b
	return num
end
--恢复魔法值
function Formula.recovermagic(energy,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = energy * a + b
	return num
end

--减少魔法值
function Formula.reducemagicvalue(energy,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - energy * a - b
	return num
end
--能量恢复速度提升
function Formula.addenergyrecover(energyRecover,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = energyRecover * a + b
	return num
end
--能量恢复速度降低
function Formula.reduceenergyrecover(energyRecover,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - energyRecover * a - b
	return num
end

--魔法消耗减少
function Formula.reducemagicexpend(mp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = - mp * a - b
	return num
end

--魔法消耗增加
function Formula.addmagicexpend(mp,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = mp * a + b
	return num
end

--无视下一次攻击
function Formula.immunenextattack()

end


--暴击值提升
function Formula.addcritvalue(phyCrit,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = a*phyCrit + b
	return num
end

--暴击值降低
function Formula.reducecritvalue(phyCrit,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = -a*phyCrit - b
	return num
end

--闪避几率提升
function Formula.adddodgeodds(paras)
	local a = paras.a or 0
	local num = a
	return num
end

--闪避几率降低
function Formula.reducedodgeodds(paras)
	local a = paras.a or 0
	local num = - a
	return num
end

--定身
function Formula.anchor()

end

--召唤英雄
function Formula.callHero(paras)
	local a = paras.a or 1
	local b = paras.b or 1
	return a,b
end

--免伤增加
function Formula.reduce_damage_add(toughIncrease,paras)
	local a = paras.a or 0
	local num = a
	return num
end

--免伤减少
function Formula.reduce_damage_reduce(toughIncrease,paras)
	local a = paras.a or 0
	local num = -a
	return num
end

--护盾
function Formula.add_hero_shield(magicPower,paras)
	local a = paras.a or 0
	local b = paras.b or 0
	local num = magicPower * a + b
	return num
end

--变身
function Formula.call_hero_sheep(paras)
	local a = paras.a or 0
	local num = a
	return num
end

--英雄技能
function Formula.call_hero_skill_effect(paras)
	local a = paras.a or 0
	local num = a
	return num
end

--吸血BUFF
function Formula.vampire_buff(paras)
	local a = paras.a or 0
	local num = a
	return num
end

--法术攻击
function Formula.reducelife2(magicTough,magicPower,resistance,resistanceOdds,level,toughIncrease,damageIncrease,bCrit,bDodge,isTeamSkill,msgObj)
	local a = msgObj.a or 0
	local b = msgObj.b or 0
	local c = msgObj.c or 0
	local d = msgObj.d or 0
	local num = 0
	
	local standardRate = DataManager.getSystemFightStandardRate()
	local standardValue = DataManager.getSystemFightStandardValue(level)
	local resistanceNum = Formula.conversionRate(resistance,standardValue.resistanceValue,standardRate.resistanceRate)+resistanceOdds
	
	if isTeamSkill then
		num = b*(1-toughIncrease)*math.random(90,110)/100
	else
		num = (magicPower*a+b)*(1-toughIncrease)*math.random(90,110)/100*(1+damageIncrease)
		if bCrit == GameField.checkValue then
			num = num * GameField.critValue
		end
	end
	num = (magicTough-1) * num
	num = num > 0 and 0 or num
	num = math.floor(num)

	return num
end

--治疗
function Formula.addlife1(maxHp,magicPower,treatmentIncrease,bCrit,isTeamSkill,msgObj)
	local a = msgObj.a or 0
	local b = msgObj.b or 0
	local c = msgObj.c or 0
	local d = msgObj.d or 0
	
	local num = 0 
	if isTeamSkill then
		num = (a+maxHp*b+c)*math.random(90,110)/100
	else
		num = (magicPower*a+maxHp*b+c)*math.random(90,110)/100*(1+treatmentIncrease)
		if bCrit == GameField.checkValue then
			num = num * GameField.critValue
		end
	end
	num = math.ceil(num)
	return num
end

--物理攻击
function Formula.reducelife1(physicsTough,attackPower,weaponHurt,armor,armorOdds,level,toughIncrease,damageIncrease,bParry,bCrit,bDodge,isTeamSkill,msgObj)
	local a = msgObj.a or 0
	local b = msgObj.b or 0
	local c = msgObj.c or 0
	local d = msgObj.d or 0
	
	local finalA = 50 --固定值
	local finalB = 100
	
	local standardRate = DataManager.getSystemFightStandardRate()	
	local standardValue = DataManager.getSystemFightStandardValue(level)
	
	local hurtNum = attackPower+weaponHurt*a+b
	local armorNum = Formula.conversionRate(armor,standardValue.armorValue,standardRate.armorRate)+armorOdds
	local num = hurtNum*(1-armorNum)*(1-toughIncrease)*(1+damageIncrease)
	
	if bParry == GameField.checkValue then
		num = num * GameField.parryValue
	end
	
	if bCrit == GameField.checkValue then
		num = num * GameField.critValue
	end
	
	if bDodge == GameField.checkValue then
		num = 0
	end
	
	num = (physicsTough-1) * num-- 减少物理伤害
	num = num > 0 and 0 or num
	num = math.floor(num)
	
	return num
end