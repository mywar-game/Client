

LegionAction_commitMessageReq = {}

--提交留言信息
function LegionAction_commitMessageReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_commitMessageReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "LegionAction_commitMessage"
end

function LegionAction_commitMessageReq:getActName()
	return self.actName
end

--聊天内容
function LegionAction_commitMessageReq:setString_content(string_content)
	self.string_content = string_content
end





function LegionAction_commitMessageReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function LegionAction_commitMessageReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end