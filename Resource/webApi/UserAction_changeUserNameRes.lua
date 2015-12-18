

UserAction_changeUserNameRes = {}

--更改昵称
function UserAction_changeUserNameRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_changeUserNameRes:init()
	
	self.string_name="" --更改的昵称

	self.int_money=0 --用户剩余钻石

	self.int_toolId=0 --改名卡id,没有为0

	self.actName = "UserAction_changeUserName"
end

function UserAction_changeUserNameRes:getActName()
	return self.actName
end

--更改的昵称
function UserAction_changeUserNameRes:setString_name(string_name)
	self.string_name = string_name
end
--用户剩余钻石
function UserAction_changeUserNameRes:setInt_money(int_money)
	self.int_money = int_money
end
--改名卡id,没有为0
function UserAction_changeUserNameRes:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end





function UserAction_changeUserNameRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_name)

		outputStream:WriteInt(self.int_money)

		outputStream:WriteInt(self.int_toolId)


end

function UserAction_changeUserNameRes:decode(inputStream)
	    local body = {}
		body.name = inputStream:ReadUTFString()

		body.money = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()


	   return body
end