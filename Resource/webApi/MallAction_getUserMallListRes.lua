

MallAction_getUserMallListRes = {}

--获取用户商城回购列表
function MallAction_getUserMallListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getUserMallListRes:init()
	
	self.actName = "MallAction_getUserMallList"
end

function MallAction_getUserMallListRes:getActName()
	return self.actName
end






function MallAction_getUserMallListRes:encode(outputStream)

end

function MallAction_getUserMallListRes:decode(inputStream)
	    local body = {}

	   return body
end