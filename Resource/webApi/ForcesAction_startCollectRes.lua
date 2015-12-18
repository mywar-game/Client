

ForcesAction_startCollectRes = {}

--开始采集
function ForcesAction_startCollectRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_startCollectRes:init()
	
	self.actName = "ForcesAction_startCollect"
end

function ForcesAction_startCollectRes:getActName()
	return self.actName
end






function ForcesAction_startCollectRes:encode(outputStream)

end

function ForcesAction_startCollectRes:decode(inputStream)
	    local body = {}

	   return body
end