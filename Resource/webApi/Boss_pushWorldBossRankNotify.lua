

Boss_pushWorldBossRankNotify = {}

--推送世界Boss的排行榜
function Boss_pushWorldBossRankNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushWorldBossRankNotify:init()
	
	self.list_hurtRankList={} --伤害排行榜列表

	self.list_treamentRankList={} --治疗量排行榜列表

	self.list_beHitRankList={} --承受伤害排行榜列表

	self.actName = "Boss_pushWorldBossRank"
end

function Boss_pushWorldBossRankNotify:getActName()
	return self.actName
end

--伤害排行榜列表
function Boss_pushWorldBossRankNotify:setList_hurtRankList(list_hurtRankList)
	self.list_hurtRankList = list_hurtRankList
end
--治疗量排行榜列表
function Boss_pushWorldBossRankNotify:setList_treamentRankList(list_treamentRankList)
	self.list_treamentRankList = list_treamentRankList
end
--承受伤害排行榜列表
function Boss_pushWorldBossRankNotify:setList_beHitRankList(list_beHitRankList)
	self.list_beHitRankList = list_beHitRankList
end





function Boss_pushWorldBossRankNotify:encode(outputStream)
		
		self.list_hurtRankList = self.list_hurtRankList or {}
		local list_hurtRankListsize = #self.list_hurtRankList
		outputStream:WriteInt(list_hurtRankListsize)
		for list_hurtRankListi=1,list_hurtRankListsize do
            self.list_hurtRankList[list_hurtRankListi]:encode(outputStream)
		end		
		self.list_treamentRankList = self.list_treamentRankList or {}
		local list_treamentRankListsize = #self.list_treamentRankList
		outputStream:WriteInt(list_treamentRankListsize)
		for list_treamentRankListi=1,list_treamentRankListsize do
            self.list_treamentRankList[list_treamentRankListi]:encode(outputStream)
		end		
		self.list_beHitRankList = self.list_beHitRankList or {}
		local list_beHitRankListsize = #self.list_beHitRankList
		outputStream:WriteInt(list_beHitRankListsize)
		for list_beHitRankListi=1,list_beHitRankListsize do
            self.list_beHitRankList[list_beHitRankListi]:encode(outputStream)
		end
end

function Boss_pushWorldBossRankNotify:decode(inputStream)
	    local body = {}
		local hurtRankListTemp = {}
		local hurtRankListsize = inputStream:ReadInt()
		for hurtRankListi=1,hurtRankListsize do
            local entry = UserBossRankBO:New()
            table.insert(hurtRankListTemp,entry:decode(inputStream))

		end
		body.hurtRankList = hurtRankListTemp
		local treamentRankListTemp = {}
		local treamentRankListsize = inputStream:ReadInt()
		for treamentRankListi=1,treamentRankListsize do
            local entry = UserBossRankBO:New()
            table.insert(treamentRankListTemp,entry:decode(inputStream))

		end
		body.treamentRankList = treamentRankListTemp
		local beHitRankListTemp = {}
		local beHitRankListsize = inputStream:ReadInt()
		for beHitRankListi=1,beHitRankListsize do
            local entry = UserBossRankBO:New()
            table.insert(beHitRankListTemp,entry:decode(inputStream))

		end
		body.beHitRankList = beHitRankListTemp

	   return body
end