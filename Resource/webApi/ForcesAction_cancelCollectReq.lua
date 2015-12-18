

ForcesAction_cancelCollectReq = {}

--取消采集
function ForcesAction_cancelCollectReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_cancelCollectReq:init()
	
	self.actName = "ForcesAction_cancelCollect"
end

function ForcesAction_cancelCollectReq:getActName()
	return self.actName
end






function ForcesAction_cancelCollectReq:encode(outputStream)

end

function ForcesAction_cancelCollectReq:decode(inputStream)
	    local body = {}

	   return body
end