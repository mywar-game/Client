

Mail_pushNewEmailNotify = {}

--推送新邮件
function Mail_pushNewEmailNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Mail_pushNewEmailNotify:init()
	
	self.actName = "Mail_pushNewEmail"
end

function Mail_pushNewEmailNotify:getActName()
	return self.actName
end






function Mail_pushNewEmailNotify:encode(outputStream)

end

function Mail_pushNewEmailNotify:decode(inputStream)
	    local body = {}

	   return body
end