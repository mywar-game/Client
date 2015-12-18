

MallAction_getMysteriousMallInfoRes = {}

--获取神秘商店的信息
function MallAction_getMysteriousMallInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_getMysteriousMallInfoRes:init()
	
	self.list_userMallList={} --用户商品信息列表

	self.actName = "MallAction_getMysteriousMallInfo"
end

function MallAction_getMysteriousMallInfoRes:getActName()
	return self.actName
end

--用户商品信息列表
function MallAction_getMysteriousMallInfoRes:setList_userMallList(list_userMallList)
	self.list_userMallList = list_userMallList
end





function MallAction_getMysteriousMallInfoRes:encode(outputStream)
		
		self.list_userMallList = self.list_userMallList or {}
		local list_userMallListsize = #self.list_userMallList
		outputStream:WriteInt(list_userMallListsize)
		for list_userMallListi=1,list_userMallListsize do
            self.list_userMallList[list_userMallListi]:encode(outputStream)
		end
end

function MallAction_getMysteriousMallInfoRes:decode(inputStream)
	    local body = {}
		local userMallListTemp = {}
		local userMallListsize = inputStream:ReadInt()
		for userMallListi=1,userMallListsize do
            local entry = UserMysteriousMallBO:New()
            table.insert(userMallListTemp,entry:decode(inputStream))

		end
		body.userMallList = userMallListTemp

	   return body
end