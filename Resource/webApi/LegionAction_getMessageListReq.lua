

LegionAction_getMessageListReq = {}

--获取留言信息列表
function LegionAction_getMessageListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getMessageListReq:init()
	
	self.actName = "LegionAction_getMessageList"
end

function LegionAction_getMessageListReq:getActName()
	return self.actName
end






function LegionAction_getMessageListReq:encode(outputStream)

end

function LegionAction_getMessageListReq:decode(inputStream)
	    local body = {}

	   return body
end