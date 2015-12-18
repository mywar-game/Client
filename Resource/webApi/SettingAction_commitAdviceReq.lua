

SettingAction_commitAdviceReq = {}

--提交建议
function SettingAction_commitAdviceReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_commitAdviceReq:init()
	
	self.string_title="" --标题

	self.string_content="" --内容

	self.actName = "SettingAction_commitAdvice"
end

function SettingAction_commitAdviceReq:getActName()
	return self.actName
end

--标题
function SettingAction_commitAdviceReq:setString_title(string_title)
	self.string_title = string_title
end
--内容
function SettingAction_commitAdviceReq:setString_content(string_content)
	self.string_content = string_content
end





function SettingAction_commitAdviceReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_title)

		outputStream:WriteUTFString(self.string_content)


end

function SettingAction_commitAdviceReq:decode(inputStream)
	    local body = {}
		body.title = inputStream:ReadUTFString()

		body.content = inputStream:ReadUTFString()


	   return body
end