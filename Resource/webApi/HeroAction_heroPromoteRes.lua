

HeroAction_heroPromoteRes = {}

--英雄进阶
function HeroAction_heroPromoteRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_heroPromoteRes:init()
	
	self.UserHeroBO_userHeroBO=nil --用户英雄对象

	self.list_userEquipIdList={} --消耗的用户装备id列表

	self.list_userGemstoneIdList={} --消耗的用户宝石id列表

	self.list_toolList={} --消耗的道具列表

	self.actName = "HeroAction_heroPromote"
end

function HeroAction_heroPromoteRes:getActName()
	return self.actName
end

--用户英雄对象
function HeroAction_heroPromoteRes:setUserHeroBO_userHeroBO(UserHeroBO_userHeroBO)
	self.UserHeroBO_userHeroBO = UserHeroBO_userHeroBO
end
--消耗的用户装备id列表
function HeroAction_heroPromoteRes:setList_userEquipIdList(list_userEquipIdList)
	self.list_userEquipIdList = list_userEquipIdList
end
--消耗的用户宝石id列表
function HeroAction_heroPromoteRes:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end
--消耗的道具列表
function HeroAction_heroPromoteRes:setList_toolList(list_toolList)
	self.list_toolList = list_toolList
end





function HeroAction_heroPromoteRes:encode(outputStream)
		self.UserHeroBO_userHeroBO:encode(outputStream)

		
		self.list_userEquipIdList = self.list_userEquipIdList or {}
		local list_userEquipIdListsize = #self.list_userEquipIdList
		outputStream:WriteInt(list_userEquipIdListsize)
		for list_userEquipIdListi=1,list_userEquipIdListsize do
            outputStream:WriteUTFString(self.list_userEquipIdList[list_userEquipIdListi])
		end		
		self.list_userGemstoneIdList = self.list_userGemstoneIdList or {}
		local list_userGemstoneIdListsize = #self.list_userGemstoneIdList
		outputStream:WriteInt(list_userGemstoneIdListsize)
		for list_userGemstoneIdListi=1,list_userGemstoneIdListsize do
            outputStream:WriteUTFString(self.list_userGemstoneIdList[list_userGemstoneIdListi])
		end		
		self.list_toolList = self.list_toolList or {}
		local list_toolListsize = #self.list_toolList
		outputStream:WriteInt(list_toolListsize)
		for list_toolListi=1,list_toolListsize do
            self.list_toolList[list_toolListi]:encode(outputStream)
		end
end

function HeroAction_heroPromoteRes:decode(inputStream)
	    local body = {}
        local userHeroBOTemp = UserHeroBO:New()
        body.userHeroBO=userHeroBOTemp:decode(inputStream)
		local userEquipIdListTemp = {}
		local userEquipIdListsize = inputStream:ReadInt()
		for userEquipIdListi=1,userEquipIdListsize do
            table.insert(userEquipIdListTemp,inputStream:ReadUTFString())
		end
		body.userEquipIdList = userEquipIdListTemp
		local userGemstoneIdListTemp = {}
		local userGemstoneIdListsize = inputStream:ReadInt()
		for userGemstoneIdListi=1,userGemstoneIdListsize do
            table.insert(userGemstoneIdListTemp,inputStream:ReadUTFString())
		end
		body.userGemstoneIdList = userGemstoneIdListTemp
		local toolListTemp = {}
		local toolListsize = inputStream:ReadInt()
		for toolListi=1,toolListsize do
            local entry = GoodsBeanBO:New()
            table.insert(toolListTemp,entry:decode(inputStream))

		end
		body.toolList = toolListTemp

	   return body
end