require("SkillCycleAI")
FightHero = {}

function FightHero:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function FightHero:Init(fightPlayer,heroInfo)
	self.skillStack = {} --技能堆栈
	self.skillBuff = {}
	self.cycleBuff = {}
	self.targetPs = {} --攻击点
	self.attackPs = {} --攻击点
	self.attackPos = {}
	self.sendHurtInfo = {} --攻打boss信息
	self.sendBuffInfo = {} --攻打boss信息
	self.receiveEffect = {} --接收攻打boss信息
	
	self.isFlee = false --逃跑
	self.isDead = false --死亡
	self.isCanSlay = false -- 是否释放必杀
	self.isSelect = false --是否选择
	self.isWaitQTE = false --等待QTE
	self.isStartFight = false --是否开始战斗
	self.isAllowWeak = true --是否允许走路
	self.isDecelerate = false --是否减速
	self.isDiscolor = false --是否变色完成
	
	self.posIdx = 0 -- 索引值
	self.shieldNum = 0 --护盾的值
	self.shieldIndex = 0 --护盾的索引值
	self.skillHurtCount = 0 --技能总伤害
	self.combatIndex = 0 --连击的次数
	self.heroHateNum = 0 --仇恨
	self.vampireBuff = 0 --吸血的BUff
	self.battleSkillId = 0 --技能ID
	self.selectHero = {} --选择的英雄
	self.attackInfo = nil --攻击的信息
	self.hurtHeroList = nil --技能伤害的人
	self.cycleSkill = nil --技能
	self.speedOdds = 1 --急速值
	self.qteClickNum = 0 --QTE点击的次数
	self.curSlayCD = heroInfo.playSlayCD --必杀技CD
	self.weakOverState = GameField.weakOver1 --是否移动到位
	self.playSkillState = StaticField.playSkillState1 --伤害结算
	self.invincibleState = StaticField.invincible0 --普通
	self.shieldState = StaticField.shieldState0 --无护盾
	self.comaState = StaticField.comaState0 --不昏迷
	self.sheepState = StaticField.sheepState0 --不变身
	self.heroSkillState = StaticField.heroSkillState0 --无英雄技能
	self.dizzinessState = StaticField.dizzinessState0 --不眩晕
	self.silenceState = StaticField.silenceState0 --不沉默
	self.beingAttackState = StaticField.beingAttackState1 --正常
	self.fightType = fightPlayer.fightReport.fightType
	
	local imgStr = "fight/shadows.png"
	if heroInfo.petType == StaticField.petType4 then
		imgStr = "fight/gray.png"
	else
		imgStr = "fight/shadows.png"
	end
	
	local modelScale=heroInfo.systemHero.modelScale
	local scale={x=modelScale,y=modelScale}
	local heroBg = CreateCCSprite(imgStr)
	local size = heroBg:getContentSize()
	fightPlayer.rootLayer:addChild(heroBg)
		
	local hero = SkeletonAction:New()
	local skeleton = hero:Create(heroInfo.systemHero.resId)
	skeleton:setPosition(cc.p(size.width/2,size.height/2))
	heroBg:addChild(skeleton,2)
		
	if heroInfo.heroState == StaticField.heroState2 then --灵魂
		local arr = {}
		arr[1] = cc.FadeOut:create(0.6)
		arr[2] = cc.FadeIn:create(0.7)
		local action = cc.RepeatForever:create(cc.Sequence:create(arr))
		skeleton:runAction(action)
	end
	
	if heroInfo.systemMonster.monsterType == StaticField.monsterType1 or  --普通怪
	   heroInfo.systemMonster.monsterType == StaticField.monsterType2 then
		skeleton:setScaleX(-scale.x)
		skeleton:setScaleY(scale.y)
	elseif heroInfo.systemMonster.monsterType == StaticField.monsterType3 then --boss
		skeleton:setScaleX(-scale.x)
		skeleton:setScaleY(scale.y)
	elseif heroInfo.systemMonster.monsterType == StaticField.monsterType4 then --英雄
		skeleton:setScaleX(scale.x)
		skeleton:setScaleY(scale.y)
	end
			
	local function rCallBack(evt)
		evt = string.gsub(evt," ","") --防止美术失误有空格
		if evt == StaticField.frameST then --攻击前
			if heroInfo.actMode == GameField.actMode2 and
			   heroInfo.battleType == GameField.battleType2 and
			   heroInfo.systemMonster.monsterType == StaticField.monsterType3 then
				--fightPlayer:doHeroSelect(self) --废弃
			end
			SkillAI.specialAI(self,self.battleSkillId)
		elseif evt == StaticField.frameAT then --攻击掉血
			fightPlayer:toPlaySkill(self)
		elseif evt == StaticField.frameET then --方大招
			self.battleSkillId = self.heroInfo.systemHero.skill05
			self.playSkillState = StaticField.playSkillState3
			fightPlayer:toPlaySkill(self)
		elseif evt == StaticField.frameNT then --攻击后
		
		elseif evt == StaticField.frameTS then --特殊
			self.isStartFight = true
			self.playSkillState = StaticField.playSkillState1
			self.skeleton:getAnimation():play(ACTION_TS)
		end
	end
	
	local function eCallBack(movementID)
		if self.isFlee then
			self.skeleton:getAnimation():play(ACTION_HOLD)
			return
		end
		
		if movementID == ACTION_ATTACK0 or 
		   movementID == ACTION_ATTACK1 or
		   movementID == ACTION_ATTACK2 or
		   movementID == ACTION_ATTACK3 or 
		   movementID == ACTION_FIRE then
			self.isStartFight = true
			self.skeleton:getAnimation():play(ACTION_HOLD)
			self:toCheckBuffState(StaticField.skillHurt5)
			self.playSkillState = StaticField.playSkillState1
		elseif movementID == ACTION_START then
			self.isStartFight = true
			self.playSkillState = StaticField.playSkillState1
			self.skeleton:getAnimation():play(ACTION_HOLD)
		elseif movementID == ACTION_HURT then
			self.skeleton:getAnimation():play(ACTION_HOLD)
		elseif movementID == ACTION_DEAD then
			self:toRelease()
		end
	end
	hero:setFrameCallBack(rCallBack,eCallBack)

	local rect = skeleton:getBoundingBox()
	if skeleton:getScaleX() < 0 then
		rect.x = rect.x + rect.width/3
	end
	rect.width = rect.width*2/3
	
	local testLayer = cc.LayerColor:create(cc.c4b(0,232,0,0))
	testLayer:setContentSize(cc.size(rect.width,rect.height))
	testLayer:setPosition(cc.p(rect.x,rect.y))
	heroBg:addChild(testLayer,-1)
	
	local label = CreateLabel("")
	label:setPosition(cc.p(size.width/2,250))
	heroBg:addChild(label)
	self.label = label
	
	self.rect = rect
	self.hero = hero
	self.heroBg = heroBg
	self.skeleton = skeleton
	self.fightPlayer = fightPlayer
	self.heroInfo = heroInfo
	self.testLayer = testLayer
	self:doSkillSpeedOdds()
	self:toCreateProgress()
