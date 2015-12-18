require("SkillConfig")
require("SkillDefineFormula")
SkillEffect = {}

--技能掉血表现
function SkillEffect.showDropBlood(layer,value,labelStr,px,py)
	if value == 0 and labelStr ~= LabelChineseStr.dodge then
		return 
	end
	
	px = px or 50
	py = py or 100
	local fnt = "fight/font/debuff_num30.fnt"
	if value > 0 then
		fnt = "fight/font/buff_num30.fnt"
	else
		fnt = "fight/font/debuff_num30.fnt"
	end
	
	local tempStr = labelStr..value
	if labelStr == LabelChineseStr.dodge then
		tempStr = labelStr
	end

	local txtLbl = cc.LabelBMFont:create(tempStr,fnt)
	txtLbl:setPosition(cc.p(px,py))
	txtLbl:setAnchorPoint(cc.p(0.5,0.5))
	layer:addChild(txtLbl,100)
	
	local arr1 = {}
	arr1[1] = cc.ScaleBy:create(0.5,1.1)
	arr1[2] = cc.MoveBy:create(1,cc.p(0,80))
	arr1[3] = cc.DelayTime:create(0.2)
	arr1[4] = cc.CallFunc:create(function() txtLbl:removeFromParent(true) end)
	local sq1 = cc.Sequence:create(arr1)
	
	local arr2 = {}
	arr2[1] = cc.DelayTime:create(0.5)
	arr2[2] = cc.FadeOut:create(1.3)
	local sq2 = cc.Sequence:create(arr2)
	local spawn =  cc.Spawn:create(sq1,sq2)
	txtLbl:runAction(spawn)
end

--技能buff技能效果
function SkillEffect.showBuffIcon(layer,imgId,px,py)
	px = px or 50
	py = py or 50
	local sprite = CreateCCSprite(imgId)
	sprite:setPosition(cc.p(px,py))
	layer:addChild(sprite,100)
	
	local arr = {}
	arr[1] = cc.ScaleBy:create(0.5,1.2)
	arr[2] = cc.MoveBy:create(1,cc.p(0,80))
	arr[3] = cc.DelayTime:create(0.2)
	arr[4] = cc.CallFunc:create(function() sprite:removeFromParent(true) end)
	local sq = cc.Sequence:create(arr)
	sprite:runAction(sq)
end

--技能buff技能效果
function SkillEffect.showCombat(layer,num,isCombat)
	local px
	local imgId 
	if isCombat then
		px = 100
		imgId = "NewUi/qietu/zhandou/lianji.png"
	else
		px = 150
		imgId = "NewUi/qietu/zhandou/zongshanghai.png"
	end
	
	local mx = 800
	local my = 500
	local sprite = layer:getChildByTag(329)
	if sprite then
		sprite:removeFromParent(true)
	end
	sprite = CreateCCSprite(imgId)
	sprite:setPosition(cc.p(mx,my))
	sprite:setTag(329)
	layer:addChild(sprite,100)
	
	local size = sprite:getContentSize()
	local fnt = "NewUi/qietu/ziti/num_30_yellow.fnt"	
	local txtLbl = cc.LabelBMFont:create(num,fnt)
	txtLbl:setPosition(cc.p(px,size.height/2))
	txtLbl:setAnchorPoint(cc.p(0,0.5))
	sprite:addChild(txtLbl)

	if isCombat then
		local arr = {}
		arr[1] = cc.MoveTo:create(0.1,cc.p(mx-20,my))
		arr[2] = cc.MoveTo:create(0.1,cc.p(mx,my))
		arr[3] = cc.DelayTime:create(4)
		arr[4] = cc.CallFunc:create(function() sprite:removeFromParent(true) end)
		local sq = cc.Sequence:create(arr)
		sprite:runAction(sq)
	else
		local arr = {}
		arr[1] = cc.DelayTime:create(4)
		arr[2] = cc.CallFunc:create(function() sprite:removeFromParent(true) end)
		local sq = cc.Sequence:create(arr)
		sprite:runAction(sq)
	end
end

function SkillEffect.playSkillAnimte(resId,bgLayer,x,y,isFar)
	if resId ~= 0 then
		local effect = SkeletonSkill:New()
		local eff = effect:Create(resId,bgLayer,isFar)
		eff:setPosition(cc.p(x,y))
	end
end

