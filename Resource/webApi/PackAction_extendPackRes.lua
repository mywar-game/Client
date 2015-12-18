

PackAction_extendPackRes = {}

--扩展背包
function PackAction_extendPackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_extendPackRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用掉落对象

	self.actName = "PackAction_extendPack"
end

function PackAction_extendPackRes:getActName()
	return self.actName
end

--通用掉落对象
function PackAction_extendPackRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function PackAction_extendPackRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function PackAction_extendPackRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end