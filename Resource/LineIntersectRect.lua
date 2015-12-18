-- 判断点在有向直线的左侧还是右侧.
-- 返回值:-1: 点在线段左侧; 0: 点在线段上; 1: 点在线段右侧
LineIntersectRect = {}
local ff = true
function LineIntersectRect.PointAtLineLeftRight(ptStart,ptEnd,ptTest)
	local sx = ptStart.x - ptTest.x
	local sy = ptStart.y - ptTest.y
	local ex = ptEnd.x - ptTest.x
	local ey = ptEnd.y - ptTest.y
	local nRet = sx * ey - sy * ex
	if nRet == 0 then
	  return 0
	elseif nRet > 0 then
	  return 1
	elseif nRet < 0 then
	  return -1
	end
	return 0
end

-- 判断两条线段是否相交
function LineIntersectRect.IsTwoLineIntersect(ptLine1Start,ptLine1End,ptLine2Start,ptLine2End)
	local nLine1Start = LineIntersectRect.PointAtLineLeftRight(ptLine2Start, ptLine2End, ptLine1Start)
	local nLine1End = LineIntersectRect.PointAtLineLeftRight(ptLine2Start, ptLine2End, ptLine1End)
	if nLine1Start * nLine1End > 0 then
		return false
	end

	local nLine2Start = LineIntersectRect.PointAtLineLeftRight(ptLine1Start, ptLine1End, ptLine2Start)
	local nLine2End = LineIntersectRect.PointAtLineLeftRight(ptLine1Start, ptLine1End, ptLine2End)
	if nLine2Start * nLine2End > 0 then
		return false
	end
	
	return true
end

-- 判断线段是否与矩形相交
function LineIntersectRect.IsLineIntersectRect(ptStart,ptEnd,rect)
	if rect.x <= ptStart.x and rect.x+rect.w >= ptStart.x and
	   rect.y <= ptStart.y and rect.y+rect.h >= ptStart.y then
		return true
	end
	
	if rect.x <= ptEnd.x and rect.x+rect.w >= ptEnd.x and
	   rect.y <= ptEnd.y and rect.y+rect.h >= ptEnd.y then
		return true
	end
	 -- Two point both aren't in rect
	if LineIntersectRect.IsTwoLineIntersect(ptStart, ptEnd,{x=rect.x,y=rect.y},{x=rect.x,y=rect.y+rect.h}) then
	  return true
	end
	
	if LineIntersectRect.IsTwoLineIntersect(ptStart, ptEnd,{x=rect.x,y=rect.y},{x=rect.x+rect.w,y=rect.y}) then
		return true
	end
	 
	if LineIntersectRect.IsTwoLineIntersect(ptStart, ptEnd,{x=rect.x+rect.w,y=rect.y},{x=rect.x,y=rect.y+rect.h}) then 
		return true
	end
	 
	if LineIntersectRect.IsTwoLineIntersect(ptStart, ptEnd,{x=rect.x,y=rect.y+rect.h},{x=rect.x+rect.w,y=rect.y+rect.h}) then
		return true
	end

	return false
end