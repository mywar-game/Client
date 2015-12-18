

ForcesAction_openBattleBoxRes = {}

--战斗后的翻牌
function ForcesAction_openBattleBoxRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_openBattleBoxRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --得到的奖励对象

	self.actName = "ForcesAction_openBattleBox"
end

function ForcesAction_openBattleBoxRes:getActName()
	return self.actName
end

--得到的奖励对象
function ForcesAction_openBattleBoxRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ForcesAction_openBattleBoxRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ForcesAction_openBattleBoxRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end