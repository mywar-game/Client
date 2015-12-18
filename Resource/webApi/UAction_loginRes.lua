

UAction_loginRes = {}

--角色登录接口
function UAction_loginRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UAction_loginRes:init()
	
	self.actName = "UAction_login"
end

function UAction_loginRes:getActName()
	return self.actName
end






function UAction_loginRes:encode(outputStream)

end

function UAction_loginRes:decode(inputStream)
	    local body = {}

	   return body
end