

HeroAction_getUserBattleInfoReq = {}

--获取用户阵容信息
function HeroAction_getUserBattleInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_getUserBattleInfoReq:init()
	
	self.string_userId="" --用户id

	self.actName = "HeroAction_getUserBattleInfo"
end

function HeroAction_getUserBattleInfoReq:getActName()
	return self.actName
end

--用户id
function HeroAction_getUserBattleInfoReq:setString_userId(string_userId)
	self.string_userId = string_userId
end





function HeroAction_getUserBattleInfoReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)


end

function HeroAction_getUserBattleInfoReq:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()


	   return body
end