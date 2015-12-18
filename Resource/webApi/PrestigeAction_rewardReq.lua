

PrestigeAction_rewardReq = {}

--领取声望奖励
function PrestigeAction_rewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_rewardReq:init()
	
	self.int_id=0 --奖励id

	self.actName = "PrestigeAction_reward"
end

function PrestigeAction_rewardReq:getActName()
	return self.actName
end

--奖励id
function PrestigeAction_rewardReq:setInt_id(int_id)
	self.int_id = int_id
end





function PrestigeAction_rewardReq:encode(outputStream)
		outputStream:WriteInt(self.int_id)


end

function PrestigeAction_rewardReq:decode(inputStream)
	    local body = {}
		body.id = inputStream:ReadInt()


	   return body
end