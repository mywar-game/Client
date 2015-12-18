

UAction_loginReq = {}

--角色登录接口
function UAction_loginReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UAction_loginReq:init()
	
	self.string_token="" --用户登录令牌

	self.string_userId="" --用户编号

	self.string_partnerId="" --渠道编号

	self.string_serverId="" --服务器编号

	self.actName = "UAction_login"
end

function UAction_loginReq:getActName()
	return self.actName
end

--用户登录令牌
function UAction_loginReq:setString_token(string_token)
	self.string_token = string_token
end
--用户编号
function UAction_loginReq:setString_userId(string_userId)
	self.string_userId = string_userId
end
--渠道编号
function UAction_loginReq:setString_partnerId(string_partnerId)
	self.string_partnerId = string_partnerId
end
--服务器编号
function UAction_loginReq:setString_serverId(string_serverId)
	self.string_serverId = string_serverId
end





function UAction_loginReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_token)

		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_partnerId)

		outputStream:WriteUTFString(self.string_serverId)


end

function UAction_loginReq:decode(inputStream)
	    local body = {}
		body.token = inputStream:ReadUTFString()

		body.userId = inputStream:ReadUTFString()

		body.partnerId = inputStream:ReadUTFString()

		body.serverId = inputStream:ReadUTFString()


	   return body
end