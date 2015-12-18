

BossAction_startAttackBossRes = {}

--开始攻打世界boss
function BossAction_startAttackBossRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_startAttackBossRes:init()
	
	self.list_userDataList={} --用户数据

	self.int_isRoomOwner=0 --是否为房主0否1是

	self.actName = "BossAction_startAttackBoss"
end

function BossAction_startAttackBossRes:getActName()
	return self.actName
end

--用户数据
function BossAction_startAttackBossRes:setList_userDataList(list_userDataList)
	self.list_userDataList = list_userDataList
end
--是否为房主0否1是
function BossAction_startAttackBossRes:setInt_isRoomOwner(int_isRoomOwner)
	self.int_isRoomOwner = int_isRoomOwner
end





function BossAction_startAttackBossRes:encode(outputStream)
		
		self.list_userDataList = self.list_userDataList or {}
		local list_userDataListsize = #self.list_userDataList
		outputStream:WriteInt(list_userDataListsize)
		for list_userDataListi=1,list_userDataListsize do
            self.list_userDataList[list_userDataListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_isRoomOwner)


end

function BossAction_startAttackBossRes:decode(inputStream)
	    local body = {}
		local userDataListTemp = {}
		local userDataListsize = inputStream:ReadInt()
		for userDataListi=1,userDataListsize do
            local entry = UserBossDataBO:New()
            table.insert(userDataListTemp,entry:decode(inputStream))

		end
		body.userDataList = userDataListTemp
		body.isRoomOwner = inputStream:ReadInt()


	   return body
end