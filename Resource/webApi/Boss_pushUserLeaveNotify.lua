

Boss_pushUserLeaveNotify = {}

--推送用户退出boss战
function Boss_pushUserLeaveNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushUserLeaveNotify:init()
	
	self.string_userId="" --用户id

	self.actName = "Boss_pushUserLeave"
end

function Boss_pushUserLeaveNotify:getActName()
	return self.actName
end

--用户id
function Boss_pushUserLeaveNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end





function Boss_pushUserLeaveNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)


end

function Boss_pushUserLeaveNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()


	   return body
end