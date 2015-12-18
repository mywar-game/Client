

UserAction_recordOpenMapRes = {}

--记录开启的地图数据
function UserAction_recordOpenMapRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordOpenMapRes:init()
	
	self.actName = "UserAction_recordOpenMap"
end

function UserAction_recordOpenMapRes:getActName()
	return self.actName
end






function UserAction_recordOpenMapRes:encode(outputStream)

end

function UserAction_recordOpenMapRes:decode(inputStream)
	    local body = {}

	   return body
end