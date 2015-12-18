

LegionAction_getMessageListRes = {}

--获取留言信息列表
function LegionAction_getMessageListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getMessageListRes:init()
	
	self.list_userMessageInfoList={} --用户留言信息列表

	self.actName = "LegionAction_getMessageList"
end

function LegionAction_getMessageListRes:getActName()
	return self.actName
end

--用户留言信息列表
function LegionAction_getMessageListRes:setList_userMessageInfoList(list_userMessageInfoList)
	self.list_userMessageInfoList = list_userMessageInfoList
end





function LegionAction_getMessageListRes:encode(outputStream)
		
		self.list_userMessageInfoList = self.list_userMessageInfoList or {}
		local list_userMessageInfoListsize = #self.list_userMessageInfoList
		outputStream:WriteInt(list_userMessageInfoListsize)
		for list_userMessageInfoListi=1,list_userMessageInfoListsize do
            self.list_userMessageInfoList[list_userMessageInfoListi]:encode(outputStream)
		end
end

function LegionAction_getMessageListRes:decode(inputStream)
	    local body = {}
		local userMessageInfoListTemp = {}
		local userMessageInfoListsize = inputStream:ReadInt()
		for userMessageInfoListi=1,userMessageInfoListsize do
            local entry = UserMessageInfoBO:New()
            table.insert(userMessageInfoListTemp,entry:decode(inputStream))

		end
		body.userMessageInfoList = userMessageInfoListTemp

	   return body
end