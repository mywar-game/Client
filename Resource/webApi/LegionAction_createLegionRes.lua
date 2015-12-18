

LegionAction_createLegionRes = {}

--创建军团
function LegionAction_createLegionRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_createLegionRes:init()
	
	self.LegionInfoBO_legionInfo=nil --军团信息

	self.UserLegionInfoBO_userLegionInfo=nil --用户军团信息

	self.actName = "LegionAction_createLegion"
end

function LegionAction_createLegionRes:getActName()
	return self.actName
end

--军团信息
function LegionAction_createLegionRes:setLegionInfoBO_legionInfo(LegionInfoBO_legionInfo)
	self.LegionInfoBO_legionInfo = LegionInfoBO_legionInfo
end
--用户军团信息
function LegionAction_createLegionRes:setUserLegionInfoBO_userLegionInfo(UserLegionInfoBO_userLegionInfo)
	self.UserLegionInfoBO_userLegionInfo = UserLegionInfoBO_userLegionInfo
end





function LegionAction_createLegionRes:encode(outputStream)
		self.LegionInfoBO_legionInfo:encode(outputStream)

		self.UserLegionInfoBO_userLegionInfo:encode(outputStream)


end

function LegionAction_createLegionRes:decode(inputStream)
	    local body = {}
        local legionInfoTemp = LegionInfoBO:New()
        body.legionInfo=legionInfoTemp:decode(inputStream)
        local userLegionInfoTemp = UserLegionInfoBO:New()
        body.userLegionInfo=userLegionInfoTemp:decode(inputStream)

	   return body
end