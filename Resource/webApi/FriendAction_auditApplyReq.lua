

FriendAction_auditApplyReq = {}

--审核好友申请
function FriendAction_auditApplyReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_auditApplyReq:init()
	
	self.int_type=0 --审核类型（0拒绝1同意）

	self.int_userMailId=0 --用户邮件id

	self.actName = "FriendAction_auditApply"
end

function FriendAction_auditApplyReq:getActName()
	return self.actName
end

--审核类型（0拒绝1同意）
function FriendAction_auditApplyReq:setInt_type(int_type)
	self.int_type = int_type
end
--用户邮件id
function FriendAction_auditApplyReq:setInt_userMailId(int_userMailId)
	self.int_userMailId = int_userMailId
end





function FriendAction_auditApplyReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)

		outputStream:WriteInt(self.int_userMailId)


end

function FriendAction_auditApplyReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()

		body.userMailId = inputStream:ReadInt()


	   return body
end