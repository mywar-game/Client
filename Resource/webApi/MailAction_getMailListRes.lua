

MailAction_getMailListRes = {}

--获取邮件列表
function MailAction_getMailListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_getMailListRes:init()
	
	self.list_userMailList={} --用户邮件列表

	self.actName = "MailAction_getMailList"
end

function MailAction_getMailListRes:getActName()
	return self.actName
end

--用户邮件列表
function MailAction_getMailListRes:setList_userMailList(list_userMailList)
	self.list_userMailList = list_userMailList
end





function MailAction_getMailListRes:encode(outputStream)
		
		self.list_userMailList = self.list_userMailList or {}
		local list_userMailListsize = #self.list_userMailList
		outputStream:WriteInt(list_userMailListsize)
		for list_userMailListi=1,list_userMailListsize do
            self.list_userMailList[list_userMailListi]:encode(outputStream)
		end
end

function MailAction_getMailListRes:decode(inputStream)
	    local body = {}
		local userMailListTemp = {}
		local userMailListsize = inputStream:ReadInt()
		for userMailListi=1,userMailListsize do
            local entry = UserMailBO:New()
            table.insert(userMailListTemp,entry:decode(inputStream))

		end
		body.userMailList = userMailListTemp

	   return body
end