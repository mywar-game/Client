

HeroAction_upgradeLeaderSkillReq = {}

--升级团长技能
function HeroAction_upgradeLeaderSkillReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_upgradeLeaderSkillReq:init()
	
	self.string_userHeroSkillId="" --用户团长技能id

	self.list_skillToolBOList={} --技能道具列表

	self.actName = "HeroAction_upgradeLeaderSkill"
end

function HeroAction_upgradeLeaderSkillReq:getActName()
	return self.actName
end

--用户团长技能id
function HeroAction_upgradeLeaderSkillReq:setString_userHeroSkillId(string_userHeroSkillId)
	self.string_userHeroSkillId = string_userHeroSkillId
end
--技能道具列表
function HeroAction_upgradeLeaderSkillReq:setList_skillToolBOList(list_skillToolBOList)
	self.list_skillToolBOList = list_skillToolBOList
end





function HeroAction_upgradeLeaderSkillReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroSkillId)

		
		self.list_skillToolBOList = self.list_skillToolBOList or {}
		local list_skillToolBOListsize = #self.list_skillToolBOList
		outputStream:WriteInt(list_skillToolBOListsize)
		for list_skillToolBOListi=1,list_skillToolBOListsize do
            self.list_skillToolBOList[list_skillToolBOListi]:encode(outputStream)
		end
end

function HeroAction_upgradeLeaderSkillReq:decode(inputStream)
	    local body = {}
		body.userHeroSkillId = inputStream:ReadUTFString()

		local skillToolBOListTemp = {}
		local skillToolBOListsize = inputStream:ReadInt()
		for skillToolBOListi=1,skillToolBOListsize do
            local entry = SkillToolBO:New()
            table.insert(skillToolBOListTemp,entry:decode(inputStream))

		end
		body.skillToolBOList = skillToolBOListTemp

	   return body
end