--播放技能角度和时间
function SkillEffect.skillRotation(ax,ay,bx,by)
	local mx = ax - bx 
	local my = ay - by
	local mc = math.deg(math.atan(math.abs(mx/my)))
	local mt = math.sqrt(mx*mx+my*my)/GameField.skillMoveSpeed
	if my == 0 then
		if ax > bx then
			mc = 180
		else
			mc = 0
		end
	elseif my < 0 then
		if mx > 0 then
			mc = 270 - mc 
		else
			mc = 270 + mc
		end
	elseif my > 0 then
		if mx > 0 then
			mc = 90 + mc 
		else
			mc = 90 - mc
		end
	end
	return mc,mt
end

local buffList = {}
local buffIndex = 0 --唯一的

function SkillEffect.initBuffInfo()
	buffList = {}
	buffIndex = 0
end

function SkillEffect.playSkillAttack(idx,skill,effect,buffHero,attacker,defender,targetSelect,isTeamSkill)
	buffIndex = buffIndex + 1 --唯一值
	SkillEffect.deleteSkeletonEffect(defender,effect)
	
	local isFar = skill.isFar
	local ax,ay = attacker.heroBg:getPosition()
	local bx,by = defender.heroBg:getPosition()
	local actMode1 = attacker.heroInfo.actMode
	local actMode2 = defender.heroInfo.actMode
	local beingAttackState = defender.beingAttackState
	local monsterType = defender.heroInfo.systemMonster.monsterType
	
	if monsterType == StaticField.monsterType3 then
		--by = by + 80
	end
	local mc,mt = SkillEffect.skillRotation(ax,ay,bx,by)
	if beingAttackState == StaticField.beingAttackState2 and 
	  (actMode1 == actMode2 or targetSelect == StaticField.seleteType52) then 
		beingAttackState = StaticField.beingAttackState1
	end
	
	local resId = skill.resId
	if effect.isReadRes == 1 then--后续效果
		isFar = StaticField.isFar2
		resId = effect.nextEffectId 
	end
	
	if (isFar == StaticField.isFar3 or 
		isFar == StaticField.isFar4 or 
		isFar == StaticField.isFar5) and idx > 1 then --全屏只播一次
		resId = "t105" --默认的技能
	end
		
	if tonumber(resId) == 0 then
		resId = "t105" --默认的技能
	end
	
	local sc = SkillConfig[resId] or SkillConfig["0"]
	local skeletonSkill = SkeletonSkill:New()
	local skeleton = skeletonSkill:Create(resId,buffIndex,skill.resId)
	skeleton:setScale(sc.s)
	SoundEffect.playSkillSound(skill.skillId)
	
	local actHeroId = attacker.heroInfo.fightHeroId
	local defHeroId = defender.heroInfo.fightHeroId
	local bufHeroId = buffHero.heroInfo.fightHeroId
	local resultObj = SkillDefineFormula.skillDefineEffect(skill,effect,attacker,defender,buffIndex,beingAttackState,isTeamSkill)
	local buff = {attacker = attacker,defender = defender,skeleton = skeletonSkill,
				  skill=skill,effect = effect,resultObj = resultObj,buffIndex = buffIndex,
				  actHeroId = actHeroId,defHeroId = defHeroId,bufHeroId=bufHeroId,}
	buff.toGetHero = function()
		return attacker.fightPlayer:toGetHero(defHeroId)
	end
    table.insert(buffList,buff)
	
	local function bloodCallback() --掉血触发回调
		SkillDefineFormula.skillDefineBlood(buff)
	end
	
	local function cycleCallback(bIndex) --掉血触发回调
		SkillDefineFormula.skillDefineBlood(buff)
	end

	local function startCallback(bIndex) --开始触发回调
		SkillDefineFormula.skillPlayHeroAppear(buff,true)
	end
	
	local function endCallback(bIndex) --删除触发回调
		if resultObj.define.effectId == StaticField.attackFormula77 or
		   resultObj.define.effectId == StaticField.attackFormula81 then --特殊处理召唤的英雄
			attacker.fightPlayer:toDelCallHero(resultObj.value,resultObj.callHeroId,attacker)
		else
			SkillEffect.clearSkillEffectIndex(bIndex)
		end
	end
	
	local function frameCallback(evt)
		if attacker.heroBg then	
			attacker:toPlaySlayAnimation(evt)
		end
	end
	
	if isFar == StaticField.isFar1 then--轨迹
		local ey = 50
		local sz = skeleton:getContentSize()
		local scaleX = attacker.skeleton:getScaleX()
		local it = mt*(sc.t or 1)
		if scaleX > 0 then
			skeleton:setPosition(cc.p(ax+sc.x,ay+sc.y))
			skeletonSkill:setWeakPlay(it,bx-90,by+ey,mc,bloodCallback,startCallback,endCallback,beingAttackState)
		else
			skeleton:setAnchorPoint(cc.p(1,0.5))
			skeleton:setPosition(cc.p(ax-sc.x-sz.width/2,ay+sc.y))
			skeletonSkill:setWeakPlay(it,bx+20,by+ey,mc,bloodCallback,startCallback,endCallback,beingAttackState)
		end
		local zorder = attacker.heroBg:getLocalZOrder() + 2
		attacker.fightPlayer.rootLayer:addChild(skeleton,zorder)
	else
		local size = defender.heroBg:getContentSize()
		if actMode1 == actMode2 then --团长技能是自己发出的。	
			local scaleX = attacker.skeleton:getScaleX()
			if scaleX < 0 and (not isTeamSkill) then
				skeleton:setScaleX(-sc.s)
			end
		else
			if ax > bx then
				skeleton:setScaleX(-sc.s)
			end
		end
		
		if isFar == StaticField.isFar0 then --攻击方身上
			local scaleX = attacker.skeleton:getScaleX()
			if scaleX > 0 then	
				skeleton:setPosition(cc.p(size.width/2+sc.x,0+sc.y))
			else
				skeleton:setPosition(cc.p(size.width/2-sc.x,0+sc.y))
			end
			attacker.heroBg:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar3 then --固定
			local mx,my = attacker.heroBg:getPosition()
			local scaleX = attacker.skeleton:getScaleX()
			if scaleX > 0 then	
				skeleton:setPosition(cc.p(mx-sc.x,my+sc.y))
			else
				skeleton:setPosition(cc.p(mx+sc.x,my+sc.y))
			end
			attacker.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar4 then --全屏播放一次
			skeleton:setPosition(cc.p(480+sc.x,320+sc.y))
			attacker.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar5 then --敌人固定位置
			local mx,my = defender.heroBg:getPosition()
			local scaleX = defender.skeleton:getScaleX()
			if scaleX > 0 then	
				skeleton:setPosition(cc.p(mx-sc.x,my+sc.y))
			else
				skeleton:setPosition(cc.p(mx+sc.x,my+sc.y))
			end
			defender.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar6 then --召唤
			local mx,my = defender.heroBg:getPosition()
			local scaleX = defender.skeleton:getScaleX()
			if scaleX > 0 then	
				skeleton:setPosition(cc.p(mx-sc.x,my+sc.y))
			else
				skeleton:setPosition(cc.p(mx+sc.x,my+sc.y))
			end
			defender.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar7 then --点到点
			local sSize = skeleton:getContentSize()
			local aSize = attacker.skeleton:getContentSize()
			local bSize = defender.skeleton:getContentSize()
			
			local ax,ay = attacker.heroBg:getPosition()
			local bx,by = defender.heroBg:getPosition()
			local py = (by - ay)/2
			ay = ay + aSize.height/2
			by = by + bSize.height/2
			
			local width = math.sqrt((ax-bx)*(ax-bx) + (ay-by)*(ay-by))
			local scaleX = width*sc.s/sSize.width
			
			if scaleX > 2.5 then
				scaleX = scaleX+(scaleX-2.5)* 1				
			end
			skeleton:setScaleX(scaleX)
			skeleton:setPosition(cc.p(ax-(ax-bx)/2,ay+py))
			skeleton:setRotation(mc+180)
			attacker.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar8 then --buff英雄上
			local mx,my = buffHero.heroBg:getPosition()
			local scaleX = buffHero.skeleton:getScaleX()
			if scaleX > 0 then	
				skeleton:setPosition(cc.p(mx-sc.x,my+sc.y))
			else
				skeleton:setPosition(cc.p(mx+sc.x,my+sc.y))
			end
			buffHero.fightPlayer.rootLayer:addChild(skeleton,sc.z)
		elseif isFar == StaticField.isFar2 then --被攻击方身上
			local scaleX = defender.skeleton:getScaleX()
			if monsterType == StaticField.monsterType3 then --boss
				local ey = 0
				if scaleX > 0 then
					if ax > bx then
						skeleton:setPosition(cc.p(size.width/2-sc.x,ey+sc.y))
					else
						skeleton:setPosition(cc.p(size.width/2+sc.x,ey+sc.y))
					end
				else
					if ax > bx then
						skeleton:setPosition(cc.p(size.width/2+sc.x,ey+sc.y))
					else
						skeleton:setPosition(cc.p(size.width/2-sc.x,ey+sc.y))
					end
				end
			else
				if scaleX > 0 then
					skeleton:setPosition(cc.p(size.width/2+sc.x,0+sc.y))
				else
					skeleton:setPosition(cc.p(size.width/2-sc.x,0+sc.y))
				end
			end
			defender.heroBg:addChild(skeleton,sc.z)
		end
		skeletonSkill:setOriginPlay(skill.effectTimes,effect,bloodCallback,cycleCallback,startCallback,endCallback,frameCallback)
	end
	setSkeletonAnimation(resId,skeleton)
	
	return resultObj
