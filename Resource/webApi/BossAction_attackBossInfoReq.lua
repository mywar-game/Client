

BossAction_attackBossInfoReq = {}

--发送攻打世界boss的数据
function BossAction_attackBossInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_attackBossInfoReq:init()
	
	self.string_userIdStr="" --用户Id

	self.int_skillId=0 --释放的技能id

	self.list_effectList={} --技能效果列表

	self.actName = "BossAction_attackBossInfo"
end

function BossAction_attackBossInfoReq:getActName()
	return self.actName
end

--用户Id
function BossAction_attackBossInfoReq:setString_userIdStr(string_userIdStr)
	self.string_userIdStr = string_userIdStr
end
--释放的技能id
function BossAction_attackBossInfoReq:setInt_skillId(int_skillId)
	self.int_skillId = int_skillId
end
--技能效果列表
function BossAction_attackBossInfoReq:setList_effectList(list_effectList)
	self.list_effectList = list_effectList
end





function BossAction_attackBossInfoReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userIdStr)

		outputStream:WriteInt(self.int_skillId)

		
		self.list_effectList = self.list_effectList or {}
		local list_effectListsize = #self.list_effectList
		outputStream:WriteInt(list_effectListsize)
		for list_effectListi=1,list_effectListsize do
            self.list_effectList[list_effectListi]:encode(outputStream)
		end
end

function BossAction_attackBossInfoReq:decode(inputStream)
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