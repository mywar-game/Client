

ColorBO = {}

--颜色对象
function ColorBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ColorBO:init()
	
	self.int_r=0 --红

	self.int_g=0 --绿

	self.int_b=0 --蓝

	self.actName = "ColorBO"
end

function ColorBO:getActName()
	return self.actName
end

--红
function ColorBO:setInt_r(int_r)
	self.int_r = int_r
end
--绿
function ColorBO:setInt_g(int_g)
	self.int_g = int_g
end
--蓝
function ColorBO:setInt_b(int_b)
	self.int_b = int_b
end





function ColorBO:encode(outputStream)
		outputStream:WriteInt(self.int_r)

		outputStream:WriteInt(self.int_g)

		outputStream:WriteInt(self.int_b)


end

function ColorBO:decode(inputStream)
	    local body = {}
		body.r = inputStream:ReadInt()

		body.g = inputStream:ReadInt()

		body.b = inputStream:ReadInt()


	   return body
end