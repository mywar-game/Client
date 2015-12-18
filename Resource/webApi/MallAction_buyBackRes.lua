

MallAction_buyBackRes = {}

--回购
function MallAction_buyBackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyBackRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --公共物品掉落

	self.actName = "MallAction_buyBack"
end

function MallAction_buyBackRes:getActName()
	return self.actName
end

--公共物品掉落
function MallAction_buyBackRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function MallAction_buyBackRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function MallAction_buyBackRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end