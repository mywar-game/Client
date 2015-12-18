

LifeAction_reCreateLifeBuilderReq = {}

--重新建造用户生活建筑
function LifeAction_reCreateLifeBuilderReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_reCreateLifeBuilderReq:init()
	
	self.int_category=0 --重新建造的类别（1矿场2花圃3渔场）

	self.actName = "LifeAction_reCreateLifeBuilder"
end

function LifeAction_reCreateLifeBuilderReq:getActName()
	return self.actName
end

--重新建造的类别（1矿场2花圃3渔场）
function LifeAction_reCreateLifeBuilderReq:setInt_category(int_category)
	self.int_category = int_category
end





function LifeAction_reCreateLifeBuilderReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)


end

function LifeAction_reCreateLifeBuilderReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()


	   return body
end