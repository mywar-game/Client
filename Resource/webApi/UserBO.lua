

UserBO = {}

--用户对象信息
function UserBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserBO:init()
	
	self.string_userId="" --用户编号

	self.int_ftId=0 --游戏id

	self.string_roleName="" --角色名称

	self.int_level=0 --用户等级

	self.int_exp=0 --用户经验

	self.int_money=0 --用户人民币

	self.int_gold=0 --用户金币

	self.int_camp=0 --1联盟，2部落

	self.int_power=0 --体力值

	self.int_honour=0 --荣誉

	self.int_vipLevel=0 --用户vip等级

	self.int_vipExp=0 --vip经验

	self.int_jobExp=0 --职业经验

	self.int_allOnLineTime=0 --在线时长，单位秒

	self.int_effective=0 --战斗力

	self.int_packExtendTimes=0 --背包扩展次数

	self.int_storehouseExtendTimes=0 --仓库扩展次数

	self.string_prePosition="" --上次登出所处位置格式为(sceneId,x,y),如果为空则说明该玩家刚刚创角，还未进入过游戏

	self.long_regTime=0 --用户注册时间戳

	self.actName = "UserBO"
end

function UserBO:getActName()
	return self.actName
end

--用户编号
function UserBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--游戏id
function UserBO:setInt_ftId(int_ftId)
	self.int_ftId = int_ftId
end
--角色名称
function UserBO:setString_roleName(string_roleName)
	self.string_roleName = string_roleName
end
--用户等级
function UserBO:setInt_level(int_level)
	self.int_level = int_level
end
--用户经验
function UserBO:setInt_exp(int_exp)
	self.int_exp = int_exp
end
--用户人民币
function UserBO:setInt_money(int_money)
	self.int_money = int_money
end
--用户金币
function UserBO:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--1联盟，2部落
function UserBO:setInt_camp(int_camp)
	self.int_camp = int_camp
end
--体力值
function UserBO:setInt_power(int_power)
	self.int_power = int_power
end
--荣誉
function UserBO:setInt_honour(int_honour)
	self.int_honour = int_honour
end
--用户vip等级
function UserBO:setInt_vipLevel(int_vipLevel)
	self.int_vipLevel = int_vipLevel
end
--vip经验
function UserBO:setInt_vipExp(int_vipExp)
	self.int_vipExp = int_vipExp
end
--职业经验
function UserBO:setInt_jobExp(int_jobExp)
	self.int_jobExp = int_jobExp
end
--在线时长，单位秒
function UserBO:setInt_allOnLineTime(int_allOnLineTime)
	self.int_allOnLineTime = int_allOnLineTime
end
--战斗力
function UserBO:setInt_effective(int_effective)
	self.int_effective = int_effective
end
--背包扩展次数
function UserBO:setInt_packExtendTimes(int_packExtendTimes)
	self.int_packExtendTimes = int_packExtendTimes
end
--仓库扩展次数
function UserBO:setInt_storehouseExtendTimes(int_storehouseExtendTimes)
	self.int_storehouseExtendTimes = int_storehouseExtendTimes
end
--上次登出所处位置格式为(sceneId,x,y),如果为空则说明该玩家刚刚创角，还未进入过游戏
function UserBO:setString_prePosition(string_prePosition)
	self.string_prePosition = string_prePosition
end
--用户注册时间戳
function UserBO:setLong_regTime(long_regTime)
	self.long_regTime = long_regTime
end





function UserBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_ftId)

		outputStream:WriteUTFString(self.string_roleName)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_exp)

		outputStream:WriteInt(self.int_money)

		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_camp)

		outputStream:WriteInt(self.int_power)

		outputStream:WriteInt(self.int_honour)

		outputStream:WriteInt(self.int_vipLevel)

		outputStream:WriteInt(self.int_vipExp)

		outputStream:WriteInt(self.int_jobExp)

		outputStream:WriteInt(self.int_allOnLineTime)

		outputStream:WriteInt(self.int_effective)

		outputStream:WriteInt(self.int_packExtendTimes)

		outputStream:WriteInt(self.int_storehouseExtendTimes)

		outputStream:WriteUTFString(self.string_prePosition)

		outputStream:WriteLong(self.long_regTime)


end

function UserBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.ftId = inputStream:ReadInt()

		body.roleName = inputStream:ReadUTFString()

		body.level = inputStream:ReadInt()

		body.exp = inputStream:ReadInt()

		body.money = inputStream:ReadInt()

		body.gold = inputStream:ReadInt()

		body.camp = inputStream:ReadInt()

		body.power = inputStream:ReadInt()

		body.honour = inputStream:ReadInt()

		body.vipLevel = inputStream:ReadInt()

		body.vipExp = inputStream:ReadInt()

		body.jobExp = inputStream:ReadInt()

		body.allOnLineTime = inputStream:ReadInt()

		body.effective = inputStream:ReadInt()

		body.packExtendTimes = inputStream:ReadInt()

		body.storehouseExtendTimes = inputStream:ReadInt()

		body.prePosition = inputStream:ReadUTFString()

		body.regTime = inputStream:ReadLong()


	   return body
end