end

function FightHero:toHold()
	self.skeleton:getAnimation():play(ACTION_HOLD)
	self.skeleton:getAnimation():setSpeedScale(math.random(100,130)/100)
end

function FightHero:toRun()
	self.skeleton:getAnimation():play(ACTION_RUN)
end

function FightHero:toFleeAction()
	self.isFlee = true
	self.skeleton:getAnimation():play(ACTION_ATTACK1)
end

function FightHero:toStart(state)
	if state then
		self.skeleton:getAnimation():play(ACTION_HOLD)
		--self.skeleton:getAnimation():play(ACTION_START)
		--self.hero:stop()
	else
		--self.skeleton:getAnimation():play(ACTION_START)
		SoundEffect.playSoundEffect("boss_1")
	end
end

--走路
function FightHero:toWeak(t,x,y,i,cback)
	if self.isFlee then
		return
	end
	
	local arr = {}
	arr[1] = cc.MoveTo:create(t,cc.p(x,y))
	arr[2] = cc.CallFunc:create(function()
		if cback then
			cback(self,i)
		end
		self:toHold()
	end)
	local sq = cc.Sequence:create(arr)	
	self.heroBg:stopAllActions()
	self.heroBg:runAction(sq)
	self.skeleton:getAnimation():play(ACTION_RUN)
	self.skeleton:getAnimation():setSpeedScale(1)
	self.isStartFight = false
	self:clearWeakTime()
end

--开始普通攻击
function FightHero:toGeneralBattle(isStop)
	if self.playSkillState == StaticField.playSkillState1 and
	   self.heroSkillState == StaticField.heroSkillState0 then
		self.isStartFight = true
		self.heroBg:stopAllActions()
		self.skeleton:getAnimation():play(ACTION_HOLD)
	else
		self.isStartFight = true
	end
end

function FightHero:toCheckSkillCd()
	if self.fightType == GameField.fightType4 and not DataManager.getWorldBossRoomOwner() then
		return
	end
	
	--更新
	local function doCheckSkillCd()
		if not self.fightPlayer.isstart then
			return
		end
		
		if self.isDead then
			return
		end
		
		for m,n in pairs(self.heroInfo.activeSkillList) do
			if n.isNotStack then
				n.nextPlayerTime = n.nextPlayerTime - 0.1
				if n.nextPlayerTime <= 0 then
					n.isNotStack = false
					table.insert(self.skillStack,n)
				end
			end
		end
		--SkillAI.TestSkill(v,heroAttr,activeSkillList)
		
		--主动技能
		if self.isStartFight and (not self.isWaitQTE) and
		   self.comaState == StaticField.comaState0 and
		   self.dizzinessState == StaticField.dizzinessState0 and
		   self.playSkillState == StaticField.playSkillState1 and
		   self.invincibleState == StaticField.invincible0 then --无敌冰冻
			self:toRunSkill1()
		    self:toRunSkill2()
		end
		
		--必杀技的能量
		self.curSlayCD = self.curSlayCD - 0.1
		if (not self.isCanSlay) and self.curSlayCD <= 0 and 
		   self.heroInfo.actMode == GameField.actMode1 then
			self.isCanSlay = true
			--v:doPlaySimpleEffect("t102",true)
		end
	end
	
	self.attackInfo = nil
	self.isStartFight = true
	self.targetPs = {x=-1,y=-1,s= -1} --攻击点
	self.attackPs = {x=-1,y=-1} --攻击点
	self.attackPos = {0,0,0,0,0,0,0} --攻击点
	self:clearSkillTime()
	self.skeleton:getAnimation():play(ACTION_HOLD)
	self.frameHandler = Director.getScheduler():scheduleScriptFunc(doCheckSkillCd,0.1,false)
end

function FightHero:doHeroMoveTo(ts,callBack)
	local sp = self.heroInfo.systemHeroAttr.moveSpeed --200
	local len = ts*sp
	local lenX = len
	local lenY = len
	
	local mx,my = self.heroBg:getPosition()
	local tx,ty = self.attackPs.x,self.attackPs.y

	local sx = math.abs(tx - mx)
	local sy = math.abs(ty - my)
	
	if sx < lenX then
		lenX = sx
	end
	
	if sy < lenY then
		lenY = sy
	end
	
	if sx > sy then
		lenY = (sy/sx)*lenY
	elseif sx < sy then
		lenX = (sx/sy)*lenX
	end

	if tx > mx then
		mx = mx+lenX
	else
		mx = mx-lenX
	end
	
	if ty > my then
		my = my+lenY
	else
		my = my-lenY
	end
	
	local mixW = 50
	local mixH = 100
	local winSize = Director.getRealWinSize()
	local maxW = winSize.width - 100
	local maxH = winSize.height - 320
	
	if (math.abs(tx-mx) <= 1 and math.abs(ty-my) <= 1) or 
	   (mx < mixW or mx > maxW or my < mixH or my > maxH) then
		callBack()
	else
		self.heroBg:setPosition(cc.p(mx,my))
		self.heroBg:setLocalZOrder(960-my)
	end
end

--测量坐标
function FightHero:doMeasurPosition(ts,callBack,flag)
	local standId = self.heroInfo.systemHero.standId
	if standId == StaticField.standId1 or standId == StaticField.standId2 then --近战
		self:doMeasurPosition1(ts,callBack,flag)
	else
		self:doMeasurPosition2(ts,callBack,flag)
	end
end

