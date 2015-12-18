

PawnshopAction_buyInRes = {}

--买入
function PawnshopAction_buyInRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PawnshopAction_buyInRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "PawnshopAction_buyIn"
end

function PawnshopAction_buyInRes:getActName()
	return self.actName
end

--通用奖励对象
function PawnshopAction_buyInRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function PawnshopAction_buyInRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function PawnshopAction_buyInRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end