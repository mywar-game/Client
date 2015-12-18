

UserAttactBossInfoBO = {}

--用户攻击Boss信息对象
function UserAttactBossInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAttactBossInfoBO:init()
	
	self.string_userId="" --用户id

	self.int_isBlood=0 --是否掉血

	self.int_bDodge=0 --是否躲闪

	self.int_bParry=0 --是否格挡

	self.int_bCrit=0 --是否暴击

	self.int_effectId=0 --效果ID

	self.int_resId=0 --资源ID

	self.int_callHeroId=0 --召唤英雄ID(变身时使用）

	self.int_beingAttackState=0 --法术反射

	self.int_hurt=0 --对Boss伤害值

	self.int_treatment=0 --治疗量

	self.int_beHit=0 --承受伤害值

	self.string_targetUserId="" --目标用户

	self.int_status=0 --是否死亡1还鲜活着0挂了

	self.long_dieTime=0 --死亡时间

	self.int_x=0 --坐标x

	self.int_y=0 --坐标y

	self.actName = "UserAttactBossInfoBO"
end

function UserAttactBossInfoBO:getActName()
	return self.actName
end

--用户id
function UserAttactBossInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--是否掉血
function UserAttactBossInfoBO:setInt_isBlood(int_isBlood)
	self.int_isBlood = int_isBlood
end
--是否躲闪
function UserAttactBossInfoBO:setInt_bDodge(int_bDodge)
	self.int_bDodge = int_bDodge
end
--是否格挡
function UserAttactBossInfoBO:setInt_bParry(int_bParry)
	self.int_bParry = int_bParry
end
--是否暴击
function UserAttactBossInfoBO:setInt_bCrit(int_bCrit)
	self.int_bCrit = int_bCrit
end
--效果ID
function UserAttactBossInfoBO:setInt_effectId(int_effectId)
	self.int_effectId = int_effectId
end
--资源ID
function UserAttactBossInfoBO:setInt_resId(int_resId)
	self.int_resId = int_resId
end
--召唤英雄ID(变身时使用）
function UserAttactBossInfoBO:setInt_callHeroId(int_callHeroId)
	self.int_callHeroId = int_callHeroId
end
--法术反射
function UserAttactBossInfoBO:setInt_beingAttackState(int_beingAttackState)
	self.int_beingAttackState = int_beingAttackState
end
--对Boss伤害值
function UserAttactBossInfoBO:setInt_hurt(int_hurt)
	self.int_hurt = int_hurt
end
--治疗量
function UserAttactBossInfoBO:setInt_treatment(int_treatment)
	self.int_treatment = int_treatment
end
--承受伤害值
function UserAttactBossInfoBO:setInt_beHit(int_beHit)
	self.int_beHit = int_beHit
end
--目标用户
function UserAttactBossInfoBO:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end
--是否死亡1还鲜活着0挂了
function UserAttactBossInfoBO:setInt_status(int_status)
	self.int_status = int_status
end
--死亡时间
function UserAttactBossInfoBO:setLong_dieTime(long_dieTime)
	self.long_dieTime = long_dieTime
end
--坐标x
function UserAttactBossInfoBO:setInt_x(int_x)
	self.int_x = int_x
end
--坐标y
function UserAttactBossInfoBO:setInt_y(int_y)
	self.int_y = int_y
end





function UserAttactBossInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_isBlood)

		outputStream:WriteInt(self.int_bDodge)

		outputStream:WriteInt(self.int_bParry)

		outputStream:WriteInt(self.int_bCrit)

		outputStream:WriteInt(self.int_effectId)

		outputStream:WriteInt(self.int_resId)

		outputStream:WriteInt(self.int_callHeroId)

		outputStream:WriteInt(self.int_beingAttackState)

		outputStream:WriteInt(self.int_hurt)

		outputStream:WriteInt(self.int_treatment)

		outputStream:WriteInt(self.int_beHit)

		outputStream:WriteUTFString(self.string_targetUserId)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteLong(self.long_dieTime)

		outputStream:WriteInt(self.int_x)

		outputStream:WriteInt(self.int_y)


end

function UserAttactBossInfoBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.isBlood = inputStream:ReadInt()

		body.bDodge = inputStream:ReadInt()

		body.bParry = inputStream:ReadInt()

		body.bCrit = inputStream:ReadInt()

		body.effectId = inputStream:ReadInt()

		body.resId = inputStream:ReadInt()

		body.callHeroId = inputStream:ReadInt()

		body.beingAttackState = inputStream:ReadInt()

		body.hurt = inputStream:ReadInt()

		body.treatment = inputStream:ReadInt()

		body.beHit = inputStream:ReadInt()

		body.targetUserId = inputStream:ReadUTFString()

		body.status = inputStream:ReadInt()

		body.dieTime = inputStream:ReadLong()

		body.x = inputStream:ReadInt()

		body.y = inputStream:ReadInt()


	   return body
end