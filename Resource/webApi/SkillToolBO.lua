

SkillToolBO = {}

--技能道具对象
function SkillToolBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SkillToolBO:init()
	
	self.int_toolId=0 --技能书道具id

	self.int_toolNum=0 --技能书数量

	self.actName = "SkillToolBO"
end

function SkillToolBO:getActName()
	return self.actName
end

--技能书道具id
function SkillToolBO:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--技能书数量
function SkillToolBO:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end





function SkillToolBO:encode(outputStream)
		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)


end

function SkillToolBO:decode(inputStream)
	    local body = {}
		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()


	   return body
end