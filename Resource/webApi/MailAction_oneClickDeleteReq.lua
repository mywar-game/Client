

MailAction_oneClickDeleteReq = {}

--一键删除邮件
function MailAction_oneClickDeleteReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_oneClickDeleteReq:init()
	
	self.actName = "MailAction_oneClickDelete"
end

function MailAction_oneClickDeleteReq:getActName()
	return self.actName
end






function MailAction_oneClickDeleteReq:encode(outputStream)

end

function MailAction_oneClickDeleteReq:decode(inputStream)
	    local body = {}

	   return body
end