

PrestigeAction_getInviteHeroInfoRes = {}

--获取用户酒馆招募英雄的信息
function PrestigeAction_getInviteHeroInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_getInviteHeroInfoRes:init()
	
	self.list_inviteHeroList={} --英雄列表

	self.actName = "PrestigeAction_getInviteHeroInfo"
end

function PrestigeAction_getInviteHeroInfoRes:getActName()
	return self.actName
end

--英雄列表
function PrestigeAction_getInviteHeroInfoRes:setList_inviteHeroList(list_inviteHeroList)
	self.list_inviteHeroList = list_inviteHeroList
end





function PrestigeAction_getInviteHeroInfoRes:encode(outputStream)
		
		self.list_inviteHeroList = self.list_inviteHeroList or {}
		local list_inviteHeroListsize = #self.list_inviteHeroList
		outputStream:WriteInt(list_inviteHeroListsize)
		for list_inviteHeroListi=1,list_inviteHeroListsize do
            self.list_inviteHeroList[list_inviteHeroListi]:encode(outputStream)
		end
end

function PrestigeAction_getInviteHeroInfoRes:decode(inputStream)
	    local body = {}
		local inviteHeroListTemp = {}
		local inviteHeroListsize = inputStream:ReadInt()
		for inviteHeroListi=1,inviteHeroListsize do
            local entry = InviteHeroBO:New()
            table.insert(inviteHeroListTemp,entry:decode(inputStream))

		end
		body.inviteHeroList = inviteHeroListTemp

	   return body
end