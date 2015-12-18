

HeroAction_studyLeaderSkillRes = {}

--学习团长技能
function HeroAction_studyLeaderSkillRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_studyLeaderSkillRes:init()
	
	self.int_gold=0 --用户金币数

	self.int_money=0 --用户钻石数

	self.UserHeroSkillBO_userHeroSkillBO=nil --用户英雄技能对象

	self.actName = "HeroAction_studyLeaderSkill"
end

function HeroAction_studyLeaderSkillRes:getActName()
	return self.actName
end

--用户金币数
function HeroAction_studyLeaderSkillRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户钻石数
function HeroAction_studyLeaderSkillRes:setInt_money(int_money)
	self.int_money = int_money
end
--用户英雄技能对象
function HeroAction_studyLeaderSkillRes:setUserHeroSkillBO_userHeroSkillBO(UserHeroSkillBO_userHeroSkillBO)
	self.UserHeroSkillBO_userHeroSkillBO = UserHeroSkillBO_userHeroSkillBO
end





function HeroAction_studyLeaderSkillRes:encode(outputStream)
		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)

		self.UserHeroSkillBO_userHeroSkillBO:encode(outputStream)


end

function HeroAction_studyLeaderSkillRes:decode(inputStream)
	    local body = {}
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()

        local userHeroSkillBOTemp = UserHeroSkillBO:New()
        body.userHeroSkillBO=userHeroSkillBOTemp:decode(inputStream)

	   return body
end