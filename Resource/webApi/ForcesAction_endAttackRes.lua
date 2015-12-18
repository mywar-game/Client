

ForcesAction_endAttackRes = {}

--攻击关卡结束
function ForcesAction_endAttackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_endAttackRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --获得的物品

	self.actName = "ForcesAction_endAttack"
end

function ForcesAction_endAttackRes:getActName()
	return self.actName
end

--获得的物品
function ForcesAction_endAttackRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ForcesAction_endAttackRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ForcesAction_endAttackRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end