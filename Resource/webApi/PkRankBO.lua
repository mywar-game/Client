

PkRankBO = {}

--竞技场排行榜对象
function PkRankBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkRankBO:init()
	
	self.int_rank=0 --排名

	self.string_userName="" --用户名称

	self.string_legionName="" --公会名称

	self.int_level=0 --用户等级

	self.int_defencePower=0 --防守装等

	self.int_systemHeroId=0 --队长头像英雄id

	self.list_defenceHeroList={} --防守阵营英雄id

	self.actName = "PkRankBO"
end

function PkRankBO:getActName()
	return self.actName
end

--排名
function PkRankBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--用户名称
function PkRankBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--公会名称
function PkRankBO:setString_legionName(string_legionName)
	self.string_legionName = string_legionName
end
--用户等级
function PkRankBO:setInt_level(int_level)
	self.int_level = int_level
end
--防守装等
function PkRankBO:setInt_defencePower(int_defencePower)
	self.int_defencePower = int_defencePower
end
--队长头像英雄id
function PkRankBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--防守阵营英雄id
function PkRankBO:setList_defenceHeroList(list_defenceHeroList)
	self.list_defenceHeroList = list_defenceHeroList
end





function PkRankBO:encode(outputStream)
		outputStream:WriteInt(self.int_rank)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteUTFString(self.string_legionName)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_defencePower)

		outputStream:WriteInt(self.int_systemHeroId)

		
		self.list_defenceHeroList = self.list_defenceHeroList or {}
		local list_defenceHeroListsize = #self.list_defenceHeroList
		outputStream:WriteInt(list_defenceHeroListsize)
		for list_defenceHeroListi=1,list_defenceHeroListsize do
            outputStream:WriteInt(self.list_defenceHeroList[list_defenceHeroListi])
		end
end

function PkRankBO:decode(inputStream)
	    local body = {}
		body.rank = inputStream:ReadInt()

		body.userName = inputStream:ReadUTFString()

		body.legionName = inputStream:ReadUTFString()

		body.level = inputStream:ReadInt()

		body.defencePower = inputStream:ReadInt()

		body.systemHeroId = inputStream:ReadInt()

		local defenceHeroListTemp = {}
		local defenceHeroListsize = inputStream:ReadInt()
		for defenceHeroListi=1,defenceHeroListsize do
            table.insert(defenceHeroListTemp,inputStream:ReadInt())
		end
		body.defenceHeroList = defenceHeroListTemp

	   return body
end