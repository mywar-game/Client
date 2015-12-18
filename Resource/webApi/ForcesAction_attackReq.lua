

ForcesAction_attackReq = {}

--攻击关卡
function ForcesAction_attackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_attackReq:init()
	
	self.int_mapId=0 --地图id

	self.int_forcesId=0 --攻击或采集的关卡id

	self.int_forcesType=0 --关卡类型如果是普通怪物或采集关卡传1即可，如果为boss关卡1代表简单、2精英、3困难

	self.string_userFriendId="" --好友的用户id

	self.actName = "ForcesAction_attack"
end

function ForcesAction_attackReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_attackReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--攻击或采集的关卡id
function ForcesAction_attackReq:setInt_forcesId(int_forcesId)
	self.int_forcesId = int_forcesId
end
--关卡类型如果是普通怪物或采集关卡传1即可，如果为boss关卡1代表简单、2精英、3困难
function ForcesAction_attackReq:setInt_forcesType(int_forcesType)
	self.int_forcesType = int_forcesType
end
--好友的用户id
function ForcesAction_attackReq:setString_userFriendId(string_userFriendId)
	self.string_userFriendId = string_userFriendId
end





function ForcesAction_attackReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_forcesId)

		outputStream:WriteInt(self.int_forcesType)

		outputStream:WriteUTFString(self.string_userFriendId)


end

function ForcesAction_attackReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.forcesId = inputStream:ReadInt()

		body.forcesType = inputStream:ReadInt()

		body.userFriendId = inputStream:ReadUTFString()


	   return body
end