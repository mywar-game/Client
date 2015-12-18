

FriendAction_getJoinBattleUserListRes = {}

--获取可参战用户
function FriendAction_getJoinBattleUserListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getJoinBattleUserListRes:init()
	
	self.list_battleUserList={} --用户聊天信息

	self.actName = "FriendAction_getJoinBattleUserList"
end

function FriendAction_getJoinBattleUserListRes:getActName()
	return self.actName
end

--用户聊天信息
function FriendAction_getJoinBattleUserListRes:setList_battleUserList(list_battleUserList)
	self.list_battleUserList = list_battleUserList
end





function FriendAction_getJoinBattleUserListRes:encode(outputStream)
		
		self.list_battleUserList = self.list_battleUserList or {}
		local list_battleUserListsize = #self.list_battleUserList
		outputStream:WriteInt(list_battleUserListsize)
		for list_battleUserListi=1,list_battleUserListsize do
            self.list_battleUserList[list_battleUserListi]:encode(outputStream)
		end
end

function FriendAction_getJoinBattleUserListRes:decode(inputStream)
	    local body = {}
		local battleUserListTemp = {}
		local battleUserListsize = inputStream:ReadInt()
		for battleUserListi=1,battleUserListsize do
            local entry = BattleUserInfoBO:New()
            table.insert(battleUserListTemp,entry:decode(inputStream))

		end
		body.battleUserList = battleUserListTemp

	   return body
end