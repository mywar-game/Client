

LifeAction_hangupReq = {}

--开始挂机
function LifeAction_hangupReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_hangupReq:init()
	
	self.int_category=0 --类别（1矿场2花圃3渔场）

	self.list_userHeroIdList={} --用户英雄id列表

	self.string_userFriendId="" --好友用户id

	self.actName = "LifeAction_hangup"
end

function LifeAction_hangupReq:getActName()
	return self.actName
end

--类别（1矿场2花圃3渔场）
function LifeAction_hangupReq:setInt_category(int_category)
	self.int_category = int_category
end
--用户英雄id列表
function LifeAction_hangupReq:setList_userHeroIdList(list_userHeroIdList)
	self.list_userHeroIdList = list_userHeroIdList
end
--好友用户id
function LifeAction_hangupReq:setString_userFriendId(string_userFriendId)
	self.string_userFriendId = string_userFriendId
end





function LifeAction_hangupReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)

		
		self.list_userHeroIdList = self.list_userHeroIdList or {}
		local list_userHeroIdListsize = #self.list_userHeroIdList
		outputStream:WriteInt(list_userHeroIdListsize)
		for list_userHeroIdListi=1,list_userHeroIdListsize do
            outputStream:WriteUTFString(self.list_userHeroIdList[list_userHeroIdListi])
		end		outputStream:WriteUTFString(self.string_userFriendId)


end

function LifeAction_hangupReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()

		local userHeroIdListTemp = {}
		local userHeroIdListsize = inputStream:ReadInt()
		for userHeroIdListi=1,userHeroIdListsize do
            table.insert(userHeroIdListTemp,inputStream:ReadUTFString())
		end
		body.userHeroIdList = userHeroIdListTemp
		body.userFriendId = inputStream:ReadUTFString()


	   return body
end