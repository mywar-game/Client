

ExploreAction_exploreReq = {}

--探索
function ExploreAction_exploreReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_exploreReq:init()
	
	self.int_type=0 --探索（左右）

	self.actName = "ExploreAction_explore"
end

function ExploreAction_exploreReq:getActName()
	return self.actName
end

--探索（左右）
function ExploreAction_exploreReq:setInt_type(int_type)
	self.int_type = int_type
end





function ExploreAction_exploreReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)


end

function ExploreAction_exploreReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()


	   return body
end