function FightHero:doMeasurPosition1(ts,callBack,flag)
	local px = 0
	local py = 0
	local ex = 0
	local tx,ty = -1,-1
	local sx = self.skeleton:getScaleX()
	local mx,my = self.heroBg:getPosition()
	local world1 = self.testLayer:convertToWorldSpace(cc.p(0,0))
	local p1world = self.fightPlayer.rootLayer:convertToWorldSpace(world1)

	local curHero = self.attackInfo.curHero
	local cx,cy = curHero.heroBg:getPosition()
	local world2 = curHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p2world = curHero.fightPlayer.rootLayer:convertToWorldSpace(world2)
	
	local distance = self.heroInfo.systemHeroAttr.attackRange
	local trackPos = self.attackInfo.trackPos
	
	local standId = self.heroInfo.systemHero.standId
	if standId == StaticField.standId1 or standId == StaticField.standId2 then --近战	
		--distance = 100
	else
		--distance = 200
	end
	
	if self.heroInfo.systemMonster.monsterType == StaticField.monsterType4 then
		--trackPos = 3
		--distance = 100
	else
		--distance = 150
		--trackPos = 1
	end
	distance = distance < 30 and 30 or distance
	
	if trackPos == 1 then
		tx = p2world.x - distance
		ty = cy
	elseif trackPos == 2 then
		tx = p2world.x - distance
		ty = cy + curHero.rect.height/3
	elseif trackPos == 3 then
		tx = p2world.x + curHero.rect.width + distance
		ty = cy
	elseif trackPos == 4 then
		tx = p2world.x + curHero.rect.width + distance
		ty = cy + curHero.rect.height/3
	elseif trackPos == 5 then
		tx = p2world.x - distance
		ty = cy + curHero.rect.height/2
	elseif trackPos == 6 then
		tx = p2world.x + curHero.rect.width + distance
		ty = cy + curHero.rect.height/2
	end
	
	local contain = false
	local offY1 = p1world.y + self.rect.height - p2world.y 
	local offY2	= p1world.y + curHero.rect.height + p2world.y
	local height = self.rect.height+curHero.rect.height
	if sx > 0 then
		if trackPos == 1 or trackPos == 2 or trackPos == 5 then
			tx = tx-math.abs(mx-p1world.x-self.rect.width)
			if p1world.x+self.rect.width > p2world.x then
				contain = true
			end
		else
			tx = tx+math.abs(mx-p1world.x)
			if p1world.y > p2world.y then
				if offY1 > height then
					ex = curHero.rect.width + distance * 10
				else 
					ex = curHero.rect.width + distance
				end
			else
				if offY2 > height then
					ex = curHero.rect.width + distance * 10
				else
					ex = curHero.rect.width + distance
				end
			end
		end
		px = p1world.x+self.rect.width-p2world.x
	else
		if trackPos == 1 or trackPos == 2 or trackPos == 5 then
			tx = tx-math.abs(mx-p1world.x-self.rect.width)
			if p1world.y > p2world.y then
				if offY1 > height then
					ex = -curHero.rect.width - distance * 10
				else 
					ex = curHero.rect.width - distance
				end
			else
				if offY2 > height then
					ex = -curHero.rect.width - distance * 10
				else
					ex = curHero.rect.width - distance
				end
			end
		else
			tx = tx+math.abs(mx-p1world.x)
			if p1world.x < p2world.x+curHero.rect.width then
				contain = true
			end
		end
		px = p1world.x-curHero.rect.width-p2world.x
	end
	
	local special = false --状态
	if contain then
		if standId == StaticField.standId1 or standId == StaticField.standId2 then
			special = true
			if px > 0 then
				px = px + distance*2
			else
				px = px - distance*2
			end
		else
			self.skeleton:setScaleX(-self.skeleton:getScaleX())
		end
	end
		
	if  math.floor(math.abs(px)+ math.abs(ex)) < distance + 2 and
		math.abs(my - ty) > 5 then
	   --(my - cy < 0 or my - cy > curHero.rect.height*2/3) then
		special = true
	end
	
	if math.floor(math.abs(px)+ math.abs(ex)) > distance + 2 then
		special = true
	end
		
	if special then
		if px > 0 then
			px = px - distance
		else
			px = px + distance
		end
		py = (p1world.y-p2world.y)/2
		callBack(tx,ty,px,py,ex)
	end
end

--测量坐标
function FightHero:doMeasurPosition2(ts,callBack,flag)
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0
	local ex = 0
	local tx,ty = -1,-1
	local sx = self.skeleton:getScaleX()
	local mx,my = self.heroBg:getPosition()
	local world1 = self.testLayer:convertToWorldSpace(cc.p(0,0))
	local p1world = self.fightPlayer.rootLayer:convertToWorldSpace(world1)

	local curHero = self.attackInfo.curHero
	local cx,cy = curHero.heroBg:getPosition()
	local world2 = curHero.testLayer:convertToWorldSpace(cc.p(0,0))
	local p2world = curHero.fightPlayer.rootLayer:convertToWorldSpace(world2)
	
	local distance = self.heroInfo.systemHeroAttr.attackRange
	local trackPos = self.attackInfo.trackPos
	
	if sx > 0 then
		x1 = p1world.x+self.rect.width
		y1 = p1world.y
		x2 = p2world.x
		y2 = p2world.y
		px = x1 - x2 + distance
		py = 0
	else
		x1 = p1world.x
		y1 = p1world.y
		x2 = p2world.x+curHero.rect.width
		y2 = p2world.y
		px = x1 - x2 - distance
		py = 0
	end
	
	local len = math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
	if len > distance then
		tx = x2-distance*(x2-x1)/len
		ty = y2-distance*(y2-y1)/len
		callBack(tx,ty,px,py,ex)
	end
end

function FightHero:doWeakHero(ts,callBack)
	local movementID = self.skeleton:getAnimation():getCurrentMovementID()
	if self.isDead == false and self.isAllowWeak and
	   self.comaState == StaticField.comaState0 and
	   self.invincibleState == StaticField.invincible0 and
	   self.playSkillState == StaticField.playSkillState1 and  --冰冻和播大招都不能走
	   self.heroSkillState == StaticField.heroSkillState0 and
	   self.dizzinessState == StaticField.dizzinessState0 then
		if movementID == ACTION_HOLD then
			self.skeleton:getAnimation():play(ACTION_RUN)
		end
		self:doHeroMoveTo(ts,callBack)
	else
		if movementID == ACTION_RUN then
			self.skeleton:getAnimation():play(ACTION_HOLD)
		end
	end
end

function FightHero:doAttackScale(curHero)
	local ax,ay = self.heroBg:getPosition()
	local dx,dy = curHero.heroBg:getPosition()
	local sx = self.skeleton:getScaleX()	
	if self.heroInfo.fightHeroId ~= curHero.heroInfo.fightHeroId then
		sx = math.abs(sx)
		if ax > dx then 
			sx = -sx
		else
			sx = sx
		end
	end
	return sx
end

function FightHero:doAttackDirection(curHero)
	local sx = self:doAttackScale(curHero)
	self.skeleton:setScaleX(sx)
end

