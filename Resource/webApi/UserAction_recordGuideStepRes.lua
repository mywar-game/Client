

UserAction_recordGuideStepRes = {}

--记录玩家新手引导
function UserAction_recordGuideStepRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordGuideStepRes:init()
	
	self.actName = "UserAction_recordGuideStep"
end

function UserAction_recordGuideStepRes:getActName()
	return self.actName
end






function UserAction_recordGuideStepRes:encode(outputStream)

end

function UserAction_recordGuideStepRes:decode(inputStream)
	    local body = {}

	   return body
end