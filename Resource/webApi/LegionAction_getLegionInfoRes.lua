

LegionAction_getLegionInfoRes = {}

--查看自己的公会信息
function LegionAction_getLegionInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionInfoRes:init()
	
	self.UserLegionInfoBO_userLegionInfoBO=nil --用户的公会信息

	self.LegionInfoBO_legionInfo=nil --军团信息

	self.list_applyLegionIdList={} --申请的公会id列表（已入公会的为空）

	self.actName = "LegionAction_getLegionInfo"
end

function LegionAction_getLegionInfoRes:getActName()
	return self.actName
end

--用户的公会信息
function LegionAction_getLegionInfoRes:setUserLegionInfoBO_userLegionInfoBO(UserLegionInfoBO_userLegionInfoBO)
	self.UserLegionInfoBO_userLegionInfoBO = UserLegionInfoBO_userLegionInfoBO
end
--军团信息
function LegionAction_getLegionInfoRes:setLegionInfoBO_legionInfo(LegionInfoBO_legionInfo)
	self.LegionInfoBO_legionInfo = LegionInfoBO_legionInfo
end
--申请的公会id列表（已入公会的为空）
function LegionAction_getLegionInfoRes:setList_applyLegionIdList(list_applyLegionIdList)
	self.list_applyLegionIdList = list_applyLegionIdList
end





function LegionAction_getLegionInfoRes:encode(outputStream)
		self.UserLegionInfoBO_userLegionInfoBO:encode(outputStream)

		self.LegionInfoBO_legionInfo:encode(outputStream)

		
		self.list_applyLegionIdList = self.list_applyLegionIdList or {}
		local list_applyLegionIdListsize = #self.list_applyLegionIdList
		outputStream:WriteInt(list_applyLegionIdListsize)
		for list_applyLegionIdListi=1,list_applyLegionIdListsize do
            outputStream:WriteUTFString(self.list_applyLegionIdList[list_applyLegionIdListi])
		end
end

function LegionAction_getLegionInfoRes:decode(inputStream)
	    local body = {}
        local userLegionInfoBOTemp = UserLegionInfoBO:New()
        body.userLegionInfoBO=userLegionInfoBOTemp:decode(inputStream)
        local legionInfoTemp = LegionInfoBO:New()
        body.legionInfo=legionInfoTemp:decode(inputStream)
		local applyLegionIdListTemp = {}
		local applyLegionIdListsize = inputStream:ReadInt()
		for applyLegionIdListi=1,applyLegionIdListsize do
            table.insert(applyLegionIdListTemp,inputStream:ReadUTFString())
		end
		body.applyLegionIdList = applyLegionIdListTemp

	   return body
end