

MailAction_deleteRes = {}

--删除邮件
function MailAction_deleteRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_deleteRes:init()
	
	self.actName = "MailAction_delete"
end

function MailAction_deleteRes:getActName()
	return self.actName
end






function MailAction_deleteRes:encode(outputStream)

end

function MailAction_deleteRes:decode(inputStream)
	    local body = {}

	   return body
end