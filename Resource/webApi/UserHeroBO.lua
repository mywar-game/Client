

UserHeroBO = {}

--用户英雄对象
function UserHeroBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserHeroBO:init()
	
	self.string_userId="" --用户编号

	self.string_userHeroId="" --用户英雄唯一id

	self.int_systemHeroId=0 --系统英雄唯一编号

	self.int_level=0 --英雄等级

	self.int_exp=0 --英雄经验

	self.int_effective=0 --英雄装等

	self.int_isScene=0 --是否在场景中0不是1是

	self.int_pos=0 --位置0不在阵上1在阵上

	self.int_isTeamLeader=0 --是否为队长0不是1是

	self.int_status=0 --英雄状态0在酒馆1在空闲的英雄2英雄在阵上3正在挖矿4正在修花圃5正在钓鱼

	self.int_star=0 --星数

	self.string_heroName="" --英雄名称

	self.actName = "UserHeroBO"
end

function UserHeroBO:getActName()
	return self.actName
end

--用户编号
function UserHeroBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户英雄唯一id
function UserHeroBO:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--系统英雄唯一编号
function UserHeroBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--英雄等级
function UserHeroBO:setInt_level(int_level)
	self.int_level = int_level
end
--英雄经验
function UserHeroBO:setInt_exp(int_exp)
	self.int_exp = int_exp
end
--英雄装等
function UserHeroBO:setInt_effective(int_effective)
	self.int_effective = int_effective
end
--是否在场景中0不是1是
function UserHeroBO:setInt_isScene(int_isScene)
	self.int_isScene = int_isScene
end
--位置0不在阵上1在阵上
function UserHeroBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end
--是否为队长0不是1是
function UserHeroBO:setInt_isTeamLeader(int_isTeamLeader)
	self.int_isTeamLeader = int_isTeamLeader
end
--英雄状态0在酒馆1在空闲的英雄2英雄在阵上3正在挖矿4正在修花圃5正在钓鱼
function UserHeroBO:setInt_status(int_status)
	self.int_status = int_status
end
--星数
function UserHeroBO:setInt_star(int_star)
	self.int_star = int_star
end
--英雄名称
function UserHeroBO:setString_heroName(string_heroName)
	self.string_heroName = string_heroName
end





function UserHeroBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_exp)

		outputStream:WriteInt(self.int_effective)

		outputStream:WriteInt(self.int_isScene)

		outputStream:WriteInt(self.int_pos)

		outputStream:WriteInt(self.int_isTeamLeader)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_star)

		outputStream:WriteUTFString(self.string_heroName)


end

function UserHeroBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userHeroId = inputStream:ReadUTFString()

		body.systemHeroId = inputStream:ReadInt()

		body.level = inputStream:ReadInt()

		body.exp = inputStream:ReadInt()

		body.effective = inputStream:ReadInt()

		body.isScene = inputStream:ReadInt()

		body.pos = inputStream:ReadInt()

		body.isTeamLeader = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.star = inputStream:ReadInt()

		body.heroName = inputStream:ReadUTFString()


	   return body
end