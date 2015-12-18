

LegionAction_getLegionMemberListReq = {}

--查看公会成员列表
function LegionAction_getLegionMemberListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionMemberListReq:init()
	
	self.actName = "LegionAction_getLegionMemberList"
end

function LegionAction_getLegionMemberListReq:getActName()
	return self.actName
end






function LegionAction_getLegionMemberListReq:encode(outputStream)

end

function LegionAction_getLegionMemberListReq:decode(inputStream)
	    local body = {}

	   return body
end