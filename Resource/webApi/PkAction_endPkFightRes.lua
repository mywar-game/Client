

PkAction_endPkFightRes = {}

--结束竞技场战斗
function PkAction_endPkFightRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_endPkFightRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_oldRank=0 --用户之前排名

	self.int_rank=0 --用户当前排名

	self.actName = "PkAction_endPkFight"
end

function PkAction_endPkFightRes:getActName()
	return self.actName
end

--通用奖励对象
function PkAction_endPkFightRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--用户之前排名
function PkAction_endPkFightRes:setInt_oldRank(int_oldRank)
	self.int_oldRank = int_oldRank
end
--用户当前排名
function PkAction_endPkFightRes:setInt_rank(int_rank)
	self.int_rank = int_rank
end





function PkAction_endPkFightRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_oldRank)

		outputStream:WriteInt(self.int_rank)


end

function PkAction_endPkFightRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.oldRank = inputStream:ReadInt()

		body.rank = inputStream:ReadInt()


	   return body
end