

LegionAction_applyJoinLegionReq = {}

--申请加入公会
function LegionAction_applyJoinLegionReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_applyJoinLegionReq:init()
	
	self.string_legionId="" --公会id

	self.actName = "LegionAction_applyJoinLegion"
end

function LegionAction_applyJoinLegionReq:getActName()
	return self.actName
end

--公会id
function LegionAction_applyJoinLegionReq:setString_legionId(string_legionId)
	self.string_legionId = string_legionId
end





function LegionAction_applyJoinLegionReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_legionId)


end

function LegionAction_applyJoinLegionReq:decode(inputStream)
	    local body = {}
		body.legionId = inputStream:ReadUTFString()


	   return body
end