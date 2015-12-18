

ForcesAction_getCollectFightRewardReq = {}

--获取采集以及打怪的奖励
function ForcesAction_getCollectFightRewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getCollectFightRewardReq:init()
	
	self.int_mapId=0 --地图id

	self.int_forcesId=0 --采集点id

	self.int_flag=0 ---1输,0平局,1赢

	self.actName = "ForcesAction_getCollectFightReward"
end

function ForcesAction_getCollectFightRewardReq:getActName()
	return self.actName
end

--地图id
function ForcesAction_getCollectFightRewardReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--采集点id
function ForcesAction_getCollectFightRewardReq:setInt_forcesId(int_forcesId)
	self.int_forcesId = int_forcesId
end
---1输,0平局,1赢
function ForcesAction_getCollectFightRewardReq:setInt_flag(int_flag)
	self.int_flag = int_flag
end





function ForcesAction_getCollectFightRewardReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_forcesId)

		outputStream:WriteInt(self.int_flag)


end

function ForcesAction_getCollectFightRewardReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.forcesId = inputStream:ReadInt()

		body.flag = inputStream:ReadInt()


	   return body
end