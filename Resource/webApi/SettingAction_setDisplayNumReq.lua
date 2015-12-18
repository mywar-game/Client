

SettingAction_setDisplayNumReq = {}

--设置同屏显示人数
function SettingAction_setDisplayNumReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_setDisplayNumReq:init()
	
	self.int_num=0 --显示人数

	self.actName = "SettingAction_setDisplayNum"
end

function SettingAction_setDisplayNumReq:getActName()
	return self.actName
end

--显示人数
function SettingAction_setDisplayNumReq:setInt_num(int_num)
	self.int_num = int_num
end





function SettingAction_setDisplayNumReq:encode(outputStream)
		outputStream:WriteInt(self.int_num)


end

function SettingAction_setDisplayNumReq:decode(inputStream)
	    local body = {}
		body.num = inputStream:ReadInt()


	   return body
end