function FightHero:doPlayBattleSkill()
	local skill = self.attackInfo.systemSkill
	for k,v in pairs(self.skillStack) do
		if v.skillId == skill.skillId then
			local nextPlayerTime = skill.cdTime*(2-self.speedOdds)
			v.isNotStack = true
			v.nextPlayerTime = nextPlayerTime
			self:toSkillBattle(self.attackInfo.selectList,skill.skillId,skill.skillPos,nextPlayerTime)
			self.attackInfo.curHero.attackPos[self.attackInfo.trackPos] = 0
			self.attackInfo = nil
			table.remove(self.skillStack,k)
			break
		end
	end
end

--技能攻击
function FightHero:toRunSkill1()
	if self.attackInfo and self.attackInfo.curHero and 
	   self.attackInfo.curHero.heroBg then
		return 
	end
	
	local skill = nil
	if #self.skillStack > 0 then --先判断存在的
		if self.silenceState == StaticField.silenceState1 then
			for k,v in pairs(self.skillStack) do
				if v.skillPos == 1 then
					skill = v
				end
			end
		else
			skill = self.skillStack[1]
		end
	end
	
	if skill == nil then --后判断不存在的
		local nextTime = 1000
		for k,v in pairs(self.heroInfo.activeSkillList) do
			if self.silenceState == StaticField.silenceState1 then
				if v.skillPos == 1 then
					skill = v
				end
			else
				if nextTime > v.nextPlayerTime then
					skill = v
					nextTime = v.nextPlayerTime
				end
			end
		end
	end

	self.attackInfo = SkillAI.getBattleHero(skill,self)
	if self.attackInfo == nil or self.attackInfo.isSelf then
		return
	end
	self.selectHero = self.attackInfo.curHero
	
	local function callBack()
		self.targetPs.x = -1
		self.targetPs.y = -1
		self.targetPs.s = -1
		self:clearWeakTime()
		self.isStartFight = true
		self.skeleton:getAnimation():play(ACTION_HOLD)
	end
	
	local function setAttackPs(tx,ty,px,py,ex)
		local curHero = self.attackInfo.curHero
		local tp = self.heroInfo.systemHeroAttr.moveSpeed
		local mp = curHero.heroInfo.systemHeroAttr.moveSpeed
		local mx = curHero.targetPs.x
		local my = curHero.targetPs.y
		if mx ~= -1 and my ~= -1 then
			local cx,cy = curHero.heroBg:getPosition()
			local sx,sy = self.heroBg:getPosition()
			
			local timX = px/(tp+mp)
			self.attackPs.x = sx-timX*tp--+ex
			--self.attackPs.y = ty + py
			
			if cy-my < sy-ty then --cy-my 表示攻击方
				--((sy-ty)-(cy-my))
				local t = (cy-my)/(tp+mp)
				self.attackPs.y = ty - t*tp
			else
				local t = (sy-ty)/(tp+mp)
				self.attackPs.y = ty + t*tp
			end
		else
			self.attackPs.x = tx
			self.attackPs.y = ty
		end
		self.targetPs.s = 1
		self.targetPs.x = tx
		self.targetPs.y = ty
	end
	
	local state = self.attackInfo.curHero.targetPs.s
	local function checkHeroState()
		local ms = self.attackInfo.curHero.targetPs.s
		if state ~= ms then
		    state = ms
			self:doMeasurPosition(0,function(tx,ty,px,py,ex) 
				setAttackPs(tx,ty,px,py,ex)
			end,false)
		end
	end
	
	local function checkCollisionFunc(ts)
		if self.attackInfo then
			checkHeroState()
			self:doWeakHero(ts,callBack)
		else
			callBack()
		end
	end

	local function runWeakFunc(tx,ty,px,py,ex)
		setAttackPs(tx,ty,px,py,ex)
		self.isStartFight = false
		self:clearWeakTime()
		self.skeleton:getAnimation():play(ACTION_RUN)
		self.skeleton:getAnimation():setSpeedScale(1)
		self.collisionHandler = Director.getScheduler():scheduleScriptFunc(checkCollisionFunc,0,false)
	end
	self:doAttackDirection(self.attackInfo.curHero) --确定方向
	self:doMeasurPosition(0,runWeakFunc,true)
end

--技能攻击
function FightHero:toRunSkill2()
	local movementID = self.skeleton:getAnimation():getCurrentMovementID()
	if movementID == ACTION_RUN or 
	   self.attackInfo == nil or 
	   self.attackInfo.curHero == nil or 
	   self.attackInfo.curHero.heroBg == nil then 
		return
	end
	
	if self.attackInfo.curHero.isDead then
		self.attackInfo = nil
	    return 
	end
	
	if self.silenceState == StaticField.silenceState1 and --走路时间大于技能到达时间，期间沉默了，需要改变。
	   self.attackInfo.systemSkill.skillPos ~= 1 then
		self.attackInfo = nil
	    return 
	end
	
	local skill = nil
	for k,v in pairs(self.skillStack) do
		if v.skillId == self.attackInfo.systemSkill.skillId then
			skill = v
			break
		end
	end
	
	if skill then
		self:clearWeakTime()
		self:doAttackDirection(self.attackInfo.curHero)
		self:doPlayBattleSkill()
	end
end

function FightHero:toSkillBattle(selectList,skillId,index,attackTime)
	if self.isDead then --死去不能播放其他动画
		return 
	end
	
	self.isStartFight = false
	self.hurtHeroList = selectList
	self.battleSkillId = skillId --主动攻击技能
	self.playSkillState = StaticField.playSkillState1
	self:toCheckBuffState(StaticField.skillHurt4)
	local action = ACTION_ATTACK0
	if self.heroInfo.actMode == GameField.actMode1 then --怪物只有一个技能骨骼动画
		if index == 1 then
			action = ACTION_ATTACK0
		elseif index == 2 then
			action = ACTION_ATTACK1
		elseif index == 3 then
			action = ACTION_ATTACK2
		elseif index == 4 then
			action = ACTION_ATTACK3
		elseif index == 5 then
			action = ACTION_FIRE
			self.playSkillState = StaticField.playSkillState2
		end
	else
		--小怪只有一个动作
		if self.heroInfo.systemMonster.monsterType == StaticField.monsterType3 then --boss
			if index == 1 then
				action = ACTION_ATTACK0
			elseif index == 2 then
				action = ACTION_ATTACK1
			end
		end
	end
	
	local frameTime = self.heroInfo.systemHero.frame/StaticField.heroFrame
	if attackTime < frameTime then
		self.skeleton:getAnimation():setSpeedScale(frameTime/attackTime)
	else
		if self.isDecelerate then
			self.skeleton:getAnimation():setSpeedScale(0.4)
		else
			self.skeleton:getAnimation():setSpeedScale(1)
		end
	end
	
	if self.heroInfo.petType == StaticField.petType4 then --召唤技能的英雄
		self.skeleton:getAnimation():setSpeedScale(0.6)
	end
		
	if self.skeleton:getAnimation():getAnimationData():getMovement(action) then--判断动作是否存在
		self.skeleton:getAnimation():play(action)
	else
		self.skeleton:getAnimation():play(ACTION_ATTACK0)
	end
		
	if self.heroSkillState == StaticField.heroSkillState0 then
		self.heroBg:stopAllActions()
	end
