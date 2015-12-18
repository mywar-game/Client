

UserAction_recordOpenMapReq = {}

--记录开启的地图数据
function UserAction_recordOpenMapReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordOpenMapReq:init()
	
	self.int_mapId=0 --开启的地图id

	self.actName = "UserAction_recordOpenMap"
end

function UserAction_recordOpenMapReq:getActName()
	return self.actName
end

--开启的地图id
function UserAction_recordOpenMapReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function UserAction_recordOpenMapReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)


end

function UserAction_recordOpenMapReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()


	   return body
end