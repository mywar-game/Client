

SettingAction_setDisplayNumRes = {}

--设置同屏显示人数
function SettingAction_setDisplayNumRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_setDisplayNumRes:init()
	
	self.int_num=0 --显示人数

	self.actName = "SettingAction_setDisplayNum"
end

function SettingAction_setDisplayNumRes:getActName()
	return self.actName
end

--显示人数
function SettingAction_setDisplayNumRes:setInt_num(int_num)
	self.int_num = int_num
end





function SettingAction_setDisplayNumRes:encode(outputStream)
		outputStream:WriteInt(self.int_num)


end

function SettingAction_setDisplayNumRes:decode(inputStream)
	    local body = {}
		body.num = inputStream:ReadInt()


	   return body
end