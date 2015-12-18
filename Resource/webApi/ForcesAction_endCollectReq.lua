

ForcesAction_endCollectReq = {}

--结束采集
function ForcesAction_endCollectReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_endCollectReq:init()
	
	self.int_mapId=0 --地图id

	self.int_forcesId=0 --采集点id

	self.actName = "ForcesAction_endCollect"
end

function ForcesAction_endCollectReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_endCollectReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--采集点id
function ForcesAction_endCollectReq:setInt_forcesId(int_forcesId)
	self.int_forcesId = int_forcesId
end





function ForcesAction_endCollectReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_forcesId)


end

function ForcesAction_endCollectReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.forcesId = inputStream:ReadInt()


	   return body
end