

MallAction_getUserMallListReq = {}

--获取用户商城回购列表
function MallAction_getUserMallListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getUserMallListReq:init()
	
	self.actName = "MallAction_getUserMallList"
end

function MallAction_getUserMallListReq:getActName()
	return self.actName
end






function MallAction_getUserMallListReq:encode(outputStream)

end

function MallAction_getUserMallListReq:decode(inputStream)
	    local body = {}

	   return body
end