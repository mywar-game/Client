

LifeAction_createLifeBuilderRes = {}

--建造用户生活建筑
function LifeAction_createLifeBuilderRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_createLifeBuilderRes:init()
	
	self.UserLifeInfoBO_userLifeInfoBO=nil --用户生活信息对象

	self.actName = "LifeAction_createLifeBuilder"
end

function LifeAction_createLifeBuilderRes:getActName()
	return self.actName
end

--用户生活信息对象
function LifeAction_createLifeBuilderRes:setUserLifeInfoBO_userLifeInfoBO(UserLifeInfoBO_userLifeInfoBO)
	self.UserLifeInfoBO_userLifeInfoBO = UserLifeInfoBO_userLifeInfoBO
end





function LifeAction_createLifeBuilderRes:encode(outputStream)
		self.UserLifeInfoBO_userLifeInfoBO:encode(outputStream)


end

function LifeAction_createLifeBuilderRes:decode(inputStream)
	    local body = {}
        local userLifeInfoBOTemp = UserLifeInfoBO:New()
        body.userLifeInfoBO=userLifeInfoBOTemp:decode(inputStream)

	   return body
end