end

--播放特殊技能
function SkillEffect.playSpecialSkill(resId,rootLayer,x,y)
	buffIndex = buffIndex + 1
	if tonumber(resId) == "0" then --不读资源
		resId = "t105" --默认的技能
	end
	local sc = SkillConfig[resId]
	x = x or sc.x
	y = y or sc.y
	local skeletonSkill = SkeletonSkill:New()
	local skeleton = skeletonSkill:Create(resId,buffIndex)
	skeleton:setScale(sc.s)
	skeleton:setPosition(cc.p(x,y))
	skeletonSkill:setCommonPlay(false)
	rootLayer:addChild(skeleton,sc.z)
end

--删除效果
function SkillEffect.deleteSkill(buff)
	SkillDefineFormula.skillRecoveryFeature(buff)
	SkillDefineFormula.skillPlayHeroAppear(buff,false)
	buff.skeleton:Release()
end

--持续效果，并且不叠加的
function SkillEffect.deleteSkeletonEffect(defender,effect)	
	for k=#buffList,1,-1 do
		local buff = buffList[k]	
		if buff.defHeroId == defender.heroInfo.fightHeroId and
		   effect.skillId == buff.effect.skillId and
		   effect.effectId == buff.effect.effectId and
		   effect.round ~= StaticField.roundType  and
		   effect.addType == StaticField.addType0 then --相同技能相同效果不叠加
			table.remove(buffList,k)
			SkillEffect.deleteSkill(buff)
			break
		end
	end
