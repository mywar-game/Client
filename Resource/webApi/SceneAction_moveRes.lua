

SceneAction_moveRes = {}

--用户移动
function SceneAction_moveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_moveRes:init()
	
	self.actName = "SceneAction_move"
end

function SceneAction_moveRes:getActName()
	return self.actName
end






function SceneAction_moveRes:encode(outputStream)

end

function SceneAction_moveRes:decode(inputStream)
	    local body = {}

	   return body
end