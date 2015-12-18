

LegionAction_cancleApplyRes = {}

--取消申请
function LegionAction_cancleApplyRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_cancleApplyRes:init()
	
	self.actName = "LegionAction_cancleApply"
end

function LegionAction_cancleApplyRes:getActName()
	return self.actName
end






function LegionAction_cancleApplyRes:encode(outputStream)

end

function LegionAction_cancleApplyRes:decode(inputStream)
	    local body = {}

	   return body
end