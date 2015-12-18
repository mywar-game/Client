

PkAction_getUserPkInfoReq = {}

--获取用户竞技场信息
function PkAction_getUserPkInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getUserPkInfoReq:init()
	
	self.actName = "PkAction_getUserPkInfo"
end

function PkAction_getUserPkInfoReq:getActName()
	return self.actName
end






function PkAction_getUserPkInfoReq:encode(outputStream)

end

function PkAction_getUserPkInfoReq:decode(inputStream)
	    local body = {}

	   return body
end