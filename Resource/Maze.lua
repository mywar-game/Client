require("LineIntersectRect")

--Point 类型
Point = {}
function Point:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self.F = 0
	self.G = 0
	self.H = 0
	self.X = 0
	self.Y = 0
	self.ParentPoint = nil
	self.open = false	--是否在开启列表
	self.close = false	--是否在关闭列表
	self.island = false	--是为不可到达区域
    return o
end

function Point:CalcF()
	self.F = self.G + self.H
end

Maze = {}

function Maze.init(mazeArray,mazeArrayTmp,hero,startPx,endPx)
	local STEP = 10
	local OBLIQUE = 14
	local openList = {}
    local closeList = {}

	local function minPoint(points,ptEnd)
		local function sortF(a,b) 
			return  a.F < b.F
		end
		table.sort(points,sortF)
		return points[1]
	end
	
	local function isCheck(x,y)
		local len = #mazeArray
		if x < 1 or x > len then
			return false
		end
		if y < 1 or y > len then
			return false
		end
		
		if mazeArray[x][y] == 0 then
			return true
		else
			return false
		end
	end
	
	--直接返回
	if isCheck(endPx.x,endPx.y) then
		return
    end
	
	function existsXY(points,x,y)
		for k,v in pairs(points)do
			if v.X == x and v.Y == y then
				return true
			end
		end
		return false
	end

	local function canReach(start,x,y,IsIgnoreCorner)
		if not isCheck(x,y) or  existsXY(closeList,x,y) then
			return false
		else
			if math.abs(x-start.X) + math.abs(y-start.Y) == 1 then
				return true
			else
			
				if isCheck(math.abs(x-1),y) and isCheck(x,math.abs(y-1)) then
					return true
				else
					return IsIgnoreCorner
				end
					
			end
		end
	end
	
	local function surrroundPoints(point,IsIgnoreCorner)
		local roundPoints = {}
		for x=point.X-1,point.X+1 do
			for y=point.Y-1,point.Y+1 do
				if canReach(point,x,y,IsIgnoreCorner) then
					local point = Point:New()
					point.X = x
					point.Y = y
					table.insert(roundPoints,point)
				end
			end
		end
		return roundPoints
	end
	
	local function calcG(start,point)
        local G = (math.abs(point.X - start.X) + math.abs(point.Y - start.Y)) == 2 and STEP or OBLIQUE
        local parentG = point.ParentPoint ~= nil and point.ParentPoint.G or 0
        return G + parentG
    end
	
	local function calcH(ptEnd,point)
		local step = math.abs(point.X - ptEnd.X) + math.abs(point.Y - ptEnd.Y)
		return step * STEP
    end
		
	local function foundPoint(tempStart,point)
		
		local G = calcG(tempStart, point)
		if G < point.G then
			point.ParentPoint = tempStart
			point.G = G
			point:CalcF()

		end
    end
	
	local function notFoundPoint(tempStart,ptEnd,point)
		point.ParentPoint = tempStart
		point.G = calcG(tempStart, point)
		point.H = calcH(ptEnd, point)
		point:CalcF()
		table.insert(openList,point)
    end
	
	function getpoints(points,point)
		for k,v in pairs(points)do
			if v.X == point.X and v.Y == point.Y then
				return v
			end
		end
		return nil
	end
	
	local function findPath(ptStart,ptEnd,IsIgnoreCorner)
		table.insert(openList,ptStart)
		while #openList ~= 0 do
			local tempStart = minPoint(DeepCopy(openList),ptEnd)
			local roundPoints = nil
			
			if  tempStart.island == false  then 
				table.remove(openList,1)
				table.insert(closeList,tempStart)
				
				--所有范围点放到外面去处理了， 使用空间替换时间的方式
				if mazeArrayTmp[tempStart.X] and mazeArrayTmp[tempStart.X][tempStart.Y] then
					roundPoints = DeepCopy(mazeArrayTmp[tempStart.X][tempStart.Y]) --surrroundPoints(tempStart,IsIgnoreCorner)	
				end
			end
			if roundPoints ~= nil then
				--分开循环优化它的流处理效果，寻路速度更快
				for k,v in pairs(roundPoints)do
					if  existsXY(openList,v.X,v.Y) then
							v.open = true
					else 
						if  existsXY(closeList,v.X,v.Y) then
							v.close = true
						end
					end	
				end
				
				for k,v in pairs(roundPoints)do
					if v.island == false then
						if not v.close  then
							if v.open  then
								foundPoint(tempStart,v)		
							else
								notFoundPoint(tempStart,ptEnd,v)
							end 
						end	
					end	
				end				
			end

			local pts = getpoints(openList,ptEnd)
			if pts then
				return pts
			end
		end
		return getpoints(openList,ptEnd)		
	end
	
	local startXY = {x=math.ceil(startPx.x/GameField.tileWidth),y=math.ceil(startPx.y/GameField.tileHeight)}
	local endXY = {x=math.ceil(endPx.x/GameField.tileWidth),y=math.ceil(endPx.y/GameField.tileHeight)}
		
	local ptStart = Point:New()
	ptStart.X = startXY.x
	ptStart.Y = startXY.y
	
	local ptEnd = Point:New()
	ptEnd.X = endXY.x
	ptEnd.Y = endXY.y
	
	local pathPt = {}
	local parent = findPath(ptStart,ptEnd,false)
	while parent ~= nil do
		table.insert(pathPt,{x=parent.X,y=parent.Y})
		parent = parent.ParentPoint
	end
	
	local count = #pathPt
	local idx = count

	local function autoWalkCallBack()
		idx = idx - 1
		if idx > 1 then
			local minX = 0
			local maxX = 0
			local minY = 0
			local maxY = 0
			local state = false
			local sx = (2*pathPt[idx].x-1)*GameField.tileWidth/2
			local sy = (2*pathPt[idx].y-1)*GameField.tileHeight/2	
			local ex = (2*endXY.x-1)*GameField.tileWidth/2
			local ey = (2*endXY.y-1)*GameField.tileHeight/2
			if pathPt[idx].x > endXY.x then
				minX = endXY.x
				maxX = pathPt[idx].x
			else
				minX = pathPt[idx].x
				maxX = endXY.x
			end
			if pathPt[idx].y > endXY.y then
				minY = endXY.y
				maxY = pathPt[idx].y
			else
				minY = pathPt[idx].y
				maxY = endXY.y
			end
			for m=minX,maxX do
				for n=minY,maxY do
					local v = mazeArray[m][n]
					if v == 1 then
						local rect = {x=(m-1)*GameField.tileWidth,y=(n-1)*GameField.tileHeight,w=GameField.tileWidth,h=GameField.tileHeight}
						if LineIntersectRect.IsLineIntersectRect({x=sx,y=sy},{x=ex,y=ey},rect) then
							state = true
							break
						end
					end
				end
			end
			
			if state then
				hero:autoWalk(sx,sy,true,autoWalkCallBack)
			else
				idx = 1
				hero:autoWalk(endPx.x,endPx.y,true,autoWalkCallBack)
			end
		elseif idx == 1 then
			local state = count > 1 and false or true
			hero:autoWalk(endPx.x,endPx.y,state,autoWalkCallBack)
		elseif idx == 0 then
			hero:weakOver()
			hero:stopAnimte()
		elseif idx == -1 then
			idx = 1
			hero:autoWalk(endPx.x,endPx.y,true,autoWalkCallBack)
		end
	end

	if count > 0 then
		autoWalkCallBack()	
	else
		hero:stopAnimte()
	end
end