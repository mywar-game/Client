

UserAction_changeUserNameReq = {}

--更改昵称
function UserAction_changeUserNameReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_changeUserNameReq:init()
	
	self.string_name="" --更改的昵称

	self.actName = "UserAction_changeUserName"
end

function UserAction_changeUserNameReq:getActName()
	return self.actName
end

--更改的昵称
function UserAction_changeUserNameReq:setString_name(string_name)
	self.string_name = string_name
end





function UserAction_changeUserNameReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_name)


end

function UserAction_changeUserNameReq:decode(inputStream)
	    local body = {}
		body.name = inputStream:ReadUTFString()


	   return body
end