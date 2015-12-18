

ForcesAction_startCollectReq = {}

--开始采集
function ForcesAction_startCollectReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_startCollectReq:init()
	
	self.int_mapId=0 --地图id

	self.int_forcesId=0 --采集点id

	self.actName = "ForcesAction_startCollect"
end

function ForcesAction_startCollectReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_startCollectReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--采集点id
function ForcesAction_startCollectReq:setInt_forcesId(int_forcesId)
	self.int_forcesId = int_forcesId
end





function ForcesAction_startCollectReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_forcesId)


end

function ForcesAction_startCollectReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.forcesId = inputStream:ReadInt()


	   return body
end