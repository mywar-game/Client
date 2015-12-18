

MailAction_oneClickDeleteRes = {}

--一键删除邮件
function MailAction_oneClickDeleteRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_oneClickDeleteRes:init()
	
	self.list_userMailIdList={} --用户邮件id列表

	self.actName = "MailAction_oneClickDelete"
end

function MailAction_oneClickDeleteRes:getActName()
	return self.actName
end

--用户邮件id列表
function MailAction_oneClickDeleteRes:setList_userMailIdList(list_userMailIdList)
	self.list_userMailIdList = list_userMailIdList
end





function MailAction_oneClickDeleteRes:encode(outputStream)
		
		self.list_userMailIdList = self.list_userMailIdList or {}
		local list_userMailIdListsize = #self.list_userMailIdList
		outputStream:WriteInt(list_userMailIdListsize)
		for list_userMailIdListi=1,list_userMailIdListsize do
            outputStream:WriteInt(self.list_userMailIdList[list_userMailIdListi])
		end
end

function MailAction_oneClickDeleteRes:decode(inputStream)
	    local body = {}
		local userMailIdListTemp = {}
		local userMailIdListsize = inputStream:ReadInt()
		for userMailIdListi=1,userMailIdListsize do
            table.insert(userMailIdListTemp,inputStream:ReadInt())
		end
		body.userMailIdList = userMailIdListTemp

	   return body
end