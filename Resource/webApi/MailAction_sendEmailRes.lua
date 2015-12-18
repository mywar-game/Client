

MailAction_sendEmailRes = {}

--发送邮件
function MailAction_sendEmailRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_sendEmailRes:init()
	
	self.actName = "MailAction_sendEmail"
end

function MailAction_sendEmailRes:getActName()
	return self.actName
end






function MailAction_sendEmailRes:encode(outputStream)

end

function MailAction_sendEmailRes:decode(inputStream)
	    local body = {}

	   return body
end