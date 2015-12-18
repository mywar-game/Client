

ForcesAction_getMapForcesRes = {}

--获取某个地图下所有用户关卡信息列表
function ForcesAction_getMapForcesRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getMapForcesRes:init()
	
	self.list_userForcesList={} --用户关卡对象，如果对应地图的关卡没有在此列表中找到数据，则说明用户还没有攻打过此关卡，客户端需要缓存该对象，并维护该对象的变化，不要重复去查询

	self.actName = "ForcesAction_getMapForces"
end

function ForcesAction_getMapForcesRes:getActName()
	return self.actName
end

--用户关卡对象，如果对应地图的关卡没有在此列表中找到数据，则说明用户还没有攻打过此关卡，客户端需要缓存该对象，并维护该对象的变化，不要重复去查询
function ForcesAction_getMapForcesRes:setList_userForcesList(list_userForcesList)
	self.list_userForcesList = list_userForcesList
end





function ForcesAction_getMapForcesRes:encode(outputStream)
		
		self.list_userForcesList = self.list_userForcesList or {}
		local list_userForcesListsize = #self.list_userForcesList
		outputStream:WriteInt(list_userForcesListsize)
		for list_userForcesListi=1,list_userForcesListsize do
            self.list_userForcesList[list_userForcesListi]:encode(outputStream)
		end
end

function ForcesAction_getMapForcesRes:decode(inputStream)
	    local body = {}
		local userForcesListTemp = {}
		local userForcesListsize = inputStream:ReadInt()
		for userForcesListi=1,userForcesListsize do
            local entry = UserForcesBO:New()
            table.insert(userForcesListTemp,entry:decode(inputStream))

		end
		body.userForcesList = userForcesListTemp

	   return body
end