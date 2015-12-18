

FriendAction_getUserFriendRankListRes = {}

--获取好友排行榜
function FriendAction_getUserFriendRankListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserFriendRankListRes:init()
	
	self.list_userFriendInfoBOList={} --好友排行榜列表

	self.actName = "FriendAction_getUserFriendRankList"
end

function FriendAction_getUserFriendRankListRes:getActName()
	return self.actName
end

--好友排行榜列表
function FriendAction_getUserFriendRankListRes:setList_userFriendInfoBOList(list_userFriendInfoBOList)
	self.list_userFriendInfoBOList = list_userFriendInfoBOList
end





function FriendAction_getUserFriendRankListRes:encode(outputStream)
		
		self.list_userFriendInfoBOList = self.list_userFriendInfoBOList or {}
		local list_userFriendInfoBOListsize = #self.list_userFriendInfoBOList
		outputStream:WriteInt(list_userFriendInfoBOListsize)
		for list_userFriendInfoBOListi=1,list_userFriendInfoBOListsize do
            self.list_userFriendInfoBOList[list_userFriendInfoBOListi]:encode(outputStream)
		end
end

function FriendAction_getUserFriendRankListRes:decode(inputStream)
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