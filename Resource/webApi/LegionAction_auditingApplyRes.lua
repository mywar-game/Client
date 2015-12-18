

LegionAction_auditingApplyRes = {}

--审核申请（同意/拒绝）
function LegionAction_auditingApplyRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_auditingApplyRes:init()
	
	self.string_auditingUserId="" --审核的用户id

	self.actName = "LegionAction_auditingApply"
end

function LegionAction_auditingApplyRes:getActName()
	return self.actName
end

--审核的用户id
function LegionAction_auditingApplyRes:setString_auditingUserId(string_auditingUserId)
	self.string_auditingUserId = string_auditingUserId
end





function LegionAction_auditingApplyRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_auditingUserId)


end

function LegionAction_auditingApplyRes:decode(inputStream)
	    local body = {}
		body.auditingUserId = inputStream:ReadUTFString()


	   return body
end