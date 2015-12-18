

LegionAction_getApplyListRes = {}

--查看申请列表
function LegionAction_getApplyListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getApplyListRes:init()
	
	self.list_userApplyList={} --用户申请列表

	self.actName = "LegionAction_getApplyList"
end

function LegionAction_getApplyListRes:getActName()
	return self.actName
end

--用户申请列表
function LegionAction_getApplyListRes:setList_userApplyList(list_userApplyList)
	self.list_userApplyList = list_userApplyList
end





function LegionAction_getApplyListRes:encode(outputStream)
		
		self.list_userApplyList = self.list_userApplyList or {}
		local list_userApplyListsize = #self.list_userApplyList
		outputStream:WriteInt(list_userApplyListsize)
		for list_userApplyListi=1,list_userApplyListsize do
            self.list_userApplyList[list_userApplyListi]:encode(outputStream)
		end
end

function LegionAction_getApplyListRes:decode(inputStream)
	    local body = {}
		local userApplyListTemp = {}
		local userApplyListsize = inputStream:ReadInt()
		for userApplyListi=1,userApplyListsize do
            local entry = UserApplyLegionBO:New()
            table.insert(userApplyListTemp,entry:decode(inputStream))

		end
		body.userApplyList = userApplyListTemp

	   return body
end