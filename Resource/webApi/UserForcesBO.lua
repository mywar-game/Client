

UserForcesBO = {}

--用户关卡对象
function UserForcesBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserForcesBO:init()
	
	self.string_userId="" --用户编号

	self.int_mapId=0 --关卡地图id

	self.int_bigForcesId=0 --大关卡id

	self.int_forcesId=0 --关卡id

	self.int_status=0 --状态-状态0未通关1通过了

	self.int_forcesType=0 --1简单2普通3精英4困难如没有记录也没有通关

	self.int_times=0 --今日已攻打次数

	self.actName = "UserForcesBO"
end

function UserForcesBO:getActName()
	return self.actName
end

--用户编号
function UserForcesBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--关卡地图id
function UserForcesBO:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--大关卡id
function UserForcesBO:setInt_bigForcesId(int_bigForcesId)
	self.int_bigForcesId = int_bigForcesId
end
--关卡id
function UserForcesBO:setInt_forcesId(int_forcesId)
	self.int_forcesId = int_forcesId
end
--状态-状态0未通关1通过了
function UserForcesBO:setInt_status(int_status)
	self.int_status = int_status
end
--1简单2普通3精英4困难如没有记录也没有通关
function UserForcesBO:setInt_forcesType(int_forcesType)
	self.int_forcesType = int_forcesType
end
--今日已攻打次数
function UserForcesBO:setInt_times(int_times)
	self.int_times = int_times
end





function UserForcesBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_bigForcesId)

		outputStream:WriteInt(self.int_forcesId)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_forcesType)

		outputStream:WriteInt(self.int_times)


end

function UserForcesBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.mapId = inputStream:ReadInt()

		body.bigForcesId = inputStream:ReadInt()

		body.forcesId = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.forcesType = inputStream:ReadInt()

		body.times = inputStream:ReadInt()


	   return body
end