end

--清除持续长的效果
function SkillEffect.clearHeroBuffEffect(defender)
	local num = #buffList
	for i=1,num do
		for k = #buffList,1,-1 do
			local buff = buffList[k]
			if buff.bufHeroId == defender.heroInfo.fightHeroId and 
			   buff.skill.isFar == StaticField.isFar8 then
				table.remove(buffList,k)--先删除表，后移除效果
				SkillEffect.deleteSkill(buff)
				break
			end
			
			if buff.actHeroId == defender.heroInfo.fightHeroId and 
			   buff.skill.isFar == StaticField.isFar0 then
				table.remove(buffList,k)--先删除表，后移除效果
				SkillEffect.deleteSkill(buff)
				break
			end
			
			if buff.defHeroId == defender.heroInfo.fightHeroId then
				table.remove(buffList,k)--先删除表，后移除效果
				if buff.skill.isFar ~= StaticField.isFar4 and 
				   buff.skill.isFar ~= StaticField.isFar6 then
					SkillEffect.deleteSkill(buff)
			    end
				break
			end
		end
	end
end

--清除持续长的效果
function SkillEffect.hideHeroBuffEffect(defender)
	for k = #buffList,1,-1 do
		local buff = buffList[k]
		if buff.defHeroId == defender.heroInfo.fightHeroId and 
		   buff.skill.isFar ~= StaticField.isFar4 then
			buff.skeleton:hide()
		end
	end
end

--清除固定位置的
function SkillEffect.clearFixedBuffEffect()
	local num = #buffList
	for i=1,num do
		for k = #buffList,1,-1 do
			local buff = buffList[k]
			if buff.skill.isFar == StaticField.isFar3 then
				table.remove(buffList,k)--先删除表，后移除效果
				SkillEffect.deleteSkill(buff)
				break
			end
		end
	end
end

--清除可以被清除的BUFF
function SkillEffect.clearCanSkillEffect(defender)
	local num = #buffList
	for i=1,num do
		for k = #buffList,1,-1 do
			local buff = buffList[k]
			if buff.defHeroId == defender.heroInfo.fightHeroId and
			   StaticField.removeAble1 == buff.effect.removeAble then
				table.remove(buffList,k)--先删除表，后移除效果
				SkillEffect.deleteSkill(buff)
				break
			end
		end
	end
end

--清除指定的buff
function SkillEffect.clearSkillEffectIndex(bIndex)
	for k=#buffList,1,-1 do
		local buff = buffList[k]
		if buff.buffIndex == bIndex then
			table.remove(buffList,k)--先删除表，后移除效果
			SkillEffect.deleteSkill(buff)
			break
		end	
	end
end