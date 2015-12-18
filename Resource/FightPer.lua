
FightPer = {}

function FightPer.saveFightResult(fightResult)
	fightResult.isSkillFight = false
	DataManager.saveDropObj(fightResult.dropList)
    if fightResult.type == 1 then--攻打副本
		--保存新开放的关卡
		fightResult.isSkillFight = DataManager.getIsBattleFight(fightResult.forcesId)
		fightResult.isOneBattle = DataManager.getForcesStarIsOne(fightResult.forcesId,fightResult.nowStar)
		DataManager.saveForcesIdMax(fightResult.maxForcesId)--最近开放的普通副本怪物id
		
		--增加攻击次数
		if fightResult.result == 1 then
			DataManager.increaseFightTimes(fightResult.forcesId)
			DataManager.increaseFightStar(fightResult.forcesId,fightResult.nowStar)
		end
	elseif fightResult.type == 2 then--争霸
		fightResult.isSkillFight = true
	elseif fightResult.type == 3 then --精英
		if DataManager.getVipLevel() >= Config.vip_skip then
			fightResult.isSkillFight = true
		end
		DataManager.setEliteForcesIdMax(fightResult.eliteMaxForcesId)
	elseif fightResult.type == 4 then --活动
		if DataManager.getVipLevel() >= Config.vip_skip then
			fightResult.isSkillFight = true
		end
		for k,v in pairs(fightResult.delList.hls)do --删除武将
			DataManager.RemoveHeroById(v)
		end
		
		for k,v in pairs(fightResult.delList.eqs)do --删除战魂
			DataManager.removeEquipment(v)
		end
		
		for k,v in pairs(fightResult.delList.tls)do --删除道具
			DataManager.removeToolListAfterMerge(v.tid,v.num)
		end
		
		for k,v in pairs(fightResult.delList.afs)do --删除神器
			DataManager.deleteUserArtifact(v)
		end
	elseif fightResult.type == 5 then --夺宝
		fightResult.isSkillFight = true
		DataManager.addUserPlunderToolBO(fightResult.pl)
		DataManager.setUserPlunderInfoBO(fightResult.upti)
	elseif fightResult.type == 6 then --boss
		fightResult.isSkillFight = true
		fightResult.enlargeTimes = 3
		fightResult.backgroundId = 8
	elseif fightResult.type == 7 then --爬塔
		fightResult.isSkillFight = true
    end 
end