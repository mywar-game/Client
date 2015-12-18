

ForcesAction_getMapCllectionInfoReq = {}

--获取地图采集点信息
function ForcesAction_getMapCllectionInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapCllectionInfoReq:init()
	
	self.int_mapId=0 --地图id

	self.actName = "ForcesAction_getMapCllectionInfo"
end

function ForcesAction_getMapCllectionInfoReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_getMapCllectionInfoReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function ForcesAction_getMapCllectionInfoReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)


end

function ForcesAction_getMapCllectionInfoReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()


	   return body
end