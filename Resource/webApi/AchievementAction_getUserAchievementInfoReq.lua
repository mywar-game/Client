

AchievementAction_getUserAchievementInfoReq = {}

--获取用户成就系统信息
function AchievementAction_getUserAchievementInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function AchievementAction_getUserAchievementInfoReq:init()
	
	self.actName = "AchievementAction_getUserAchievementInfo"
end

function AchievementAction_getUserAchievementInfoReq:getActName()
	return self.actName
end






function AchievementAction_getUserAchievementInfoReq:encode(outputStream)

end

function AchievementAction_getUserAchievementInfoReq:decode(inputStream)
	    local body = {}

	   return body
end