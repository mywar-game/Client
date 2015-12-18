

HeroAction_changeHeroPosRes = {}

--英雄上阵
function HeroAction_changeHeroPosRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeHeroPosRes:init()
	
	self.list_updateHeroList={} --需要更新的英雄列表，如果客户端缓存中存在该列表中的英雄对象，则替换

	self.actName = "HeroAction_changeHeroPos"
end

function HeroAction_changeHeroPosRes:getActName()
	return self.actName
end

--需要更新的英雄列表，如果客户端缓存中存在该列表中的英雄对象，则替换
function HeroAction_changeHeroPosRes:setList_updateHeroList(list_updateHeroList)
	self.list_updateHeroList = list_updateHeroList
end





function HeroAction_changeHeroPosRes:encode(outputStream)
		
		self.list_updateHeroList = self.list_updateHeroList or {}
		local list_updateHeroListsize = #self.list_updateHeroList
		outputStream:WriteInt(list_updateHeroListsize)
		for list_updateHeroListi=1,list_updateHeroListsize do
            self.list_updateHeroList[list_updateHeroListi]:encode(outputStream)
		end
end

function HeroAction_changeHeroPosRes:decode(inputStream)
	    local body = {}
		local updateHeroListTemp = {}
		local updateHeroListsize = inputStream:ReadInt()
		for updateHeroListi=1,updateHeroListsize do
            local entry = UserHeroBO:New()
            table.insert(updateHeroListTemp,entry:decode(inputStream))

		end
		body.updateHeroList = updateHeroListTemp

	   return body
end