

PkAction_getUserPkMallInfoRes = {}

--获取用户兑换奖励信息
function PkAction_getUserPkMallInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getUserPkMallInfoRes:init()
	
	self.list_pkMallList={} --荣誉兑换商城列表

	self.actName = "PkAction_getUserPkMallInfo"
end

function PkAction_getUserPkMallInfoRes:getActName()
	return self.actName
end

--荣誉兑换商城列表
function PkAction_getUserPkMallInfoRes:setList_pkMallList(list_pkMallList)
	self.list_pkMallList = list_pkMallList
end





function PkAction_getUserPkMallInfoRes:encode(outputStream)
		
		self.list_pkMallList = self.list_pkMallList or {}
		local list_pkMallListsize = #self.list_pkMallList
		outputStream:WriteInt(list_pkMallListsize)
		for list_pkMallListi=1,list_pkMallListsize do
            self.list_pkMallList[list_pkMallListi]:encode(outputStream)
		end
end

function PkAction_getUserPkMallInfoRes:decode(inputStream)
	    local body = {}
		local pkMallListTemp = {}
		local pkMallListsize = inputStream:ReadInt()
		for pkMallListi=1,pkMallListsize do
            local entry = PkMallBO:New()
            table.insert(pkMallListTemp,entry:decode(inputStream))

		end
		body.pkMallList = pkMallListTemp

	   return body
end