

MailAction_readRes = {}

--读取邮件
function MailAction_readRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_readRes:init()
	
	self.int_userMailId=0 --用户邮件id

	self.actName = "MailAction_read"
end

function MailAction_readRes:getActName()
	return self.actName
end

--用户邮件id
function MailAction_readRes:setInt_userMailId(int_userMailId)
	self.int_userMailId = int_userMailId
end





function MailAction_readRes:encode(outputStream)
		outputStream:WriteInt(self.int_userMailId)


end

function MailAction_readRes:decode(inputStream)
	    local body = {}
		body.userMailId = inputStream:ReadInt()


	   return body
end