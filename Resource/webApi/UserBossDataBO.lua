

UserBossDataBO = {}

--用户Boss战信息对象
function UserBossDataBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserBossDataBO:init()
	
	self.string_userId="" --用户唯一id

	self.string_userName="" --用户名

	self.UserHeroBO_userHeroBO=nil --用户英雄

	self.list_equipList={} --用户装备列表

	self.int_posX=0 --进入场景所在x坐标

	self.int_posY=0 --进入场景所在y坐标

	self.actName = "UserBossDataBO"
end

function UserBossDataBO:getActName()
	return self.actName
end

--用户唯一id
function UserBossDataBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户名
function UserBossDataBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--用户英雄
function UserBossDataBO:setUserHeroBO_userHeroBO(UserHeroBO_userHeroBO)
	self.UserHeroBO_userHeroBO = UserHeroBO_userHeroBO
end
--用户装备列表
function UserBossDataBO:setList_equipList(list_equipList)
	self.list_equipList = list_equipList
end
--进入场景所在x坐标
function UserBossDataBO:setInt_posX(int_posX)
	self.int_posX = int_posX
end
--进入场景所在y坐标
function UserBossDataBO:setInt_posY(int_posY)
	self.int_posY = int_posY
end





function UserBossDataBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		self.UserHeroBO_userHeroBO:encode(outputStream)

		
		self.list_equipList = self.list_equipList or {}
		local list_equipListsize = #self.list_equipList
		outputStream:WriteInt(list_equipListsize)
		for list_equipListi=1,list_equipListsize do
            self.list_equipList[list_equipListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_posX)

		outputStream:WriteInt(self.int_posY)


end

function UserBossDataBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

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


	   return body
end