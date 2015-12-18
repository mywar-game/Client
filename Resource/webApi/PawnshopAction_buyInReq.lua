

PawnshopAction_buyInReq = {}

--买入
function PawnshopAction_buyInReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PawnshopAction_buyInReq:init()
	
	self.int_mallId=0 --买入的商品id

	self.int_num=0 --买入数量

	self.int_camp=0 --阵营

	self.actName = "PawnshopAction_buyIn"
end

function PawnshopAction_buyInReq:getActName()
	return self.actName
end

--买入的商品id
function PawnshopAction_buyInReq:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end
--买入数量
function PawnshopAction_buyInReq:setInt_num(int_num)
	self.int_num = int_num
end
--阵营
function PawnshopAction_buyInReq:setInt_camp(int_camp)
	self.int_camp = int_camp
end





function PawnshopAction_buyInReq:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)

		outputStream:WriteInt(self.int_num)

		outputStream:WriteInt(self.int_camp)


end

function PawnshopAction_buyInReq:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()

		body.num = inputStream:ReadInt()

		body.camp = inputStream:ReadInt()


	   return body
end