

ForcesAction_endCollectRes = {}

--结束采集
function ForcesAction_endCollectRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_endCollectRes:init()
	
	self.int_isFightAgain=0 --是否遇到怪物0没有1有

	self.CommonGoodsBeanBO_drop=nil --公共物品掉落

	self.actName = "ForcesAction_endCollect"
end

function ForcesAction_endCollectRes:getActName()
	return self.actName
end

--是否遇到怪物0没有1有
function ForcesAction_endCollectRes:setInt_isFightAgain(int_isFightAgain)
	self.int_isFightAgain = int_isFightAgain
end
--公共物品掉落
function ForcesAction_endCollectRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ForcesAction_endCollectRes:encode(outputStream)
		outputStream:WriteInt(self.int_isFightAgain)

		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ForcesAction_endCollectRes:decode(inputStream)
	    local body = {}
		body.isFightAgain = inputStream:ReadInt()

        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end