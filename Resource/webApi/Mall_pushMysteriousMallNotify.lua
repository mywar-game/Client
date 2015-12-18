

Mall_pushMysteriousMallNotify = {}

--推送神秘商店信息
function Mall_pushMysteriousMallNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Mall_pushMysteriousMallNotify:init()
	
	self.int_mapId=0 --神秘商店出现的地图

	self.actName = "Mall_pushMysteriousMall"
end

function Mall_pushMysteriousMallNotify:getActName()
	return self.actName
end

--神秘商店出现的地图
function Mall_pushMysteriousMallNotify:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function Mall_pushMysteriousMallNotify:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)


end

function Mall_pushMysteriousMallNotify:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()


	   return body
end