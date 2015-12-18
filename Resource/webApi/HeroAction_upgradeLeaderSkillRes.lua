

HeroAction_upgradeLeaderSkillRes = {}

--升级团长技能
function HeroAction_upgradeLeaderSkillRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_upgradeLeaderSkillRes:init()
	
	self.string_userHeroSkillId="" --用户团长技能id

	self.int_skillLevel=0 --技能等级

	self.int_skillExp=0 --用户团长技能总经验

	self.int_gold=0 --用户金币数

	self.list_skillToolBOList={} --消耗掉的道具列表

	self.actName = "HeroAction_upgradeLeaderSkill"
end

function HeroAction_upgradeLeaderSkillRes:getActName()
	return self.actName
end

--用户团长技能id
function HeroAction_upgradeLeaderSkillRes:setString_userHeroSkillId(string_userHeroSkillId)
	self.string_userHeroSkillId = string_userHeroSkillId
end
--技能等级
function HeroAction_upgradeLeaderSkillRes:setInt_skillLevel(int_skillLevel)
	self.int_skillLevel = int_skillLevel
end
--用户团长技能总经验
function HeroAction_upgradeLeaderSkillRes:setInt_skillExp(int_skillExp)
	self.int_skillExp = int_skillExp
end
--用户金币数
function HeroAction_upgradeLeaderSkillRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--消耗掉的道具列表
function HeroAction_upgradeLeaderSkillRes:setList_skillToolBOList(list_skillToolBOList)
	self.list_skillToolBOList = list_skillToolBOList
end





function HeroAction_upgradeLeaderSkillRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroSkillId)

		outputStream:WriteInt(self.int_skillLevel)

		outputStream:WriteInt(self.int_skillExp)

		outputStream:WriteInt(self.int_gold)

		
		self.list_skillToolBOList = self.list_skillToolBOList or {}
		local list_skillToolBOListsize = #self.list_skillToolBOList
		outputStream:WriteInt(list_skillToolBOListsize)
		for list_skillToolBOListi=1,list_skillToolBOListsize do
            self.list_skillToolBOList[list_skillToolBOListi]:encode(outputStream)
		end
end

function HeroAction_upgradeLeaderSkillRes:decode(inputStream)
	    local body = {}
		body.userHeroSkillId = inputStream:ReadUTFString()

		body.skillLevel = inputStream:ReadInt()

		body.skillExp = inputStream:ReadInt()

		body.gold = inputStream:ReadInt()

		local skillToolBOListTemp = {}
		local skillToolBOListsize = inputStream:ReadInt()
		for skillToolBOListi=1,skillToolBOListsize do
            local entry = SkillToolBO:New()
            table.insert(skillToolBOListTemp,entry:decode(inputStream))

		end
		body.skillToolBOList = skillToolBOListTemp

	   return body
end