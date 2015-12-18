
ShortestPathStep = {}
function ShortestPathStep:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function ShortestPathStep:inst(pos)
	self.position = pos
	self.gScore = 0
	hScore = 0
	parent = nil
	inOpen = false
	inClose = false
end

AStarPathFinder = {}
function AStarPathFinder.find(hero,map,lockPointList,startTilePt,endTilePt)
	local path = {}
	local openSteps = {}
	local closedSteps = {}
	local isFinded = false --能否找到路径，true-已找到
	
	local function equals(sPt,tPt)
		if sPt.x == tPt.x and sPt.y == tPt.y then
			return true
		else
			return false
		end
	end

	
	local function isWalkable(tPt)
		if tPt.x < 0 or tPt.x >= map.width then
			return false
		end
		if tPt.y < 0 or tPt.y >= map.height then
			return false
		end
		
		for k,v in pairs(lockPointList)do
			if tPt.x == v.x and tPt.y == v.y then
				return false
			end
		end
		
		return true
	end
	
	local function isInClosed(pt)
		for k,v in pairs(closedSteps)do
			if equals(v,pt) then
				return true
			end
		end
		return false
	end
	
	local function getAroundsNode(tPt)
		local aroundNodes = {}
	
		--左
		local p = {x=tPt.x-1,y=tPt.y,z=5}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		--右
		p = {x=tPt.x+1,y=tPt.y,z=5}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		--上
		p = {x=tPt.x,y=tPt.y+1,z=5}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		--下
		p = {x=tPt.x,y=tPt.y+1,z=5}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		p = {x=tPt.x-1,y=tPt.y-1,z=10}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		p = {x=tPt.x-1,y=tPt.y+1,z=10}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		p = {x=tPt.x+1,y=tPt.y-1,z=10}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		p = {x=tPt.x+1,y=tPt.y+1,z=10}
		if isWalkable(p) and not isInClosed(p) then
			table.insert(aroundNodes,p)
		end
		
		return aroundNodes
	end
	
	local function getGValue(curStep,step)
		return curStep.gScore+1
	end
	
	local function getHValue(curStep,endStep,step)
		if curStep == nil or endStep == nil or step == nil then
			return 0
		end
		return (math.abs(step.position.x-endStep.position.x)*math.abs(step.position.x-endStep.position.x)+
				math.abs(step.position.y-endStep.position.y)*math.abs(step.position.y-endStep.position.y))
	end
	
	local function getOpenSteps(tPt)
		for k,v in pairs(openSteps)do
			if equals(v.position,tPt) then
				return v
			end
		end
		return nil
	end
	
	local function isInOpen(tPt)
		for k,v in pairs(openSteps)do
			if equals(v.position,tPt) then
				return true
			end
		end
		return false
	end
	
	local function findAndSort(step)
		if #openSteps < 1 then
			return 
		end
		
		for k=#openSteps,1,-1 do
			if equals(step.position,openSteps[k].position) then
				table.remove(openSteps,k)
				break
			end
		end
		table.insert(openSteps,step)
	end
	
	local function createPath(step)
		local path = {}
		while step do
			table.insert(path,step.position)
			step = step.parent
		end
		return path
	end

	if map == nil then
		return path
	end
	
	if equals(startTilePt,endTilePt) then
		return path
	end
	
	if not isWalkable(endTilePt) then
		return path
	end
	
	local endStep = ShortestPathStep:New()
	endStep:inst(endTilePt)
	
	local startStep = ShortestPathStep:New()
	startStep:inst(startTilePt)
	table.insert(openSteps,startStep)
	
	local curStep
	while #openSteps > 0 do
		
		curStep = openSteps[1]
		table.insert(closedSteps,curStep)
		table.remove(openSteps,1)
		
		if equals(curStep.position,endTilePt) then
			isFinded = true
			break
		end
		
		local aroundNodes = getAroundsNode(curStep.position)
		for k,v in pairs(aroundNodes) do
			local point = v
			local nextStep = ShortestPathStep:New()
			nextStep:inst(point)
			
			local g = getGValue(curStep,nextStep)+v.z
			local h = getHValue(curStep,endStep,nextStep)
			if isInOpen(point) then
				local openStep = getOpenSteps(point)
				if g < openStep.gScore then
					nextStep.gScore = g
					nextStep.hScore = h
					nextStep.parent = curStep
					findAndSort(nextStep)
				end
			else
				nextStep.gScore = g
				nextStep.hScore = h
				nextStep.parent = curStep
				table.insert(openSteps,nextStep)
			end
		end
	end
	
	if isFinded then
		path = createPath(curStep)
	end
	
	local idx = #path
	local function autoWalkCallBack()
		idx = idx - 1
		if idx > 0 then
			local x = (2*path[idx].x-1)*GameField.tileWidth/2
			local y = (2*path[idx].y-1)*GameField.tileHeight/2
			hero:autoWalk(x,y,true,autoWalkCallBack)
		elseif idx == 1 then
			local state = #path > 1 and false or true
			--hero:autoWalk(endPx.x,endPx.y,state,autoWalkCallBack)
		else
			hero:stopAnimte()
		end
	end
	autoWalkCallBack()
end