

UserMysteriousMallBO = {}

--用户神秘商店商品对象
function UserMysteriousMallBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserMysteriousMallBO:init()
	
	self.int_mallId=0 --商品id

	self.int_buyStatus=0 --购买状态0可购买1不可购买

	self.actName = "UserMysteriousMallBO"
end

function UserMysteriousMallBO:getActName()
	return self.actName
end

--商品id
function UserMysteriousMallBO:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end
--购买状态0可购买1不可购买
function UserMysteriousMallBO:setInt_buyStatus(int_buyStatus)
	self.int_buyStatus = int_buyStatus
end





function UserMysteriousMallBO:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)

		outputStream:WriteInt(self.int_buyStatus)


end

function UserMysteriousMallBO:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()

		body.buyStatus = inputStream:ReadInt()


	   return body
end