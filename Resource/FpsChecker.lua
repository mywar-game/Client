require('log')

FpsChecker = {}

local _longDurationFrameHandler =nil
local _longDuration = 0

local tolerance = 5 --每个计时周期，允许的误差

local _toleranceNum=0 --误差次数

local _count=0
local _totalTime=0  
local _startTime=0

local _tickTime={}
local _frameTime=1/60 --写死每秒60帧数
local _toleranceValue=0.005 --误差值平均帧数允许

local _average={} --记录平均值表
local _checkNum=18 --平均值表达到多少次进行检测

local scheduler	= Director.getScheduler()

function FpsChecker.errorHandler()
    FpsChecker.stop()
	LayerManager.showSysDialog(GameString.FpsChecker_1)
end

--长周期的计时器
function FpsChecker.longDurationFrameTick(tick)
	_count=_count+1--每帧+1
	table.insert(_tickTime,tick)

	if _count==600 then --运行600帧（一分钟）检测一次 每秒60帧 

		table.insert(_average,Average(_tickTime))--添加到平均值
		
		CheckAverage()
		
		_count=0
		_startTime=os.time()
		_tickTime={}
	end
	
	
end

--检测平均值表
function CheckAverage()
	--达到检测的次数
	if #_average==_checkNum then
		local num=0 --误差次数
		for k,v in ipairs(_average) do
			cclog("Average:"..k.."---------->"..v)
			if (v-_frameTime)>=_toleranceValue then--减去60帧标准值 大于 误差值 则为加速或者掉帧
				num=num+1
			end
		end
		--所有平均数都大于标准次数则判断加速
		if num==#_average then
			FpsChecker.errorHandler()
		end
		
		_average={}
	end
	
end


function Average(tab)
	local total=0
	for k,v in ipairs(tab) do
		total=total+v
	end
	cclog("Average:"..total/#tab)
	return total/#tab
end


--开始变速齿轮的检测
function FpsChecker.start()
	_startTime=os.time()
	local osTarget = cc.Application:getInstance():getTargetPlatform() 
	if osTarget == kTargetAndroid then
		_longDurationFrameHandler = scheduler:scheduleScriptFunc(FpsChecker.longDurationFrameTick,_longDuration,false)--
	end
end

--结束变速齿轮的检测
function FpsChecker.stop()
    scheduler:unscheduleScriptEntry(_longDurationFrameHandler)
end