end

--QTE攻击
function FightHero:toQTEBattle(skillId,attackTime)
	if self.isDead then --死去不能播放其他动画
		return 
	end
	
	self.isStartFight = false
	local frameTime = self.heroInfo.systemHero.frame/StaticField.heroFrame
	if attackTime < frameTime then
		local speed = frameTime/attackTime
		speed = speed > 3 and 3 or speed
		self.skeleton:getAnimation():setSpeedScale(speed)
	else
		self.skeleton:getAnimation():setSpeedScale(1)
	end
	self.skeleton:getAnimation():play(ACTION_ATTACK0)
end

--播放必杀技
function FightHero:toPlaySlaySkill()
	self.isWaitQTE = false
	self.curSlayCD = self.heroInfo.playSlayCD --必杀技CD
	self:toSkillBattle(self.heroInfo.systemHero.skill01,5,10)
end

function FightHero:toBloodVisible(flag)
	local function visible(flag)
		self.bloodBg:setVisible(flag)
		self.bloodPro:setVisible(flag)
	end
	
	local monsterType = self.heroInfo.systemMonster.monsterType
	if monsterType ~= StaticField.monsterType3 then
		visible(flag)
	end
	
	if flag then
		local arr = {}
		arr[1] = cc.DelayTime:create(10)
		arr[2] = cc.CallFunc:create(function() visible(false) end)
		local sq = cc.Sequence:create(arr)
		self.heroBg:runAction(sq)
	end
end

--受击效果
function FightHero:doPlaySimpleEffect(resId,isCycle)
	local sc = SkillConfig[resId]
	local skeletonSkill = SkeletonSkill:New()
	local skeleton = skeletonSkill:Create(resId,0)
	local size = self.heroBg:getContentSize()
	local ey = self.heroInfo.systemMonster.monsterType == StaticField.monsterType3 and 100 or 0
	if self.heroInfo.actMode == GameField.actMode1 then
		skeleton:setPosition(cc.p(size.width/2+sc.x,ey+sc.y))
	else
		skeleton:setPosition(cc.p(size.width/2-sc.x,ey+sc.y))
	end
	skeleton:setScale(sc.s)
	skeletonSkill:setCommonPlay(isCycle)
	self.heroBg:addChild(skeleton,sc.z)
	SoundEffect.playSkillSound(string.gsub(resId,"t","")) --音效
	
	if isCycle then
		self.cycleSkill = skeleton
	end
end

--受击效果
function FightHero:doStrikeEffect(num,resId)
	if num <= 0 then
		if resId == "t21010" then
			self:doPlaySimpleEffect("t124",false) --受击效果
		else
			self:doPlaySimpleEffect("t100",false) --受击效果
		end
	end
end

function FightHero:doHeroDisColor()
	if self.isDiscolor then
		return
	end
	local arr = {}
	arr[1] = cc.CallFunc:create(function() 
		self.isDiscolor = true
		self.skeleton:setColor(cc.c3b(250,0,0))
		--self.skeleton:runAction(cc.TintTo:create(0.15,255,0,0))
	end)
	arr[2] = cc.DelayTime:create(0.1)
	arr[3] = cc.CallFunc:create(function()
		self.isDiscolor = false
		self.skeleton:setColor(cc.c3b(255,255,255))
	end)
	local sq = cc.Sequence:create(arr)
	self.fightPlayer.rootLayer:runAction(sq)
end

--扣血
function FightHero:toBloodNum(num,resId)
	if self.heroInfo.posId < 12 and  self.heroInfo.actMode == GameField.actMode2 then
		--num = 0--100
	end
	
	if self.heroInfo.posId < 12 and  self.heroInfo.actMode == GameField.actMode1 then
		--num = 0--num - 60
	end
	
	local hp = self.heroInfo.systemHeroAttr.hp
	local maxHp = self.heroInfo.systemHeroAttr.maxHp		
	if hp > 0 then
		self:doHeroDisColor()
		self:doStrikeEffect(num,resId)
		self:toCheckBuffState(StaticField.skillHurt17)
		self.fightPlayer:doHeroBlood(self)
		
		if num < 0 and self.shieldState == StaticField.shieldState1 then --护盾
			self.shieldNum = self.shieldNum + num
			if self.shieldNum <= 0 then
				SkillAI.clearSkillEffectIndex(self.shieldIndex)
				self.heroInfo.systemHeroAttr.hp = hp + self.shieldNum --护盾不够应该扣英雄的血量
			end
		else
			hp = hp + num
			hp = hp > maxHp and maxHp or hp
			self.bloodPro:setPercentage(hp*100/maxHp)
			self.heroInfo.systemHeroAttr.hp = hp
		end
		
		local monsterType = self.heroInfo.systemMonster.monsterType
		local movementID = self.skeleton:getAnimation():getCurrentMovementID()
		if num < 0 and movementID == ACTION_HOLD and 
		   monsterType ~= StaticField.monsterType3 then --boss没有受击效果
			self.skeleton:getAnimation():play(ACTION_HURT)
		end

		if self.heroInfo.systemHeroAttr.hp <= 0 then
			self.isDead = true
			self:toCheckBuffState(StaticField.skillHurt12)
			self.fightPlayer:doHeroDead(self)
			self.fightPlayer:doNextPlay(self)
			self:toCheckBuffState(StaticField.skillHurt13)
			self:toBloodVisible(false)
			self.heroBg:stopAllActions()
			
			if self.attackInfo and self.attackInfo.curHero then
				self.attackInfo.curHero.attackPos[self.attackInfo.trackPos] = 0
			end
		else
			self.isDead = false
			self:toBloodVisible(true)
		end
	end
end

--添加BUFF
function FightHero:toAddSkillBuff(buff)	
	table.insert(self.skillBuff,buff)
end

