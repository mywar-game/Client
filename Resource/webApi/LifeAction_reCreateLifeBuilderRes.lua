

LifeAction_reCreateLifeBuilderRes = {}

--重新建造用户生活建筑
function LifeAction_reCreateLifeBuilderRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_reCreateLifeBuilderRes:init()
	
	self.UserLifeInfoBO_userLifeInfoBO=nil --用户生活信息对象

	self.actName = "LifeAction_reCreateLifeBuilder"
end

function LifeAction_reCreateLifeBuilderRes:getActName()
	return self.actName
end

--用户生活信息对象
function LifeAction_reCreateLifeBuilderRes:setUserLifeInfoBO_userLifeInfoBO(UserLifeInfoBO_userLifeInfoBO)
	self.UserLifeInfoBO_userLifeInfoBO = UserLifeInfoBO_userLifeInfoBO
end





function LifeAction_reCreateLifeBuilderRes:encode(outputStream)
		self.UserLifeInfoBO_userLifeInfoBO:encode(outputStream)


end

function LifeAction_reCreateLifeBuilderRes:decode(inputStream)
	    local body = {}
        local userLifeInfoBOTemp = UserLifeInfoBO:New()
        body.userLifeInfoBO=userLifeInfoBOTemp:decode(inputStream)

	   return body
end