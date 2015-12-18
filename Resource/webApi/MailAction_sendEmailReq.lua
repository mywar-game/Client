

MailAction_sendEmailReq = {}

--发送邮件
function MailAction_sendEmailReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_sendEmailReq:init()
	
	self.string_toUserId="" --发往用户id

	self.string_name="" --用户名

	self.string_content="" --内容

	self.actName = "MailAction_sendEmail"
end

function MailAction_sendEmailReq:getActName()
	return self.actName
end

--发往用户id
function MailAction_sendEmailReq:setString_toUserId(string_toUserId)
	self.string_toUserId = string_toUserId
end
--用户名
function MailAction_sendEmailReq:setString_name(string_name)
	self.string_name = string_name
end
--内容
function MailAction_sendEmailReq:setString_content(string_content)
	self.string_content = string_content
end





function MailAction_sendEmailReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_toUserId)

		outputStream:WriteUTFString(self.string_name)

		outputStream:WriteUTFString(self.string_content)


end

function MailAction_sendEmailReq:decode(inputStream)
	    local body = {}
		body.toUserId = inputStream:ReadUTFString()

		body.name = inputStream:ReadUTFString()

		body.content = inputStream:ReadUTFString()


	   return body
end