function FightHero:toCheckBuffState(trigger)
	local len = #self.skillBuff
	for i=1,len do
		for k=#self.skillBuff,1,-1 do
			local buff = self.skillBuff[k].effect
			if buff.triggerType == trigger then
				self.fightPlayer:toPlaySkillEffect(buff,self)
				table.remove(self.skillBuff,k)
				break
			end
		end
	end
end

--掉血
function FightHero:toBloodShow(effect,resultObj)
	if self.isDead or self.heroInfo.petType == StaticField.petType4 then
		return
	end

	if self.fightPlayer.violentNum <= 0 and resultObj.value < 0 and
	   self.heroInfo.actMode == GameField.actMode1 and 
	   self.fightPlayer.fightReport.fightType == GameField.fightType1 then --狂暴时间
		resultObj.value =  resultObj.value * GameField.violentMultiple
	end
	
	local blood = resultObj.value
	local value = resultObj.value
	local resId = resultObj.resId
	if self.invincibleState == StaticField.invincible0 then --普通
		local labelStr = ""
		if resultObj.bParry == GameField.checkValue then
			labelStr = LabelChineseStr.parry
		end
		if resultObj.bCrit == GameField.checkValue then
			labelStr = LabelChineseStr.crit
		end
		if resultObj.bDodge == GameField.checkValue then
			labelStr = LabelChineseStr.dodge
		end
		
		if blood < 0 and self.shieldState == StaticField.shieldState1 then --有护盾不掉血			
			if self.shieldNum + blood >= 0 then
				blood = 0
			else
				blood = self.shieldNum + blood
			end
		end
		SkillEffect.showDropBlood(self.heroBg,blood,labelStr)
		
		--[[
		if effect.showText == StaticField.showText0 then --不数值和字
		
		elseif effect.showText == StaticField.showText1 then--字
			SkillEffect.showBuffIcon(self.heroBg,"")
		elseif effect.showText == StaticField.showText2 then--数值
			
		elseif effect.showText == StaticField.showText3 then--数值和字
			SkillEffect.showDropBlood(self.heroBg,value)
			SkillEffect.showBuffIcon(self.heroBg,imgRes)
		end
		
		if imgRes ~= "" then
			SkillEffect.showBuffIcon(self.heroBg,imgRes)
		end]]
		
		if effect.showIcons == StaticField.showIcons1 then --是否显示buff图标
			SkillEffect.showBuffIcon(self.heroBg,effect.imgId)
		end
		self:toBloodNum(value,resId)
		self.fightPlayer:toTriggerMonster(self)--怪物是触发型的
	else
		SkillEffect.showBuffIcon(self.heroBg,"NewUi/qietu/zhandou/mianyi.png") --无敌状态
	end
	
	if self.dizzinessState == StaticField.dizzinessState1 then --眩晕
		self.dizzinessState = StaticField.dizzinessState0 --被打激活
	end
end

--QTE的伤害
function FightHero:toQteHurtNum(resultObj)
	if self.isWaitQTE then
		self.combatIndex = self.combatIndex + 1
		self.skillHurtCount = self.skillHurtCount + resultObj.value
		SkillEffect.showCombat(self.fightPlayer.rootLayer,self.combatIndex,true)
	end
end

--必杀击的动画
function FightHero:toPlaySlayAnimation(evt)
	if evt == ACTION_BT then
		self:doSnakeUpdate()
	elseif evt == ACTION_NT then
		SkillEffect.showCombat(self.fightPlayer.rootLayer,self.skillHurtCount,false)
		self.combatIndex = 0
		self.skillHurtCount = 0
		self.fightPlayer:toCheckCollision()
	end
end

--振屏
function FightHero:doSnakeUpdate()
	local times = 0
	local function fgRangeRand(minNum,maxNum) 
        local rnd = math.random(800) / 21
        return rnd * (maxNum - minNum) + minNum
    end
		   
	local function snakeUpdateFunc() 
		times = times + 0.01
		if times > 0.15 then
			self.fightPlayer.rootLayer:setPosition(cc.p(0,0))
			Director.getScheduler():unscheduleScriptEntry(self.snakeHandler)
			self.snakeHandler = nil
		else
			local randx = fgRangeRand(-5,5)*0.1
			local randy = fgRangeRand(-5,5)*0.1
			randx = randx > 88 and 88 or randx
			randx = randx < -88 and -88 or randx
			randy = randy > 64 and 64 or randy
			randy = randy < -64 and -64 or randy
			self.fightPlayer.rootLayer:setPosition(cc.p(randx,randy))
		end
	end
	
	if self.snakeHandler then
		Director.getScheduler():unscheduleScriptEntry(self.snakeHandler)
		self.snakeHandler = nil
	end
	self.snakeHandler = Director.getScheduler():scheduleScriptFunc(snakeUpdateFunc,0.01,false)
end

function FightHero:toAttackTrigger(resultObj)

	if resultObj.bDodge == 2 then --躲闪
		self:toCheckBuffState(StaticField.skillHurt16)
	end
	
	if resultObj.bParry == 2 then --招架
		self:toCheckBuffState(StaticField.skillHurt17)
	end
	
	if resultObj.bCrit == 2 then --暴击
		self:toCheckBuffState(StaticField.skillHurt15)
	end
end

--添加仇恨
function FightHero:toHateNum(blood,attackPro,effect)
	local num = 0
	local hate = self.heroInfo.systemHerohate
	if self.heroInfo.actMode == GameField.actMode1 and
	   self.heroInfo.battleType == GameField.battleType2 then
		if attackPro == StaticField.attackPro6 then --正常攻击
			num = Formula.hateAttackerNum(blood,effect.hateValue1,effect.hateValue2,effect.hateValue3)
		elseif attackPro == StaticField.attackPro2 then  --被闪避
			num = Formula.hateDefenderNum(blood,hate.dodgeHateValue1,hate.dodgeHateValue2,hate.dodgeHateValue3)
		elseif attackPro == StaticField.attackPro3 then --被攻击方招架
			num = Formula.hateDefenderNum(blood,hate.parryHateValue1,hate.parryHateValue2,hate.parryHateValue3)
		elseif attackPro == StaticField.attackPro4 then --被攻击方格挡
			num = Formula.hateDefenderNum(blood,hate.hitParryHateValue1,hate.hitParryHateValue2,hate.hitParryHateValue3)
		end	
		self.heroHateNum = self.heroHateNum + math.abs(num)
	end
end

--战斗结果
function FightHero:toHeroWin(reslut)
	local arr = {}
	arr[1] = cc.DelayTime:create(1)
	arr[2] = cc.CallFunc:create(function() 
		self:toReslut(reslut)
	end)
	local sq = cc.Sequence:create(arr)
	self.heroBg:runAction(sq)
