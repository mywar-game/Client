

ForcesAction_getMapCollectionInfoReq = {}

--获取地图采集点信息
function ForcesAction_getMapCollectionInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapCollectionInfoReq:init()
	
	self.int_mapId=0 --地图id

	self.actName = "ForcesAction_getMapCollectionInfo"
end

function ForcesAction_getMapCollectionInfoReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_getMapCollectionInfoReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function ForcesAction_getMapCollectionInfoReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)


end

function ForcesAction_getMapCollectionInfoReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()


	   return body
end