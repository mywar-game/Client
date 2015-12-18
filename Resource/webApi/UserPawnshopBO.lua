

UserPawnshopBO = {}

--当铺商品信息对象
function UserPawnshopBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserPawnshopBO:init()
	
	self.int_mallId=0 --商品id

	self.int_num=0 --商品数量

	self.int_floatValue=0 --浮动值

	self.actName = "UserPawnshopBO"
end

function UserPawnshopBO:getActName()
	return self.actName
end

--商品id
function UserPawnshopBO:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end
--商品数量
function UserPawnshopBO:setInt_num(int_num)
	self.int_num = int_num
end
--浮动值
function UserPawnshopBO:setInt_floatValue(int_floatValue)
	self.int_floatValue = int_floatValue
end





function UserPawnshopBO:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)

		outputStream:WriteInt(self.int_num)

		outputStream:WriteInt(self.int_floatValue)


end

function UserPawnshopBO:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()

		body.num = inputStream:ReadInt()

		body.floatValue = inputStream:ReadInt()


	   return body
end