end

function FightHero:toReslut(reslut)
	local state 
	local scale
	if reslut == GameField.fightSuccess then
		scale = 1
		if self.heroInfo.actMode == GameField.actMode1 and 
		   self.heroInfo.petType == StaticField.petType1 then
			state = ACTION_VICTORY
		else
			state = ACTION_HOLD
		end
	else
		if self.heroInfo.systemMonster.monsterType == StaticField.monsterType3 then
			scale = 0.5
		else
			scale = 1
		end
		state = ACTION_DEAD
	end
	
	self.skeleton:getAnimation():setSpeedScale(scale) --恢复攻击速度
	self.skeleton:getAnimation():play(state)
	self:toCanSlayState()
	self:clearWeakTime()
	self:clearSkillTime()
end

--血值和魔法
function FightHero:toCreateProgress()
	local offx = self.heroBg:getContentSize().width/2
	local offy = self.rect.y + self.rect.height + 5
	
	local bluebg = CreateCCSprite("fight/people_blood_bg.png")
	bluebg:setScaleY(0.8)
	bluebg:setPosition(cc.p(offx,offy))
	bluebg:setVisible(false)
	self.heroBg:addChild(bluebg,1)
	self.bloodBg = bluebg
	
	local bloodPro = cc.ProgressTimer:create(CreateCCSprite("fight/people_greed_blood.png"))
	bloodPro:setType(1)
	bloodPro:setScaleY(0.8)
	bloodPro:setMidpoint(cc.p(0,1))
	bloodPro:setBarChangeRate(cc.p(1,0))
	bloodPro:setPosition(cc.p(offx,offy+1))
	bloodPro:setPercentage(100)
	bloodPro:setVisible(false)
	self.heroBg:addChild(bloodPro,2)
	self.bloodPro = bloodPro
end

--废弃
function FightHero:toShowSprite(isSelect)
	self.isSelect = isSelect
	if self.isSelect then
		if self.selectSprite == nil then
			local size = self.heroBg:getContentSize()
			local sprite = CreateCCSprite("fight/select.png")
			sprite:setPosition(cc.p(size.width/2,size.height/2))
			sprite:setScale(0.7)
			self.heroBg:addChild(sprite,-1)
			self.selectSprite = sprite
		end
	else
		if self.selectSprite then
			self.selectSprite:removeFromParent(true)
			self.selectSprite = nil
		end
	end
end

--废弃
function FightHero:toAttackTarget(tx)
	if self.heroInfo.battleType == GameField.battleType2 then
		local sx = math.abs(self.skeleton:getScaleX())
		if tx < 480 then 
			self.skeleton:setScaleX(-sx)
		else
			self.skeleton:setScaleX(sx)
		end
	end
end

function FightHero:clearHero()
	for k,v in pairs(self.cycleBuff)do
		v:Release()
	end
	SkillAI.clearHeroBuffEffect(self) --清除Buff
end

function FightHero:clearWeakTime()
	if self.collisionHandler then
		local scheduler	= Director.getScheduler()
		scheduler:unscheduleScriptEntry(self.collisionHandler)
		self.collisionHandler = nil
	end
end

function FightHero:clearSkillTime()
	if self.frameHandler then
		local scheduler	= Director.getScheduler()
		scheduler:unscheduleScriptEntry(self.frameHandler)
		self.frameHandler = nil
	end
end

function FightHero:removeNil()
	self:clearWeakTime()
	self:clearSkillTime()
	self.hero:Release()
	self.heroBg:removeFromParent(true)
	self.heroBg = nil
	self.heroInfo = nil
	self = nil
end

function FightHero:soulRelease()
	self:clearHero()
	self:removeNil()
end

function FightHero:toRelease()
	local arr = {}
	arr[1] = cc.FadeOut:create(2)
	arr[2] = cc.DelayTime:create(1)
	arr[3] = cc.CallFunc:create(function()
		self:removeNil()
	end)
	
	if self.selectSprite then
		self.selectSprite:setVisible(false)
	end
	self:clearHero()
	self.hero:stop()
	self.heroBg:setOpacity(30)
	self.heroBg:setLocalZOrder(0)
	self:toBloodVisible(false)
	
	local sq = cc.Sequence:create(arr)
	self.skeleton:runAction(sq)
end

--英雄复活
function FightHero:revivalLife()
	self.isDead = false
	self.heroInfo.heroState = StaticField.heroState1
	self.heroInfo.systemHeroAttr.hp = self.heroInfo.systemHeroAttr.maxHp
	
	self.skeleton:stopAllActions()
	self.skeleton:runAction(cc.FadeIn:create(1))
end

--重置属性
function FightHero:toResetHeroAttr(battleType)
	self.attackInfo = nil
	self.targetPs = {x=-1,y=-1,s=-1}
	self.heroHateNum = 0 --重置仇恨
	self.heroInfo.attackPosId = 0 --重置聚火
	self.weakOverState = GameField.weakOver1
	self.heroInfo.battleType = battleType
	self.playSkillState = StaticField.playSkillState1
	for m,n in pairs(self.heroInfo.activeSkillList) do
		n.nextPlayerTime = 0
	end
	
	for m,n in pairs(self.heroInfo.passiveSkillList) do
		n.nextPlayerTime = 0
	end
end

--改变必杀技的状态
function FightHero:toCanSlayState()
	self.isCanSlay = false -- 是否释放必杀
	self.curSlayCD = self.heroInfo.playSlayCD --必杀技CD
	if self.cycleSkill then
		self.cycleSkill:stopAllActions()
		self.cycleSkill:getAnimation():stop()
		self.cycleSkill:removeFromParent(true)
		self.cycleSkill = nil
	end
end

--清除可以清除的效果技能
function FightHero:toCleanCanEffect()
	SkillAI.clearCanSkillEffect(self)
end

--设置普通攻击CD
function FightHero:doSkillSpeedOdds()
	local heroAttr = self.heroInfo.systemHeroAttr
	self.speedOdds = heroAttr.speedOdds + Formula.speedOdds(heroAttr.speedUp,heroAttr.level,self.heroInfo.speedOddsParas)
end

function FightHero:toSetSpeedOdds(value)
	local activeSkillList = self.heroInfo.activeSkillList
	for m,n in pairs(activeSkillList) do
		n.nextPlayerTime = n.nextPlayerTime + n.cdTime*value
	end
	self:doSkillSpeedOdds()
end

