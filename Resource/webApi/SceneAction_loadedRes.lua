

SceneAction_loadedRes = {}

--加载场景完成
function SceneAction_loadedRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_loadedRes:init()
	
	self.list_sceneUsersList={} --场景内的用户数据对象列表

	self.actName = "SceneAction_loaded"
end

function SceneAction_loadedRes:getActName()
	return self.actName
end

--场景内的用户数据对象列表
function SceneAction_loadedRes:setList_sceneUsersList(list_sceneUsersList)
	self.list_sceneUsersList = list_sceneUsersList
end





function SceneAction_loadedRes:encode(outputStream)
		
		self.list_sceneUsersList = self.list_sceneUsersList or {}
		local list_sceneUsersListsize = #self.list_sceneUsersList
		outputStream:WriteInt(list_sceneUsersListsize)
		for list_sceneUsersListi=1,list_sceneUsersListsize do
            self.list_sceneUsersList[list_sceneUsersListi]:encode(outputStream)
		end
end

function SceneAction_loadedRes:decode(inputStream)
	    local body = {}
		local sceneUsersListTemp = {}
		local sceneUsersListsize = inputStream:ReadInt()
		for sceneUsersListi=1,sceneUsersListsize do
            local entry = UserSceneDataBO:New()
            table.insert(sceneUsersListTemp,entry:decode(inputStream))

		end
		body.sceneUsersList = sceneUsersListTemp

	   return body
end