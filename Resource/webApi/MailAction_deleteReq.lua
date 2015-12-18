

MailAction_deleteReq = {}

--删除邮件
function MailAction_deleteReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_deleteReq:init()
	
	self.string_userMailIds="" --用户邮件ids（1,2,3）

	self.actName = "MailAction_delete"
end

function MailAction_deleteReq:getActName()
	return self.actName
end

--用户邮件ids（1,2,3）
function MailAction_deleteReq:setString_userMailIds(string_userMailIds)
	self.string_userMailIds = string_userMailIds
end





function MailAction_deleteReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userMailIds)


end

function MailAction_deleteReq:decode(inputStream)
	    local body = {}
		body.userMailIds = inputStream:ReadUTFString()


	   return body
end