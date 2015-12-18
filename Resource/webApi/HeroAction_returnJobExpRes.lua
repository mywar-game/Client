

HeroAction_returnJobExpRes = {}

--职业解锁回退
function HeroAction_returnJobExpRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_returnJobExpRes:init()
	
	self.int_jobExp=0 --用户剩余魂能

	self.UserCareerInfoBO_userCareerInfo=nil --用户职业信息对象

	self.GoodsBeanBO_tool=nil --消耗的魂能令牌道具

	self.actName = "HeroAction_returnJobExp"
end

function HeroAction_returnJobExpRes:getActName()
	return self.actName
end

--用户剩余魂能
function HeroAction_returnJobExpRes:setInt_jobExp(int_jobExp)
	self.int_jobExp = int_jobExp
end
--用户职业信息对象
function HeroAction_returnJobExpRes:setUserCareerInfoBO_userCareerInfo(UserCareerInfoBO_userCareerInfo)
	self.UserCareerInfoBO_userCareerInfo = UserCareerInfoBO_userCareerInfo
end
--消耗的魂能令牌道具
function HeroAction_returnJobExpRes:setGoodsBeanBO_tool(GoodsBeanBO_tool)
	self.GoodsBeanBO_tool = GoodsBeanBO_tool
end





function HeroAction_returnJobExpRes:encode(outputStream)
		outputStream:WriteInt(self.int_jobExp)

		self.UserCareerInfoBO_userCareerInfo:encode(outputStream)

		self.GoodsBeanBO_tool:encode(outputStream)


end

function HeroAction_returnJobExpRes:decode(inputStream)
	    local body = {}
		body.jobExp = inputStream:ReadInt()

        local userCareerInfoTemp = UserCareerInfoBO:New()
        body.userCareerInfo=userCareerInfoTemp:decode(inputStream)
        local toolTemp = GoodsBeanBO:New()
        body.tool=toolTemp:decode(inputStream)

	   return body
end