

UserToolBO = {}

--用户道具对象
function UserToolBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserToolBO:init()
	
	self.int_toolId=0 --道具id，即道具系统常量表中的唯一id

	self.int_toolNum=0 --道具数量

	self.int_storehouseNum=0 --仓库数量

	self.actName = "UserToolBO"
end

function UserToolBO:getActName()
	return self.actName
end

--道具id，即道具系统常量表中的唯一id
function UserToolBO:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--道具数量
function UserToolBO:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end
--仓库数量
function UserToolBO:setInt_storehouseNum(int_storehouseNum)
	self.int_storehouseNum = int_storehouseNum
end





function UserToolBO:encode(outputStream)
		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)

		outputStream:WriteInt(self.int_storehouseNum)


end

function UserToolBO:decode(inputStream)
	    local body = {}
		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()

		body.storehouseNum = inputStream:ReadInt()


	   return body
end