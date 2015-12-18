

RankAction_getUserRankInfoRes = {}

--用户排行榜信息
function RankAction_getUserRankInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function RankAction_getUserRankInfoRes:init()
	
	self.list_rankList={} --排行榜列表

	self.UserRankBO_selfRankBO=nil --自己的排行榜信息

	self.actName = "RankAction_getUserRankInfo"
end

function RankAction_getUserRankInfoRes:getActName()
	return self.actName
end

--排行榜列表
function RankAction_getUserRankInfoRes:setList_rankList(list_rankList)
	self.list_rankList = list_rankList
end
--自己的排行榜信息
function RankAction_getUserRankInfoRes:setUserRankBO_selfRankBO(UserRankBO_selfRankBO)
	self.UserRankBO_selfRankBO = UserRankBO_selfRankBO
end





function RankAction_getUserRankInfoRes:encode(outputStream)
		
		self.list_rankList = self.list_rankList or {}
		local list_rankListsize = #self.list_rankList
		outputStream:WriteInt(list_rankListsize)
		for list_rankListi=1,list_rankListsize do
            self.list_rankList[list_rankListi]:encode(outputStream)
		end		self.UserRankBO_selfRankBO:encode(outputStream)


end

function RankAction_getUserRankInfoRes:decode(inputStream)
	    local body = {}
		local rankListTemp = {}
		local rankListsize = inputStream:ReadInt()
		for rankListi=1,rankListsize do
            local entry = UserRankBO:New()
            table.insert(rankListTemp,entry:decode(inputStream))

		end
		body.rankList = rankListTemp
        local selfRankBOTemp = UserRankBO:New()
        body.selfRankBO=selfRankBOTemp:decode(inputStream)

	   return body
end