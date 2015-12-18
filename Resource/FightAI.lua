require("SkillEffect")
FightAI={}

--攻击仇恨最高的
function FightAI.autoAttackAI(attacker,people)
	local hero = HateAI.getMaxHateHero(people)
	attacker:setAttackPeopleId(hero.peopleId)
end


function FightAI.tileMapAI(bgLayer,heroAttacker,heroDefender)
	--------------------攻击方---------------------
	local attacker = heroAttacker:getSkeleton()
	local defender = heroDefender:getSkeleton()
	
	local function attackrunCallBack()
		
	end
	
	local function attackendCallBack()
		if not heroDefender:isDead() then
			local rd = math.random(100)
			local px,py = defender:getPosition()
			heroDefender:setBloodDrop(-rd)
			SkillEffect.showDropBlood(bgLayer,-rd,px,py+50)	
		end
	end
	
	--------------------攻击方---------------------
	local function defendrunCallBack()
		
	end
	
	local function defendendCallBack()
		if not heroAttacker:isDead() then
			local rd = math.random(100)
			local px,py = attacker:getPosition()
			heroAttacker:setBloodDrop(-rd)
			SkillEffect.showDropBlood(bgLayer,-rd,px,py+50)	
		end
	end
	
	local function twosidesDirection()
		local tx = 0
		local ax,ay = attacker:getPosition()
		local dx,dy = defender:getPosition()
		local size = defender:getContentSize()
		local ac = defender:getScaleX()
		local bc = defender:getScaleX()
		if ax > dx then
			attacker:setScaleX(-math.abs(ac))
			defender:setScaleX(math.abs(bc))
			tx = -size.width/3
		else
			attacker:setScaleX(math.abs(ac))
			defender:setScaleX(-math.abs(ac))
			tx = size.width/3
		end
		return tx+ax,ay
	end
	
	
	local function walkcallback()	
		cclog("fighting")
		attacker:stopAllActions()
		attacker:playAttack(attackrunCallBack,attackendCallBack)
		
		defender:stopAllActions()
		defender:playAttack(defendrunCallBack,defendendCallBack)
		
		twosidesDirection()
	end
	
	local tx,ty = twosidesDirection()
	heroDefender:walk(tx,ty,walkcallback)
end


