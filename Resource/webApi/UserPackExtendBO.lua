

UserPackExtendBO = {}

--用户背包扩展对象
function UserPackExtendBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserPackExtendBO:init()
	
	self.int_toolId=0 --道具id

	self.int_pos=0 --位置(1,2,3,4)

	self.actName = "UserPackExtendBO"
end

function UserPackExtendBO:getActName()
	return self.actName
end

--道具id
function UserPackExtendBO:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--位置(1,2,3,4)
function UserPackExtendBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function UserPackExtendBO:encode(outputStream)
		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_pos)


end

function UserPackExtendBO:decode(inputStream)
	    local body = {}
		body.toolId = inputStream:ReadInt()

		body.pos = inputStream:ReadInt()


	   return body
end