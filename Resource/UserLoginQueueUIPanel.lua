UserLoginQueueUIPanel = {
panel = nil,
}
--测试用
local data = "token=&serverId=s1&partnerId=&qn=&fr=&idfa=&mac=&version=&ua=&timestamp=123456&queneToken=&sign=bbsc"

function UserLoginQueueUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
i = 1
--创建
function UserLoginQueueUIPanel:Create(para)
    local p_name = "LoginQueueUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	self.panel:setNodeVisible("btn_ok",false)
    self.panel:setNodeVisible("btn_cancel",true)
    self.panel:setNodeVisible("btn_weihu",false)
   
    local function btnCallBack(sender,tag)
	if tag == 0 then
			self:Release()
	elseif tag == 1 then
	elseif tag == 2 then
			self:Release()	 
		end
    end
	self.panel:addNodeTouchEventListener("btn_ok",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_cancel",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_weihu",btnCallBack,2)

	--结束秒倒计时
	local function StopTimer()
		cclog("StopTimer--------")
		Scheduler.UnscheduleScriptEntry(self.tick_handler)
	end
    --前置声明
	local StartTimer,timerCallBack

	--登录回调
	local function QeueuCallBack(code,tag,data)
		cclog("QeueuCallBack--------"..i)
		local result = json.decode(data)
		i = i+1
		if result.rc ~= nil then
			--rc == 2001说明需要排队
			if result.rc == 2001 then
				self.result = result
                local pn = result.pn
				local wt = result.wt
             	local rc = result.rc
				cclog("times----="..wt)
				--实际毫秒数
				self.reality = 3000
	
				--将毫秒换成实际的分秒
				self.timemiaoClock,_ = math.modf( self.reality / 1000)  	
				self.timefenClock,_ = math.modf(self.timemiaoClock/60)
				self.timemiaoClock = self.timemiaoClock - (self.timefenClock*60)
				
				cclog(self.timemiaoClock .. self.timefenClock ..'--------------')
		
				self.panel:setLabelText("lab_numraking", pn)
				self.panel:setLabelText("lab_numfen", self.timefenClock)
				self.panel:setLabelText("lab_nummiao", self.timemiaoClock)

				--启动定时器用于等时间到了就去做请求以及更新界面显示的时间
				StartTimer()	
			end
		end
	end
   -- for i = 1, 10000 do 
		NetHttpReq.sendRequest("webApi/login.do",data,QeueuCallBack)
   -- end
	
	--时间回调用于排队时间到了继续发送请求看是否可以进入游戏
	function timerCallBack()
		cclog("timerCallBack--------"..self.result.queneToken..self.timefenClock .. self.timemiaoClock)
		
        self.timemiaoClock = self.timemiaoClock - 1

        if  self.timemiaoClock <= 0 then
			if self.timefenClock <= 0 then
				--分秒都为0 请求看是否可以进入游戏
			    data = "token=&serverId=s1&partnerId=&qn=&fr=&idfa=&mac=&version=&ua=&timestamp=123456&queneToken="..self.result.queneToken.."&sign=bbsc"
				NetHttpReq.sendRequest("webApi/login.do",data,QeueuCallBack,nil)
				StopTimer()
			
                self.panel:setLabelText("lab_numfen", "0")
			    self.panel:setLabelText("lab_nummiao", "0")

                self.panel:setNodeVisible("btn_ok",true)
                self.panel:setNodeVisible("btn_cancel",false)
                --self.panel:setNodeVisible("btn_weihu",false)
			else
			  --分数不为0 则转成秒
			  self.timemiaoClock = 60
			  self.timefenClock = self.timefenClock  -1
			  self.panel:setLabelText("lab_numfen", self.timefenClock)
			  self.panel:setLabelText("lab_nummiao", self.timemiaoClock)
			end
		else
			--秒数不为0 改变显示的秒数
			self.panel:setLabelText("lab_numfen", self.timefenClock)
			self.panel:setLabelText("lab_nummiao", self.timemiaoClock)
        end
	end
	
	--开始秒倒计时
    function StartTimer()
		cclog("StartTimer--------"..self.result.queneToken)   
		self.tick_handler = Scheduler.ScheduleScriptFunc(self, timerCallBack, 1, false)
	end
	return panel
end


--退出
function UserLoginQueueUIPanel:Release()
	self.panel:Release()
end
--隐藏
function UserLoginQueueUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function UserLoginQueueUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
