

Boss_pushUserAttackInfoNotify = {}

--推送用户攻击信息
function Boss_pushUserAttackInfoNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushUserAttackInfoNotify:init()
	
	self.string_userIdStr="" --用户Id

	self.int_skillId=0 --释放的技能id

	self.list_effectList={} --技能效果列表

	self.actName = "Boss_pushUserAttackInfo"
end

function Boss_pushUserAttackInfoNotify:getActName()
	return self.actName
end

--用户Id
function Boss_pushUserAttackInfoNotify:setString_userIdStr(string_userIdStr)
	self.string_userIdStr = string_userIdStr
end
--释放的技能id
function Boss_pushUserAttackInfoNotify:setInt_skillId(int_skillId)
	self.int_skillId = int_skillId
end
--技能效果列表
function Boss_pushUserAttackInfoNotify:setList_effectList(list_effectList)
	self.list_effectList = list_effectList
end





function Boss_pushUserAttackInfoNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userIdStr)

		outputStream:WriteInt(self.int_skillId)

		
		self.list_effectList = self.list_effectList or {}
		local list_effectListsize = #self.list_effectList
		outputStream:WriteInt(list_effectListsize)
		for list_effectListi=1,list_effectListsize do
            self.list_effectList[list_effectListi]:encode(outputStream)
		end
end

function Boss_pushUserAttackInfoNotify:decode(inputStream)
	    local body = {}
		body.userIdStr = inputStream:ReadUTFString()

		body.skillId = inputStream:ReadInt()

		local effectListTemp = {}
		local effectListsize = inputStream:ReadInt()
		for effectListi=1,effectListsize do
            local entry = EffectBO:New()
            table.insert(effectListTemp,entry:decode(inputStream))

		end
		body.effectList = effectListTemp

	   return body
end