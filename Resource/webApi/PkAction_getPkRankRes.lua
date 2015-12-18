

PkAction_getPkRankRes = {}

--查看排行榜
function PkAction_getPkRankRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getPkRankRes:init()
	
	self.list_rankList={} --排行榜列表

	self.actName = "PkAction_getPkRank"
end

function PkAction_getPkRankRes:getActName()
	return self.actName
end

--排行榜列表
function PkAction_getPkRankRes:setList_rankList(list_rankList)
	self.list_rankList = list_rankList
end





function PkAction_getPkRankRes:encode(outputStream)
		
		self.list_rankList = self.list_rankList or {}
		local list_rankListsize = #self.list_rankList
		outputStream:WriteInt(list_rankListsize)
		for list_rankListi=1,list_rankListsize do
            self.list_rankList[list_rankListi]:encode(outputStream)
		end
end

function PkAction_getPkRankRes:decode(inputStream)
	    local body = {}
		local rankListTemp = {}
		local rankListsize = inputStream:ReadInt()
		for rankListi=1,rankListsize do
            local entry = PkRankBO:New()
            table.insert(rankListTemp,entry:decode(inputStream))

		end
		body.rankList = rankListTemp

	   return body
end