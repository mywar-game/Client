

SystemActivityBO = {}

--运营活动对象
function SystemActivityBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SystemActivityBO:init()
	
	self.int_activityId=0 --活动id

	self.int_activityShowType=0 --显示分类

	self.int_activityType=0 --活动类型

	self.string_activityName="" --活动名称

	self.string_activityTitle="" --活动标题

	self.string_activityDesc="" --活动描述

	self.long_startTime=0 --活动开始时间

	self.long_endTime=0 --活动结束时间

	self.string_param="" --扩展参数

	self.string_openWeeks="" --开放的星期

	self.string_openTime="" --开放的时间段

	self.int_display=0 --是否显示0不显示1显示

	self.int_status=0 --状态0开启1关闭

	self.int_sort=0 --排序字段

	self.int_imgId=0 --图片id

	self.actName = "SystemActivityBO"
end

function SystemActivityBO:getActName()
	return self.actName
end

--活动id
function SystemActivityBO:setInt_activityId(int_activityId)
	self.int_activityId = int_activityId
end
--显示分类
function SystemActivityBO:setInt_activityShowType(int_activityShowType)
	self.int_activityShowType = int_activityShowType
end
--活动类型
function SystemActivityBO:setInt_activityType(int_activityType)
	self.int_activityType = int_activityType
end
--活动名称
function SystemActivityBO:setString_activityName(string_activityName)
	self.string_activityName = string_activityName
end
--活动标题
function SystemActivityBO:setString_activityTitle(string_activityTitle)
	self.string_activityTitle = string_activityTitle
end
--活动描述
function SystemActivityBO:setString_activityDesc(string_activityDesc)
	self.string_activityDesc = string_activityDesc
end
--活动开始时间
function SystemActivityBO:setLong_startTime(long_startTime)
	self.long_startTime = long_startTime
end
--活动结束时间
function SystemActivityBO:setLong_endTime(long_endTime)
	self.long_endTime = long_endTime
end
--扩展参数
function SystemActivityBO:setString_param(string_param)
	self.string_param = string_param
end
--开放的星期
function SystemActivityBO:setString_openWeeks(string_openWeeks)
	self.string_openWeeks = string_openWeeks
end
--开放的时间段
function SystemActivityBO:setString_openTime(string_openTime)
	self.string_openTime = string_openTime
end
--是否显示0不显示1显示
function SystemActivityBO:setInt_display(int_display)
	self.int_display = int_display
end
--状态0开启1关闭
function SystemActivityBO:setInt_status(int_status)
	self.int_status = int_status
end
--排序字段
function SystemActivityBO:setInt_sort(int_sort)
	self.int_sort = int_sort
end
--图片id
function SystemActivityBO:setInt_imgId(int_imgId)
	self.int_imgId = int_imgId
end





function SystemActivityBO:encode(outputStream)
		outputStream:WriteInt(self.int_activityId)

		outputStream:WriteInt(self.int_activityShowType)

		outputStream:WriteInt(self.int_activityType)

		outputStream:WriteUTFString(self.string_activityName)

		outputStream:WriteUTFString(self.string_activityTitle)

		outputStream:WriteUTFString(self.string_activityDesc)

		outputStream:WriteLong(self.long_startTime)

		outputStream:WriteLong(self.long_endTime)

		outputStream:WriteUTFString(self.string_param)

		outputStream:WriteUTFString(self.string_openWeeks)

		outputStream:WriteUTFString(self.string_openTime)

		outputStream:WriteInt(self.int_display)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_sort)

		outputStream:WriteInt(self.int_imgId)


end

function SystemActivityBO:decode(inputStream)
	    local body = {}
		body.activityId = inputStream:ReadInt()

		body.activityShowType = inputStream:ReadInt()

		body.activityType = inputStream:ReadInt()

		body.activityName = inputStream:ReadUTFString()

		body.activityTitle = inputStream:ReadUTFString()

		body.activityDesc = inputStream:ReadUTFString()

		body.startTime = inputStream:ReadLong()

		body.endTime = inputStream:ReadLong()

		body.param = inputStream:ReadUTFString()

		body.openWeeks = inputStream:ReadUTFString()

		body.openTime = inputStream:ReadUTFString()

		body.display = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.sort = inputStream:ReadInt()

		body.imgId = inputStream:ReadInt()


	   return body
end