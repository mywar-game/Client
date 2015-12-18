

PawnshopAction_getPawnshopInfoReq = {}

--获取当铺信息
function PawnshopAction_getPawnshopInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PawnshopAction_getPawnshopInfoReq:init()
	
	self.int_camp=0 --阵营

	self.actName = "PawnshopAction_getPawnshopInfo"
end

function PawnshopAction_getPawnshopInfoReq:getActName()
	return self.actName
end

--阵营
function PawnshopAction_getPawnshopInfoReq:setInt_camp(int_camp)
	self.int_camp = int_camp
end





function PawnshopAction_getPawnshopInfoReq:encode(outputStream)
		outputStream:WriteInt(self.int_camp)


end

function PawnshopAction_getPawnshopInfoReq:decode(inputStream)
	    local body = {}
		body.camp = inputStream:ReadInt()


	   return body
end