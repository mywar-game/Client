

ActivityAction_receiveLoginReward30Req = {}

--领取每月签到奖励
function ActivityAction_receiveLoginReward30Req:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveLoginReward30Req:init()
	
	self.int_day=0 --领取第几天

	self.actName = "ActivityAction_receiveLoginReward30"
end

function ActivityAction_receiveLoginReward30Req:getActName()
	return self.actName
end

--领取第几天
function ActivityAction_receiveLoginReward30Req:setInt_day(int_day)
	self.int_day = int_day
end





function ActivityAction_receiveLoginReward30Req:encode(outputStream)
		outputStream:WriteInt(self.int_day)


end

function ActivityAction_receiveLoginReward30Req:decode(inputStream)
	    local body = {}
		body.day = inputStream:ReadInt()


	   return body
end