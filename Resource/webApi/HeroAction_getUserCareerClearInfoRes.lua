

HeroAction_getUserCareerClearInfoRes = {}

--获取用户职业解锁信息
function HeroAction_getUserCareerClearInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_getUserCareerClearInfoRes:init()
	
	self.list_userCareerInfoList={} --用户职业信息列表

	self.actName = "HeroAction_getUserCareerClearInfo"
end

function HeroAction_getUserCareerClearInfoRes:getActName()
	return self.actName
end

--用户职业信息列表
function HeroAction_getUserCareerClearInfoRes:setList_userCareerInfoList(list_userCareerInfoList)
	self.list_userCareerInfoList = list_userCareerInfoList
end





function HeroAction_getUserCareerClearInfoRes:encode(outputStream)
		
		self.list_userCareerInfoList = self.list_userCareerInfoList or {}
		local list_userCareerInfoListsize = #self.list_userCareerInfoList
		outputStream:WriteInt(list_userCareerInfoListsize)
		for list_userCareerInfoListi=1,list_userCareerInfoListsize do
            self.list_userCareerInfoList[list_userCareerInfoListi]:encode(outputStream)
		end
end

function HeroAction_getUserCareerClearInfoRes:decode(inputStream)
	    local body = {}
		local userCareerInfoListTemp = {}
		local userCareerInfoListsize = inputStream:ReadInt()
		for userCareerInfoListi=1,userCareerInfoListsize do
            local entry = UserCareerInfoBO:New()
            table.insert(userCareerInfoListTemp,entry:decode(inputStream))

		end
		body.userCareerInfoList = userCareerInfoListTemp

	   return body
end