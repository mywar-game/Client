

LifeAction_createLifeBuilderReq = {}

--建造用户生活建筑
function LifeAction_createLifeBuilderReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_createLifeBuilderReq:init()
	
	self.int_category=0 --建造的类别（1矿场2花圃3渔场）

	self.actName = "LifeAction_createLifeBuilder"
end

function LifeAction_createLifeBuilderReq:getActName()
	return self.actName
end

--建造的类别（1矿场2花圃3渔场）
function LifeAction_createLifeBuilderReq:setInt_category(int_category)
	self.int_category = int_category
end





function LifeAction_createLifeBuilderReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)


end

function LifeAction_createLifeBuilderReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()


	   return body
end