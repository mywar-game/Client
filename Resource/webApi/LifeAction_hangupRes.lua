

LifeAction_hangupRes = {}

--开始挂机
function LifeAction_hangupRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_hangupRes:init()
	
	self.UserLifeInfoBO_userLifeInfoBO=nil --用户生活信息对象

	self.actName = "LifeAction_hangup"
end

function LifeAction_hangupRes:getActName()
	return self.actName
end

--用户生活信息对象
function LifeAction_hangupRes:setUserLifeInfoBO_userLifeInfoBO(UserLifeInfoBO_userLifeInfoBO)
	self.UserLifeInfoBO_userLifeInfoBO = UserLifeInfoBO_userLifeInfoBO
end





function LifeAction_hangupRes:encode(outputStream)
		self.UserLifeInfoBO_userLifeInfoBO:encode(outputStream)


end

function LifeAction_hangupRes:decode(inputStream)
	    local body = {}
        local userLifeInfoBOTemp = UserLifeInfoBO:New()
        body.userLifeInfoBO=userLifeInfoBOTemp:decode(inputStream)

	   return body
end