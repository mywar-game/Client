

HeroAction_careerClearRes = {}

--职业解锁
function HeroAction_careerClearRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_careerClearRes:init()
	
	self.int_jobExp=0 --用户剩余魂能

	self.UserCareerInfoBO_userCareerInfo=nil --用户职业信息对象

	self.actName = "HeroAction_careerClear"
end

function HeroAction_careerClearRes:getActName()
	return self.actName
end

--用户剩余魂能
function HeroAction_careerClearRes:setInt_jobExp(int_jobExp)
	self.int_jobExp = int_jobExp
end
--用户职业信息对象
function HeroAction_careerClearRes:setUserCareerInfoBO_userCareerInfo(UserCareerInfoBO_userCareerInfo)
	self.UserCareerInfoBO_userCareerInfo = UserCareerInfoBO_userCareerInfo
end





function HeroAction_careerClearRes:encode(outputStream)
		outputStream:WriteInt(self.int_jobExp)

		self.UserCareerInfoBO_userCareerInfo:encode(outputStream)


end

function HeroAction_careerClearRes:decode(inputStream)
	    local body = {}
		body.jobExp = inputStream:ReadInt()

        local userCareerInfoTemp = UserCareerInfoBO:New()
        body.userCareerInfo=userCareerInfoTemp:decode(inputStream)

	   return body
end