function REDUCE_HATE(attacker,hateNum) --���
	attacker.heroHateNum = attacker.heroHateNum + math.abs(hateNum)
end

--10000 ������
function REDUCE_LIFE1(buff)
	local effect = buff.effect
	local attacker = buff.attacker
	local defender = buff.toGetHero()
	local resultObj = buff.resultObj

	if defender == nil then
		return
	end
	
	if resultObj.beingAttackState == StaticField.beingAttackState1 then
		defender:toBloodShow(effect,resultObj)
		defender:toAttackTrigger(resultObj)
		attacker:toQteHurtNum(resultObj)
	elseif resultObj.beingAttackState == StaticField.beingAttackState2 then 
		attacker:toBloodShow(effect,resultObj)
		attacker:toAttackTrigger(resultObj)
		attacker:toQteHurtNum(resultObj)
	elseif resultObj.beingAttackState == StaticField.beingAttackState3 then
		
	end
	
	if effect.effectId == StaticField.attackFormula83 or --������߷�����Ѫ
	   effect.effectId == StaticField.attackFormula84 then
		resultObj.value = math.abs(resultObj.value)
		attacker:toBloodShow(effect,resultObj)
	elseif attacker.vampireBuff > 0 then
		resultObj.value = math.ceil(math.abs(resultObj.value*attacker.vampireBuff))
		attacker:toBloodShow(effect,resultObj)
	end
	
	local data = {}
	data.value = resultObj.value
	data.actMode1 = attacker.heroInfo.actMode
	if attacker.heroInfo.perentHeroId == 0 then
		data.fightHeroId1 = attacker.heroInfo.fightHeroId
		data.systemHeroId1 = attacker.heroInfo.systemHero.systemHeroId
	else
		data.fightHeroId1 = attacker.heroInfo.perentHeroId
		data.systemHeroId1 = attacker:toPerentSystemHeroId()
	end
	
	data.actMode2 = defender.heroInfo.actMode
	data.fightHeroId2 = defender.heroInfo.fightHeroId
	data.systemHeroId2 = defender.heroInfo.systemHero.systemHeroId
	DataManager.addFightData(data)
end

--10001 ��������
function REDUCE_LIFE2()

end

--10002 ����
function ADD_LIFE1()

end

--1 ��������˺�
function CLEAR_CONTINUED_DAMAGE(defender,value,flag)
	if flag then
		defender:toCleanCanEffect()
	else
	
	end
end

--2 ����
function STUN_AIM1(defender,value,flag)
	if flag then
		if defender.comaState == StaticField.comaState0 then
			defender.comaState = StaticField.comaState1
		end
	else
		defender.comaState = StaticField.comaState0
	end
end

--3 ѣ��
function STUN_AIM2(defender,value,flag)
	if flag then
		if defender.dizzinessState == StaticField.dizzinessState0 then
			defender.dizzinessState = StaticField.dizzinessState1
		end
	else
		defender.dizzinessState = StaticField.dizzinessState0
	end
end

--4 ����ѣ��
function IMMUNE_STUN_AIM2()
	if flag then
		defender.dizzinessState = StaticField.dizzinessState2
	else
		defender.dizzinessState = StaticField.dizzinessState0
	end
end

--5 ���߻���
function IMMUNE_STUN_AIM1()
	if flag then
		defender.comaState = StaticField.comaState2
	else
		defender.comaState = StaticField.comaState0
	end
end

--6 ����
function STUN_AIM3(defender,value,flag)
	if flag then
		if defender.invincibleState == StaticField.invincible0 and 
		   defender.heroSkillState == StaticField.heroSkillState0 then --�����߱���Ч��
			defender.hero:pause()
			defender.heroBg:pause()
			defender.invincibleState = StaticField.invincible1
		end
	else
		if defender.invincibleState == StaticField.invincible1 and 
		   defender.heroSkillState == StaticField.heroSkillState0 then --�����߱���Ч��
			defender.hero:resume()
			defender.heroBg:resume()
			defender.invincibleState = StaticField.invincible0
		end
	end
