

PawnshopAction_getPawnshopInfoRes = {}

--获取当铺信息
function PawnshopAction_getPawnshopInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PawnshopAction_getPawnshopInfoRes:init()
	
	self.list_userPawnshopList={} --当铺商品信息对象列表

	self.actName = "PawnshopAction_getPawnshopInfo"
end

function PawnshopAction_getPawnshopInfoRes:getActName()
	return self.actName
end

--当铺商品信息对象列表
function PawnshopAction_getPawnshopInfoRes:setList_userPawnshopList(list_userPawnshopList)
	self.list_userPawnshopList = list_userPawnshopList
end





function PawnshopAction_getPawnshopInfoRes:encode(outputStream)
		
		self.list_userPawnshopList = self.list_userPawnshopList or {}
		local list_userPawnshopListsize = #self.list_userPawnshopList
		outputStream:WriteInt(list_userPawnshopListsize)
		for list_userPawnshopListi=1,list_userPawnshopListsize do
            self.list_userPawnshopList[list_userPawnshopListi]:encode(outputStream)
		end
end

function PawnshopAction_getPawnshopInfoRes:decode(inputStream)
	    local body = {}
		local userPawnshopListTemp = {}
		local userPawnshopListsize = inputStream:ReadInt()
		for userPawnshopListi=1,userPawnshopListsize do
            local entry = UserPawnshopBO:New()
            table.insert(userPawnshopListTemp,entry:decode(inputStream))

		end
		body.userPawnshopList = userPawnshopListTemp

	   return body
end