

UserMailBO = {}

--用户邮件对象
function UserMailBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserMailBO:init()
	
	self.int_userMailId=0 --用户邮件id

	self.int_mailType=0 --邮件类型（-1用户间邮件）

	self.int_showType=0 --显示类型

	self.int_status=0 --邮件状态（0新邮件1已读2已删除）

	self.int_receiveStatus=0 --领取状态（0未领取1已领取）

	self.string_content="" --内容

	self.string_title="" --标题

	self.string_sign="" --署名

	self.string_fromUserId="" --来自谁的邮件，只有用户邮件才有

	self.long_createdTime=0 --创建时间

	self.int_expiredTime=0 --过期时间

	self.list_goodsBeanBOList={} --附件物品

	self.actName = "UserMailBO"
end

function UserMailBO:getActName()
	return self.actName
end

--用户邮件id
function UserMailBO:setInt_userMailId(int_userMailId)
	self.int_userMailId = int_userMailId
end
--邮件类型（-1用户间邮件）
function UserMailBO:setInt_mailType(int_mailType)
	self.int_mailType = int_mailType
end
--显示类型
function UserMailBO:setInt_showType(int_showType)
	self.int_showType = int_showType
end
--邮件状态（0新邮件1已读2已删除）
function UserMailBO:setInt_status(int_status)
	self.int_status = int_status
end
--领取状态（0未领取1已领取）
function UserMailBO:setInt_receiveStatus(int_receiveStatus)
	self.int_receiveStatus = int_receiveStatus
end
--内容
function UserMailBO:setString_content(string_content)
	self.string_content = string_content
end
--标题
function UserMailBO:setString_title(string_title)
	self.string_title = string_title
end
--署名
function UserMailBO:setString_sign(string_sign)
	self.string_sign = string_sign
end
--来自谁的邮件，只有用户邮件才有
function UserMailBO:setString_fromUserId(string_fromUserId)
	self.string_fromUserId = string_fromUserId
end
--创建时间
function UserMailBO:setLong_createdTime(long_createdTime)
	self.long_createdTime = long_createdTime
end
--过期时间
function UserMailBO:setInt_expiredTime(int_expiredTime)
	self.int_expiredTime = int_expiredTime
end
--附件物品
function UserMailBO:setList_goodsBeanBOList(list_goodsBeanBOList)
	self.list_goodsBeanBOList = list_goodsBeanBOList
end





function UserMailBO:encode(outputStream)
		outputStream:WriteInt(self.int_userMailId)

		outputStream:WriteInt(self.int_mailType)

		outputStream:WriteInt(self.int_showType)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_receiveStatus)

		outputStream:WriteUTFString(self.string_content)

		outputStream:WriteUTFString(self.string_title)

		outputStream:WriteUTFString(self.string_sign)

		outputStream:WriteUTFString(self.string_fromUserId)

		outputStream:WriteLong(self.long_createdTime)

		outputStream:WriteInt(self.int_expiredTime)

		
		self.list_goodsBeanBOList = self.list_goodsBeanBOList or {}
		local list_goodsBeanBOListsize = #self.list_goodsBeanBOList
		outputStream:WriteInt(list_goodsBeanBOListsize)
		for list_goodsBeanBOListi=1,list_goodsBeanBOListsize do
            self.list_goodsBeanBOList[list_goodsBeanBOListi]:encode(outputStream)
		end
end

function UserMailBO:decode(inputStream)
	    local body = {}
		body.userMailId = inputStream:ReadInt()

		body.mailType = inputStream:ReadInt()

		body.showType = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.receiveStatus = inputStream:ReadInt()

		body.content = inputStream:ReadUTFString()

		body.title = inputStream:ReadUTFString()

		body.sign = inputStream:ReadUTFString()

		body.fromUserId = inputStream:ReadUTFString()

		body.createdTime = inputStream:ReadLong()

		body.expiredTime = inputStream:ReadInt()

		local goodsBeanBOListTemp = {}
		local goodsBeanBOListsize = inputStream:ReadInt()
		for goodsBeanBOListi=1,goodsBeanBOListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsBeanBOListTemp,entry:decode(inputStream))

		end
		body.goodsBeanBOList = goodsBeanBOListTemp

	   return body
end