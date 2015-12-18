

ForcesAction_getMapForcesReq = {}

--获取某个地图下所有用户关卡信息列表
function ForcesAction_getMapForcesReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapForcesReq:init()
	
	self.int_mapId=0 --地图id

	self.actName = "ForcesAction_getMapForces"
end

function ForcesAction_getMapForcesReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_getMapForcesReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function ForcesAction_getMapForcesReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)


end

function ForcesAction_getMapForcesReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()


	   return body
end