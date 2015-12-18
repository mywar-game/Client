HateAI = {}

--最大仇恨的人
function HateAI.getMaxHateHero(hero)	
	local function sortHate(a,b)
		return a.heroHateNum > b.heroHateNum
	end
	table.sort(hero,sortHate)
	return hero[1]
end

function HateAI.attackHero(attacker,heroArray)
	local hero = nil
	local peopleId = attacker:getAttackPeopleId()
	for k,v in pairs(heroArray)do
		if peopleId == v:getPeopleId() then
			hero = v
			break
		end
	end
	return hero,peopleId
end

function HateAI.deadHero(attacker,heroArray)

end