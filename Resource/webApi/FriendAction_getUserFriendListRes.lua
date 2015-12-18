

FriendAction_getUserFriendListRes = {}

--获取好友列表
function FriendAction_getUserFriendListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserFriendListRes:init()
	
	self.list_userFriendInfoBOList={} --用户好友信息对象列表

	self.actName = "FriendAction_getUserFriendList"
end

function FriendAction_getUserFriendListRes:getActName()
	return self.actName
end

--用户好友信息对象列表
function FriendAction_getUserFriendListRes:setList_userFriendInfoBOList(list_userFriendInfoBOList)
	self.list_userFriendInfoBOList = list_userFriendInfoBOList
end





function FriendAction_getUserFriendListRes:encode(outputStream)
		
		self.list_userFriendInfoBOList = self.list_userFriendInfoBOList or {}
		local list_userFriendInfoBOListsize = #self.list_userFriendInfoBOList
		outputStream:WriteInt(list_userFriendInfoBOListsize)
		for list_userFriendInfoBOListi=1,list_userFriendInfoBOListsize do
            self.list_userFriendInfoBOList[list_userFriendInfoBOListi]:encode(outputStream)
		end
end

function FriendAction_getUserFriendListRes:decode(inputStream)
	    local body = {}
		local userFriendInfoBOListTemp = {}
		local userFriendInfoBOListsize = inputStream:ReadInt()
		for userFriendInfoBOListi=1,userFriendInfoBOListsize do
            local entry = UserFriendInfoBO:New()
            table.insert(userFriendInfoBOListTemp,entry:decode(inputStream))

		end
		body.userFriendInfoBOList = userFriendInfoBOListTemp

	   return body
end