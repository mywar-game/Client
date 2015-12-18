require("StaticField")

local heroHeight = 85
local winWidth = UIConfig.stageWidth/2
local winHeight = UIConfig.stageHeight/2

FightConfig = {}

FightConfig.heroStart = {{y=-15,x=-306},{y=47,x=-332},{y=-81,x=-332},
						 {y=-13,x=-396},{y=46,x=-419},{y=-80,x=-419}}

FightConfig.heroRun = {{y=-15,x=-193},{y=50,x=-238},{y=-87,x=-230},
						{y=-18,x=-277},{y=48,x=-314},{y=-85,x=-307},
						{y=-15,x=-336},{y=47,x=-362},{y=-81,x=-362},
						{y=-13,x=-396},{y=46,x=-419},{y=-80,x=-419}}
						
FightConfig.heroEnd = {{y=-15,x=-133},{y=50,x=-178},{y=-87,x=-170},
						{y=-18,x=-227},{y=48,x=-254},{y=-85,x=-247},
						{y=-15,x=-306},{y=47,x=-332},{y=-81,x=-332},
						{y=-13,x=-396},{y=46,x=-419},{y=-80,x=-419}}

FightConfig.MTEnd = {{y=-2,x=-170},{y=-2,x=170},{y=-60,x=-120},
					 {y=-60,x=120},{y=80,x=-140},{y=80,x=140},}
					 					 
FightConfig.DPSEnd = {{y=-2,x=-350},{y=-2,x=350},{y=-70,x=-305},
					  {y=-70,x=305},{y=80,x=-270},{y=80,x=270},}
FightConfig.petOffset = {x=40,y=10}

function FightConfig.RandomSite(sitePx,standId)
	local pt = sitePx[standId]
	local rd = math.random(#pt)	
	local px = pt[rd]
	for k=#pt,1,-1 do
		if k == rd then
			table.remove(pt,k)
			break
		end
	end
	return px
end

function FightConfig.runCommPosition(posId,petType)
	local my = petType == StaticField.petType2 and 20 or 0
	local pt = FightConfig.heroRun[posId]
	return {x=pt.x+winWidth,y=pt.y+winHeight-heroHeight-my}
end

function FightConfig.runBossPosition(idx1,idx2,state,petType)
	local x,y
	local mx = FightConfig.petOffset.x
	local my = FightConfig.petOffset.y
	if state then
	    x = FightConfig.MTEnd[idx1].x
	    y = FightConfig.MTEnd[idx1].y
		if petType == StaticField.petType2 then
			if idx1 % 2 == 0 then
			   x = x - mx
			else	
				x = x + mx
			end
			y =  y - my
	   end
	else
	   x = FightConfig.DPSEnd[idx2].x
	   y = FightConfig.DPSEnd[idx2].y
	   if petType == StaticField.petType2 then
			if idx2 % 2 == 0 then
			   x = x + mx
			else	
				x = x - mx
			end
			y =  y - my
	   end
	end
	return {x=x+winWidth,y=y+winHeight-heroHeight}
end

function FightConfig.startHeroPosition(posId,actMode)
	local x = 0
	local y = 0
	if actMode == GameField.actMode1 then
		x = FightConfig.heroStart[posId].x
		y = FightConfig.heroStart[posId].y
	else
		x = math.abs(FightConfig.heroEnd[posId].x)
		y = FightConfig.heroEnd[posId].y
	end
	return {x=x+winWidth,y=y+winHeight-heroHeight}
end

function FightConfig.startMonsterPosition(posId,petType)
	local pt = FightConfig.heroEnd[posId]
	if petType == StaticField.petType1 then
		return {x=math.abs(pt.x)+winWidth,y=pt.y+winHeight-heroHeight}
	else
		return {x=math.abs(pt.x)+mx+winWidth,y=pt.y-my+winHeight-heroHeight}
	end
end

function FightConfig.getCommZorder(posId)
    local poor = posId > 0 and 1 or 5
	posId = math.abs(posId)
	local zorder = posId % 3
	if zorder == 1 then
		zorder = 2
	elseif zorder == 2 then
		zorder = 1
	elseif zorder == 0 then
		zorder = 3
	end
	return 12 - math.ceil(posId/3) + zorder * 10 + poor
end

function FightConfig.getBossZorder(idx1,idx2,state,perType)	
	local idx0 = 0
	local idx3 = 0
	if state then
		idx3 = idx1
		idx = math.ceil(idx1/2)
	else
		idx3 = idx2
	    idx = math.ceil(idx2/2)
	end
	
	local zorder = 10
	if idx == 1 then
		zorder = 20
	elseif idx == 2 then
		zorder = 30
	elseif idx == 3 then
		zorder = 10
	end
	
	if perType == StaticField.petType1 then
		return zorder + idx3
	else
		return zorder + idx3 + 5
	end
	
end
