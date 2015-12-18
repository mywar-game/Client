

MallAction_getBuyBackListRes = {}

--获取用户回购列表
function MallAction_getBuyBackListRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getBuyBackListRes:init()
	
	self.list_userBuyBackInfoList={} --用户回购信息列表

	self.actName = "MallAction_getBuyBackList"
end

function MallAction_getBuyBackListRes:getActName()
	return self.actName
end

--用户回购信息列表
function MallAction_getBuyBackListRes:setList_userBuyBackInfoList(list_userBuyBackInfoList)
	self.list_userBuyBackInfoList = list_userBuyBackInfoList
end





function MallAction_getBuyBackListRes:encode(outputStream)
		
		self.list_userBuyBackInfoList = self.list_userBuyBackInfoList or {}
		local list_userBuyBackInfoListsize = #self.list_userBuyBackInfoList
		outputStream:WriteInt(list_userBuyBackInfoListsize)
		for list_userBuyBackInfoListi=1,list_userBuyBackInfoListsize do
            self.list_userBuyBackInfoList[list_userBuyBackInfoListi]:encode(outputStream)
		end
end

function MallAction_getBuyBackListRes:decode(inputStream)
	    local body = {}
		local userBuyBackInfoListTemp = {}
		local userBuyBackInfoListsize = inputStream:ReadInt()
		for userBuyBackInfoListi=1,userBuyBackInfoListsize do
            local entry = UserBuyBackInfoBO:New()
            table.insert(userBuyBackInfoListTemp,entry:decode(inputStream))

		end
		body.userBuyBackInfoList = userBuyBackInfoListTemp

	   return body
end