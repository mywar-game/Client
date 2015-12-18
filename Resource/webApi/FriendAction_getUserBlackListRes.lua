

FriendAction_getUserBlackListRes = {}

--获取黑名单列表
function FriendAction_getUserBlackListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserBlackListRes:init()
	
	self.list_userBlackInfoBOList={} --黑名单列表

	self.actName = "FriendAction_getUserBlackList"
end

function FriendAction_getUserBlackListRes:getActName()
	return self.actName
end

--黑名单列表
function FriendAction_getUserBlackListRes:setList_userBlackInfoBOList(list_userBlackInfoBOList)
	self.list_userBlackInfoBOList = list_userBlackInfoBOList
end





function FriendAction_getUserBlackListRes:encode(outputStream)
		
		self.list_userBlackInfoBOList = self.list_userBlackInfoBOList or {}
		local list_userBlackInfoBOListsize = #self.list_userBlackInfoBOList
		outputStream:WriteInt(list_userBlackInfoBOListsize)
		for list_userBlackInfoBOListi=1,list_userBlackInfoBOListsize do
            self.list_userBlackInfoBOList[list_userBlackInfoBOListi]:encode(outputStream)
		end
end

function FriendAction_getUserBlackListRes:decode(inputStream)
	    local body = {}
		local userBlackInfoBOListTemp = {}
		local userBlackInfoBOListsize = inputStream:ReadInt()
		for userBlackInfoBOListi=1,userBlackInfoBOListsize do
            local entry = UserFriendInfoBO:New()
            table.insert(userBlackInfoBOListTemp,entry:decode(inputStream))

		end
		body.userBlackInfoBOList = userBlackInfoBOListTemp

	   return body
end