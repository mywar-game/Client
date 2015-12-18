

MallAction_getMysteriousMallInfoReq = {}

--获取神秘商店的信息
function MallAction_getMysteriousMallInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getMysteriousMallInfoReq:init()
	
	self.actName = "MallAction_getMysteriousMallInfo"
end

function MallAction_getMysteriousMallInfoReq:getActName()
	return self.actName
end






function MallAction_getMysteriousMallInfoReq:encode(outputStream)

end

function MallAction_getMysteriousMallInfoReq:decode(inputStream)
	    local body = {}

	   return body
end