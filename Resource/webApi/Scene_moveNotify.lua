

Scene_moveNotify = {}

--场景中移动广播
function Scene_moveNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Scene_moveNotify:init()
	
	self.string_userId="" --用户唯一编号

	self.int_posX=0 --移动目的地的x坐标

	self.int_posY=0 --移动目的地y坐标

	self.actName = "Scene_move"
end

function Scene_moveNotify:getActName()
	return self.actName
end

--用户唯一编号
function Scene_moveNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end
--移动目的地的x坐标
function Scene_moveNotify:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--移动目的地y坐标
function Scene_moveNotify:setInt_posY(int_posY)
	self.int_posY = int_posY
end





function Scene_moveNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)


end

function Scene_moveNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()


	   return body
end