

SceneAction_enterReq = {}

--进入场景
function SceneAction_enterReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_enterReq:init()
	
	self.int_sceneId=0 --要进入的场景id

	self.int_posX=0 --所在位置x坐标

	self.int_posY=0 --所在位置y坐标

	self.actName = "SceneAction_enter"
end

function SceneAction_enterReq:getActName()
	return self.actName
end

--要进入的场景id
function SceneAction_enterReq:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end
--所在位置x坐标
function SceneAction_enterReq:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--所在位置y坐标
function SceneAction_enterReq:setInt_posY(int_posY)
	self.int_posY = int_posY
end





function SceneAction_enterReq:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)

		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)


end

function SceneAction_enterReq:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()

		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()


	   return body
end