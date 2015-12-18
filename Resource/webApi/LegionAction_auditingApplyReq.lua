

LegionAction_auditingApplyReq = {}

--审核申请（同意/拒绝）
function LegionAction_auditingApplyReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_auditingApplyReq:init()
	
	self.string_auditingUserId="" --审核的用户id

	self.int_type=0 --1同意2拒绝

	self.actName = "LegionAction_auditingApply"
end

function LegionAction_auditingApplyReq:getActName()
	return self.actName
end

--审核的用户id
function LegionAction_auditingApplyReq:setString_auditingUserId(string_auditingUserId)
	self.string_auditingUserId = string_auditingUserId
end
--1同意2拒绝
function LegionAction_auditingApplyReq:setInt_type(int_type)
	self.int_type = int_type
end





function LegionAction_auditingApplyReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_auditingUserId)

		outputStream:WriteInt(self.int_type)


end

function LegionAction_auditingApplyReq:decode(inputStream)
	    local body = {}
		body.auditingUserId = inputStream:ReadUTFString()

		body.type = inputStream:ReadInt()


	   return body
end