--显示玩家聊天 头顶冒一个聊天气泡
function  FightHero:toHeroChatBubble(msg)
	msg = string.gsub(msg," ","")
	if msg == "" then
		return
	end
	
	if self.chatBgSprite then
		self.chatBgSprite:removeFromParent(true)
	end
	local offx = self.heroBg:getContentSize().width/2
	local offy = self.rect.y + self.rect.height + 40
	
	self.chatBgSprite = CreateCCSprite(IconPath.liaotian.."i_qipao1.png")	
	self.chatBgSprite:setPosition(cc.p(offx, offy))
	self.heroBg:addChild(self.chatBgSprite,100)
	
	local size1 = self.chatBgSprite:getContentSize()
	local strLable = CreateLabel(msg, nil,16, cc.c3b(0, 0, 0), 1,cc.size(130,55))	
	strLable:setAnchorPoint(cc.p(0.5, 0.5))
	strLable:setPosition(cc.p(size1.width/2 , size1.height/2 + 3))
	self.chatBgSprite:addChild(strLable)
	
	local arr = {}
	arr[1] = cc.DelayTime:create(2)
	arr[2] = cc.CallFunc:create(function() 
		self.chatBgSprite:removeFromParent(true)
		self.chatBgSprite = nil
	end)
	self.chatBgSprite:runAction(cc.Sequence:create(arr))
end

function FightHero:toSetSpeedUp(value)
	local heroAttr = self.heroInfo.systemHeroAttr
	local speedOdds = Formula.speedOdds(value,heroAttr.level,self.heroInfo.speedOddsParas)
	
	local activeSkillList = self.heroInfo.activeSkillList
	for m,n in pairs(activeSkillList) do
		n.nextPlayerTime = n.nextPlayerTime + n.cdTime*speedOdds
	end
	self:doSkillSpeedOdds()
end

function FightHero:toPerentSystemHeroId()
	if self.heroInfo.actMode == GameField.actMode1 then
		for k,v in pairs(self.fightPlayer.atk_hero_list) do
			if self.heroInfo.perentHeroId == v.heroInfo.fightHeroId then
				return v.heroInfo.systemHero.systemHeroId
			end
		end
	else
		for k,v in pairs(self.fightPlayer.def_cards_list) do
			if self.heroInfo.perentHeroId == v.heroInfo.fightHeroId then
				return v.heroInfo.systemHero.systemHeroId
			end
		end
	end
	return 0
end

--召唤英雄
function FightHero:toCallHero(heroId,callHeroId)
	self.fightPlayer:toAddCallHero(heroId,callHeroId,self)
end

--删除召唤英雄
function FightHero:toDelCallHero(heroId,callHeroId)
	self.fightPlayer:toDelCallHero(heroId,callHeroId,self)
end

--召唤技能英雄
function FightHero:toCallHeroSkillEffect(heroId,callHeroId)
	self.fightPlayer:toAddHeroSkillEffect(heroId,callHeroId,self)
end

--删除召唤技能英雄
function FightHero:toDelHeroSkillEffect(heroId,callHeroId)
	self.fightPlayer:toDelHeroSkillEffect(heroId,callHeroId,self)
end


--召唤变身
function FightHero:toCallHeroSheep(heroId,callHeroId)
	self.fightPlayer:toCallHeroSheep(heroId,callHeroId,self)
end

--删除变身
function FightHero:toDelHeroSheep(heroId,callHeroId)	
	self.fightPlayer:toDelHeroSheep(heroId,callHeroId,self)
end

--发送伤害数据
function FightHero:toAddAttackHurtData(hurtList,buffHero)
	table.insert(self.sendHurtInfo,hurtList)
	table.insert(self.sendBuffInfo,buffHero)
end

function FightHero:toSendAttackHurtData(skill)
	local function getEffectBo(buffHero,hurtInfo)
		local buffHeroStr = ""
		for k,v in pairs(buffHero) do
			buffHeroStr = buffHeroStr..v.heroInfo.userId
			if k < #buffHero then
				buffHeroStr = buffHeroStr..","
			end
		end
		
		local attactList = {}
		for k,v in pairs(hurtInfo)do
			local status = 1 
			--[[
			local isHurt = false
			if defender.heroInfo.systemHeroAttr.maxHp <= 0 then
				status = 0
			end
			
			if defender.heroInfo.actMode == GameField.actMode1 then
				isHurt = true
			end]]
			
			local attactBossInfo = UserAttactBossInfoBO:New()
			attactBossInfo:setString_userId(v.userId)
			attactBossInfo:setInt_isBlood(v.isBlood)
			attactBossInfo:setInt_bDodge(v.bDodge)
			attactBossInfo:setInt_bParry(v.bParry)
			attactBossInfo:setInt_bCrit(v.bCrit)
			attactBossInfo:setInt_beingAttackState(v.beingAttackState)
			attactBossInfo:setInt_effectId(v.define.effectId)
			attactBossInfo:setInt_resId(v.resId)
			
			attactBossInfo:setInt_callHeroId(0)
			attactBossInfo:setString_targetUserId(0)
			attactBossInfo:setInt_status(status)
			attactBossInfo:setInt_x(0)
			attactBossInfo:setInt_y(0)
			if isHurt then
				attactBossInfo:setInt_hurt(math.abs(value))
				attactBossInfo:setInt_treatment(0)
				attactBossInfo:setInt_beHit(0)
			else
				attactBossInfo:setInt_hurt(0)
				if value > 0 then
					attactBossInfo:setInt_treatment(value)
					attactBossInfo:setInt_beHit(0)
				else
					attactBossInfo:setInt_treatment(0)
					attactBossInfo:setInt_beHit(value)
				end
			end
			table.insert(attactList,attactBossInfo)
		end
		
		local effectBO = EffectBO:New()
		effectBO:setString_buff(buffHeroStr)
		effectBO:setList_attactList(attactList)
		return effectBO
	end
	
	if DataManager.getWorldBossRoomOwner() then
		local effectList = {}
		for k,v in pairs(self.sendHurtInfo)do
			table.insert(effectList,getEffectBo(self.sendBuffInfo[k],self.sendHurtInfo[k]))
		end
		
		local attackBossInfoReq = BossAction_attackBossInfoReq:New()
		attackBossInfoReq:setString_userIdStr(self.heroInfo.userId)
		attackBossInfoReq:setInt_skillId(skill.skillId)
		attackBossInfoReq:setList_effectList(effectList)
		NetReqLua(attackBossInfoReq)
	end
	self.sendBuffInfo = {}
	self.sendHurtInfo = {}
end