

LifeAction_getHangupRewardListRes = {}

--获取挂机奖励
function LifeAction_getHangupRewardListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_getHangupRewardListRes:init()
	
	self.list_userLifeRewardList={} --挂机奖励列表

	self.actName = "LifeAction_getHangupRewardList"
end

function LifeAction_getHangupRewardListRes:getActName()
	return self.actName
end

--挂机奖励列表
function LifeAction_getHangupRewardListRes:setList_userLifeRewardList(list_userLifeRewardList)
	self.list_userLifeRewardList = list_userLifeRewardList
end





function LifeAction_getHangupRewardListRes:encode(outputStream)
		
		self.list_userLifeRewardList = self.list_userLifeRewardList or {}
		local list_userLifeRewardListsize = #self.list_userLifeRewardList
		outputStream:WriteInt(list_userLifeRewardListsize)
		for list_userLifeRewardListi=1,list_userLifeRewardListsize do
            self.list_userLifeRewardList[list_userLifeRewardListi]:encode(outputStream)
		end
end

function LifeAction_getHangupRewardListRes:decode(inputStream)
	    local body = {}
		local userLifeRewardListTemp = {}
		local userLifeRewardListsize = inputStream:ReadInt()
		for userLifeRewardListi=1,userLifeRewardListsize do
            local entry = GoodsBeanBO:New()
            table.insert(userLifeRewardListTemp,entry:decode(inputStream))

		end
		body.userLifeRewardList = userLifeRewardListTemp

	   return body
end