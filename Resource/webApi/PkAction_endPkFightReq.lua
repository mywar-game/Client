

PkAction_endPkFightReq = {}

--结束竞技场战斗
function PkAction_endPkFightReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_endPkFightReq:init()
	
	self.int_flag=0 --胜负（0负1胜）

	self.actName = "PkAction_endPkFight"
end

function PkAction_endPkFightReq:getActName()
	return self.actName
end

--胜负（0负1胜）
function PkAction_endPkFightReq:setInt_flag(int_flag)
	self.int_flag = int_flag
end





function PkAction_endPkFightReq:encode(outputStream)
		outputStream:WriteInt(self.int_flag)


end

function PkAction_endPkFightReq:decode(inputStream)
	    local body = {}
		body.flag = inputStream:ReadInt()


	   return body
end