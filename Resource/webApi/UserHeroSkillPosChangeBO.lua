

UserHeroSkillPosChangeBO = {}

--用户英雄技能位置更新对象
function UserHeroSkillPosChangeBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserHeroSkillPosChangeBO:init()
	
	self.string_userHeroSkillId="" --用户英雄技能唯一id

	self.int_pos=0 --31、32、33、34、35为团长技能位置

	self.actName = "UserHeroSkillPosChangeBO"
end

function UserHeroSkillPosChangeBO:getActName()
	return self.actName
end

--用户英雄技能唯一id
function UserHeroSkillPosChangeBO:setString_userHeroSkillId(string_userHeroSkillId)
	self.string_userHeroSkillId = string_userHeroSkillId
end
--31、32、33、34、35为团长技能位置
function UserHeroSkillPosChangeBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function UserHeroSkillPosChangeBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroSkillId)

		outputStream:WriteInt(self.int_pos)


end

function UserHeroSkillPosChangeBO:decode(inputStream)
	    local body = {}
		body.userHeroSkillId = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()


	   return body
end