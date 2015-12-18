

LegionAction_editDeclarationRes = {}

--修改军团宣言
function LegionAction_editDeclarationRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_editDeclarationRes:init()
	
	self.string_declaration="" --军团宣言内容

	self.actName = "LegionAction_editDeclaration"
end

function LegionAction_editDeclarationRes:getActName()
	return self.actName
end

--军团宣言内容
function LegionAction_editDeclarationRes:setString_declaration(string_declaration)
	self.string_declaration = string_declaration
end





function LegionAction_editDeclarationRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_declaration)


end

function LegionAction_editDeclarationRes:decode(inputStream)
	    local body = {}
		body.declaration = inputStream:ReadUTFString()


	   return body
end