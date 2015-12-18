

HeroAction_studyLeaderSkillReq = {}

--学习团长技能
function HeroAction_studyLeaderSkillReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_studyLeaderSkillReq:init()
	
	self.int_systemHeroSkillId=0 --团长技能id

	self.actName = "HeroAction_studyLeaderSkill"
end

function HeroAction_studyLeaderSkillReq:getActName()
	return self.actName
end

--团长技能id
function HeroAction_studyLeaderSkillReq:setInt_systemHeroSkillId(int_systemHeroSkillId)
	self.int_systemHeroSkillId = int_systemHeroSkillId
end





function HeroAction_studyLeaderSkillReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemHeroSkillId)


end

function HeroAction_studyLeaderSkillReq:decode(inputStream)
	    local body = {}
		body.systemHeroSkillId = inputStream:ReadInt()


	   return body
end