

LegionAction_applyJoinLegionRes = {}

--申请加入公会
function LegionAction_applyJoinLegionRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_applyJoinLegionRes:init()
	
	self.actName = "LegionAction_applyJoinLegion"
end

function LegionAction_applyJoinLegionRes:getActName()
	return self.actName
end






function LegionAction_applyJoinLegionRes:encode(outputStream)

end

function LegionAction_applyJoinLegionRes:decode(inputStream)
	    local body = {}

	   return body
end