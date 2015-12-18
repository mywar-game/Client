

ForcesAction_endAttackReq = {}

--攻击关卡结束
function ForcesAction_endAttackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_endAttackReq:init()
	
	self.int_flag=0 ---1输,0平局,1赢,如果为采集关卡直接传1即可

	self.actName = "ForcesAction_endAttack"
end

function ForcesAction_endAttackReq:getActName()
	return self.actName
end

---1输,0平局,1赢,如果为采集关卡直接传1即可
function ForcesAction_endAttackReq:setInt_flag(int_flag)
	self.int_flag = int_flag
end





function ForcesAction_endAttackReq:encode(outputStream)
		outputStream:WriteInt(self.int_flag)


end

function ForcesAction_endAttackReq:decode(inputStream)
	    local body = {}
		body.flag = inputStream:ReadInt()


	   return body
end