

ForcesAction_openBattleBoxReq = {}

--战斗后的翻牌
function ForcesAction_openBattleBoxReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_openBattleBoxReq:init()
	
	self.int_status=0 --状态1不开启2开启宝箱

	self.actName = "ForcesAction_openBattleBox"
end

function ForcesAction_openBattleBoxReq:getActName()
	return self.actName
end

--状态1不开启2开启宝箱
function ForcesAction_openBattleBoxReq:setInt_status(int_status)
	self.int_status = int_status
end





function ForcesAction_openBattleBoxReq:encode(outputStream)
		outputStream:WriteInt(self.int_status)


end

function ForcesAction_openBattleBoxReq:decode(inputStream)
	    local body = {}
		body.status = inputStream:ReadInt()


	   return body
end