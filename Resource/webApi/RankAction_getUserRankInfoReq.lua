

RankAction_getUserRankInfoReq = {}

--用户排行榜信息
function RankAction_getUserRankInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function RankAction_getUserRankInfoReq:init()
	
	self.int_type=0 --排行榜类型1等级2战斗力3土豪榜

	self.actName = "RankAction_getUserRankInfo"
end

function RankAction_getUserRankInfoReq:getActName()
	return self.actName
end

--排行榜类型1等级2战斗力3土豪榜
function RankAction_getUserRankInfoReq:setInt_type(int_type)
	self.int_type = int_type
end





function RankAction_getUserRankInfoReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)


end

function RankAction_getUserRankInfoReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()


	   return body
end