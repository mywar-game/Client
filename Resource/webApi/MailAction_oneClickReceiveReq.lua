

MailAction_oneClickReceiveReq = {}

--一键领取邮件附件
function MailAction_oneClickReceiveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_oneClickReceiveReq:init()
	
	self.actName = "MailAction_oneClickReceive"
end

function MailAction_oneClickReceiveReq:getActName()
	return self.actName
end






function MailAction_oneClickReceiveReq:encode(outputStream)

end

function MailAction_oneClickReceiveReq:decode(inputStream)
	    local body = {}

	   return body
end