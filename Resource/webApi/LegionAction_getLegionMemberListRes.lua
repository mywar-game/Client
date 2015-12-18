

LegionAction_getLegionMemberListRes = {}

--查看公会成员列表
function LegionAction_getLegionMemberListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionMemberListRes:init()
	
	self.list_legionMemberList={} --公会成员列表

	self.actName = "LegionAction_getLegionMemberList"
end

function LegionAction_getLegionMemberListRes:getActName()
	return self.actName
end

--公会成员列表
function LegionAction_getLegionMemberListRes:setList_legionMemberList(list_legionMemberList)
	self.list_legionMemberList = list_legionMemberList
end





function LegionAction_getLegionMemberListRes:encode(outputStream)
		
		self.list_legionMemberList = self.list_legionMemberList or {}
		local list_legionMemberListsize = #self.list_legionMemberList
		outputStream:WriteInt(list_legionMemberListsize)
		for list_legionMemberListi=1,list_legionMemberListsize do
            self.list_legionMemberList[list_legionMemberListi]:encode(outputStream)
		end
end

function LegionAction_getLegionMemberListRes:decode(inputStream)
	    local body = {}
		local legionMemberListTemp = {}
		local legionMemberListsize = inputStream:ReadInt()
		for legionMemberListi=1,legionMemberListsize do
            local entry = LegionMemberBO:New()
            table.insert(legionMemberListTemp,entry:decode(inputStream))

		end
		body.legionMemberList = legionMemberListTemp

	   return body
end