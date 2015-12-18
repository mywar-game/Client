

Boss_enterNotify = {}

--用户进入Boss战广播
function Boss_enterNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_enterNotify:init()
	
	self.string_userId="" --进入场景的用户唯一编号

	self.UserHeroBO_userHeroBO=nil --用户英雄

	self.list_equipList={} --用户装备列表

	self.int_posX=0 --进入场景所在x坐标

	self.int_posY=0 --进入场景所在y坐标

	self.string_userName="" --玩家名称

	self.actName = "Boss_enter"
end

function Boss_enterNotify:getActName()
	return self.actName
end

--进入场景的用户唯一编号
function Boss_enterNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户英雄
function Boss_enterNotify:setUserHeroBO_userHeroBO(UserHeroBO_userHeroBO)
	self.UserHeroBO_userHeroBO = UserHeroBO_userHeroBO
end
--用户装备列表
function Boss_enterNotify:setList_equipList(list_equipList)
	self.list_equipList = list_equipList
end
--进入场景所在x坐标
function Boss_enterNotify:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--进入场景所在y坐标
function Boss_enterNotify:setInt_posY(int_posY)
	self.int_posY = int_posY
end
--玩家名称
function Boss_enterNotify:setString_userName(string_userName)
	self.string_userName = string_userName
end





function Boss_enterNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		self.UserHeroBO_userHeroBO:encode(outputStream)

		
		self.list_equipList = self.list_equipList or {}
		local list_equipListsize = #self.list_equipList
		outputStream:WriteInt(list_equipListsize)
		for list_equipListi=1,list_equipListsize do
            self.list_equipList[list_equipListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)

		outputStream:WriteUTFString(self.string_userName)


end

function Boss_enterNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

        local userHeroBOTemp = UserHeroBO:New()
        body.userHeroBO=userHeroBOTemp:decode(inputStream)
		local equipListTemp = {}
		local equipListsize = inputStream:ReadInt()
		for equipListi=1,equipListsize do
            local entry = UserEquipBO:New()
            table.insert(equipListTemp,entry:decode(inputStream))

		end
		body.equipList = equipListTemp
		body.posX = inputStream:ReadInt()

		body.posY = inputStream:ReadInt()

		body.userName = inputStream:ReadUTFString()


	   return body
end