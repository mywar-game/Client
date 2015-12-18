GameField = {} 
GameField.allTool=0 	--全部
GameField.tool=1 	--道具
GameField.equip = 2  --装备
GameField.gold=3 	--金币
GameField.money=4 	--钱(钻石)
GameField.exp=5 	--经验
GameField.chest = 101		---6(已修改)  --宝箱
GameField.hero=7 	--英雄
GameField.jobExp=8 --魂能
GameField.honour=9 	--荣誉
GameField.packExtendTimes=10 --背包扩展次数
GameField.level = 11  --用户等级 即团队等级
GameField.prestigeLevel= 12  --声望等级
GameField.heroExp= 13  --英雄经验
GameField.gemstone = 14  --宝石
GameField.packExtendNum = 101  --背包大小
GameField.skillBook = 102  --技能书
GameField.heroSkill = 103 --英雄技能

GameField.heroPackgeLevel = 3 --英雄开放背包等级

GameField.maxEnergy = 5 --最大能量球
GameField.ballType1 = 1 --最大能量球
GameField.ballType2 = 2 --最大能量球
GameField.ballType3 = 3 --最大能量球

GameField.moveHateLen = 180 --移动距离

GameField.alertType1 = 1 --呆在刷新点不动
GameField.alertType2 = 2 --在警戒范围内随机移动

GameField.attackType1 = 1 --入警戒范围后就激活攻击
GameField.attackType2 = 2 --进入警戒范围，被攻击后才会激活

GameField.tileWidth = 32 --格子宽
GameField.tileHeight = 32 --格子高
GameField.tileXNum = 30 --格子宽
GameField.tileYNum = 20 --格子高

GameField.actMode1 = 1 --英雄
GameField.actMode2 = 2 --怪物

GameField.battleType1 = 1 --正常1
GameField.battleType2 = 2 --boss

GameField.fightSuccess = 1 --战斗胜利
GameField.fightFail = 2 --战斗失败

GameField.hateNumPro = 5 --仇恨的列表

GameField.rowNum = 4 --4排
GameField.columnNum = 3 --3列

GameField.heroMoveSpeed = 300 --1s像素
GameField.skillMoveSpeed = 960 --1s像素

GameField.FightState1 = -1 --输
GameField.FightState2 = 0 --平局
GameField.FightState3 = 1 --赢

GameField.sceneType1 = 1--单人
GameField.sceneType2 = 2--多人

GameField.taskStatus0 = 0--可领取
GameField.taskStatus1 = 1--已领取
GameField.taskStatus2 = 2--已完成
GameField.taskStatus3 = 3--已获得奖励

GameField.taskType1 = 1 --主线
GameField.taskType2 = 2 --支线
GameField.taskType3 = 3 --日线

GameField.npcFunction1 = 1 --杂货店
GameField.npcFunction2 = 2 --神秘商店
GameField.npcFunction3 = 3 --回收站
GameField.npcFunction4 = 4 --兑换商人
GameField.npcFunction5 = 5 --锻造
GameField.npcFunction6 = 6 --练金
GameField.npcFunction7 = 7 --酒馆
GameField.npcFunction8 = 8 --探索
GameField.npcFunction9 = 9 --日常任务
GameField.npcFunction10 = 10 --分解
GameField.npcFunction11 = 11 --附魔
GameField.npcFunction12 = 12 --宝石制造
GameField.npcFunction13 = 13 --宝石加工
GameField.npcFunction14 = 14 --附魔融合
GameField.npcFunction15 = 15 --仓库

