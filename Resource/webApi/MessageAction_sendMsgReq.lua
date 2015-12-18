

MessageAction_sendMsgReq = {}

--发送跑马灯
function MessageAction_sendMsgReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MessageAction_sendMsgReq:init()
	
	self.string_content="" --跑马灯内容

	self.actName = "MessageAction_sendMsg"
end

function MessageAction_sendMsgReq:getActName()
	return self.actName
end

--跑马灯内容
function MessageAction_sendMsgReq:setString_content(string_content)
	self.string_content = string_content
end





function MessageAction_sendMsgReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function MessageAction_sendMsgReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end