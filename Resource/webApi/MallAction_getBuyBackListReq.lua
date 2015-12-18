

MallAction_getBuyBackListReq = {}

--获取用户回购列表
function MallAction_getBuyBackListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getBuyBackListReq:init()
	
	self.actName = "MallAction_getBuyBackList"
end

function MallAction_getBuyBackListReq:getActName()
	return self.actName
end






function MallAction_getBuyBackListReq:encode(outputStream)

end

function MallAction_getBuyBackListReq:decode(inputStream)
	    local body = {}

	   return body
end