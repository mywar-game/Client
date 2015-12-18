

Scene_enterNotify = {}

--用户进入场景广播
function Scene_enterNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Scene_enterNotify:init()
	
	self.string_userId="" --进入场景的用户唯一编号

	self.int_heroId=0 --用户角色模型id

	self.int_posX=0 --进入场景所在x坐标

	self.int_posY=0 --进入场景所在y坐标

	self.string_userName="" --玩家名称

	self.actName = "Scene_enter"
end

function Scene_enterNotify:getActName()
	return self.actName
end

--进入场景的用户唯一编号
function Scene_enterNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户角色模型id
function Scene_enterNotify:setInt_heroId(int_heroId)
	self.int_heroId = int_heroId
end
--进入场景所在x坐标
function Scene_enterNotify:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--进入场景所在y坐标
function Scene_enterNotify:setInt_posY(int_posY)
	self.int_posY = int_posY
end
--玩家名称
function Scene_enterNotify:setString_userName(string_userName)
	self.string_userName = string_userName
end





function Scene_enterNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_heroId)

		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)

		outputStream:WriteUTFString(self.string_userName)


end

function Scene_enterNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.heroId = inputStream:ReadInt()

		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()

		body.userName = inputStream:ReadUTFString()


	   return body
end