GameField.tasklibrary1 = 1--杀掉关卡中的某个怪物	sceneId 场景id  mapId 地图id forcesId：关卡id；monsterId：怪物ID
GameField.tasklibrary2 = 2--找人	sceneId 场景id  mapId 地图ID；npcId npcID
GameField.tasklibrary3 = 3--采集	sceneId 场景id  mapId 地图ID forcesId:关卡id
GameField.tasklibrary4 = 4--通关某个副本	sceneId 场景id  mapId 地图id forcesId：关卡id
GameField.tasklibrary5 = 5--用户到达指定等级	lv：目标等级
GameField.tasklibrary6 = 6--获得指定英雄	heroId:英雄模型ID
GameField.tasklibrary7 = 7--充值	
GameField.tasklibrary8 = 8--累计充值	
GameField.tasklibrary9 = 9--VIP等级	vipLv:到达指定vip等级
GameField.tasklibrary10 = 10--完成一个日常
GameField.tasklibrary11 = 11--获取任务道具
GameField.tasklibrary12 = 12--通关任意副本

GameField.heroSkill1 = 1--主动
GameField.heroSkill2 = 2--被动
GameField.heroSkill3 = 3--团长

GameField.forcesCategory1 = 1 --怪物
GameField.forcesCategory2 = 2 --关卡
GameField.forcesCategory3 = 3 --采集
GameField.forcesCategory4 = 4 --调用

GameField.forcesDifficulty1 = 1 --难度1
GameField.forcesDifficulty2 = 2 --难度2
GameField.forcesDifficulty3 = 3 --难度3
GameField.forcesDifficulty4 = 4 --难度4

GameField.forcesStatus_null = -1--状态无
GameField.forcesStatus_notPass = 0--未通过
GameField.forcesStatus_pass = 1--通过了

GameField.proType1 = 1 --血条进度
GameField.proType2 = 2 --血条进度

GameField.weakOver1 = 1 --寻走
GameField.weakOver2 = 2 --攻击
GameField.weakOver3 = 3 --检查

GameField.checkValue = 2 --判断值
GameField.critValue = 2 --暴击
GameField.parryValue = 0.7 --格挡

--界面常用常量
--icon回调 type
GameField.Event_Back = -1--事件返回
GameField.Event_Click = 1--单击
GameField.Event_LongPress = 2--长按
GameField.Event_DoubleClick = 3--双击
GameField.Event_Move = 4--移动
GameField.Event_End = 5--抬起手

GameField.Camp_Alliance = 1--联盟
GameField.Camp_Clan = 2--部落
GameField.Camp_all = 3--全部

GameField.PushNotify_Email = 1--推送提示邮件
GameField.openLevel = {0,15,30,45} --开放等级

GameField.fightType1 = 1 --副本
GameField.fightType2 = 2 --野外
GameField.fightType3 = 3 --pk
GameField.fightType4 = 4 --boss

GameField.windowTips1 = 1
GameField.heroDescSkill = 1
GameField.heroDescPackage = 2

GameField.equipType10 = 10 --武器 和道具的分割点

GameField.magicToolType1141 = 1141 --卷轴道具的道具id的起点
GameField.magicToolType1170 = 1170 --卷轴道具的道具id的终点

GameField.GemSynthesisForge = 1 --宝石合成
GameField.GemSynthesisResolve = 2 --宝石分解
GameField.GemSynthesisOre = 3 --宝石熔炼

GameField.equipForge = 1 --装备合成
GameField.equipResolve = 2 --装备分解
GameField.oreForge = 3 --矿石熔炼
GameField.HerbsForge = 4 --药草淬炼

GameField.OreForge1016 = 1016 --装备合成

GameField.heroStatus0 = 0 --0在酒馆
GameField.heroStatus1 = 1 --1在空闲的英雄
GameField.heroStatus2 = 2 --2英雄在阵上
GameField.heroStatus3 = 3 --3正在挖矿
GameField.heroStatus4 = 4 --4正在修花圃
GameField.heroStatus5 = 5 --5正在钓鱼

GameField.violentNum = 90 --狂暴时间
GameField.violentMultiple = 10 --狂暴倍数

GameField.changNameTool = 1363

GameField.StoreOperateTypeIn = 1
GameField.StoreOperateTypeOut = 0

--可以消耗的道具ID
GameField.VanHorn = 1372		--先锋号角 （大喇叭）