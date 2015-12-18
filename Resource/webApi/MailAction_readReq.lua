

MailAction_readReq = {}

--读取邮件
function MailAction_readReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_readReq:init()
	
	self.int_userMailId=0 --用户邮件id

	self.actName = "MailAction_read"
end

function MailAction_readReq:getActName()
	return self.actName
end

--用户邮件id
function MailAction_readReq:setInt_userMailId(int_userMailId)
	self.int_userMailId = int_userMailId
end





function MailAction_readReq:encode(outputStream)
		outputStream:WriteInt(self.int_userMailId)


end

function MailAction_readReq:decode(inputStream)
	    local body = {}
		body.userMailId = inputStream:ReadInt()


	   return body
end