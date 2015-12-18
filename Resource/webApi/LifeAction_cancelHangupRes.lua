

LifeAction_cancelHangupRes = {}

--取消挂机
function LifeAction_cancelHangupRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_cancelHangupRes:init()
	
	self.UserLifeInfoBO_userLifeInfoBO=nil --用户生活信息对象

	self.actName = "LifeAction_cancelHangup"
end

function LifeAction_cancelHangupRes:getActName()
	return self.actName
end

--用户生活信息对象
function LifeAction_cancelHangupRes:setUserLifeInfoBO_userLifeInfoBO(UserLifeInfoBO_userLifeInfoBO)
	self.UserLifeInfoBO_userLifeInfoBO = UserLifeInfoBO_userLifeInfoBO
end





function LifeAction_cancelHangupRes:encode(outputStream)
		self.UserLifeInfoBO_userLifeInfoBO:encode(outputStream)


end

function LifeAction_cancelHangupRes:decode(inputStream)
	    local body = {}
        local userLifeInfoBOTemp = UserLifeInfoBO:New()
        body.userLifeInfoBO=userLifeInfoBOTemp:decode(inputStream)

	   return body
end