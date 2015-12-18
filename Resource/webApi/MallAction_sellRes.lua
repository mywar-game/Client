

MallAction_sellRes = {}

--出售
function MallAction_sellRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_sellRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --公共物品掉落

	self.actName = "MallAction_sell"
end

function MallAction_sellRes:getActName()
	return self.actName
end

--公共物品掉落
function MallAction_sellRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function MallAction_sellRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function MallAction_sellRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end