

PkAction_enterPkRes = {}

--首次进入竞技场
function PkAction_enterPkRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_enterPkRes:init()
	
	self.UserPkInfoBO_userPkInfoBO=nil --用户竞技场信息

	self.list_userDefenceHeroList={} --用户防守阵容列表

	self.list_userPkList={} --用户可挑战列表

	self.actName = "PkAction_enterPk"
end

function PkAction_enterPkRes:getActName()
	return self.actName
end

--用户竞技场信息
function PkAction_enterPkRes:setUserPkInfoBO_userPkInfoBO(UserPkInfoBO_userPkInfoBO)
	self.UserPkInfoBO_userPkInfoBO = UserPkInfoBO_userPkInfoBO
end
--用户防守阵容列表
function PkAction_enterPkRes:setList_userDefenceHeroList(list_userDefenceHeroList)
	self.list_userDefenceHeroList = list_userDefenceHeroList
end
--用户可挑战列表
function PkAction_enterPkRes:setList_userPkList(list_userPkList)
	self.list_userPkList = list_userPkList
end





function PkAction_enterPkRes:encode(outputStream)
		self.UserPkInfoBO_userPkInfoBO:encode(outputStream)

		
		self.list_userDefenceHeroList = self.list_userDefenceHeroList or {}
		local list_userDefenceHeroListsize = #self.list_userDefenceHeroList
		outputStream:WriteInt(list_userDefenceHeroListsize)
		for list_userDefenceHeroListi=1,list_userDefenceHeroListsize do
            outputStream:WriteUTFString(self.list_userDefenceHeroList[list_userDefenceHeroListi])
		end		
		self.list_userPkList = self.list_userPkList or {}
		local list_userPkListsize = #self.list_userPkList
		outputStream:WriteInt(list_userPkListsize)
		for list_userPkListi=1,list_userPkListsize do
            self.list_userPkList[list_userPkListi]:encode(outputStream)
		end
end

function PkAction_enterPkRes:decode(inputStream)
	    local body = {}
        local userPkInfoBOTemp = UserPkInfoBO:New()
        body.userPkInfoBO=userPkInfoBOTemp:decode(inputStream)
		local userDefenceHeroListTemp = {}
		local userDefenceHeroListsize = inputStream:ReadInt()
		for userDefenceHeroListi=1,userDefenceHeroListsize do
            table.insert(userDefenceHeroListTemp,inputStream:ReadUTFString())
		end
		body.userDefenceHeroList = userDefenceHeroListTemp
		local userPkListTemp = {}
		local userPkListsize = inputStream:ReadInt()
		for userPkListi=1,userPkListsize do
            local entry = PkChallengerBO:New()
            table.insert(userPkListTemp,entry:decode(inputStream))

		end
		body.userPkList = userPkListTemp

	   return body
end