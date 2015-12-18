

ActivityAction_getLoginReward30InfoRes = {}

--查看每月签到信息
function ActivityAction_getLoginReward30InfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_getLoginReward30InfoRes:init()
	
	self.list_userLoginRewardList={} --用户签到列表

	self.actName = "ActivityAction_getLoginReward30Info"
end

function ActivityAction_getLoginReward30InfoRes:getActName()
	return self.actName
end

--用户签到列表
function ActivityAction_getLoginReward30InfoRes:setList_userLoginRewardList(list_userLoginRewardList)
	self.list_userLoginRewardList = list_userLoginRewardList
end





function ActivityAction_getLoginReward30InfoRes:encode(outputStream)
		
		self.list_userLoginRewardList = self.list_userLoginRewardList or {}
		local list_userLoginRewardListsize = #self.list_userLoginRewardList
		outputStream:WriteInt(list_userLoginRewardListsize)
		for list_userLoginRewardListi=1,list_userLoginRewardListsize do
            self.list_userLoginRewardList[list_userLoginRewardListi]:encode(outputStream)
		end
end

function ActivityAction_getLoginReward30InfoRes:decode(inputStream)
	    local body = {}
		local userLoginRewardListTemp = {}
		local userLoginRewardListsize = inputStream:ReadInt()
		for userLoginRewardListi=1,userLoginRewardListsize do
            local entry = UserLoginRewardBO:New()
            table.insert(userLoginRewardListTemp,entry:decode(inputStream))

		end
		body.userLoginRewardList = userLoginRewardListTemp

	   return body
end