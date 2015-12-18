

LegionAction_userInvestRes = {}

--用户捐献
function LegionAction_userInvestRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_userInvestRes:init()
	
	self.UserLegionInfoBO_userLegionInfo=nil --用户公会信息

	self.LegionInfoBO_legionInfo=nil --公会信息

	self.actName = "LegionAction_userInvest"
end

function LegionAction_userInvestRes:getActName()
	return self.actName
end

--用户公会信息
function LegionAction_userInvestRes:setUserLegionInfoBO_userLegionInfo(UserLegionInfoBO_userLegionInfo)
	self.UserLegionInfoBO_userLegionInfo = UserLegionInfoBO_userLegionInfo
end
--公会信息
function LegionAction_userInvestRes:setLegionInfoBO_legionInfo(LegionInfoBO_legionInfo)
	self.LegionInfoBO_legionInfo = LegionInfoBO_legionInfo
end





function LegionAction_userInvestRes:encode(outputStream)
		self.UserLegionInfoBO_userLegionInfo:encode(outputStream)

		self.LegionInfoBO_legionInfo:encode(outputStream)


end

function LegionAction_userInvestRes:decode(inputStream)
	    local body = {}
        local userLegionInfoTemp = UserLegionInfoBO:New()
        body.userLegionInfo=userLegionInfoTemp:decode(inputStream)
        local legionInfoTemp = LegionInfoBO:New()
        body.legionInfo=legionInfoTemp:decode(inputStream)

	   return body
end