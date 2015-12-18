

MessageBO = {}

--跑马灯消息对象
function MessageBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MessageBO:init()
	
	self.string_txt="" --内容

	self.ColorBO_cor=nil --颜色对象

	self.actName = "MessageBO"
end

function MessageBO:getActName()
	return self.actName
end

--内容
function MessageBO:setString_txt(string_txt)
	self.string_txt = string_txt
end
--颜色对象
function MessageBO:setColorBO_cor(ColorBO_cor)
	self.ColorBO_cor = ColorBO_cor
end





function MessageBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_txt)

		self.ColorBO_cor:encode(outputStream)


end

function MessageBO:decode(inputStream)
	    local body = {}
		body.txt = inputStream:ReadUTFString()

        local corTemp = ColorBO:New()
        body.cor=corTemp:decode(inputStream)

	   return body
end