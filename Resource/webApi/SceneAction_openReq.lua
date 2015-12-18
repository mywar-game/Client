

SceneAction_openReq = {}

--开启场景
function SceneAction_openReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_openReq:init()
	
	self.int_sceneId=0 --场景id

	self.actName = "SceneAction_open"
end

function SceneAction_openReq:getActName()
	return self.actName
end

--场景id
function SceneAction_openReq:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end





function SceneAction_openReq:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)


end

function SceneAction_openReq:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()


	   return body
end