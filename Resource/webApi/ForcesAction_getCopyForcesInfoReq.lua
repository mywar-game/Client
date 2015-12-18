

ForcesAction_getCopyForcesInfoReq = {}

--获取用户副本关卡信息列表
function ForcesAction_getCopyForcesInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getCopyForcesInfoReq:init()
	
	self.int_mapId=0 --该副本的所在的地图id

	self.int_bigForcesId=0 --大关卡id

	self.actName = "ForcesAction_getCopyForcesInfo"
end

function ForcesAction_getCopyForcesInfoReq:getActName()
	return self.actName
end

--该副本的所在的地图id
function ForcesAction_getCopyForcesInfoReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--大关卡id
function ForcesAction_getCopyForcesInfoReq:setInt_bigForcesId(int_bigForcesId)
	self.int_bigForcesId = int_bigForcesId
end





function ForcesAction_getCopyForcesInfoReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_bigForcesId)


end

function ForcesAction_getCopyForcesInfoReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.bigForcesId = inputStream:ReadInt()


	   return body
end