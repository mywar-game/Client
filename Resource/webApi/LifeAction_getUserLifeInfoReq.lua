

LifeAction_getUserLifeInfoReq = {}

--获取用户生活技能信息
function LifeAction_getUserLifeInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_getUserLifeInfoReq:init()
	
	self.actName = "LifeAction_getUserLifeInfo"
end

function LifeAction_getUserLifeInfoReq:getActName()
	return self.actName
end






function LifeAction_getUserLifeInfoReq:encode(outputStream)

end

function LifeAction_getUserLifeInfoReq:decode(inputStream)
	    local body = {}

	   return body
end