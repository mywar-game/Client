

PkAction_getUserPkMallInfoReq = {}

--获取用户兑换奖励信息
function PkAction_getUserPkMallInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getUserPkMallInfoReq:init()
	
	self.actName = "PkAction_getUserPkMallInfo"
end

function PkAction_getUserPkMallInfoReq:getActName()
	return self.actName
end






function PkAction_getUserPkMallInfoReq:encode(outputStream)

end

function PkAction_getUserPkMallInfoReq:decode(inputStream)
	    local body = {}

	   return body
end