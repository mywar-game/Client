

PkAction_changePosReq = {}

--上阵、下阵防守阵营
function PkAction_changePosReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_changePosReq:init()
	
	self.list_userHeroIdList={} --用户英雄id列表

	self.actName = "PkAction_changePos"
end

function PkAction_changePosReq:getActName()
	return self.actName
end

--用户英雄id列表
function PkAction_changePosReq:setList_userHeroIdList(list_userHeroIdList)
	self.list_userHeroIdList = list_userHeroIdList
end





function PkAction_changePosReq:encode(outputStream)
		
		self.list_userHeroIdList = self.list_userHeroIdList or {}
		local list_userHeroIdListsize = #self.list_userHeroIdList
		outputStream:WriteInt(list_userHeroIdListsize)
		for list_userHeroIdListi=1,list_userHeroIdListsize do
            outputStream:WriteUTFString(self.list_userHeroIdList[list_userHeroIdListi])
		end
end

function PkAction_changePosReq:decode(inputStream)
	    local body = {}
		local userHeroIdListTemp = {}
		local userHeroIdListsize = inputStream:ReadInt()
		for userHeroIdListi=1,userHeroIdListsize do
            table.insert(userHeroIdListTemp,inputStream:ReadUTFString())
		end
		body.userHeroIdList = userHeroIdListTemp

	   return body
end