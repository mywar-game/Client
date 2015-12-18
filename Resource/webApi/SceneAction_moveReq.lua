

SceneAction_moveReq = {}

--用户移动
function SceneAction_moveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_moveReq:init()
	
	self.int_sceneId=0 --场景id

	self.int_posX=0 --目的点x坐标

	self.int_posY=0 --目的点y坐标

	self.actName = "SceneAction_move"
end

function SceneAction_moveReq:getActName()
	return self.actName
end

--场景id
function SceneAction_moveReq:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end
--目的点x坐标
function SceneAction_moveReq:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--目的点y坐标
function SceneAction_moveReq:setInt_posY(int_posY)
	self.int_posY = int_posY
end





function SceneAction_moveReq:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)

		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)


end

function SceneAction_moveReq:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()

		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()


	   return body
end