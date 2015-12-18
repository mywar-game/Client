

ForcesAction_cancelCollectRes = {}

--取消采集
function ForcesAction_cancelCollectRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_cancelCollectRes:init()
	
	self.actName = "ForcesAction_cancelCollect"
end

function ForcesAction_cancelCollectRes:getActName()
	return self.actName
end






function ForcesAction_cancelCollectRes:encode(outputStream)

end

function ForcesAction_cancelCollectRes:decode(inputStream)
	    local body = {}

	   return body
end