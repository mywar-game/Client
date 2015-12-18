

UserSceneDataBO = {}

--用户场景数据BO
function UserSceneDataBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserSceneDataBO:init()
	
	self.string_userId="" --用户编号

	self.string_userName="" --用户名称

	self.int_heroId=0 --角色模型id

	self.int_posX=0 --所在位置x坐标

	self.int_posY=0 --所在位置y坐标

	self.actName = "UserSceneDataBO"
end

function UserSceneDataBO:getActName()
	return self.actName
end

--用户编号
function UserSceneDataBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户名称
function UserSceneDataBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--角色模型id
function UserSceneDataBO:setInt_heroId(int_heroId)
	self.int_heroId = int_heroId
end
--所在位置x坐标
function UserSceneDataBO:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--所在位置y坐标
function UserSceneDataBO:setInt_posY(int_posY)
	self.int_posY = int_posY
end





function UserSceneDataBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteInt(self.int_heroId)

		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)


end

function UserSceneDataBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

		body.heroId = inputStream:ReadInt()

		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()


	   return body
end