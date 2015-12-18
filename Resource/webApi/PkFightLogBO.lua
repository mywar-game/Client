

PkFightLogBO = {}

--战斗日志对象
function PkFightLogBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkFightLogBO:init()
	
	self.string_targetUserName="" --用户姓名

	self.int_flag=0 --胜负（0负1胜）

	self.int_systemHeroId=0 --系统英雄id

	self.int_level=0 --等级

	self.long_fightTime=0 --挑战时间

	self.int_rank=0 --自己的排名

	self.int_changeRank=0 --排名变化

	self.actName = "PkFightLogBO"
end

function PkFightLogBO:getActName()
	return self.actName
end

--用户姓名
function PkFightLogBO:setString_targetUserName(string_targetUserName)
	self.string_targetUserName = string_targetUserName
end
--胜负（0负1胜）
function PkFightLogBO:setInt_flag(int_flag)
	self.int_flag = int_flag
end
--系统英雄id
function PkFightLogBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--等级
function PkFightLogBO:setInt_level(int_level)
	self.int_level = int_level
end
--挑战时间
function PkFightLogBO:setLong_fightTime(long_fightTime)
	self.long_fightTime = long_fightTime
end
--自己的排名
function PkFightLogBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--排名变化
function PkFightLogBO:setInt_changeRank(int_changeRank)
	self.int_changeRank = int_changeRank
end





function PkFightLogBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_targetUserName)

		outputStream:WriteInt(self.int_flag)

		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteLong(self.long_fightTime)

		outputStream:WriteInt(self.int_rank)

		outputStream:WriteInt(self.int_changeRank)


end

function PkFightLogBO:decode(inputStream)
	    local body = {}
		body.targetUserName = inputStream:ReadUTFString()

		body.flag = inputStream:ReadInt()

		body.systemHeroId = inputStream:ReadInt()

		body.level = inputStream:ReadInt()

		body.fightTime = inputStream:ReadLong()

		body.rank = inputStream:ReadInt()

		body.changeRank = inputStream:ReadInt()


	   return body
end