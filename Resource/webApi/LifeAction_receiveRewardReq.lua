

LifeAction_receiveRewardReq = {}

--领取挂机奖励
function LifeAction_receiveRewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_receiveRewardReq:init()
	
	self.int_category=0 --类别（1矿场2花圃3渔场）

	self.actName = "LifeAction_receiveReward"
end

function LifeAction_receiveRewardReq:getActName()
	return self.actName
end

--类别（1矿场2花圃3渔场）
function LifeAction_receiveRewardReq:setInt_category(int_category)
	self.int_category = int_category
end





function LifeAction_receiveRewardReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)


end

function LifeAction_receiveRewardReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()


	   return body
end