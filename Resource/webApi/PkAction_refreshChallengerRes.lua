

PkAction_refreshChallengerRes = {}

--换一批
function PkAction_refreshChallengerRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_refreshChallengerRes:init()
	
	self.list_userPkList={} --用户可挑战列表

	self.actName = "PkAction_refreshChallenger"
end

function PkAction_refreshChallengerRes:getActName()
	return self.actName
end

--用户可挑战列表
function PkAction_refreshChallengerRes:setList_userPkList(list_userPkList)
	self.list_userPkList = list_userPkList
end





function PkAction_refreshChallengerRes:encode(outputStream)
		
		self.list_userPkList = self.list_userPkList or {}
		local list_userPkListsize = #self.list_userPkList
		outputStream:WriteInt(list_userPkListsize)
		for list_userPkListi=1,list_userPkListsize do
            self.list_userPkList[list_userPkListi]:encode(outputStream)
		end
end

function PkAction_refreshChallengerRes:decode(inputStream)
	    local body = {}
		local userPkListTemp = {}
		local userPkListsize = inputStream:ReadInt()
		for userPkListi=1,userPkListsize do
            local entry = PkChallengerBO:New()
            table.insert(userPkListTemp,entry:decode(inputStream))

		end
		body.userPkList = userPkListTemp

	   return body
end