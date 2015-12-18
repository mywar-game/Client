

HeroAction_changeSkillPosReq = {}

--上阵团长技能
function HeroAction_changeSkillPosReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeSkillPosReq:init()
	
	self.string_userSkillId="" --用户技能唯一id

	self.int_pos=0 --要上阵到的位置（0为下阵）

	self.actName = "HeroAction_changeSkillPos"
end

function HeroAction_changeSkillPosReq:getActName()
	return self.actName
end

--用户技能唯一id
function HeroAction_changeSkillPosReq:setString_userSkillId(string_userSkillId)
	self.string_userSkillId = string_userSkillId
end
--要上阵到的位置（0为下阵）
function HeroAction_changeSkillPosReq:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function HeroAction_changeSkillPosReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userSkillId)

		outputStream:WriteInt(self.int_pos)


end

function HeroAction_changeSkillPosReq:decode(inputStream)
	    local body = {}
		body.userSkillId = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()


	   return body
end