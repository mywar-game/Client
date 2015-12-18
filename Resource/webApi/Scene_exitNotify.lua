

Scene_exitNotify = {}

--用户退出场景
function Scene_exitNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Scene_exitNotify:init()
	
	self.string_userId="" --退出的用户id

	self.actName = "Scene_exit"
end

function Scene_exitNotify:getActName()
	return self.actName
end

--退出的用户id
function Scene_exitNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end





function Scene_exitNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)


end

function Scene_exitNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()


	   return body
end