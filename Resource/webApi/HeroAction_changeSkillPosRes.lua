

HeroAction_changeSkillPosRes = {}

--上阵团长技能
function HeroAction_changeSkillPosRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeSkillPosRes:init()
	
	self.list_updateHeroSkillPosList={} --需要更新的技能列表，修改列表中对应技能的位置属性

	self.actName = "HeroAction_changeSkillPos"
end

function HeroAction_changeSkillPosRes:getActName()
	return self.actName
end

--需要更新的技能列表，修改列表中对应技能的位置属性
function HeroAction_changeSkillPosRes:setList_updateHeroSkillPosList(list_updateHeroSkillPosList)
	self.list_updateHeroSkillPosList = list_updateHeroSkillPosList
end





function HeroAction_changeSkillPosRes:encode(outputStream)
		
		self.list_updateHeroSkillPosList = self.list_updateHeroSkillPosList or {}
		local list_updateHeroSkillPosListsize = #self.list_updateHeroSkillPosList
		outputStream:WriteInt(list_updateHeroSkillPosListsize)
		for list_updateHeroSkillPosListi=1,list_updateHeroSkillPosListsize do
            self.list_updateHeroSkillPosList[list_updateHeroSkillPosListi]:encode(outputStream)
		end
end

function HeroAction_changeSkillPosRes:decode(inputStream)
	    local body = {}
		local updateHeroSkillPosListTemp = {}
		local updateHeroSkillPosListsize = inputStream:ReadInt()
		for updateHeroSkillPosListi=1,updateHeroSkillPosListsize do
            local entry = UserHeroSkillPosChangeBO:New()
            table.insert(updateHeroSkillPosListTemp,entry:decode(inputStream))

		end
		body.updateHeroSkillPosList = updateHeroSkillPosListTemp

	   return body
end