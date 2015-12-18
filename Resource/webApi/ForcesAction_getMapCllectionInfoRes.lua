

ForcesAction_getMapCllectionInfoRes = {}

--获取地图采集点信息
function ForcesAction_getMapCllectionInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapCllectionInfoRes:init()
	
	self.list_userCoolectList={} --用户采集信息列表

	self.actName = "ForcesAction_getMapCllectionInfo"
end

function ForcesAction_getMapCllectionInfoRes:getActName()
	return self.actName
end

--用户采集信息列表
function ForcesAction_getMapCllectionInfoRes:setList_userCoolectList(list_userCoolectList)
	self.list_userCoolectList = list_userCoolectList
end





function ForcesAction_getMapCllectionInfoRes:encode(outputStream)
		
		self.list_userCoolectList = self.list_userCoolectList or {}
		local list_userCoolectListsize = #self.list_userCoolectList
		outputStream:WriteInt(list_userCoolectListsize)
		for list_userCoolectListi=1,list_userCoolectListsize do
            self.list_userCoolectList[list_userCoolectListi]:encode(outputStream)
		end
end

function ForcesAction_getMapCllectionInfoRes:decode(inputStream)
	    local body = {}
		local userCoolectListTemp = {}
		local userCoolectListsize = inputStream:ReadInt()
		for userCoolectListi=1,userCoolectListsize do
            local entry = UserForcesBO:New()
            table.insert(userCoolectListTemp,entry:decode(inputStream))

		end
		body.userCoolectList = userCoolectListTemp

	   return body
end