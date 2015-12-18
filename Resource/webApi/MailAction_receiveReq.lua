

MailAction_receiveReq = {}

--领取邮件附件
function MailAction_receiveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_receiveReq:init()
	
	self.int_userMailId=0 --用户邮件id

	self.actName = "MailAction_receive"
end

function MailAction_receiveReq:getActName()
	return self.actName
end

--用户邮件id
function MailAction_receiveReq:setInt_userMailId(int_userMailId)
	self.int_userMailId = int_userMailId
end





function MailAction_receiveReq:encode(outputStream)
		outputStream:WriteInt(self.int_userMailId)


end

function MailAction_receiveReq:decode(inputStream)
	    local body = {}
		body.userMailId = inputStream:ReadInt()


	   return body
end