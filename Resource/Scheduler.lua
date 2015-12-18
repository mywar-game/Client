

Scheduler={
childs={},
}

local _scheduler = Director.getScheduler()

function Scheduler.ScheduleScriptFunc(panel,update,fInterval,bPaused)
	fInterval=fInterval or 1/30.0
	bPaused=bPaused or false
	
	local handle = _scheduler:scheduleScriptFunc(update,fInterval,bPaused)
	
	local data={}
	data.panel=panel
	data.handle=handle
	table.insert(Scheduler.childs,data)
	
	return handle
end


function Scheduler.UnscheduleScriptEntry(key)
	for k,v in ipairs(Scheduler.childs) do
		if v and (v.panel==key or v.handle==key) then
			_scheduler:unscheduleScriptEntry(v.handle)
			table.remove(Scheduler.childs,k)
		end
	end
end

function Scheduler.PerformWithDelay(node,times, update,isRepeat)
    if node then
        local delay = cc.DelayTime:create(times)
        local callfunc = cc.CallFunc:create(update)
        local sequence = cc.Sequence:create(delay,callfunc)
		if isRepeat then
			 node:runAction(cc.RepeatForever:create(sequence))
		else
			 node:runAction(sequence)
		end
    else 
        local handle 
        handle = _scheduler:scheduleScriptFunc(function()
            _scheduler:unscheduleScriptEntry(handle)
            update()
            end, times, false)
    end
end


--[[ args={
--delay   		延迟 
--time    		动作执行时间 
--onComplete	执行完动作回调
--}
--]] 
function Scheduler.ActionCallback(target, action, args,delayFunc)
    local delay = tonumber(args.delay)
    if type(delay) ~= "number" then delay = 0 end

    local time = tonumber(args.time)
    if type(time) ~= "number" then time = 0 end 

    local onComplete = args.onComplete
    if type(onComplete) ~= "function" then onComplete = nil end

    if action then
        if delay >0 then
            target:retain()
            action:retain()
            local handle 
            
            handle=  _scheduler:scheduleScriptFunc(function()
                _scheduler:unscheduleScriptEntry(handle)
                
                target:runAction(action)
                target:release()
                action:release()
                if delayFunc then delayFunc() end
                end, delay, false)
        else
			target:runAction(action)
        end
    else
        cclog("ActionCallback: action is nil")
    end
    
    if onComplete then
        local onCompleteHandle = Scheduler.PerformWithDelay(target,delay + time, function()
            onCompleteHandle = nil
            onComplete()
        end)
    end
end

function Scheduler.UpadteFunc(delay,delayFunc,callBack)
	 local curTime=0
	 local handle 
	 handle = _scheduler:scheduleScriptFunc(
	 function(dt)
		-- cclog(dt)
		curTime=curTime+dt
		if delayFunc then delayFunc() end
		if curTime>=delay then
			if callBack then callBack() end
			_scheduler:unscheduleScriptEntry(handle)
		end
	 end,0,false)
	 return handle
end

function Scheduler.UnscheduleUpadteFunc(handle)
	_scheduler:unscheduleScriptEntry(handle)
end