end

--7 ���߶���
function IMMUNE_STUN_AIM3(defender,value,flag)
	if flag then
		defender.invincibleState = StaticField.invincible2
	else
		defender.invincibleState = StaticField.invincible0
	end
end

--8 �־�
function STUN_AIM4()
	
end

--9 ���߿־�
function IMMUNE_STUN_AIM4()

end

--10 ��������Ч��
function REDUCE_TREATMENT(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.treatmentIncrease = defender.heroInfo.systemHeroAttr.treatmentIncrease + value
	else
		defender.heroInfo.systemHeroAttr.treatmentIncrease = defender.heroInfo.systemHeroAttr.treatmentIncrease - value
	end
end

--11 ��������Ч��
function ADD_TREATMENT(defender,value,flag)	
	if flag then
		defender.heroInfo.systemHeroAttr.treatmentIncrease = defender.heroInfo.systemHeroAttr.treatmentIncrease + value
	else
		defender.heroInfo.systemHeroAttr.treatmentIncrease = defender.heroInfo.systemHeroAttr.treatmentIncrease - value
	end
end

--12 ������������
function ADD_CRIT_ODDS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.critOdds = defender.heroInfo.systemHeroAttr.critOdds + value
	else
		defender.heroInfo.systemHeroAttr.critOdds = defender.heroInfo.systemHeroAttr.critOdds - value
	end
end

--13 �������ʽ���
function REDUCE_CRIT_ODDS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.critOdds = defender.heroInfo.systemHeroAttr.critOdds + value
	else
		defender.heroInfo.systemHeroAttr.critOdds = defender.heroInfo.systemHeroAttr.critOdds - value
	end
end

--14 ��������
function ADD_STRENGTH(defender,value,flag)	
	if flag then
		defender.heroInfo.systemHeroAttr.strength = defender.heroInfo.systemHeroAttr.strength + value
	else
		defender.heroInfo.systemHeroAttr.strength = defender.heroInfo.systemHeroAttr.strength - value
	end
end

--15 ��������
function ADD_AGILE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.agile = defender.heroInfo.systemHeroAttr.agile + value
	else
		defender.heroInfo.systemHeroAttr.agile = defender.heroInfo.systemHeroAttr.agile - value
	end
end

--16 ��������
function ADD_INTELLIGENCE(defender,value,flag)	
	if flag then
		defender.heroInfo.systemHeroAttr.intelligence = defender.heroInfo.systemHeroAttr.intelligence + value
	else
		defender.heroInfo.systemHeroAttr.intelligence = defender.heroInfo.systemHeroAttr.intelligence - value
	end
end

--17 ��������
function ADD_STAMINA(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.stamina = defender.heroInfo.systemHeroAttr.stamina + value
	else
		defender.heroInfo.systemHeroAttr.stamina = defender.heroInfo.systemHeroAttr.stamina - value
	end
end

--18 HP��������
function ADD_HP(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.hp = defender.heroInfo.systemHeroAttr.hp * value
		defender.heroInfo.systemHeroAttr.maxHp = defender.heroInfo.systemHeroAttr.maxHp * value
	else
		defender.heroInfo.systemHeroAttr.hp = defender.heroInfo.systemHeroAttr.hp / value
		defender.heroInfo.systemHeroAttr.maxHp = defender.heroInfo.systemHeroAttr.maxHp / value
	end
end

--19 MP��������
function ADD_MP(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy * value
		defender.heroInfo.systemHeroAttr.maxEnergy = defender.heroInfo.systemHeroAttr.maxEnergy * value
	else
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy / value
		defender.heroInfo.systemHeroAttr.maxEnergy = defender.heroInfo.systemHeroAttr.maxEnergy / value
	end
end

--20 ����ǿ������
function ADD_ATTACK(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.attackPower = defender.heroInfo.systemHeroAttr.attackPower + value
	else
		defender.heroInfo.systemHeroAttr.attackPower = defender.heroInfo.systemHeroAttr.attackPower - value
	end
end

--21 ����ǿ������
function ADD_MANA(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.magicPower = defender.heroInfo.systemHeroAttr.magicPower + value
	else
		defender.heroInfo.systemHeroAttr.magicPower = defender.heroInfo.systemHeroAttr.magicPower - value
	end
end

--22 ��������
function ADD_ARMOR(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.armor = defender.heroInfo.systemHeroAttr.armor + value
	else
		defender.heroInfo.systemHeroAttr.armor = defender.heroInfo.systemHeroAttr.armor - value
	end
end

--23 ��������
function ADD_RESISTANCE()

end

--24 ��͸����
function ADD_PENETRATE()


end

--25 ��������
function ADD_HIT()


end

--26 ������
function ADD_PARRY(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.parry = defender.heroInfo.systemHeroAttr.parry + value
	else
		defender.heroInfo.systemHeroAttr.parry = defender.heroInfo.systemHeroAttr.parry - value
	end
end

--27 ��������
function ADD_DODGE_VALUE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.dodge = defender.heroInfo.systemHeroAttr.dodge + value
	else
		defender.heroInfo.systemHeroAttr.dodge = defender.heroInfo.systemHeroAttr.dodge - value
	end
end

--28 �����ٶ�����
function ADD_ATTACK_SPEED(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.speedOdds = defender.heroInfo.systemHeroAttr.speedOdds + value
	else
		defender.heroInfo.systemHeroAttr.speedOdds = defender.heroInfo.systemHeroAttr.speedOdds - value
	end
	defender.isDecelerate = false
	if flag then
		defender:toSetSpeedOdds(-value)
	else
		defender:toSetSpeedOdds(value)
	end
end

--29 ��������
function REDUCE_STRENGTH(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.strength = defender.heroInfo.systemHeroAttr.strength + value
	else
		defender.heroInfo.systemHeroAttr.strength = defender.heroInfo.systemHeroAttr.strength - value
	end
end

--30 ���ݼ���
function REDUCE_AGILE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.agile = defender.heroInfo.systemHeroAttr.agile + value
	else
		defender.heroInfo.systemHeroAttr.agile = defender.heroInfo.systemHeroAttr.agile - value
	end
end

--31 ��������
function REDUCE_INTELLIGENCE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.intelligence = defender.heroInfo.systemHeroAttr.intelligence + value
	else
		defender.heroInfo.systemHeroAttr.intelligence = defender.heroInfo.systemHeroAttr.intelligence - value
	end
end

--32 ��������
function REDUCE_STAMINA(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.stamina = defender.heroInfo.systemHeroAttr.stamina + value
	else
		defender.heroInfo.systemHeroAttr.stamina = defender.heroInfo.systemHeroAttr.stamina - value
	end
end

--33 HP���޼���
function REDUCE_HP(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.hp = defender.heroInfo.systemHeroAttr.hp * value
		defender.heroInfo.systemHeroAttr.maxHp = defender.heroInfo.systemHeroAttr.maxHp * value
	else
		defender.heroInfo.systemHeroAttr.hp = defender.heroInfo.systemHeroAttr.hp / value
		defender.heroInfo.systemHeroAttr.maxHp = defender.heroInfo.systemHeroAttr.maxHp / value
	end
end

--34 MP���޼���
function REDUCE_MP(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy * value
		defender.heroInfo.systemHeroAttr.maxEnergy = defender.heroInfo.systemHeroAttr.maxEnergy * value
	else
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy / value
		defender.heroInfo.systemHeroAttr.maxEnergy = defender.heroInfo.systemHeroAttr.maxEnergy / value
	end
end

--35 ����ǿ�ȼ���
function REDUCE_ATTACK(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.attackPower = defender.heroInfo.systemHeroAttr.attackPower + value
	else
		defender.heroInfo.systemHeroAttr.attackPower = defender.heroInfo.systemHeroAttr.attackPower - value
	end
end

--36 ����ǿ�ȼ���
function REDUCE_MANA(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.magicPower = defender.heroInfo.systemHeroAttr.magicPower + value
	else
		defender.heroInfo.systemHeroAttr.magicPower = defender.heroInfo.systemHeroAttr.magicPower - value
	end
end

--37 ���׼���
function REDUCE_ARMOR(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.armor = defender.heroInfo.systemHeroAttr.armor + value
	else
		defender.heroInfo.systemHeroAttr.armor = defender.heroInfo.systemHeroAttr.armor - value
	end
end

--38 ���Լ���
function REDUCE_RESISTANCE()


end

--39 ��͸����
function REDUCE_PENETRATE()


end

--40 ���м���
function REDUCE_HIT()


end

--41 �񵲼���
function REDUCE_PARRY(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.parry = defender.heroInfo.systemHeroAttr.parry + value
	else
		defender.heroInfo.systemHeroAttr.parry = defender.heroInfo.systemHeroAttr.parry - value
	end
end

--42 ���ܼ���
function REDUCE_DODGE_VALUE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.dodge = defender.heroInfo.systemHeroAttr.dodge + value
	else
		defender.heroInfo.systemHeroAttr.dodge = defender.heroInfo.systemHeroAttr.dodge - value
	end
end

--43 �����ٶȼ���
function REDUCE_ATTACK_SPEED(defender,value,flag)
	if flag then
		defender.isDecelerate = true
		defender.heroInfo.systemHeroAttr.speedOdds = defender.heroInfo.systemHeroAttr.speedOdds + value
	else
		defender.isDecelerate = false
		defender.heroInfo.systemHeroAttr.speedOdds = defender.heroInfo.systemHeroAttr.speedOdds - value
	end
	if defender.heroInfo.systemHeroAttr.speedOdds <= 0 then
		defender.heroInfo.systemHeroAttr.speedOdds = 0.0001
	end
	
	if flag then
		defender:toSetSpeedOdds(-value)
	else
		defender:toSetSpeedOdds(value)
	end
end

--44 ����
function TAUNT()

end

--45 �����˺�����
function REDUCE_DAMAGE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease + value
	else
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease - value
	end
end

--46 �����˺�����
function REDUCE_DAMEGE_WEAPON(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.miniDamage = defender.heroInfo.systemHeroAttr.miniDamage + value
		defender.heroInfo.systemHeroAttr.maxDamage = defender.heroInfo.systemHeroAttr.miniDamage + value
	else
		defender.heroInfo.systemHeroAttr.miniDamage = defender.heroInfo.systemHeroAttr.miniDamage - value
		defender.heroInfo.systemHeroAttr.maxDamage = defender.heroInfo.systemHeroAttr.maxDamage - value
	end
end

--47 �����˺�����
function REDUCE_DAMEGE_PHYSICS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.physicsTough = defender.heroInfo.systemHeroAttr.physicsTough + value
	else
		defender.heroInfo.systemHeroAttr.physicsTough = defender.heroInfo.systemHeroAttr.physicsTough - value
	end
end

--48 �����˺�����
function REDUCE_DAMEGE_MAGIC(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.magicTouch = defender.heroInfo.systemHeroAttr.magicTouch + value
	else
		defender.heroInfo.systemHeroAttr.magicTouch = defender.heroInfo.systemHeroAttr.magicTouch - value
	end
end

--49 ������һ�ι���
function REFLECT_NEXT_ATTACK(defender,value,flag)
	if flag then
		defender.beingAttackState = StaticField.beingAttackState2
	else
		defender.beingAttackState = StaticField.beingAttackState1
	end
end

--50 ���ֵ����
function REDUCE_HATE_VALUE()

end

--51 �����˺�����
function ADD_DAMAGE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease + value
	else
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease - value
	end
end

--52 �����˺�����
function ADD_DAMEGE_WEAPON(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.miniDamage = defender.heroInfo.systemHeroAttr.miniDamage + value
		defender.heroInfo.systemHeroAttr.maxDamage = defender.heroInfo.systemHeroAttr.miniDamage + value
	else
		defender.heroInfo.systemHeroAttr.miniDamage = defender.heroInfo.systemHeroAttr.miniDamage - value
		defender.heroInfo.systemHeroAttr.maxDamage = defender.heroInfo.systemHeroAttr.maxDamage - value
	end
end

--53 �����˺�����
function ADD_DAMEGE_PHYSICS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease + value
	else
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease - value
	end
end

--54 �����˺�����
function ADD_DAMEGE_MAGIC(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease + value
	else
		defender.heroInfo.systemHeroAttr.damageIncrease = defender.heroInfo.systemHeroAttr.damageIncrease - value
	end
end

--55 ���ֵ����
function ADD_HATE_VALUE()

end

--56 ���ʩ��
function STUN_CONJURE()

end

--57 ��ĬĿ��
function SILENT_AIM(defender,value,flag)
	if flag then
		defender.silenceState = StaticField.silenceState1
	else
		defender.silenceState = StaticField.silenceState0
	end	
end

--58 ����ʱ������
function ADD_CONJURE_TIME()


end

--59 ����ʱ�����
function REDUCE_CONJURE_TIME()


end

--60 ��������
function ADD_RAPID(defender,value,flag)
	if flag then
		defender.isDecelerate = false
		defender.heroInfo.systemHeroAttr.speedUp = defender.heroInfo.systemHeroAttr.speedUp + value
	else
		defender.heroInfo.systemHeroAttr.speedUp = defender.heroInfo.systemHeroAttr.speedUp - value
	end	
	if flag then
		defender:toSetSpeedOdds(-value)
	else
		defender:toSetSpeedOdds(value)
	end
end

--61 ���ټ���
function REDUCE_RAPID(defender,value,flag)
	if flag then
		defender.isDecelerate = true
		defender.heroInfo.systemHeroAttr.speedUp = defender.heroInfo.systemHeroAttr.speedUp + value
	else
		defender.isDecelerate = false
		defender.heroInfo.systemHeroAttr.speedUp = defender.heroInfo.systemHeroAttr.speedUp - value
	end
	if flag then
		defender:toSetSpeedOdds(-value)
	else
		defender:toSetSpeedOdds(value)
	end
end

--62 �ָ�ħ��ֵ
function RECOVER_MAGIC(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy + value
	else
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy - value
	end
end

--63 ����ħ��ֵ
function REDUCE_MAGIC_VALUE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy + value
	else
		defender.heroInfo.systemHeroAttr.energy = defender.heroInfo.systemHeroAttr.energy - value
	end
end

--64 �����ָ��ٶ�����
function ADD_ENERGY_RECOVER(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energyRecover = defender.heroInfo.systemHeroAttr.energyRecover + value
	else
		defender.heroInfo.systemHeroAttr.energyRecover = defender.heroInfo.systemHeroAttr.energyRecover - value
	end
end

--65 �����ָ��ٶȽ���
function REDUCE_ENERGY_RECOVER(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.energyRecover = defender.heroInfo.systemHeroAttr.energyRecover + value
	else
		defender.heroInfo.systemHeroAttr.energyRecover = defender.heroInfo.systemHeroAttr.energyRecover - value
	end
end

--66 ħ�����ļ���
function REDUCE_MAGIC_EXPEND(defender,value,flag)

end

--67 ħ����������
function ADD_MAGIC_EXPEND(defender,value,flag)


end

--68 ������һ�ι���
function IMMUNE_NEXT_ATTACK(defender,value,flag)
	if flag then
		defender.beingAttackState = StaticField.beingAttackState3
	else
		defender.beingAttackState = StaticField.beingAttackState1
	end
end

--72 ����ֵ����
function ADD_CRIT_VALUE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.phyCrit = defender.heroInfo.systemHeroAttr.phyCrit + value
	else
		defender.heroInfo.systemHeroAttr.phyCrit = defender.heroInfo.systemHeroAttr.phyCrit - value
	end
end

--����ֵ����
function REDUCE_CRIT_VALUE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.phyCrit = defender.heroInfo.systemHeroAttr.phyCrit + value
	else
		defender.heroInfo.systemHeroAttr.phyCrit = defender.heroInfo.systemHeroAttr.phyCrit - value
	end
end

--���ܼ�������
function ADD_DODGE_ODDS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.dodgeOdds = defender.heroInfo.systemHeroAttr.dodgeOdds + value
	else
		defender.heroInfo.systemHeroAttr.dodgeOdds = defender.heroInfo.systemHeroAttr.dodgeOdds - value
	end
end

--���ܼ��ʽ���
function REDUCE_DODGE_ODDS(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.dodgeOdds = defender.heroInfo.systemHeroAttr.dodgeOdds + value
	else
		defender.heroInfo.systemHeroAttr.dodgeOdds = defender.heroInfo.systemHeroAttr.dodgeOdds - value
	end
end

--����
function ANCHOR(defender,value,flag)
	if flag then
		defender.isAllowWeak = false
		if defender.weakOverState == GameField.weakOver2 then
			defender:toHold()
			defender.heroBg:pause()
		end
	else
		defender.isAllowWeak = true
		if defender.weakOverState == GameField.weakOver2 then
			defender:toRun()
			defender.heroBg:resume()
		end
	end
end

--�ٻ�Ӣ��
function CALL_HERO(defender,value,callHeroId,flag)
	if flag then
		defender:toCallHero(value,callHeroId)
	else
		defender:toDelCallHero(value,callHeroId)
	end
end

--��������
function REDUCE_DAMAGE_ADD(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.toughIncrease = defender.heroInfo.systemHeroAttr.toughIncrease + value
	else
		defender.heroInfo.systemHeroAttr.toughIncrease = defender.heroInfo.systemHeroAttr.toughIncrease - value
	end
end

--���˼���
function REDUCE_DAMAGE_REDUCE(defender,value,flag)
	if flag then
		defender.heroInfo.systemHeroAttr.toughIncrease = defender.heroInfo.systemHeroAttr.toughIncrease + value
	else
		defender.heroInfo.systemHeroAttr.toughIncrease = defender.heroInfo.systemHeroAttr.toughIncrease - value
	end
end

--����
function ADD_HERO_SHIELD(defender,value,bIndex,flag)
	if flag then	
		defender.shieldNum = value
		defender.shieldIndex = bIndex
		defender.shieldState = StaticField.shieldState1
	else
		defender.shieldNum = value
		defender.shieldIndex = bIndex
		defender.shieldState = StaticField.shieldState0
	end
end

--�ٻ�Ӣ�ۼ���
function CALL_HERO_SKILL_EFFECT(defender,value,callHeroId,flag)
	if flag then
		defender:toCallHeroSkillEffect(value,callHeroId)
	else
		defender:toDelHeroSkillEffect(value,callHeroId)
	end
end

--����
function CALL_HERO_SHEEP(defender,value,callHeroId,flag)
	if flag then
		defender.sheepState = StaticField.sheepState1
		defender:toCallHeroSheep(value,callHeroId)
	else
		if defender.sheepState == StaticField.sheepState1 then --������ѭ��
		   defender.sheepState = StaticField.sheepState0
			defender:toDelHeroSheep(value,callHeroId)
		end
	end
end

function VAMPIRE_BUFF(defender,value,flag)
	if flag then
		defender.vampireBuff = value
	else
		defender.vampireBuff = 0
	end
end