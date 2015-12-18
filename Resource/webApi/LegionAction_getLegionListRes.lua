

LegionAction_getLegionListRes = {}

--查看公会列表
function LegionAction_getLegionListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionListRes:init()
	
	self.list_recommendLegionList={} --推荐的军团列表

	self.list_legionRankList={} --军团排行榜列表

	self.actName = "LegionAction_getLegionList"
end

function LegionAction_getLegionListRes:getActName()
	return self.actName
end

--推荐的军团列表
function LegionAction_getLegionListRes:setList_recommendLegionList(list_recommendLegionList)
	self.list_recommendLegionList = list_recommendLegionList
end
--军团排行榜列表
function LegionAction_getLegionListRes:setList_legionRankList(list_legionRankList)
	self.list_legionRankList = list_legionRankList
end





function LegionAction_getLegionListRes:encode(outputStream)
		
		self.list_recommendLegionList = self.list_recommendLegionList or {}
		local list_recommendLegionListsize = #self.list_recommendLegionList
		outputStream:WriteInt(list_recommendLegionListsize)
		for list_recommendLegionListi=1,list_recommendLegionListsize do
            self.list_recommendLegionList[list_recommendLegionListi]:encode(outputStream)
		end		
		self.list_legionRankList = self.list_legionRankList or {}
		local list_legionRankListsize = #self.list_legionRankList
		outputStream:WriteInt(list_legionRankListsize)
		for list_legionRankListi=1,list_legionRankListsize do
            self.list_legionRankList[list_legionRankListi]:encode(outputStream)
		end
end

function LegionAction_getLegionListRes:decode(inputStream)
	    local body = {}
		local recommendLegionListTemp = {}
		local recommendLegionListsize = inputStream:ReadInt()
		for recommendLegionListi=1,recommendLegionListsize do
            local entry = LegionInfoBO:New()
            table.insert(recommendLegionListTemp,entry:decode(inputStream))

		end
		body.recommendLegionList = recommendLegionListTemp
		local legionRankListTemp = {}
		local legionRankListsize = inputStream:ReadInt()
		for legionRankListi=1,legionRankListsize do
            local entry = LegionInfoBO:New()
            table.insert(legionRankListTemp,entry:decode(inputStream))

		end
		body.legionRankList = legionRankListTemp

	   return body
end