

HeroAction_promoteHeroStarReq = {}

--升星
function HeroAction_promoteHeroStarReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_promoteHeroStarReq:init()
	
	self.int_type=0 --类型1材料升星2道具升星

	self.string_userHeroId="" --用户英雄id

	self.GoodsBeanBO_tool=nil --幸运石

	self.actName = "HeroAction_promoteHeroStar"
end

function HeroAction_promoteHeroStarReq:getActName()
	return self.actName
end

--类型1材料升星2道具升星
function HeroAction_promoteHeroStarReq:setInt_type(int_type)
	self.int_type = int_type
end
--用户英雄id
function HeroAction_promoteHeroStarReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--幸运石
function HeroAction_promoteHeroStarReq:setGoodsBeanBO_tool(GoodsBeanBO_tool)
	self.GoodsBeanBO_tool = GoodsBeanBO_tool
end





function HeroAction_promoteHeroStarReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)

		outputStream:WriteUTFString(self.string_userHeroId)

		self.GoodsBeanBO_tool:encode(outputStream)


end

function HeroAction_promoteHeroStarReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()

		body.userHeroId = inputStream:ReadUTFString()

        local toolTemp = GoodsBeanBO:New()
        body.tool=toolTemp:decode(inputStream)

	   return body
end