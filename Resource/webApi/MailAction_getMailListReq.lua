

MailAction_getMailListReq = {}

--获取邮件列表
function MailAction_getMailListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_getMailListReq:init()
	
	self.int_mailId=0 --最大的邮件id

	self.actName = "MailAction_getMailList"
end

function MailAction_getMailListReq:getActName()
	return self.actName
end

--最大的邮件id
function MailAction_getMailListReq:setInt_mailId(int_mailId)
	self.int_mailId = int_mailId
end





function MailAction_getMailListReq:encode(outputStream)
		outputStream:WriteInt(self.int_mailId)


end

function MailAction_getMailListReq:decode(inputStream)
	    local body = {}
		body.mailId = inputStream:ReadInt()


	   return body
end