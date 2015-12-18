

MallAction_buyInRes = {}

--购买
function MallAction_buyInRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyInRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --公共物品掉落

	self.actName = "MallAction_buyIn"
end

function MallAction_buyInRes:getActName()
	return self.actName
end

--公共物品掉落
function MallAction_buyInRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function MallAction_buyInRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function MallAction_buyInRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end