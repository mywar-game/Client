

PawnshopAction_sellRes = {}

--卖出
function PawnshopAction_sellRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PawnshopAction_sellRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "PawnshopAction_sell"
end

function PawnshopAction_sellRes:getActName()
	return self.actName
end

--通用奖励对象
function PawnshopAction_sellRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function PawnshopAction_sellRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function PawnshopAction_sellRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end