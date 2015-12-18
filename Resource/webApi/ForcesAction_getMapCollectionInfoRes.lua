

ForcesAction_getMapCollectionInfoRes = {}

--获取地图采集点信息
function ForcesAction_getMapCollectionInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapCollectionInfoRes:init()
	
	self.list_userCollectList={} --用户采集信息列表

	self.actName = "ForcesAction_getMapCollectionInfo"
end

function ForcesAction_getMapCollectionInfoRes:getActName()
	return self.actName
end

--用户采集信息列表
function ForcesAction_getMapCollectionInfoRes:setList_userCollectList(list_userCollectList)
	self.list_userCollectList = list_userCollectList
end





function ForcesAction_getMapCollectionInfoRes:encode(outputStream)
		
		self.list_userCollectList = self.list_userCollectList or {}
		local list_userCollectListsize = #self.list_userCollectList
		outputStream:WriteInt(list_userCollectListsize)
		for list_userCollectListi=1,list_userCollectListsize do
            self.list_userCollectList[list_userCollectListi]:encode(outputStream)
		end
end

function ForcesAction_getMapCollectionInfoRes:decode(inputStream)
	    local body = {}
		local userCollectListTemp = {}
		local userCollectListsize = inputStream:ReadInt()
		for userCollectListi=1,userCollectListsize do
            local entry = UserForcesBO:New()
            table.insert(userCollectListTemp,entry:decode(inputStream))

		end
		body.userCollectList = userCollectListTemp

	   return body
end