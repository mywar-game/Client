

LegionAction_getApplyListReq = {}

--查看申请列表
function LegionAction_getApplyListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getApplyListReq:init()
	
	self.actName = "LegionAction_getApplyList"
end

function LegionAction_getApplyListReq:getActName()
	return self.actName
end






function LegionAction_getApplyListReq:encode(outputStream)

end

function LegionAction_getApplyListReq:decode(inputStream)
	    local body = {}

	   return body
end