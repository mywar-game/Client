

UserHeroSkillBO = {}

--用户英雄技能对象
function UserHeroSkillBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserHeroSkillBO:init()
	
	self.string_userId="" --用户编号

	self.string_userHeroSkillId="" --用户英雄技能唯一id

	self.int_systemHeroSkillId=0 --系统英雄技能唯一编号

	self.int_skillLevel=0 --技能等级

	self.int_skillExp=0 --技能经验

	self.int_pos=0 --技能所在英雄的位置,11、12、13、14、15为主动技能位置,21、22、23、24、25为被动技能的位置,31、32、33、34、35为团长技能位置

	self.actName = "UserHeroSkillBO"
end

function UserHeroSkillBO:getActName()
	return self.actName
end

--用户编号
function UserHeroSkillBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户英雄技能唯一id
function UserHeroSkillBO:setString_userHeroSkillId(string_userHeroSkillId)
	self.string_userHeroSkillId = string_userHeroSkillId
end
--系统英雄技能唯一编号
function UserHeroSkillBO:setInt_systemHeroSkillId(int_systemHeroSkillId)
	self.int_systemHeroSkillId = int_systemHeroSkillId
end
--技能等级
function UserHeroSkillBO:setInt_skillLevel(int_skillLevel)
	self.int_skillLevel = int_skillLevel
end
--技能经验
function UserHeroSkillBO:setInt_skillExp(int_skillExp)
	self.int_skillExp = int_skillExp
end
--技能所在英雄的位置,11、12、13、14、15为主动技能位置,21、22、23、24、25为被动技能的位置,31、32、33、34、35为团长技能位置
function UserHeroSkillBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function UserHeroSkillBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userHeroSkillId)

		outputStream:WriteInt(self.int_systemHeroSkillId)

		outputStream:WriteInt(self.int_skillLevel)

		outputStream:WriteInt(self.int_skillExp)

		outputStream:WriteInt(self.int_pos)


end

function UserHeroSkillBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userHeroSkillId = inputStream:ReadUTFString()

		body.systemHeroSkillId = inputStream:ReadInt()

		body.skillLevel = inputStream:ReadInt()

		body.skillExp = inputStream:ReadInt()

		body.pos = inputStream:ReadInt()


	   return body
end