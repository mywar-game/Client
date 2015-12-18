

SceneAction_loadedReq = {}

--加载场景完成
function SceneAction_loadedReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_loadedReq:init()
	
	self.int_sceneId=0 --场景id

	self.actName = "SceneAction_loaded"
end

function SceneAction_loadedReq:getActName()
	return self.actName
end

--场景id
function SceneAction_loadedReq:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end





function SceneAction_loadedReq:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)


end

function SceneAction_loadedReq:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()


	   return body
end