

SceneAction_openRes = {}

--开启场景
function SceneAction_openRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_openRes:init()
	
	self.int_sceneId=0 --场景id，客户端需要将该sceneId加入到已开启场景列表中

	self.actName = "SceneAction_open"
end

function SceneAction_openRes:getActName()
	return self.actName
end

--场景id，客户端需要将该sceneId加入到已开启场景列表中
function SceneAction_openRes:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end





function SceneAction_openRes:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)


end

function SceneAction_openRes:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()


	   return body
end