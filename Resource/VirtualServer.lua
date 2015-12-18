VirtualServer = {}

--修改总推送接口返回的数据
function VirtualServer.hack_User_pushUserData(msgObj)
    local dt = msgObj.dt
    if dt then
        dt.swp = {}
        local swp = dt.swp
        local now =DataManager.getServerSystemTimeNow()
        swp.st=now-60*1000
        swp.et=swp.st+60*1000*2
        swp.sta=0
    end

    return msgObj
end

--修改战报
function VirtualServer.hack_Battle_fightRq(msgObj)
    if not msgObj.dt.dr then msgObj.dt.dr = {} end
    msgObj.dt.dr.aco = 50       --vip增加的掉落银币
    msgObj.dt.dr.aexp = 100     --vip增加的掉落经验
    return msgObj
end

--修改总推送接口返回的数据
function VirtualServer.hack_User_pushUser(msgObj)
    local dt = msgObj.dt
    if dt then
        --背包上限
        dt.uinfo.ebl =100
        dt.uinfo.hbl = 100
        
        dt.uinfo.vl = 0 --vip等级
        dt.uinfo.ve = 1375770540459  --vip到期时间
     end
     return msgObj
end

--模拟 争霸可挑战列表 及 用户争霸信息
function VirtualServer.Pk_enterPk_rq()
    local msgObj = {}
    msgObj.act = "Pk.enterPkRq"
    msgObj.dt = {}
    msgObj.dt.upi = {}
    
    msgObj.dt.upi.pkt = 25      --剩余可挑战次数
    msgObj.dt.upi.sc= 3000      --积分
    msgObj.dt.upi.rk = 1300     --排名
    
    msgObj.dt.ps= {}
    
    local heroList = DataManager.getHeroList()
    for i=1,5 do
        local t = {}
        t.nn = LabelChineseStr.VirtualServer_1..i
        t.pid = "id"..i
        t.sc = 1000*(5-i)
        t.hs = {}
        for i=1,6 do 
            table.insert(t.hs,heroList[math.random(#heroList)])
        end
        table.insert(msgObj.dt.ps,t)
    end
    NetResponseHelper_onRecvMessage(msgObj)
end

--模拟 争霸可挑战列表接口返回
function VirtualServer.Pk_loadPlayers_rq()
    local msgObj = {}
    msgObj.act = "Pk.loadPlayersRq"
    msgObj.dt = {}
    msgObj.dt.ps= {}
    
    local heroList = DataManager.getHeroList()
    for i=1,5 do
        local t = {}
        t.nn = LabelChineseStr.VirtualServer_2..i
        t.pid = "id"..i
        t.sc = 1000*(5-i)
        t.hs = {}
        for i=1,6 do 
            table.insert(t.hs,heroList[math.random(#heroList)])
        end
        table.insert(msgObj.dt.ps,t)
    end
    NetResponseHelper_onRecvMessage(msgObj)
end

--模拟 争霸排行列表接口返回
function VirtualServer.Pk_loadRank_rq()
    local msgObj = {}
    msgObj.act = "Pk.loadRankRq"
    msgObj.dt = {}
    msgObj.dt.ps= {}
    
    local heroList = DataManager.getHeroList()
    for i=1,5 do
        local t = {}
        t.nn = LabelChineseStr.VirtualServer_3..i
        t.pid = "id"..i
        t.sc = 1000*(5-i)
        t.hs = {}
        for i=1,6 do 
            table.insert(t.hs,heroList[math.random(#heroList)])
        end
        table.insert(msgObj.dt.ps,t)
    end
    NetResponseHelper_onRecvMessage(msgObj)
end

--模拟 争霸排行列表接口返回
function VirtualServer.System_pushMsg()
    local msgObj = {}
    msgObj.act = "System.pushMsg"
    msgObj.dt = {}
    local t = {        
        {txt=LabelChineseStr.VirtualServer_4,color={r=255,g=192,b=0}},
        {txt=LabelChineseStr.VirtualServer_5,color={r=math.random(255),g=math.random(255),b=math.random(255)}},
        {txt=LabelChineseStr.VirtualServer_6..math.random(10),},
        
    }
    msgObj.dt.ml=  t  --json.encode(t) ----"尼玛这是跑马灯吗？马呢？"..math.random(10)
    NetResponseHelper_onRecvMessage(msgObj)
end

--装备升级预览返回
function VirtualServer.hack_Equipment_upgradePreRq(msgObj)

    msgObj.dt.eq.ur = "20%"
    return msgObj
end

--装备升级返回
function VirtualServer.hack_Equipment_upgradeRq(msgObj)
    msgObj.dt.eqPre.ur = "30%"
    return msgObj
end


--开始扫荡
function VirtualServer.Scene_sweep()
--    {
--  dt: {
--    "st": 开始时间,
--    "et": 结束时间
--  }
    local msgObj = {}
    msgObj.act = "Scene.sweepRq"
    msgObj.dt = {}
    msgObj.dt.st = os.time()*1000
    msgObj.dt.et = msgObj.dt.st + 60*1000
    NetResponseHelper_onRecvMessage(msgObj)   
    
end

--停止扫荡
function VirtualServer.Scene_stopSweep()
    local msgObj = {}
    msgObj.act = "Scene.stopSweepRq"
    msgObj.rc = 2001
    NetResponseHelper_onRecvMessage(msgObj)
end

--加速扫荡
function VirtualServer.Scene_finishSweep()
    local msgObj = {}
    msgObj.act = "Scene.finishSweepRq"
    msgObj.rc = 1000
    NetResponseHelper_onRecvMessage(msgObj)
end

--领取扫荡奖励
function VirtualServer.Scene_receiveSweep()
--{
--  dt: {
--  dr:{
--     hls:[...],
--     ts:[...],
--     eqs:[...],
--     ulv: 2,
--     hp: 100,
--     pha: 100,
--     phd: 100,
--     co:1000,
--     exp:1000
--  }
--  }
--}

    local msgObj = {}
    msgObj.act = "Scene.receiveSweepRq"
    msgObj.rc = 1000
    msgObj.dt = {}
    dt = msgObj.dt
    dt.ulv=2
    dt.hp=99
    dt.pha=100
    dt.phd=222
    dt.co=3333
    dt.exp=4444
    
    NetResponseHelper_onRecvMessage(msgObj)
end

function VirtualServer.Activity_heroExchange(exchangeId)
   
end


function VirtualServer.Activity_getHeroExchangeList()

end

--兑换武将碎片
function VirtualServer.Activity_exchangeHeroFragments()
	local heros=DataManager.getHeroList()
	local msgObj = {}
	msgObj.act = "Activity.exchangeHeroFragmentsRq"
	msgObj.rc = 1000
	msgObj.dt={}
	local dt = msgObj.dt
	dt.uhid=heros[1].userHeroId
	cclog("heros[1].userHeroID:"..heros[1].userHeroId)
	dt.ncm=12
	NetResponseHelper_onRecvMessage(msgObj)
end

--进入转生塔地图
function VirtualServer.Tower_enterFloor()
	local msgObj = {}
	msgObj.act = "Tower.enterFloorRq"
	msgObj.rc = 1000
	msgObj.dt={}
	local dt = msgObj.dt
	dt.md = {}
    
    table.insert(dt.md,{mid=1,fl=1,pos=12,obt=0,psd=0,obid=1})
    table.insert(dt.md,{mid=1,fl=1,pos=13,obt=0,psd=1,obid=2})
    table.insert(dt.md,{mid=1,fl=1,pos=14,obt=1,psd=0,obid=3})
    table.insert(dt.md,{mid=1,fl=1,pos=15,obt=1,psd=1,obid=4})
   
	NetResponseHelper_onRecvMessage(msgObj)
end

--获取用户可打boss信息
function VirtualServer.Boss_getUserBoss()
	local msgObj = {}
	msgObj.act = "Boss.getUserBossRq"
	msgObj.rc = 1000
    local dt = {}
	msgObj.dt = dt
    dt.ex = 1 --0不存在boss，1表示不存在
    dt.fid = 20101
    dt.ts = 1
    dt.mt = 3
    dt.cd = 0
    
    NetResponseHelper_onRecvMessage(msgObj)
end

--快速开始boss战
function VirtualServer.Boss_quickStart()
	local msgObj = {}
	msgObj.act = "Boss.quickStartRq"
	msgObj.rc = 1000
    local dt = {}
    local bs = {}
	msgObj.dt = dt
    dt.bs = bs
    
    local t = {}
    t.pid = DataManager.getUserPlayerId()
    t.ic = true
    t.ul = 55
    t.po = 1099
    t.tid = "5349499dea96497db4a2e203ef064b15"
    t.un = LabelChineseStr.VirtualServer_7
    t.hls = DataManager.getFightHeros()
    table.insert(bs,t)
    
    t = {}
    t.pid = 10008
    t.ic = false
    t.ul = 90
    t.po = 9999
    t.tid = "5349499dea96497db4a2e203ef064b15"
    t.un = LabelChineseStr.VirtualServer_8
    t.hls = DataManager.getFightHeros()
    table.insert(bs,t)


    t = {}
    t.pid = 10009
    t.ic = false
    t.ul = 80
    t.po = 7777
    t.tid = "5349499dea96497db4a2e203ef064b15"
    t.un = LabelChineseStr.VirtualServer_9
    t.hls = DataManager.getFightHeros()
    table.insert(bs,t)
        
    NetResponseHelper_onRecvMessage(msgObj)
end

--Boss封印结果
function VirtualServer.pushFightResult()
	local msgObj = {}
	msgObj.act = "Boss.pushFightResult"
	msgObj.rc = 1000
	msgObj.dt = StaticDataLoader.loadBoss_fightJson()
    NetResponseHelper_onRecvMessage(msgObj)
end

--读取邮件列表
function VirtualServer.Email_getList()
	cclog("VirtualServer.Email_getList")
	local data={}
	
	email={}
	email.mid=1
	email.tp=2
	email.tt=LabelChineseStr.VirtualServer_10
	email.st=0
	email.rst=1
	email.content=LabelChineseStr.VirtualServer_11
	email.ct=os.time()
	email.et=os.time()+3*3600*24
	tools={}
	-- tool={tt="",tid="",tn="",}
	-- table.insert(tools,tool)
	email.tls=tools
	table.insert(data,email)
	
	email={}
	email.mid=2
	email.tp=2
	email.tt=LabelChineseStr.VirtualServer_12
	email.st=0
	email.rst=0
	email.content=LabelChineseStr.VirtualServer_13
	email.ct=os.time()
	email.et=os.time()+1*3600*24
	tools={}
	tool={tt=4001,tid=11051,tn=100,}
	table.insert(tools,tool)
	tool={tt=4001,tid=11050,tn=1,}
	table.insert(tools,tool)
	email.tls=tools
	table.insert(data,email)
	
	local msgObj = {}
	msgObj.act = "Email.getListRq"
	msgObj.rc = 1000
	msgObj.dt={}
	msgObj.dt.ems = data
    NetResponseHelper_onRecvMessage(msgObj)
end