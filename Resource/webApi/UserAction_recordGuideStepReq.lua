

UserAction_recordGuideStepReq = {}

--记录玩家新手引导
function UserAction_recordGuideStepReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordGuideStepReq:init()
	
	self.int_guideStep=0 --引导步奏id

	self.actName = "UserAction_recordGuideStep"
end

function UserAction_recordGuideStepReq:getActName()
	return self.actName
end

--引导步奏id
function UserAction_recordGuideStepReq:setInt_guideStep(int_guideStep)
	self.int_guideStep = int_guideStep
end





function UserAction_recordGuideStepReq:encode(outputStream)
		outputStream:WriteInt(self.int_guideStep)


end

function UserAction_recordGuideStepReq:decode(inputStream)
	    local body = {}
		body.guideStep = inputStream:ReadInt()


	   return body
end