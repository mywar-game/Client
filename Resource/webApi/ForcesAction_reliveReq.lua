

ForcesAction_reliveReq = {}

--复活
function ForcesAction_reliveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_reliveReq:init()
	
	self.string_userHeroId="" --用户英雄id

	self.actName = "ForcesAction_relive"
end

function ForcesAction_reliveReq:getActName()
	return self.actName
end

--用户英雄id
function ForcesAction_reliveReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end





function ForcesAction_reliveReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)


end

function ForcesAction_reliveReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()


	   return body
end